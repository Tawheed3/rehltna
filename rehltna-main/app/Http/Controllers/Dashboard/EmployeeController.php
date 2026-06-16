<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Tenant;
use App\Models\User;
use App\Models\Role;
use App\Services\ActivityLogger;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\RedirectResponse;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class EmployeeController extends Controller
{
    public function index(): View
    {
        $employees = User::query()->with('systemRole')->orderByDesc('id')->paginate(10);
        return view('pages.employees.index', compact('employees'));
    }

    public function create(): View
    {
        $roles = Role::all();
        return view('pages.employees.create', compact('roles'));
    }

    public function store(Request $request): RedirectResponse
    {
        $request->validate([
            'name' => 'required|string|max:191',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'role_id' => [
                'required',
                Rule::exists(Role::class, 'id')
            ],
        ]);

        try {
            $data = $request->except(['password']);
            $data['password'] = Hash::make($request->password);

            $data['role'] = 'user';
            $data['tenant_id'] = Tenant::query()->first()->id;

            $employee = User::create($data);

            ActivityLogger::log('created', "Employee \"{$employee->name}\" ({$employee->email}) was created.", 'Employee', $employee->id);

            return redirect()->route('employees.index')->with('success', 'Employee created successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function edit($id): View|RedirectResponse
    {
        $employee = User::findOrFail(decrypt($id));
        if ($employee->email === 'admin@rehltna-panel.com') {
            return redirect()->route('employees.index')->with('error', 'Super Admin account cannot be edited.');
        }
        $roles = Role::all();
        return view('pages.employees.edit', compact('employee', 'roles'));
    }

    public function update(Request $request, $id): RedirectResponse
    {
        $employee = User::findOrFail($id);
        if ($employee->email === 'admin@rehltna-panel.com') {
            return redirect()->route('employees.index')->with('error', 'Super Admin account cannot be edited.');
        }
        $request->validate([
            'name' => 'required|string|max:191',
            'email' => 'required|email|unique:users,email,' . $employee->id,
            'role_id' => [
                'required',
                Rule::exists(Role::class, 'id')
            ],
            'password' => 'nullable|string|min:6',
        ]);

        try {
            $data = $request->except(['password']);

            if ($request->filled('password')) {
                $data['password'] = Hash::make($request->password);
            }

            $employee->update($data);

            ActivityLogger::log('updated', "Employee \"{$employee->name}\" ({$employee->email}) was updated.", 'Employee', $employee->id);

            return redirect()->route('employees.index')->with('success', 'Employee updated successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function destroy($id): RedirectResponse
    {
        try {
            $employee = User::findOrFail($id);
            if ($employee->email === 'admin@rehltna-panel.com') {
                return redirect()->route('employees.index')->with('error', 'Super Admin account cannot be deleted.');
            }
            ActivityLogger::log('deleted', "Employee \"{$employee->name}\" ({$employee->email}) was deleted.", 'Employee', $id);
            $employee->delete();
            return redirect()->route('employees.index')->with('success', 'Employee deleted successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }
}
