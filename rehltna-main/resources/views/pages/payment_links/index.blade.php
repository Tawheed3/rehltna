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
            background-color: #f8fafc;
            transform: translateY(-1px);
        }

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
            color: #64748b;
        }

        .btn-action:hover {
            transform: scale(1.15) rotate(5deg);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.08);
        }

        .btn-edit-action:hover {
            color: #4f46e5;
            border-color: #4f46e5;
            background: #f5f3ff;
        }

        .btn-delete-action:hover {
            color: #ef4444;
            border-color: #ef4444;
            background: #fef2f2;
        }

        .btn-check-action:hover {
            color: #22c55e;
            border-color: #22c55e;
            background: #f0fdf4;
        }

        /* Status Badges Custom */
        .status-badge {
            padding: 6px 14px;
            border-radius: 10px;
            font-weight: 800;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
        }

        /* FIX: Copy URL Button - Professional Hover */
        .btn-copy-link {
            background: #f8fafc;
            color: #4f46e5; /* Indigo Color */
            border: 1px solid #e2e8f0;
            font-weight: 700;
            padding: 8px 16px;
            border-radius: 12px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 0.85rem;
        }

        .btn-copy-link:hover {
            background: #4f46e5 !important;
            color: #ffffff !important;
            border-color: #4f46e5 !important;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(79, 70, 229, 0.2) !important;
        }

        .btn-copy-link i {
            transition: transform 0.3s;
        }

        .btn-copy-link:hover i {
            transform: rotate(-10deg) scale(1.1);
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Payment Gateway
            </h4>
            <p class="text-muted mb-0 small fw-medium">Finance / <span class="text-primary">Quick Links</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Payment Links Hub</h3>
            <p class="mb-0 opacity-75 fw-medium">Create personalized payment requests and track real-time transaction
                statuses.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a href="{{ route('payment-links.create') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #4f46e5; height: 48px;">
                <i class="fas fa-plus-circle me-2"></i> Create Link
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
                                <th class="text-center" width="60">#</th>
                                <th>Customer</th>
                                <th>Details (Items/Amount)</th>
                                <th class="text-center">Status</th>
                                <th class="text-center">Magic Link</th>
                                <th>Created</th>
                                <th class="text-center px-4">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($links as $link)
                                <tr>
                                    <td class="text-center fw-bold text-muted">{{ $loop->iteration }}</td>

                                    <td>
                                        <div class="fw-bold text-dark">{{ $link->name }}</div>
                                        <div class="small text-muted">{{ $link->email }}</div>
                                        <div class="small text-muted font-italic">{{ $link->phone }}</div>
                                    </td>

                                    <td>
                                        @if($link->items)
                                            @php $itemsArray = is_string($link->items) ? json_decode($link->items, true) : $link->items; @endphp
                                            <span class="badge bg-purple-transparent text-purple fw-bold px-3 py-2">
                                                    <i class="las la-shopping-cart me-1"></i> {{ count($itemsArray ?? []) }} Items
                                                </span>
                                        @elseif($link->amount)
                                            <span class="badge bg-success-transparent text-success fw-bold px-3 py-2"
                                                  style="font-size: 0.85rem;">
                                                    $ {{ number_format($link->amount, 2) }}
                                                </span>
                                        @else
                                            <span class="text-muted small">---</span>
                                        @endif
                                    </td>

                                    <td class="text-center">
                                        @php
                                            $statusClasses = [
                                                'paid' => 'bg-success-transparent text-success',
                                                'pending' => 'bg-warning-transparent text-warning',
                                                'partial' => 'bg-warning-transparent text-warning',
                                                'canceled' => 'bg-danger-transparent text-danger',
                                                'reviewing' => 'bg-secondary-transparent text-secondary',
                                                'rejected' => 'bg-danger-transparent text-danger'
                                            ];
                                            $class = $statusClasses[$link->status] ?? 'bg-light text-dark';
                                        @endphp
                                        <span class="status-badge {{ $class }}">{{ strtoupper($link->status) }}</span>
                                    </td>

                                    <td class="text-center">
                                        <button class="btn btn-copy-link copy-btn shadow-sm"
                                                data-link="{{ route('quick.pay', $link->uuid) }}">
                                            <i class="far fa-copy me-1"></i> Copy URL
                                        </button>
                                    </td>

                                    <td>
                                            <span class="small fw-bold text-muted">
                                                <i class="far fa-calendar-alt me-1"></i> {{ $link->created_at->format('Y-m-d') }}
                                            </span>
                                    </td>

                                    <td class="text-center px-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            @if($link->status != 'paid' && $link->status != 'partial')
                                                <a class="btn-action btn-edit-action"
                                                   href="{{ route('payment-links.edit', encrypt($link->id)) }}"
                                                   title="Edit Link">
                                                    <i class="las la-pen fs-18"></i>
                                                </a>
                                                <a class="btn-action btn-delete-action delete-btn"
                                                   data-route="{{ route('payment-links.destroy', $link->id) }}"
                                                   data-bs-toggle="modal" href="#deleteModal"
                                                   title="Remove Link">
                                                    <i class="las la-trash fs-18"></i>
                                                </a>
                                            @else
                                                <i class="btn-action btn-check-action las la-check"></i>
                                            @endif
                                        </div>
                                    </td>
                                </tr>
                            @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer bg-transparent border-0 p-4 mt-2">
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="text-muted small mb-0 fw-bold">Records: {{ $links->count() }}
                            of {{ $links->total() }}</p>
                        {{ $links->links() }}
                    </div>
                </div>
            </div>

            @include('pages.models.confirm-delete')

        </div>
    </div>
@endsection

@section('scripts')
    <script>
        // Copy Link Logic
        $(document).on('click', '.copy-btn', function () {
            var link = $(this).data('link');
            if (navigator.clipboard && window.isSecureContext) {
                navigator.clipboard.writeText(link).then(function () {
                    toastr.success("Magic Link Copied!");
                });
            } else {
                let textArea = document.createElement("textarea");
                textArea.value = link;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                toastr.success("Magic Link Copied!");
            }
        });

        document.addEventListener('DOMContentLoaded', function () {
            if (typeof confirmDelete === 'function') {
                confirmDelete();
            }
        });
    </script>
@endsection
