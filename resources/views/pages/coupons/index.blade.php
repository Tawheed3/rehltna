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
            background: #fef2f2;
            border-color: #fecaca;
        }

        /* Coupon Specific Badges */
        .coupon-code {
            background: #f1f5f9;
            color: #1e293b;
            padding: 6px 12px;
            border-radius: 8px;
            font-family: 'Monaco', monospace;
            font-weight: 800;
            border: 1px dashed #cbd5e1;
        }

        .usage-badge {
            background: #e0f2fe;
            color: #0369a1;
            padding: 4px 10px;
            border-radius: 8px;
            font-weight: 700;
        }

        .main-toggle {
            cursor: pointer;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Promo Coupons
            </h4>
            <p class="text-muted mb-0 small fw-medium">Marketing / <span class="text-primary">Discount Codes</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Discount Management Hub</h3>
            <p class="mb-0 opacity-75 fw-medium">Create, monitor and control promotional codes to boost your sales.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a href="{{ route('coupons.create') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #4f46e5; height: 48px;">
                <i class="fas fa-plus-circle me-2"></i> New Coupon
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
                                <th>Code</th>
                                <th>Type</th>
                                <th>Applied To</th>
                                <th>Value</th>
                                <th class="text-center">Usage</th>
                                <th>Expiry</th>
                                <th class="text-center">Status</th>
                                <th class="text-center px-4">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($coupons as $coupon)
                                <tr>
                                    <td class="text-center fw-bold text-muted">{{ $loop->iteration }}</td>

                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="coupon-code">{{ $coupon->code }}</span>
                                            <button class="btn btn-sm btn-light copy-btn p-2 rounded-3 border"
                                                    data-code="{{ $coupon->code }}" title="Copy Code">
                                                <i class="far fa-copy text-primary"></i>
                                            </button>
                                        </div>
                                    </td>

                                    <td>
                                        @if($coupon->type == 'percent')
                                            <span class="badge bg-warning-transparent text-warning fw-bold px-3 py-2">Percentage %</span>
                                        @else
                                            <span class="badge bg-info-transparent text-info fw-bold px-3 py-2">Fixed Amount</span>
                                        @endif
                                    </td>

                                    <td>
                                        @if($coupon->items->count() > 0)
                                            <div class="d-flex flex-wrap gap-1" style="max-width: 200px;">
                                                @foreach($coupon->items->take(1) as $item)
                                                    <span
                                                        class="badge bg-light text-primary border">{{ $item->title_en ?? $item->name }}</span>
                                                @endforeach
                                                @if($coupon->items->count() > 1)
                                                    <span class="badge bg-light text-muted border">+{{ $coupon->items->count() - 1 }} More</span>
                                                @endif
                                            </div>
                                        @else
                                            <span
                                                class="badge bg-success-transparent text-success fw-bold">Global (All)</span>
                                        @endif
                                    </td>

                                    <td><span
                                            class="fw-bold text-dark">{{ $coupon->value }} {{ $coupon->type == 'percent' ? '%' : '$' }}</span>
                                    </td>

                                    <td class="text-center">
                                        <span
                                            class="usage-badge">{{ $coupon->orders_count ?? 0 }} / {{ $coupon->usage_limit ?? '∞' }}</span>
                                    </td>

                                    <td>
                                            <span
                                                class="small fw-bold {{ $coupon->expires_at && \Carbon\Carbon::parse($coupon->expires_at)->isPast() ? 'text-danger' : 'text-muted' }}">
                                                <i class="far fa-calendar-alt me-1"></i>
                                                {{ $coupon->expires_at ? \Carbon\Carbon::parse($coupon->expires_at)->format('Y-m-d') : 'No Expiry' }}
                                            </span>
                                    </td>

                                    <td class="text-center">
                                        <div
                                            class="toggle-status-btn main-toggle mx-auto {{ $coupon->status == 1 ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                                            data-id="{{ $coupon->id }}">
                                            <span></span>
                                        </div>
                                    </td>

                                    <td class="text-center px-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a class="btn-action btn-edit-action"
                                               href="{{ route('coupons.edit', encrypt($coupon->id)) }}"
                                               title="Edit Coupon">
                                                <i class="las la-pen fs-18"></i>
                                            </a>
                                            <a class="btn-action btn-delete-action delete-btn"
                                               data-route="{{ route('coupons.destroy', $coupon->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"
                                               title="Remove Coupon">
                                                <i class="las la-trash fs-18"></i>
                                            </a>
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
                        <p class="text-muted small mb-0 fw-bold">Showing {{ $coupons->count() }}
                            of {{ $coupons->total() }} coupons</p>
                        {{ $coupons->links() }}
                    </div>
                </div>
            </div>

            @include('pages.models.confirm-delete')

        </div>
    </div>
@endsection

@section('scripts')
    <script>
        // Copy Button Logic
        $(document).on('click', '.copy-btn', function () {
            var code = $(this).data('code');
            if (navigator.clipboard && window.isSecureContext) {
                navigator.clipboard.writeText(code).then(function () {
                    toastr.success("Copied: " + code);
                });
            } else {
                let textArea = document.createElement("textarea");
                textArea.value = code;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                toastr.success("Copied: " + code);
            }
        });

        // AJAX Status Toggle
        $(document).on('click', '.toggle-status-btn', function () {
            let button = $(this);
            let id = button.data('id');
            $.ajax({
                url: "{{ route('coupons.change.status', ['id' => ':id']) }}".replace(':id', id),
                type: 'POST',
                data: {_token: '{{ csrf_token() }}'},
                success: function (response) {
                    toastr.success("Status Updated");
                    if (response.status == 1) {
                        button.removeClass('main-toggle-danger of').addClass('main-toggle-success on');
                    } else {
                        button.removeClass('main-toggle-success on').addClass('main-toggle-danger of');
                    }
                }
            });
        });

        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete();
        });
    </script>
@endsection
