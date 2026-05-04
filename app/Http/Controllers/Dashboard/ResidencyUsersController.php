<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Jobs\SendRegisterUserReplyJob;
use App\Models\Package;
use App\Models\RegisterUsers;
use App\Models\ResidencyUser;
use App\Models\Tenant;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class ResidencyUsersController extends Controller
{
    public function index(Request $request): view|string
    {
        $query = ResidencyUser::query()->with(['package'])->withCount('items', 'orders');

        if ($request->has('search') && $request->get('search') != '') {
            $query->where(function ($q) use ($request) {
                $q->where('name', 'like', "%{$request->get('search')}%")
                    ->orWhere('email', 'like', "%{$request->get('search')}%")
                    ->orWhere('phone', 'like', "%{$request->get('search')}%");
            });
        }

        if ($request->has('package_id') && $request->get('package_id') != 'all') {
            $query->where('package_id', $request->get('package_id'));
        }

        $residencyUsers = $query->latest()->paginate(10);
        $packages = Package::all();

        if ($request->ajax()) {
            return view('pages.residency-users.partials.table', compact('residencyUsers', 'packages'))->render();
        }

        return view('pages.residency-users.index', compact('residencyUsers', 'packages'));
    }

    public function destroy($id): RedirectResponse
    {
        ResidencyUser::query()->findOrFail($id)->delete();
        return redirect()->back()->with('success', 'Residency users deleted successfully.');
    }

    public function bulkDelete(Request $request): RedirectResponse
    {
        $ids = $request->get('ids');
        if (!is_array($ids) || count($ids) === 0) {
            return redirect()->back()->with('warning', 'No register user selected for deletion.');
        }

        ResidencyUser::query()->whereIn('id', $ids)->delete();
        return redirect()->back()->with('success', 'Residency users deleted successfully.');
    }

    public function changePackage(Request $request, $id): RedirectResponse
    {
        $request->validate([
            'package_id' => ['required', Rule::exists(Package::class, 'id')]
        ]);

        $user = ResidencyUser::query()->findOrFail($id);
        $user->update([
            'package_id' => $request->get('package_id')
        ]);

        return redirect()->back()->with('success', "User's package updated successfully.");
    }

    public function updatePoints(Request $request, $id): RedirectResponse
    {
        $request->validate([
            'available_points' => ['required', 'numeric', 'min:0'],
        ]);

        $user = ResidencyUser::query()->findOrFail($id);
        $user->update([
            'available_points' => $request->get('available_points'),
            'earned_points'    => $request->get('available_points'),
        ]);

        return redirect()->back()->with('success', "User's points updated successfully.");
    }

}
