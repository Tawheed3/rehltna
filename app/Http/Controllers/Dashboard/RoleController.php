<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Role;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class RoleController extends Controller
{
    public array $permissions_list = [
        'Content' => [
            'manage_blogs'        => 'Blogs',
            'manage_offers'       => 'Offers',
            'manage_sliders'      => 'Sliders & Members',
            'manage_custom_pages' => 'Custom Pages',
        ],
        'Trips' => [
            'manage_trips'        => 'Trips & Trip Types',
            'manage_testimonials' => 'Reviews & Testimonials',
        ],
        'Sales' => [
            'manage_orders'          => 'Orders',
            'manage_coupons'         => 'Coupons',
            'manage_payment_methods' => 'Payment Methods',
        ],
        'Customers' => [
            'manage_customers'   => 'Users & Packages',
            'manage_contact_us'  => 'Contact Messages',
            'manage_subscribers' => 'Subscribers',
            'manage_leads'       => 'Leads',
        ],
        'Locations' => [
            'manage_locations' => 'Countries, States & Cities',
            'manage_events'    => 'Events & Tourist Attractions',
            'manage_news'      => 'News',
        ],
        'Operations' => [
            'manage_careers'       => 'Careers & Job Applications',
            'manage_notifications' => 'Notifications',
        ],
        'System' => [
            'manage_staff'     => 'Staff & Roles',
            'manage_settings'  => 'Settings & Integrations',
            'manage_etisalaty' => 'Etisalaty Contacts',
        ],
    ];

    public function index(): View
    {
        $roles = Role::query()->withCount('users')->orderByDesc('id')->paginate(10);
        return view('pages.roles.index', compact('roles'));
    }

    public function create(): View
    {
        $permissions = $this->permissions_list;
        return view('pages.roles.create', compact('permissions'));
    }

    public function store(Request $request): RedirectResponse
    {
        $validKeys = collect($this->permissions_list)->flatten()->keys()->toArray();
        $request->validate([
            'name' => [
                'required',
                'string',
                'max:255',
                Rule::unique(Role::class, 'name')
            ],
            'permissions'   => 'nullable|array',
            'permissions.*' => ['string', Rule::in($validKeys)],
        ]);

        Role::query()->create([
            'name' => $request->name,
            'permissions' => $request->permissions ?? [],
        ]);

        return redirect()->route('roles.index')->with('success', 'Role created successfully.');
    }

    public function edit($id): View|RedirectResponse
    {
        $role = Role::query()->findOrFail(decrypt($id));
        if (strtolower($role->name) === 'admin') {
            return redirect()->route('roles.index')->with('error', 'The Admin role is a system role and cannot be edited.');
        }
        $permissions = $this->permissions_list;
        return view('pages.roles.edit', compact('role', 'permissions'));
    }

    public function update(Request $request, $id): RedirectResponse
    {
        $role = Role::query()->findOrFail($id);
        if (strtolower($role->name) === 'admin') {
            return redirect()->route('roles.index')->with('error', 'The Admin role is a system role and cannot be edited.');
        }
        $validKeys = collect($this->permissions_list)->flatten()->keys()->toArray();
        $request->validate([
            'name' => [
                'required',
                'string',
                'max:255',
                Rule::unique(Role::class, 'name')->ignore($role->id)
            ],
            'permissions'   => 'nullable|array',
            'permissions.*' => ['string', Rule::in($validKeys)],
        ]);

        $role->update([
            'name' => $request->name,
            'permissions' => $request->permissions ?? [],
        ]);

        return redirect()->route('roles.index')->with('success', 'Role updated successfully.');
    }

    public function destroy($id): RedirectResponse
    {
        $role = Role::query()->findOrFail($id);
        if (strtolower($role->name) === 'admin') {
            return redirect()->route('roles.index')->with('error', 'The Admin role is a system role and cannot be deleted.');
        }
        if ($role->users()->count() > 0) {
            return redirect()->back()->with('error', 'Cannot delete role assigned to users.');
        }
        $role->delete();
        return redirect()->route('roles.index')->with('success', 'Role deleted successfully.');
    }
}
