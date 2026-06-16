@extends('layouts.app')

@section('styles')
    <style>
        body {
            background-color: #f8fafc;
        }

        .custom-card {
            border: none;
            border-radius: 24px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.03);
            background: #fff;
            overflow: visible !important;
            margin-top: 20px;
        }

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

        .role-badge {
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            display: inline-block;
        }

        .role-admin {
            background-color: #ffe2e5;
            color: #ef4444;
            border: 1px solid #fecaca;
        }

        .role-user {
            background-color: #e0f2fe;
            color: #3b82f6;
            border: 1px solid #bfdbfe;
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
                Employees Management
            </h4>
            <p class="text-muted mb-0 small fw-medium">Administration / <span class="text-primary">Staff</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Staff & Roles Hub</h3>
            <p class="mb-0 opacity-75 fw-medium">Manage employee accounts, emails, and system access roles.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a href="{{ route('employees.create') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #1e293b; height: 48px;">
                <i class="fas fa-user-plus me-2 text-primary"></i> Add New Employee
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
                                <th>Name</th>
                                <th>Email</th>
                                <th class="text-center">Role</th>
                                <th>Joined Date</th>
                                <th>Last Login</th>
                                <th class="text-center px-4">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($employees as $employee)
                                <tr>
                                    <td class="text-center fw-bold text-muted">{{ $loop->iteration }}</td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div
                                                class="avatar bg-light text-primary fw-bold rounded-circle d-flex align-items-center justify-content-center me-3"
                                                style="width: 40px; height: 40px;">
                                                {{ strtoupper(substr($employee->name, 0, 1)) }}
                                            </div>
                                            <span class="fw-bold text-dark">{{ $employee->name }}</span>
                                        </div>
                                    </td>
                                    <td class="text-muted">{{ $employee->email }}</td>
                                    <td class="text-center">
                                        @if($employee->systemRole)
                                            @if(strtolower($employee->systemRole->name) == 'admin')
                                                <span
                                                    class="role-badge role-admin">{{ $employee->systemRole->name }}</span>
                                            @else
                                                <span
                                                    class="role-badge role-user">{{ $employee->systemRole->name }}</span>
                                            @endif
                                        @else
                                            <span class="badge bg-secondary rounded-pill px-3">No Role</span>
                                        @endif
                                    </td>
                                    <td class="text-muted small">{{ $employee->created_at ? $employee->created_at->format('d M Y') : 'N/A' }}</td>
                                    <td class="small">
                                        @if($employee->last_login_at)
                                            <span class="text-success fw-semibold">{{ \Carbon\Carbon::parse($employee->last_login_at)->diffForHumans() }}</span>
                                            <br><span class="text-muted" style="font-size:11px;">{{ \Carbon\Carbon::parse($employee->last_login_at)->format('d M Y, H:i') }}</span>
                                        @else
                                            <span class="text-muted">Never</span>
                                        @endif
                                    </td>
                                    <td class="text-center px-4">
                                        @if($employee->email === 'admin@rehltna-panel.com')
                                            <span class="admin-badge">
                                                <i class="las la-lock fs-16"></i> Super Admin
                                            </span>
                                        @else
                                            <div class="d-flex justify-content-center gap-2">
                                                <a class="btn-action btn-edit-gal"
                                                   href="{{ route('employees.edit', encrypt($employee->id)) }}"
                                                   title="Edit Employee">
                                                    <i class="las la-pen fs-18"></i>
                                                </a>
                                                <a class="btn-action btn-delete-gal delete-btn"
                                                   data-route="{{ route('employees.destroy', $employee->id) }}"
                                                   data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"
                                                   title="Remove Employee">
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
                        <p class="text-muted small mb-0 fw-bold">Items: {{ $employees->firstItem() }}
                            - {{ $employees->lastItem() }} / Total: {{ $employees->total() }}</p>
                        {{ $employees->links() }}
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
