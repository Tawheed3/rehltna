<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\EtisalatyContact;
use App\Models\EtisalatyEmployeeContact;
use App\Models\User;
use App\Services\EtisalatyDistributionService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class EtisalatyController extends Controller
{
    use ResponseTrait;

    /**
     * POST /api/v1/etisalaty/login
     */
    public function login(Request $request, EtisalatyDistributionService $distribution): JsonResponse
    {
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $request->email)
            ->whereNotNull('etisalaty_role')
            ->first();

        if (!$user || !$distribution->isSupportedEmployee($user) || !Hash::check($request->password, $user->password)) {
            return $this->responseMessage(401, 'Invalid email or password.');
        }

        // Revoke old Etisalaty tokens
        $user->tokens()->where('name', 'etisalaty-token')->delete();

        $token = $user->createToken('etisalaty-token')->plainTextToken;

        return $this->responseMessage(200, 'Logged Successfully', [
            'id'           => $user->id,
            'name'         => $user->name,
            'email'        => $user->email,
            'role'         => $user->etisalaty_role,
            'access_token' => $token,
            'token_type'   => 'Bearer',
        ]);
    }

    /**
     * POST /api/v1/etisalaty/upload-contacts
     * Available to: employee, security
     */
    public function uploadContacts(Request $request, EtisalatyDistributionService $distribution): JsonResponse
    {
        $request->validate([
            'contacts' => 'required|array|min:1',
        ]);

        $user = $request->etisalaty_user;

        if (!$distribution->isSupportedEmployee($user)) {
            return $this->responseMessage(403, 'This user is not enabled for Etisalaty uploads.');
        }

        $totalReceived        = count($request->contacts);
        $newContactsAdded     = 0;
        $alreadyExists        = 0;
        $duplicatesByEmployee = 0;
        $skippedInvalid       = 0;

        // Step 1 — normalize & validate; deduplicate within the batch (keep first name seen)
        $batch = [];
        foreach ($request->contacts as $item) {
            if (empty($item['phone_number'])) {
                $skippedInvalid++;
                continue;
            }

            $phone = $this->normalizePhone(trim($item['phone_number']));

            if (!$this->isSaudiNumber($phone)) {
                $skippedInvalid++;
                continue;
            }

            if (!isset($batch[$phone])) {
                $batch[$phone] = trim($item['contact_name'] ?? '') ?: 'Unknown';
            }
        }

        if (empty($batch)) {
            return $this->responseMessage(200, 'No valid Saudi contacts to upload.', [
                'total_received'         => $totalReceived,
                'new_contacts_added'     => 0,
                'already_exists'         => 0,
                'duplicates_by_employee' => 0,
                'skipped_invalid'        => $skippedInvalid,
            ]);
        }

        $now   = now();
        $phones = array_keys($batch);

        DB::transaction(function () use (
            $batch, $phones, $user, $now,
            &$newContactsAdded, &$alreadyExists, &$duplicatesByEmployee
        ) {
            // Step 2 — fetch all contacts that already exist in one query
            $existing = EtisalatyContact::whereIn('phone_number', $phones)
                ->get(['id', 'phone_number'])
                ->keyBy('phone_number');

            // Step 3 — fetch existing employee→contact links for this employee
            $existingLinkIds = EtisalatyEmployeeContact::where('employee_id', $user->id)
                ->whereIn('contact_id', $existing->pluck('id'))
                ->pluck('contact_id')
                ->flip(); // use as a set keyed by contact_id

            $newLinks = [];

            foreach ($batch as $phone => $name) {
                $contact = $existing->get($phone);

                if ($contact) {
                    // Number already in the system — just refresh last_seen_at
                    EtisalatyContact::where('id', $contact->id)
                        ->update(['last_seen_at' => $now]);
                    $alreadyExists++;
                } else {
                    // Brand-new number
                    $contact = EtisalatyContact::create([
                        'phone_number'  => $phone,
                        'contact_name'  => $name,
                        'first_seen_at' => $now,
                        'last_seen_at'  => $now,
                    ]);
                    $existing->put($phone, $contact); // keep set consistent
                    $newContactsAdded++;
                }

                if ($existingLinkIds->has($contact->id)) {
                    // This employee already uploaded this number before
                    $duplicatesByEmployee++;
                } else {
                    $newLinks[] = [
                        'employee_id' => $user->id,
                        'contact_id'  => $contact->id,
                        'uploaded_at' => $now,
                    ];
                    $existingLinkIds->put($contact->id, true);
                }
            }

            // Step 4 — bulk-insert all new employee→contact links in one query
            if (!empty($newLinks)) {
                EtisalatyEmployeeContact::insert($newLinks);
            }
        });

        $distribution->rebalance();

        return $this->responseMessage(200, 'Contacts uploaded successfully.', [
            'total_received'         => $totalReceived,
            'new_contacts_added'     => $newContactsAdded,
            'already_exists'         => $alreadyExists,
            'duplicates_by_employee' => $duplicatesByEmployee,
            'skipped_invalid'        => $skippedInvalid,
        ]);
    }

    private function normalizePhone(string $phone): string
    {
        // Remove spaces, dashes, parentheses, dots
        $phone = preg_replace('/[\s\-\(\)\.]+/', '', $phone);

        // Already E.164 with +966
        if (preg_match('/^\+9665[0-9]{8}$/', $phone)) {
            return $phone;
        }

        // 9665xxxxxxxx → +9665xxxxxxxx
        if (preg_match('/^9665[0-9]{8}$/', $phone)) {
            return '+' . $phone;
        }

        // 05xxxxxxxx → +9665xxxxxxxx
        if (preg_match('/^05[0-9]{8}$/', $phone)) {
            return '+966' . substr($phone, 1);
        }

        // Not a Saudi number
        return '';
    }

    private function isSaudiNumber(string $normalized): bool
    {
        return preg_match('/^\+9665[0-9]{8}$/', $normalized) === 1;
    }

    /**
     * GET /api/v1/etisalaty/download-all-contacts
     * Available to: security only
     */
    public function downloadAllContacts(Request $request): JsonResponse
    {
        $contacts = EtisalatyContact::orderBy('contact_name')
            ->get(['phone_number', 'contact_name']);

        return $this->responseMessage(200, 'Contacts fetched successfully.', [
            'total_contacts' => $contacts->count(),
            'contacts'       => $contacts,
        ]);
    }

    /**
     * GET /api/v1/etisalaty/download-assigned-contacts/{employeeId}
     * Available to: security only
     */
    public function downloadAssignedContacts(
        Request $request,
        int $employeeId,
        EtisalatyDistributionService $distribution
    ): JsonResponse {
        $employee = $distribution->employeesQuery()->findOrFail($employeeId);
        $distribution->rebalance();

        $contacts = EtisalatyContact::query()
            ->where('assigned_employee_id', $employee->id)
            ->with('employeeLinks.employee')
            ->orderBy('contact_name')
            ->get(['id', 'phone_number', 'contact_name'])
            ->map(fn (EtisalatyContact $contact) => [
                'phone_number' => $contact->phone_number,
                'contact_name' => $contact->contact_name,
                'ownership_marker' => $distribution->ownershipMarker($contact->employeeLinks),
            ]);

        return $this->responseMessage(200, 'Assigned contacts fetched successfully.', [
            'employee' => [
                'id' => $employee->id,
                'name' => $employee->name,
            ],
            'total_contacts' => $contacts->count(),
            'contacts' => $contacts,
        ]);
    }

    /**
     * GET /api/v1/etisalaty/distribution-summary
     * Available to: security only
     */
    public function distributionSummary(
        Request $request,
        EtisalatyDistributionService $distribution
    ): JsonResponse {
        return $this->responseMessage(200, 'Distribution summary fetched successfully.', [
            'summary' => $distribution->rebalance(),
        ]);
    }
}
