<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Jobs\SendRegisterUserReplyJob;
use App\Models\Package;
use App\Models\PointLog;
use App\Models\RegisterUsers;
use App\Models\ResidencyUser;
use App\Models\Tenant;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
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
            'action' => ['required', 'in:add,deduct'],
            'points' => ['required', 'integer', 'min:1'],
            'reason' => ['required', 'string', 'min:10', 'max:500'],
        ]);

        $user          = ResidencyUser::query()->findOrFail($id);
        $balanceBefore = (int) $user->available_points;
        $amount        = (int) $request->get('points');
        $action        = $request->get('action');

        if ($action === 'add') {
            $newBalance = $balanceBefore + $amount;
            $diff       = $amount;
        } else {
            $newBalance = max(0, $balanceBefore - $amount);
            $diff       = -($balanceBefore - $newBalance);
        }

        $user->update([
            'available_points' => $newBalance,
            'earned_points'    => $action === 'add' ? $user->earned_points + $amount : $user->earned_points,
        ]);

        PointLog::create([
            'residency_user_id' => $user->id,
            'type'              => 'employee_adjusted',
            'points'            => $diff,
            'balance_before'    => $balanceBefore,
            'balance_after'     => $newBalance,
            'reason'            => $request->get('reason'),
            'employee_id'       => Auth::id(),
            'employee_name'     => Auth::user()->name ?? Auth::user()->username ?? 'Admin',
        ]);

        return redirect()->back()->with('success', "User's points updated successfully.");
    }

}
