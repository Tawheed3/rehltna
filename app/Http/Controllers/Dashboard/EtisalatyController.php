<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\EtisalatyContact;
use App\Models\EtisalatyEmployeeContact;
use App\Models\User;
use Illuminate\Http\Request;

class EtisalatyController extends Controller
{
    public function index(Request $request)
    {
        $query = EtisalatyContact::query();

        if ($request->filled('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('phone_number', 'like', '%' . $request->search . '%')
                  ->orWhere('contact_name', 'like', '%' . $request->search . '%');
            });
        }

        $contacts = $query->withCount('employeeLinks')
            ->orderByDesc('last_seen_at')
            ->paginate(20)
            ->withQueryString();

        $totalContacts  = EtisalatyContact::count();
        $totalEmployees = User::whereNotNull('etisalaty_role')->count();
        $totalUploads   = EtisalatyEmployeeContact::count();

        // Top uploaders — only count links to contacts that still exist
        $topEmployees = User::whereNotNull('etisalaty_role')
            ->withCount(['etisalatyUploads as uploads_count' => fn($q) => $q->whereHas('contact')])
            ->orderByDesc('uploads_count')
            ->take(5)
            ->get();

        return view('pages.etisalaty.index', compact(
            'contacts', 'totalContacts', 'totalEmployees', 'topEmployees'
        ));
    }

    public function destroy(int $id)
    {
        EtisalatyEmployeeContact::where('contact_id', $id)->delete();
        EtisalatyContact::findOrFail($id)->delete();
        return back()->with('success', 'Contact deleted.');
    }

    public function destroyByEmployee(int $employeeId)
    {
        $employee = User::findOrFail($employeeId);

        $contactIds = EtisalatyEmployeeContact::where('employee_id', $employeeId)
            ->pluck('contact_id');

        // Delete all employee_contact links pointing to these contacts (any employee)
        EtisalatyEmployeeContact::whereIn('contact_id', $contactIds)->delete();

        $deleted = EtisalatyContact::whereIn('id', $contactIds)->delete();

        return back()->with('success', "Deleted {$deleted} contacts uploaded by {$employee->name}.");
    }
}
