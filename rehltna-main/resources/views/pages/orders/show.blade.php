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
            margin-bottom: 25px;
        }

        .card-header {
            border-bottom: 1px solid #f1f5f9 !important;
            padding: 20px 25px !important;
            background: transparent !important;
        }

        .card-title {
            font-weight: 800 !important;
            color: #1e293b !important;
            text-transform: uppercase;
            font-size: 13px !important;
            letter-spacing: 0.5px;
        }

        /* Information Grid */
        .info-item {
            margin-bottom: 15px;
        }

        .info-label {
            display: block;
            font-size: 11px;
            font-weight: 800;
            color: #94a3b8;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .info-value {
            display: block;
            font-weight: 700;
            color: #1e293b;
            font-size: 14px;
        }

        /* Table Design */
        .table thead th {
            background-color: #f8fafc !important;
            color: #64748b !important;
            text-transform: uppercase !important;
            font-size: 11px !important;
            font-weight: 800 !important;
            padding: 15px 20px !important;
            border: none !important;
        }

        .table td {
            padding: 18px 20px;
            vertical-align: middle;
            border-top: 1px solid #f1f5f9;
        }

        /* Inputs & Selects - Fix Text Clipping */
        .form-control, .form-select {
            border-radius: 12px !important;
            border: 2px solid #f1f5f9 !important;
            height: auto !important;
            padding: 12px 15px !important;
            font-weight: 600 !important;
            line-height: 1.5 !important;
        }

        .form-control:focus, .form-select:focus {
            border-color: #4f46e5 !important;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1) !important;
        }

        .btn-update {
            background: #4f46e5 !important;
            color: white !important;
            border-radius: 14px !important;
            padding: 14px !important;
            font-weight: 700 !important;
            border: none !important;
            transition: 0.3s;
        }

        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(79, 70, 229, 0.2);
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Order #{{ $order->id }}
            </h4>
            <p class="text-muted mb-0 small fw-medium">Sales / <span class="text-primary">Transaction Details</span></p>
        </div>
    </div>

    <div class="row">
        {{-- Left Side: Items & Cart --}}
        <div class="col-lg-8">
            <div class="card custom-card">
                <div class="card-header"><h6 class="card-title mb-0">Purchased Items</h6></div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table mb-0">
                            <thead>
                            <tr>
                                <th>Description</th>
                                <th>Variation / Package</th>
                                <th class="text-center">Pax</th>
                                <th>Unit Price</th>
                                <th>Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($order->items as $item)
                                <tr>
                                    <td>
                                        <div class="info-value">{{ $item->item->title_en ?? 'Item #' . $item->item_id }}</div>
                                        <small class="text-muted fw-bold">{{ $item->item->itemType->title_en ?? '' }}</small>
                                    </td>
                                    <td>
                                        @if($item->variation_title_en || $item->variation_title_ar)
                                            <span class="badge bg-light text-primary border px-2 py-1">
                                                <i class="fas fa-tag me-1"></i>
                                                {{ $item->variation_title_en ?? $item->variation_title_ar }}
                                            </span>
                                        @else
                                            <span class="text-muted small">Standard Package</span>
                                        @endif
                                    </td>
                                    <td class="fw-bold text-center">
                                        <span class="badge rounded-pill bg-dark px-3">{{ $item->attendees_count }}</span>
                                    </td>
                                    <td class="text-muted">{{ number_format($item->price_per_unit, 2) }} SAR</td>
                                    <td class="fw-bold text-dark">{{ number_format($item->total, 2) }} SAR</td>
                                </tr>
                            @endforeach
                            </tbody>
                            <tfoot class="bg-light bg-opacity-50">
                            <tr>
                                <td colspan="4" class="text-end fw-bold py-3">Sub Total</td>
                                <td class="py-3 fw-bold">{{ number_format($order->sub_total, 2) }} SAR</td>
                            </tr>
                            <tr>
                                <td colspan="4" class="text-end fw-bold text-danger py-2">Discount</td>
                                <td class="text-danger py-2">- {{ number_format($order->discount_amount, 2) }} SAR</td>
                            </tr>
                            <tr style="background-color: #f5f3ff;">
                                <td colspan="4" class="text-end fw-extrabold tx-16 py-3 text-primary">Total Amount</td>
                                <td class="fw-extrabold tx-16 text-primary py-3">{{ number_format($order->total_amount, 2) }} SAR</td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>

            {{-- Customer Details Card --}}
            <div class="card custom-card">
                <div class="card-header"><h6 class="card-title mb-0">Customer Profile</h6></div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="info-item"><span class="info-label">Full Name</span><span
                                    class="info-value">{{ $order->name }}</span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="info-item"><span class="info-label">Email Address</span><span
                                    class="info-value">{{ $order->email }}</span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="info-item"><span class="info-label">Phone Number</span><span
                                    class="info-value text-primary">{{ $order->phone }}</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        {{-- Right Side: Payment Settlement --}}
        <div class="col-lg-4">

            <div class="card custom-card">
                <div class="card-header"><h6 class="card-title mb-0">Payment Settlement</h6></div>
                <div class="card-body">
                    {{-- Payment Method Badge --}}
                    <div class="mb-4 text-center">
                        @php
                            $methods = [
                                'tamara'    => ['bg' => 'rgba(79, 70, 229, 0.1)',  'color' => '#4f46e5', 'icon' => 'fa-credit-card'],
                                'moyasar'   => ['bg' => 'rgba(16, 185, 129, 0.1)', 'color' => '#10b981', 'icon' => 'fa-credit-card'],
                                'apple_pay' => ['bg' => 'rgba(0, 0, 0, 0.1)',      'color' => '#000000', 'icon' => 'fab fa-apple'],
                                'instapay'  => ['bg' => 'rgba(236, 72, 153, 0.1)', 'color' => '#ec4899', 'icon' => 'fa-bolt'],
                                'wallet_vodafone' => ['bg' => 'rgba(239, 68, 68, 0.1)', 'color' => '#ef4444', 'icon' => 'fa-mobile-alt'],
                                'wallet_etisalat' => ['bg' => 'rgba(16, 185, 129, 0.1)', 'color' => '#10b981', 'icon' => 'fa-mobile-alt'],
                                'wallet_orange' => ['bg' => 'rgba(249, 115, 22, 0.1)', 'color' => '#f97316', 'icon' => 'fa-mobile-alt'],
                                'wallet_we' => ['bg' => 'rgba(139, 92, 246, 0.1)', 'color' => '#8b5cf6', 'icon' => 'fa-mobile-alt'],
                                'bank_transfer_alrajhi' => ['bg' => 'rgba(147, 51, 234, 0.1)', 'color' => '#9333ea', 'icon' => 'fa-university'],
                                'bank_transfer_alahli' => ['bg' => 'rgba(100, 116, 139, 0.1)', 'color' => '#64748b', 'icon' => 'fa-university'],
                                'cash_on_delivery' => ['bg' => 'rgba(245, 158, 11, 0.1)', 'color' => '#f59e0b', 'icon' => 'fa-money-bill-wave'],
                            ];

                            // Fallback for wallets
                            if (!isset($methods[$order->payment_method]) && str_contains($order->payment_method, 'wallet')) {
                                $m = ['bg' => 'rgba(59, 130, 246, 0.1)', 'color' => '#3b82f6', 'icon' => 'fa-mobile-alt'];
                            } else {
                                $m = $methods[$order->payment_method] ?? ['bg' => '#f1f5f9', 'color' => '#1e293b', 'icon' => 'fa-wallet'];
                            }

                            $methodName = str_replace('_', ' ', $order->payment_method);
                        @endphp
                        <div class="p-3 shadow-sm rounded-4"
                             style="background-color: {{ $m['bg'] }} !important; border: 1px solid {{ $m['color'] }}40;">
                            <i class="{{ str_contains($m['icon'], 'fab') ? '' : 'fas' }} {{ $m['icon'] }} mb-2"
                               style="color: {{ $m['color'] }}; font-size: 1.5rem;"></i>
                            <span class="d-block fw-extrabold"
                                  style="color: {{ $m['color'] }};">{{ strtoupper($methodName) }}</span>
                        </div>
                    </div>

                    {{-- Current Status --}}
                    @php
                        $statusStyles = [
                            'paid'      => ['bg' => '#f0fdf4', 'color' => '#10b981', 'icon' => 'check-circle'],
                            'reviewing' => ['bg' => '#eff6ff', 'color' => '#3b82f6', 'icon' => 'clock'],
                            'rejected'  => ['bg' => '#fef2f2', 'color' => '#ef4444', 'icon' => 'times-circle'],
                            'pending'   => ['bg' => '#fffbeb', 'color' => '#f59e0b', 'icon' => 'clock'],
                        ];
                        $s = $statusStyles[$order->payment_status] ?? ['bg' => '#f8fafc', 'color' => '#64748b', 'icon' => 'clock'];
                    @endphp
                    <div class="d-flex justify-content-between align-items-center p-3 rounded-3 mb-4"
                         style="background-color: {{ $s['bg'] }} !important; border: 1px solid {{ $s['color'] }}40;">
                        <span class="fw-bold" style="color: {{ $s['color'] }};">Status:</span>
                        <span class="fw-extrabold text-uppercase" style="color: {{ $s['color'] }};">{{ $order->payment_status }} <i
                                class="fas fa-{{ $s['icon'] }} ms-1"></i></span>
                    </div>

                    {{-- Proof Image --}}
                    @if($order->payment_proof)
                        <div class="mb-4 text-center border-top pt-3">
                            <span class="info-label text-start">Manual Payment Proof</span>
                            <div class="position-relative mt-2">
                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#receiptModal">
                                    <img src="{{ asset($order->payment_proof) }}"
                                         class="img-fluid rounded-4 border shadow-sm p-1"
                                         style="max-height: 180px; width: 100%; object-fit: cover; transition: transform 0.3s;"
                                         onmouseover="this.style.transform='scale(1.02)'"
                                         onmouseout="this.style.transform='scale(1)'">
                                </a>
                            </div>
                        </div>
                    @endif

                    {{-- Update Status Form --}}
                    @php
                        $isManualMethod = str_contains($order->payment_method, 'bank_transfer') || str_contains($order->payment_method, 'wallet') || $order->payment_method === 'instapay';
                    @endphp

                    @if($isManualMethod && $order->payment_status != 'paid')
                        <form id="updateStatusForm" action="{{ route('orders.update.status', $order->id) }}"
                              method="POST" class="border-top pt-4">
                            @csrf
                            <div class="form-group">
                                <label class="info-label">Action Required</label>
                                <select name="payment_status" class="form-select" required>
                                    <option value="" disabled selected>-- Select Result --</option>
                                    <option value="paid" class="text-success fw-bold">Approve Payment (Paid)</option>
                                    <option value="rejected" class="text-danger fw-bold">Reject Payment</option>
                                </select>
                            </div>
                            <button type="submit" id="updateBtn" class="btn btn-update w-100 mt-3 shadow-sm">
                                <i class="fas fa-save me-2"></i> Confirm Changes
                            </button>
                        </form>
                    @elseif(!$isManualMethod)
                        <div class="alert alert-light border-0 text-center small text-muted">
                            <i class="fas fa-info-circle me-1"></i> Automated gateway status. Manual approval is not
                            required.
                        </div>
                    @endif
                </div>
            </div>

            {{-- Points Used --}}
            @if($order->used_points > 0)
                @php $pointsValueSAR = round($order->used_points / 50, 2); @endphp
                <div class="card custom-card" style="background-color: #faf5ff; border: 1px solid #9333ea30;">
                    <div class="card-header"><h6 class="card-title mb-0" style="color:#9333ea;">Points Redeemed</h6></div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="text-muted fw-semibold small">Points Used</span>
                            <span class="fw-bold" style="color:#9333ea;">
                                <i class="fas fa-coins me-1"></i> {{ number_format($order->used_points) }} pts
                            </span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="text-muted fw-semibold small">Equivalent Value</span>
                            <span class="fw-bold text-success">{{ number_format($pointsValueSAR, 2) }} SAR</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted fw-semibold small">Conversion Rate</span>
                            <span class="text-muted small fw-semibold">50 pts = 1 SAR</span>
                        </div>
                    </div>
                </div>
            @else
                <div class="card custom-card" style="background-color: #f8fafc; border: 1px solid #e2e8f0;">
                    <div class="card-body py-3 d-flex align-items-center gap-2">
                        <i class="fas fa-coins text-muted"></i>
                        <span class="text-muted fw-semibold small">No points were used in this order</span>
                    </div>
                </div>
            @endif

            @if($order->coupon)
                <div class="card custom-card" style="background-color: #f0fdf4; border: 1px solid #10b98130;">
                    <div class="card-body py-3 text-center">
                        <span style="color: #10b981;" class="fw-bold"><i class="fas fa-ticket-alt me-2"></i> Coupon Applied: <strong>{{ $order->coupon->code }}</strong></span>
                    </div>
                </div>
            @endif
        </div>
    </div>

    {{-- Modal & Scripts --}}
    @if($order->payment_proof)
        <div class="modal fade" id="receiptModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 28px; overflow: hidden;">
                    <div class="modal-header border-0 bg-light p-4">
                        <h5 class="modal-title fw-bold text-dark"><i class="las la-receipt me-2 text-primary"></i>Proof
                            Review</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center p-4 bg-white">
                        <img src="{{ asset($order->payment_proof) }}" class="img-fluid rounded-4 shadow-sm"
                             alt="Full Receipt">
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <a href="{{ asset($order->payment_proof) }}" target="_blank"
                           class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">
                            <i class="fas fa-external-link-alt me-2"></i> Open Original
                        </a>
                    </div>
                </div>
            </div>
        </div>
    @endif
@endsection

@section('scripts')
    <script>
        $('#updateStatusForm').on('submit', function () {
            var btn = $('#updateBtn');
            btn.html('<i class="fas fa-spinner fa-spin"></i> Processing...');
            btn.prop('disabled', true);
            return true;
        });
    </script>
@endsection
