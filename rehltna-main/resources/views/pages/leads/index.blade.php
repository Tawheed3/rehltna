@extends('layouts.app')

@section('styles')
    <style>
        /* Global Background */
        body {
            background-color: #f8fafc;
        }

        /* Deluxe Card Styling */
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

        /* FIX: Table Header Visibility & Space */
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
            background-color: #f8fbff;
        }

        .table td {
            padding: 22px 20px;
            vertical-align: middle;
            color: #334155;
            border-top: 1px solid #f1f5f9;
            font-size: 0.95rem;
        }

        /* Email Badge Design */
        .email-badge {
            background: #f1f5f9;
            color: #1e293b;
            padding: 8px 16px;
            border-radius: 12px;
            font-weight: 700;
            border: 1px solid #e2e8f0;
            display: inline-flex;
            align-items: center;
        }

        .email-badge i {
            color: #4f46e5;
            margin-right: 8px;
            font-size: 1.1rem;
        }

        /* Magnet Tag */
        .magnet-tag {
            background: #eef2ff;
            color: #4338ca;
            padding: 4px 12px;
            border-radius: 8px;
            font-weight: 800;
            font-size: 0.8rem;
            border: 1px solid #c7d2fe;
        }

        /* Glassmorphism Stat Card Fix */
        .stat-glass-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 20px 30px;
            border-radius: 20px;
            color: white;
            min-width: 180px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.1);
        }

        .stat-label {
            display: block;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.8;
            margin-bottom: 5px;
            font-weight: 700;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Leads Collector
            </h4>
            <p class="text-muted mb-0 small fw-medium">Marketing / <span class="text-primary">Contact Acquisition</span>
            </p>
        </div>
    </div>


    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Acquisition Database</h3>
            <p class="mb-0 opacity-75 fw-medium">Tracking and analyzing all contacts collected through your active lead
                magnets.</p>
        </div>

        <div class="d-flex gap-3">
            <div class="stat-glass-card">
                <span class="stat-label">Total Collected</span>
                <div class="d-flex align-items-center gap-2">
                    <h3 class="mb-0 fw-bold">{{ $leads->total() }}</h3>
                    <i class="las la-users fs-4 opacity-50"></i>
                </div>
            </div>
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
                                <th class="text-center" width="80">Index</th>
                                <th>Email Address</th>
                                <th class="text-center">Lead Magnet Source</th>
                                <th class="text-center">Captured At</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($leads as $lead)
                                <tr>
                                    <td class="text-center fw-bold text-muted">#{{ $loop->iteration }}</td>

                                    <td>
                                        <div class="email-badge">
                                            <i class="las la-envelope"></i> {{ $lead->email }}
                                        </div>
                                    </td>

                                    <td class="text-center">
                                        @if($lead->magnet)
                                            <span class="magnet-tag">
                                                    <i class="las la-magnet me-1"></i>
                                                    {{ $lead->magnet->name_en ?? $lead->magnet->name_ar }}
                                                </span>
                                        @else
                                            <span class="text-muted small italic">Direct / Unknown Source</span>
                                        @endif
                                    </td>

                                    <td class="text-center">
                                            <span class="small fw-bold text-muted">
                                                <i class="lar la-clock me-1"></i>
                                                {{ $lead->created_at }}
                                            </span>
                                    </td>
                                </tr>
                            @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer bg-transparent border-0 p-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="text-muted small mb-0 fw-bold">Showing {{ $leads->count() }} contacts</p>
                        {{ $leads->links() }}
                    </div>
                </div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')

@endsection
