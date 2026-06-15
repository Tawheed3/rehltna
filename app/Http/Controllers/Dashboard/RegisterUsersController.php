<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Jobs\SendRegisterUserReplyJob;
use App\Models\RegisterUsers;
use App\Models\Tenant;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class RegisterUsersController extends Controller
{
    public function index(Request $request): view|string
    {
        $query = RegisterUsers::query();

        if ($request->has('search')) {
            $query->when($request->get('search'), function ($q) use ($request) {
                $q->where('name', 'like', "%{$request->get('search')}%")
                    ->orWhere('email', 'like', "%{$request->get('search')}%")
                    ->orWhere('phone', 'like', "%{$request->get('search')}%")
                    ->orWhere('specialty', 'like', "%{$request->get('search')}%")
                    ->orWhere('country', 'like', "%{$request->get('search')}%");
            });
        }

        $registerUsers = $query->latest()
            ->paginate(10);

        if ($request->ajax()) {
            return view('pages.register-users.partials.table', compact('registerUsers'))->render();
        }

        return view('pages.register-users.index', compact('registerUsers'));

    }

    public function destroy($id): RedirectResponse
    {
        RegisterUsers::query()->findOrFail($id)->delete();
        return redirect()->back()->with('success', 'Register users deleted successfully.');
    }

    public function bulkDelete(Request $request): RedirectResponse
    {
        $ids = $request->get('ids');
        if (!is_array($ids) || count($ids) === 0) {
            return redirect()->back()->with('warning', 'No register user selected for deletion.');
        }

        RegisterUsers::query()->whereIn('id', $ids)->delete();
        return redirect()->back()->with('success', 'Register users deleted successfully.');
    }

    public function replyMessage(Request $request, $id): RedirectResponse
    {
        $registerUser = RegisterUsers::query()->findOrFail($id);
        $reply = $request->get('reply');

        $registerUser->update([
            'reply' => $reply,
        ]);

        SendRegisterUserReplyJob::dispatch($registerUser->id, $reply, Tenant::query()->first()->id);

        return redirect()->back()->with('success', 'Reply sent successfully via email.');

    }

}
