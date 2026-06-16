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
            background-color: #fef2f2;
            transform: translateY(-1px);
        }

        /* Hover محمر خفيف للوظائف الفاشلة */
        .table td {
            padding: 22px 20px;
            vertical-align: middle;
            color: #334155;
            border-top: 1px solid #f1f5f9;
            font-size: 0.95rem;
        }

        /* Action Buttons - Animated Scale & Rotate */
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
            color: #4f46e5;
        }

        .btn-action:hover {
            transform: scale(1.15) rotate(-10deg);
            background: #f5f3ff;
            border-color: #4f46e5;
            box-shadow: 0 10px 15px rgba(79, 70, 229, 0.1);
        }

        /* Technical Info Styling */
        .uuid-badge {
            font-family: 'Monaco', monospace;
            background: #f1f5f9;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 0.8rem;
            color: #475569;
            border: 1px solid #e2e8f0;
        }

        .exception-box {
            max-width: 400px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: #ef4444;
            font-weight: 600;
            font-size: 0.85rem;
        }

        /* Glassmorphism Effect - Fix White Box Issue */
        .stat-glass-card {
            background: rgba(255, 255, 255, 0.1) !important;
            backdrop-filter: blur(12px) !important;
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            padding: 15px 25px;
            border-radius: 20px;
            min-width: 140px;
            text-align: center;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.1);
        }

        .stat-label {
            display: block;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 4px;
            font-weight: 800;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Queue Monitor
            </h4>
            <p class="text-muted mb-0 small fw-medium">System / <span class="text-danger text-uppercase fw-bold">Failed Jobs</span>
            </p>
        </div>
    </div>

    <div class="hero-section"
         style="background: linear-gradient(135deg, #450a0a 0%, #7f1d1d 100%);"> {{-- لون أحمر غامق فخم للطوارئ --}}
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Job Failure Registry</h3>
            <p class="mb-0 opacity-75 fw-medium">Review background tasks that encountered errors and trigger manual
                retries.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <div class="stat-glass-card">
                <span class="stat-label">Failed Count</span>
                <div class="d-flex align-items-center justify-content-center gap-2">
                    <h3 class="mb-0 fw-bold text-white">{{ $failedJobs->count() }}</h3>
                    <i class="las la-exclamation-circle fs-4 text-white opacity-50"></i>
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
                                <th class="text-center" width="60">#</th>
                                <th>Job UUID</th>
                                <th>Exception Details</th>
                                <th class="text-center px-4">Options</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($failedJobs as $failedJob)
                                <tr>
                                    <td class="text-center fw-bold text-muted">{{ $loop->iteration }}</td>
                                    <td><span class="uuid-badge">{{ $failedJob->uuid }}</span></td>
                                    <td>
                                        <div class="exception-box" title="{{ $failedJob->exception }}">
                                            <i class="las la-exclamation-triangle me-1"></i> {{ $failedJob->exception }}
                                        </div>
                                    </td>
                                    <td class="text-center px-4">
                                        <button class="btn-action"
                                                data-bs-effect="effect-scale"
                                                data-bs-toggle="modal" href="#Retry{{$failedJob->id}}"
                                                title="Retry this job">
                                            <i class="las la-reply fs-18"></i>
                                        </button>
                                    </td>
                                </tr>

                                {{--  retry model  --}}
                                <div class="modal fade" id="Retry{{$failedJob->id}}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <form action="{{ route('blogs.failed.jobs.retry',$failedJob->uuid) }}"
                                              method="POST">
                                            @csrf
                                            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                                                <div class="modal-header border-0 p-4">
                                                    <h5 class="modal-title fw-bold text-dark"><i
                                                            class="las la-redo me-2 text-primary"></i>Retry Failed Task
                                                    </h5>
                                                    <button type="button" class="btn-close"
                                                            data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body p-4 text-center">
                                                    <div class="mb-3">
                                                        <i class="las la-question-circle text-warning"
                                                           style="font-size: 4rem;"></i>
                                                    </div>
                                                    <p class="fw-bold text-dark mb-0">Are you sure you want to retry
                                                        this job?</p>
                                                    <small class="text-muted">This will attempt to re-process the data
                                                        using the latest logic.</small>
                                                </div>
                                                <div class="modal-footer border-0 p-4">
                                                    <button type="button"
                                                            class="btn btn-light rounded-pill px-4 fw-bold"
                                                            data-bs-dismiss="modal">Cancel
                                                    </button>
                                                    <button type="submit"
                                                            class="btn btn-primary rounded-pill px-4 fw-bold shadow">
                                                        Yes, Retry Now
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                {{--  end retry model  --}}
                            @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('scripts')
@endsection
