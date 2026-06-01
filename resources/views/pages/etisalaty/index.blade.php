@extends('layouts.app')

@section('content')
<div class="container-fluid">

    {{-- Header --}}
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="fw-bold mb-0">Etisalaty Contacts</h2>
            <small class="text-muted">All contacts uploaded by employees via the Etisalaty app</small>
        </div>
        <form method="POST" action="{{ route('etisalaty.distribute') }}">
            @csrf
            <button class="btn btn-primary">Rebalance Assignments</button>
        </form>
    </div>

    {{-- Alerts --}}
    @if(session('success'))
        <div class="alert alert-success alert-dismissible fade show">
            {{ session('success') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    @endif

    {{-- Stats Cards --}}
    <div class="row g-3 mb-4">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm text-center py-4">
                <div class="card-body">
                    <div class="fs-1 fw-bold text-primary">{{ number_format($totalContacts) }}</div>
                    <div class="text-muted mt-1">Total Unique Saudi Contacts</div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card border-0 shadow-sm text-center py-4">
                <div class="card-body">
                    <div class="fs-1 fw-bold text-success">{{ number_format($totalEmployees) }}</div>
                    <div class="text-muted mt-1">Employees with App Access</div>
                </div>
            </div>
        </div>
    </div>

    {{-- Distribution Summary --}}
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-header bg-transparent border-0 pt-3">
            <h6 class="fw-bold mb-0">Distribution Summary</h6>
        </div>
        <div class="card-body">
            <div class="row g-3">
                @foreach($summary['assigned_per_employee'] as $assignment)
                    <div class="col-md-4">
                        <div class="border rounded p-3">
                            <div class="text-muted small">{{ $assignment['employee_name'] }}</div>
                            <div class="fs-4 fw-bold">{{ number_format($assignment['total_assigned']) }} assigned</div>
                        </div>
                    </div>
                @endforeach
            </div>
            <div class="mt-3">
                <span class="fw-semibold me-2">Ownership groups:</span>
                @foreach($summary['ownership_groups'] as $marker => $count)
                    <span class="badge bg-secondary me-1">{{ $marker }}: {{ number_format($count) }}</span>
                @endforeach
                @if($summary['total_unassigned'] > 0)
                    <span class="badge bg-danger">Unassigned: {{ number_format($summary['total_unassigned']) }}</span>
                @endif
            </div>
        </div>
    </div>

    <div class="row g-3">
        {{-- Contacts Table --}}
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 pt-3 pb-0">
                    <form method="GET" action="{{ route('etisalaty.index') }}" class="d-flex gap-2">
                        <input type="text" name="search" class="form-control" placeholder="Search by name or number..." value="{{ request('search') }}">
                        <button type="submit" class="btn btn-secondary px-4">Search</button>
                        @if(request('search'))
                            <a href="{{ route('etisalaty.index') }}" class="btn btn-outline-secondary">Clear</a>
                        @endif
                    </form>
                </div>
                <div class="card-body p-0 mt-3">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Phone Number</th>
                                    <th>Contact Name</th>
                                    <th>Owners</th>
                                    <th>Assigned To</th>
                                    <th>First Seen</th>
                                    <th>Last Seen</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                @forelse($contacts as $contact)
                                <tr>
                                    <td class="text-muted small">{{ $contact->id }}</td>
                                    <td class="fw-semibold">{{ $contact->phone_number }}</td>
                                    <td>{{ $contact->contact_name }}</td>
                                    <td>
                                        <span class="badge bg-primary rounded-pill">
                                            {{ $contact->ownership_marker }}
                                        </span>
                                    </td>
                                    <td>{{ $contact->assignedEmployee?->name ?? 'Unassigned' }}</td>
                                    <td class="text-muted small">{{ \Carbon\Carbon::parse($contact->first_seen_at)->format('d M Y') }}</td>
                                    <td class="text-muted small">{{ \Carbon\Carbon::parse($contact->last_seen_at)->format('d M Y') }}</td>
                                    <td>
                                        <form method="POST" action="{{ route('etisalaty.destroy', $contact->id) }}"
                                              onsubmit="return confirm('Delete this contact?')">
                                            @csrf @method('DELETE')
                                            <button class="btn btn-sm btn-danger" title="Delete">
                                                <i class="fe fe-trash-2"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                @empty
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-5">No contacts uploaded yet.</td>
                                </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>
                @if($contacts->hasPages())
                <div class="card-footer bg-transparent border-0">
                    {{ $contacts->links() }}
                </div>
                @endif
            </div>
        </div>

        {{-- Top Employees --}}
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 pt-3">
                    <h6 class="fw-bold mb-0">Top Uploaders</h6>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        @forelse($topEmployees as $emp)
                        <li class="list-group-item d-flex align-items-center justify-content-between px-4 py-3">
                            <div>
                                <div class="fw-semibold">{{ $emp->name }}</div>
                                <small class="text-muted">
                                    {{ $emp->etisalaty_role === 'security' ? '🔒 Security' : '👤 Employee' }}
                                </small>
                            </div>
                            <span class="badge bg-primary rounded-pill fs-6">{{ number_format($emp->uploads_count) }}</span>
                        </li>
                        @empty
                        <li class="list-group-item text-center text-muted py-4">No uploads yet.</li>
                        @endforelse
                    </ul>
                </div>
            </div>

            {{-- Employees with App Access --}}
            <div class="card border-0 shadow-sm mt-3">
                <div class="card-header bg-transparent border-0 pt-3">
                    <h6 class="fw-bold mb-0">App Users</h6>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        @foreach($employees as $emp)
                        <li class="list-group-item px-4 py-3">
                            <div class="d-flex align-items-center justify-content-between mb-1">
                                <div>
                                    <div class="fw-semibold small">{{ $emp->name }}</div>
                                    <div class="text-muted" style="font-size:11px;">{{ $emp->email }}</div>
                                </div>
                                @if($emp->etisalaty_role === 'security')
                                    <span class="badge bg-danger">Security</span>
                                @else
                                    <span class="badge bg-secondary">Employee</span>
                                @endif
                            </div>
                            <div class="d-flex align-items-center justify-content-between mt-2">
                                <small class="text-muted">
                                    {{ number_format($emp->uploads_count) }} uploaded,
                                    {{ number_format($emp->assigned_count) }} assigned
                                </small>
                                <a href="{{ route('etisalaty.export-assigned', $emp->id) }}" class="btn btn-sm btn-outline-primary">
                                    Export Assigned
                                </a>
                            </div>
                            <div class="d-flex justify-content-end mt-2">
                                @if($emp->uploads_count > 0)
                                <form method="POST"
                                      action="{{ route('etisalaty.destroy-by-employee', $emp->id) }}"
                                      onsubmit="return confirm('Delete ALL {{ $emp->uploads_count }} contacts uploaded by {{ $emp->name }}?')">
                                    @csrf @method('DELETE')
                                    <button class="btn btn-sm btn-outline-danger">
                                        <i class="fe fe-trash-2 me-1"></i> Delete All
                                    </button>
                                </form>
                                @endif
                            </div>
                        </li>
                        @endforeach
                    </ul>
                </div>
            </div>
        </div>
    </div>

</div>
@endsection
