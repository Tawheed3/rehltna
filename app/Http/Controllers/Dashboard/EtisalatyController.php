<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\EtisalatyContact;
use App\Models\EtisalatyEmployeeContact;
use App\Models\User;
use App\Services\EtisalatyDistributionService;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class EtisalatyController extends Controller
{
    public function index(Request $request, EtisalatyDistributionService $distribution)
    {
        $summary = $distribution->rebalance();
        $query = EtisalatyContact::query();

        if ($request->filled('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('phone_number', 'like', '%' . $request->search . '%')
                  ->orWhere('contact_name', 'like', '%' . $request->search . '%');
            });
        }

        $contacts = $query->with(['employeeLinks.employee', 'assignedEmployee'])
            ->withCount('employeeLinks')
            ->orderByDesc('last_seen_at')
            ->paginate(20)
            ->withQueryString();

        $totalContacts  = EtisalatyContact::count();
        $totalEmployees = $distribution->employeesQuery()->count();

        $contacts->getCollection()->each(function (EtisalatyContact $contact) use ($distribution) {
            $contact->setAttribute('ownership_marker', $distribution->ownershipMarker($contact->employeeLinks));
        });

        // Top uploaders — only count links to contacts that still exist
        $topEmployees = $distribution->employeesQuery()
            ->withCount(['etisalatyUploads as uploads_count' => fn($q) => $q->whereHas('contact')])
            ->orderByDesc('uploads_count')
            ->take(5)
            ->get();

        $employees = $distribution->employeesQuery()
            ->withCount([
                'etisalatyUploads as uploads_count' => fn ($q) => $q->whereHas('contact'),
                'assignedEtisalatyContacts as assigned_count',
            ])
            ->orderBy('name')
            ->get();

        return view('pages.etisalaty.index', compact(
            'contacts', 'totalContacts', 'totalEmployees', 'topEmployees', 'employees', 'summary'
        ));
    }

    public function distribute(EtisalatyDistributionService $distribution)
    {
        $summary = $distribution->rebalance();

        return back()->with('success', "Distributed {$summary['total_unique_numbers']} unique contacts.");
    }

    public function exportAll(EtisalatyDistributionService $distribution)
    {
        $distribution->rebalance();

        return response()->streamDownload(function () use ($distribution) {
            $output = fopen('php://output', 'w');
            fprintf($output, chr(0xEF) . chr(0xBB) . chr(0xBF)); // UTF-8 BOM for Excel/Sheets
            fputcsv($output, ['phone_number', 'contact_name', 'ownership', 'assigned_to']);

            EtisalatyContact::query()
                ->with(['employeeLinks.employee', 'assignedEmployee'])
                ->orderBy('contact_name')
                ->each(fn (EtisalatyContact $contact) => fputcsv($output, [
                    $contact->phone_number,
                    $contact->contact_name,
                    $distribution->ownershipMarker($contact->employeeLinks),
                    $contact->assignedEmployee?->name ?? '',
                ]));

            fclose($output);
        }, 'etisalaty-all-contacts-' . now()->format('Y-m-d') . '.csv', ['Content-Type' => 'text/csv; charset=UTF-8']);
    }

    public function exportAssigned(int $employeeId, EtisalatyDistributionService $distribution)
    {
        $employee = $distribution->employeesQuery()->findOrFail($employeeId);
        $distribution->rebalance();

        $filename = 'etisalaty-assigned-' . Str::slug($employee->name) . '.csv';

        return response()->streamDownload(function () use ($employee, $distribution) {
            $output = fopen('php://output', 'w');
            fputcsv($output, ['phone_number', 'contact_name', 'ownership_marker']);

            EtisalatyContact::query()
                ->where('assigned_employee_id', $employee->id)
                ->with('employeeLinks.employee')
                ->orderBy('contact_name')
                ->each(fn (EtisalatyContact $contact) => fputcsv($output, [
                    $contact->phone_number,
                    $contact->contact_name,
                    $distribution->ownershipMarker($contact->employeeLinks),
                ]));

            fclose($output);
        }, $filename, ['Content-Type' => 'text/csv']);
    }

    public function destroy(int $id, EtisalatyDistributionService $distribution)
    {
        EtisalatyEmployeeContact::where('contact_id', $id)->delete();
        EtisalatyContact::findOrFail($id)->delete();
        $distribution->rebalance();

        return back()->with('success', 'Contact deleted.');
    }

    public function destroyByEmployee(int $employeeId, EtisalatyDistributionService $distribution)
    {
        $employee = $distribution->employeesQuery()->findOrFail($employeeId);

        $contactIds = EtisalatyEmployeeContact::where('employee_id', $employeeId)
            ->pluck('contact_id');

        // Delete all employee_contact links pointing to these contacts (any employee)
        EtisalatyEmployeeContact::whereIn('contact_id', $contactIds)->delete();

        $deleted = EtisalatyContact::whereIn('id', $contactIds)->delete();
        $distribution->rebalance();

        return back()->with('success', "Deleted {$deleted} contacts uploaded by {$employee->name}.");
    }
}
