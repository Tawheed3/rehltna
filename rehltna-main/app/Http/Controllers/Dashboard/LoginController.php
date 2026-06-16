<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;


class LoginController extends Controller
{
    public function loginForm(): view
    {
        return view('pages.auth.index');
    }

    public function loginSubmit(LoginRequest $request): RedirectResponse
    {
        $credentials = $request->only('email', 'password');
        if (Auth::guard('web')->attempt($credentials)) {
            $request->session()->regenerate();
            $user = Auth::guard('web')->user();
            $user->update(['last_login_at' => now()]);
//            if ($user->role == 'admin') {
//                return redirect()->route('tenants.index')->with('info', 'Login successfully select database to continue');
//            } else {
            $TenantController = new TenantController();
            return $TenantController->activate($user->tenant_id);
//            }
        }
        return redirect()->back()->with('error', 'invalid login details');
    }

    public function logOut(Request $request): RedirectResponse
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect()->route('admin.login.form')->with('info', 'Logout successfully.');
    }
}
