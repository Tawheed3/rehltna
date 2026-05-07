<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\EtisalatyContact;
use App\Models\EtisalatyEmployeeContact;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class EtisalatyController extends Controller
{
    use ResponseTrait;

    /**
     * POST /api/v1/etisalaty/login
     */
    public function login(Request $request): JsonResponse
    {
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $request->email)
            ->whereNotNull('etisalaty_role')
            ->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
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
    public function uploadContacts(Request $request): JsonResponse
    {
        $request->validate([
            'contacts'                => 'required|array|min:1',
            'contacts.*.phone_number' => 'required|string|max:20',
            'contacts.*.contact_name' => 'required|string|max:255',
        ]);

        $user  = $request->etisalaty_user;
        $now   = now();

        $totalReceived        = count($request->contacts);
        $newContactsAdded     = 0;
        $alreadyExists        = 0;
        $duplicatesByEmployee = 0;

        foreach ($request->contacts as $item) {
            $phone = $this->normalizePhone(trim($item['phone_number']));
            $name  = trim($item['contact_name']) . ' (' . $user->name . ')';

            $contact = EtisalatyContact::where('phone_number', $phone)->first();

            if (!$contact) {
                $contact = EtisalatyContact::create([
                    'phone_number'  => $phone,
                    'contact_name'  => $name,
                    'first_seen_at' => $now,
                    'last_seen_at'  => $now,
                ]);
                $newContactsAdded++;
            } else {
                $alreadyExists++;
                $contact->update(['last_seen_at' => $now]);
            }

            $alreadyLinked = EtisalatyEmployeeContact::where('employee_id', $user->id)
                ->where('contact_id', $contact->id)
                ->exists();

            if (!$alreadyLinked) {
                EtisalatyEmployeeContact::create([
                    'employee_id' => $user->id,
                    'contact_id'  => $contact->id,
                    'uploaded_at' => $now,
                ]);
            } else {
                $duplicatesByEmployee++;
            }
        }

        return $this->responseMessage(200, 'Contacts uploaded successfully.', [
            'total_received'         => $totalReceived,
            'new_contacts_added'     => $newContactsAdded,
            'already_exists'         => $alreadyExists,
            'duplicates_by_employee' => $duplicatesByEmployee,
        ]);
    }

    private function normalizePhone(string $phone): string
    {
        // Remove spaces, dashes, parentheses
        $phone = preg_replace('/[\s\-\(\)]+/', '', $phone);

        // Egyptian: 01xxxxxxxxx → +201xxxxxxxxx
        if (preg_match('/^01[0-9]{9}$/', $phone)) {
            return '+20' . $phone;
        }

        // Egyptian: 201xxxxxxxxx → +201xxxxxxxxx
        if (preg_match('/^201[0-9]{9}$/', $phone)) {
            return '+' . $phone;
        }

        return $phone;
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
}
