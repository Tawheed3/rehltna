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

        // Top uploaders
        $topEmployees = User::whereNotNull('etisalaty_role')
            ->withCount(['etisalatyUploads as uploads_count'])
            ->orderByDesc('uploads_count')
            ->take(5)
            ->get();

        return view('pages.etisalaty.index', compact(
            'contacts', 'totalContacts', 'totalEmployees', 'totalUploads', 'topEmployees'
        ));
    }

    public function destroy(int $id)
    {
        EtisalatyContact::findOrFail($id)->delete();
        return back()->with('success', 'Contact deleted.');
    }
}
