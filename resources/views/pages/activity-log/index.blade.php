@extends('layouts.app')

@section('styles')
    <style>
        body { background-color: #f8fafc; }

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

        .table thead th {
            background-color: #f1f5f9 !important;
            color: #475569 !important;
            text-transform: uppercase !important;
            font-size: 11px !important;
            font-weight: 800 !important;
            letter-spacing: 1.5px !important;
            padding: 18px 16px !important;
            border: none !important;
            border-bottom: 2px solid #e2e8f0 !important;
        }

        .table td {
            padding: 16px;
            vertical-align: middle;
            color: #334155;
            border-top: 1px solid #f1f5f9;
            font-size: 13px;
        }

        .action-badge {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-approved  { background: #d1fae5; color: #065f46; }
        .badge-rejected  { background: #fee2e2; color: #991b1b; }
        .badge-deleted   { background: #fef3c7; color: #92400e; }
        .badge-created   { background: #dbeafe; color: #1e40af; }
        .badge-updated   { background: #ede9fe; color: #5b21b6; }
        .badge-default   { background: #f1f5f9; color: #475569; }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Activity Log
            </h4>
            <p class="text-muted mb-0 small fw-medium">Administration / <span class="text-primary">Audit Trail</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Admin Activity Audit</h3>
            <p class="mb-0 opacity-75 fw-medium">Track every action taken by staff members in the system.</p>
        </div>
        <div>
            <span class="badge bg-light text-dark fw-bold px-3 py-2 rounded-pill" style="font-size: 13px;">
                <i class="fas fa-shield-alt me-1 text-primary"></i> {{ $logs->total() }} Total Records
            </span>
        </div>
    </div>

    {{-- Filters --}}
    <form method="GET" action="{{ route('activity-log.index') }}" class="row g-3 mb-4">
        <div class="col-md-5">
            <input type="text" name="search" value="{{ request('search') }}"
                   class="form-control rounded-pill border-0 shadow-sm"
                   placeholder="Search by user or description…">
        </div>
        <div class="col-md-3">
            <select name="action" class="form-select rounded-pill border-0 shadow-sm">
                <option value="">All Actions</option>
                @foreach($actions as $action)
                    <option value="{{ $action }}" @selected(request('action') === $action)>{{ ucfirst($action) }}</option>
                @endforeach
            </select>
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-primary rounded-pill px-4 w-100">Filter</button>
        </div>
        @if(request('search') || request('action'))
            <div class="col-md-2">
                <a href="{{ route('activity-log.index') }}" class="btn btn-outline-secondary rounded-pill px-4 w-100">Clear</a>
            </div>
        @endif
    </form>

    <div class="row">
        <div class="col-xl-12">
            <div class="card custom-card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table" style="border-collapse: separate; border-spacing: 0;">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>User</th>
                                <th>Action</th>
                                <th>Description</th>
                                <th>Subject</th>
                                <th>IP Address</th>
                                <th>Date & Time</th>
                            </tr>
                            </thead>
                            <tbody>
                            @forelse($logs as $log)
                                <tr>
                                    <td class="text-muted fw-bold">{{ $logs->firstItem() + $loop->index }}</td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div style="width:32px;height:32px;border-radius:50%;background:#e2e8f0;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:12px;color:#475569;flex-shrink:0;">
                                                {{ strtoupper(substr($log->user_name, 0, 1)) }}
                                            </div>
                                            <span class="fw-semibold text-dark">{{ $log->user_name }}</span>
                                        </div>
                                    </td>
                                    <td>
                                        @php
                                            $badgeClass = match($log->action) {
                                                'approved' => 'badge-approved',
                                                'rejected' => 'badge-rejected',
                                                'deleted'  => 'badge-deleted',
                                                'created'  => 'badge-created',
                                                'updated'  => 'badge-updated',
                                                default    => 'badge-default',
                                            };
                                        @endphp
                                        <span class="action-badge {{ $badgeClass }}">{{ $log->action }}</span>
                                    </td>
                                    <td style="max-width:300px;">{{ $log->description }}</td>
                                    <td class="text-muted small">
                                        @if($log->subject_type)
                                            <span class="fw-semibold">{{ $log->subject_type }}</span>
                                            @if($log->subject_id) <span class="text-muted">#{{ $log->subject_id }}</span> @endif
                                        @else
                                            —
                                        @endif
                                    </td>
                                    <td class="text-muted small font-monospace">{{ $log->ip_address ?? '—' }}</td>
                                    <td class="text-muted small">
                                        <span title="{{ $log->created_at }}">
                                            {{ $log->created_at ? \Carbon\Carbon::parse($log->created_at)->format('d M Y, H:i') : '—' }}
                                        </span>
                                        <br>
                                        <span class="text-muted" style="font-size:10px;">{{ $log->created_at ? \Carbon\Carbon::parse($log->created_at)->diffForHumans() : '' }}</span>
                                    </td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-5">
                                        <i class="fas fa-history fa-2x mb-3 d-block opacity-25"></i>
                                        No activity records found.
                                    </td>
                                </tr>
                            @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer bg-transparent border-0 p-4 mt-2">
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="text-muted small mb-0 fw-bold">
                            Items: {{ $logs->firstItem() }} - {{ $logs->lastItem() }} / Total: {{ $logs->total() }}
                        </p>
                        {{ $logs->links() }}
                    </div>
                </div>
            </div>
        </div>
    </div>

@endsection
