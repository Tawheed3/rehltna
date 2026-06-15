@extends('layouts.app')

@section('styles')
    <style>
        /* Global Background */
        body {
            background-color: #f8fafc;
        }

        /* Card Styling */
        .custom-card {
            border: none;
            border-radius: 24px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.03);
            background: #fff;
            overflow: visible !important;
            margin-top: 20px;
        }

        /* Hero Header Section */
        .hero-section {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            border-radius: 24px;
            padding: 45px 35px;
            margin-bottom: 35px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 20px 30px rgba(0, 0, 0, 0.12);
        }

        /* Table Styling */
        .table-responsive {
            border-radius: 18px;
            overflow: hidden;
            padding: 2px;
        }

        .table {
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0;
            width: 100%;
        }

        .table thead th {
            background-color: #f1f5f9 !important;
            color: #475569 !important;
            text-transform: uppercase !important;
            font-size: 11px !important;
            font-weight: 800 !important;
            letter-spacing: 1.5px !important;
            padding: 25px 20px !important;
            border: none !important;
            border-bottom: 2px solid #e2e8f0 !important;
            line-height: 1.5 !important;
            vertical-align: middle !important;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background-color: #f8fafc;
            transform: translateY(-1px);
        }

        .table td {
            padding: 22px 20px;
            vertical-align: middle;
            color: #334155;
            border-top: 1px solid #f1f5f9;
        }

        /* Users Count Badge */
        .users-badge {
            background-color: #e0f2fe;
            color: #0ea5e9;
            border: 1px solid #bae6fd;
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        /* Perm Badge */
        .perm-badge {
            font-size: 11px;
            padding: 5px 10px;
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            color: #475569;
            border-radius: 6px;
            font-weight: 600;
            text-transform: capitalize;
        }

        /* Action Buttons */
        .btn-action {
            width: 42px;
            height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 14px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: #fff;
            border: 1px solid #e2e8f0;
            color: #64748b;
        }

        .btn-action:hover {
            transform: scale(1.15) rotate(5deg);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.08);
        }

        .btn-edit-gal:hover {
            color: #4f46e5;
            border-color: #4f46e5;
            background: #f5f3ff;
        }

        .btn-delete-gal:hover {
            color: #ef4444;
            border-color: #ef4444;
            background: #fef2f2;
        }

        .admin-badge {
            background-color: #ffe2e5 !important;
            color: #ef4444 !important;
            border: 1px solid #fecaca !important;
            padding: 8px 18px;
            border-radius: 50px;
            font-size: 13px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
    </style>
@endsection

@section('content')
    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Roles & Permissions
            </h4>
            <p class="text-muted mb-0 small fw-medium">Administration / <span
                    class="text-primary">Roles Management</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Roles Hub</h3>
            <p class="mb-0 opacity-75 fw-medium">Create customized roles and manage system access levels.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a href="{{ route('roles.create') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #1e293b; height: 48px;">
                <i class="fas fa-plus-circle me-2 text-primary"></i> Create Role
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-12">
            <div class="card custom-card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table" id="table">
                            <thead>
                            <tr>
                                <th class="text-center" width="80">#</th>
                                <th>Role Name</th>
                                <th>Permissions</th>
                                <th class="text-center">Assigned Users</th>
                                <th class="text-center px-4">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($roles as $role)
                                <tr>
                                    <td class="text-center fw-bold text-muted">{{ $loop->iteration }}</td>

                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div
                                                class="avatar bg-light text-primary fw-bold rounded-circle d-flex align-items-center justify-content-center me-3"
                                                style="width: 40px; height: 40px;">
                                                @if(strtolower($role->name) == 'admin')
                                                    <i class="las la-crown fs-5 text-warning"></i>
                                                @else
                                                    <i class="las la-shield-alt fs-5"></i>
                                                @endif
                                            </div>
                                            <span class="fw-bold text-dark fs-15">{{ $role->name }}</span>
                                        </div>
                                    </td>

                                    <td>
                                        @if(is_array($role->permissions) && count($role->permissions) > 0)
                                            <div class="d-flex flex-wrap gap-1" style="max-width: 600px;">
                                                @foreach(array_slice($role->permissions, 0, 5) as $perm)
                                                    <span class="perm-badge">{{ str_replace('_', ' ', $perm) }}</span>
                                                @endforeach

                                                @if(count($role->permissions) > 5)
                                                    <span class="perm-badge bg-primary text-white border-primary"
                                                          style="opacity: 0.9;">
                                                        +{{ count($role->permissions) - 5 }} More
                                                    </span>
                                                @endif
                                            </div>
                                        @else
                                            <span class="text-muted small fw-bold"><i class="las la-ban"></i> No Permissions</span>
                                        @endif
                                    </td>

                                    <td class="text-center">
                                        <span class="users-badge">
                                            <i class="las la-users fs-15"></i> {{ $role->users_count ?? 0 }} Users
                                        </span>
                                    </td>

                                    <td class="text-center px-4">
                                        @if(strtolower($role->name) == 'admin')
                                            <span class="admin-badge">
                                                <i class="las la-lock fs-16"></i> System Role
                                            </span>
                                        @else
                                            <div class="d-flex justify-content-center gap-2">
                                                <a class="btn-action btn-edit-gal"
                                                   href="{{ route('roles.edit', encrypt($role->id)) }}"
                                                   title="Edit Role">
                                                    <i class="las la-pen fs-18"></i>
                                                </a>
                                                <a class="btn-action btn-delete-gal delete-btn"
                                                   data-route="{{ route('roles.destroy', $role->id) }}"
                                                   data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"
                                                   title="Remove Role">
                                                    <i class="las la-trash fs-18"></i>
                                                </a>
                                            </div>
                                        @endif
                                    </td>
                                </tr>
                            @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card-footer bg-transparent border-0 p-4 mt-2">
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="text-muted small mb-0 fw-bold">Items: {{ $roles->firstItem() }}
                            - {{ $roles->lastItem() }} / Total: {{ $roles->total() }}</p>
                        {{ $roles->links() }}
                    </div>
                </div>
            </div>

            @include('pages.models.confirm-delete')

        </div>
    </div>
@endsection

@section('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete();
        });
    </script>
@endsection
