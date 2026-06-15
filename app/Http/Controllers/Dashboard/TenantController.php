<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Tenant;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class TenantController extends Controller
{
    public function index(): View
    {
        $tenants = Tenant::all();
        return view('pages.tenants.index', compact('tenants'));
    }

    public function create(): view|RedirectResponse
    {
        if (env('APP_TENANTS_SETTING') != 'on')
            return redirect()->route('tenants.index')->with('error', 'Tenants settings not allowed');

        return view('pages.tenants.create');
    }

    public function store(Request $request): RedirectResponse
    {
        if (env('APP_TENANTS_SETTING') != 'on')
            return redirect()->route('tenants.index')->with('error', 'Tenants settings not allowed');

        $request->validate([
            'email' => [
                'required',
                'email',
                Rule::unique(User::class, 'email'),
            ],
        ]);

        $data = $request->except(['image', 'password', 'email', 'options']);

        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $imageName = uniqid() . '_' . time() . '.' . $image->getClientOriginalExtension();
            $image->move(public_path('uploads/tenants'), $imageName);
            $data['image'] = 'uploads/tenants/' . $imageName;
        }

        $data['options'] = implode(',', $request->input('options', []));

        $tenant = Tenant::query()->create($data);

        User::query()->create([
            'tenant_id' => $tenant->id,
            'role' => 'user',
            'name' => $request->get('name'),
            'email' => $request->get('email'),
            'password' => Hash::make($request->get('password')),
        ]);

        return redirect()->route('tenants.index');
    }

    public function edit($id): View|RedirectResponse
    {
        if (env('APP_TENANTS_SETTING') != 'on')
            return redirect()->route('tenants.index')->with('error', 'Tenants settings not allowed');

        $tenant = Tenant::query()->findOrFail(decrypt($id));
        return view('pages.tenants.edit', compact('tenant'));
    }

    public function update(Request $request, $id): RedirectResponse
    {
        if (env('APP_TENANTS_SETTING') != 'on')
            return redirect()->route('tenants.index')->with('error', 'Tenants settings not allowed');

        $tenant = Tenant::query()->findOrFail($id);

        $request->validate([
            'email' => [
                'required',
                'email',
                Rule::unique('users', 'email')->ignore($tenant->user->id),
            ],
        ]);

        $data = $request->except(['image', 'password', 'email', 'options']);

        if ($request->hasFile('image')) {
            if ($tenant->image && file_exists(public_path($tenant->image))) {
                deleteFiles([$tenant->image]);
            }
            $image = $request->file('image');
            $imageName = uniqid() . '_' . time() . '.' . $image->getClientOriginalExtension();
            $image->move(public_path('uploads/tenants'), $imageName);
            $data['image'] = 'uploads/tenants/' . $imageName;
        }

        $data['options'] = implode(',', $request->input('options', []));

        $tenant->update($data);

        if ($request->has('password') && !empty($request->get('password'))) {
            $password = Hash::make($request->get('password'));
        } else {
            $password = $tenant->user->password ?? '';
        }

        User::query()->updateOrCreate(['tenant_id' => $tenant->id], [
            'role' => 'user',
            'name' => $request->get('name'),
            'email' => $request->get('email'),
            'password' => $password,
        ]);

        return redirect()->route('tenants.index')->with('success', 'Tenant updated successfully');
    }

    public function activate($id): RedirectResponse
    {
        $tenant = Tenant::query()->findOrFail($id);
        $tenant->makeCurrent();
        session(['tenant_id' => $tenant->id]);
        return redirect()->intended('/admin/dashboard')->with('info', 'Login successfully with database : ' . $tenant->name);
    }

    public function destroy($id): RedirectResponse
    {
        $tenant = Tenant::query()->findOrFail(decrypt($id));
        $tenant->user->delete();
        deleteFiles([$tenant->image]);
        $tenant->delete();
        return redirect()->route('tenants.index')->with('success', 'Tenant deleted successfully');
    }
}
