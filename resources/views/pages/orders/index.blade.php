@extends('layouts.app')

@section('styles')
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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

        /* Table Design */
        .table-responsive {
            border-radius: 18px;
            overflow: hidden;
            padding: 2px;
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
        }

        .table td {
            padding: 22px 20px;
            vertical-align: middle;
            color: #334155;
            border-top: 1px solid #f1f5f9;
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
            color: #4f46e5;
            border-color: #4f46e5;
        }

        /* Filter Controls Styling */
        .form-control-deluxe {
            border-radius: 12px !important;
            border: 2px solid #f1f5f9 !important;
            font-weight: 600 !important;
            padding: 10px 15px !important;
            height: auto !important;
            transition: 0.3s;
        }

        .form-control-deluxe:focus {
            border-color: #4f46e5 !important;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1) !important;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Sales Orders</h4>
            <p class="text-muted mb-0 small fw-medium">Finance / <span class="text-primary">Order History</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Orders Management Hub</h3>
            <p class="mb-0 opacity-75 fw-medium">Track transactions, verify payments, and manage customer
                fulfillment.</p>
        </div>
        <div style="background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 20px; padding: 15px 25px; text-align: center;">
            <small class="d-block opacity-75 fw-bold text-uppercase" style="letter-spacing: 1px;">Current View</small>
            <h4 class="mb-0 fw-bold text-white">{{ $orders->total() }} Orders</h4>
        </div>
    </div>

    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card custom-card">
                <div class="card-header pb-0 border-bottom-0 p-4">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">

                        <div class="d-flex gap-2 flex-wrap">
                            <select id="filter_method" class="form-control-deluxe" style="width: 180px;">
                                <option value="">All Methods</option>
                                <option value="tamara" {{ request('payment_method') == 'tamara' ? 'selected' : '' }}>
                                    Tamara
                                </option>
                                <option value="moyasar" {{ request('payment_method') == 'moyasar' ? 'selected' : '' }}>
                                    Moyasar / Cards
                                </option>
                                <option value="apple_pay" {{ request('payment_method') == 'apple_pay' ? 'selected' : '' }}>
                                    Apple Pay
                                </option>
                                <option value="bank_transfer_alrajhi" {{ request('payment_method') == 'bank_transfer_alrajhi' ? 'selected' : '' }}>
                                    Al Rajhi Bank
                                </option>
                                <option value="bank_transfer_alahli" {{ request('payment_method') == 'bank_transfer_alahli' ? 'selected' : '' }}>
                                    AlAhli Bank
                                </option>
                                <option value="wallet_vodafone" {{ request('payment_method') == 'wallet_vodafone' ? 'selected' : '' }}>
                                    Vodafone Cash
                                </option>
                                <option value="instapay" {{ request('payment_method') == 'instapay' ? 'selected' : '' }}>
                                    InstaPay
                                </option>
                                <option value="cash_on_delivery" {{ request('payment_method') == 'cash_on_delivery' ? 'selected' : '' }}>
                                    Cash on Delivery
                                </option>
                            </select>

                            <select id="filter_status" class="form-control-deluxe" style="width: 160px;">
                                <option value="">All Statuses</option>
                                <option value="paid" {{ request('payment_status') == 'paid' ? 'selected' : '' }}>Paid
                                </option>
                                <option value="pending" {{ request('payment_status') == 'pending' ? 'selected' : '' }}>
                                    Pending
                                </option>
                                <option value="reviewing" {{ request('payment_status') == 'reviewing' ? 'selected' : '' }}>
                                    Reviewing
                                </option>
                                <option value="rejected" {{ request('payment_status') == 'rejected' ? 'selected' : '' }}>
                                    Rejected
                                </option>
                                <option value="canceled" {{ request('payment_status') == 'canceled' ? 'selected' : '' }}>
                                    Canceled
                                </option>
                            </select>

                            <div class="input-group" style="width: 250px;">
                                <span class="input-group-text bg-light border-0"
                                      style="border-radius: 12px 0 0 12px;"><i
                                            class="fas fa-calendar-alt text-muted"></i></span>
                                <input type="text" id="date_range" class="form-control-deluxe border-start-0"
                                       style="border-radius: 0 12px 12px 0 !important;" placeholder="Select Date Range"
                                       readonly>
                            </div>
                        </div>

                        <div class="flex-grow-2" style="max-width: 300px;">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-0"
                                      style="border-radius: 12px 0 0 12px;"><i
                                            class="fas fa-search text-muted"></i></span>
                                <input type="text" id="search" class="form-control-deluxe border-start-0"
                                       style="border-radius: 0 12px 12px 0 !important;"
                                       placeholder="Search customers..." value="{{ request('search') }}">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-body p-0" id="orders-table">
                    @include('pages.orders.partials.table',['orders'=> $orders])
                </div>

            </div>
        </div>
    </div>

    @include('pages.models.confirm-delete')

    {{-- Receipt Modal --}}
    <div class="modal fade" id="receiptModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0" style="border-radius: 28px; overflow: hidden;">
                <div class="modal-header border-0 bg-light p-4">
                    <h5 class="modal-title fw-bold text-dark"><i class="las la-receipt me-2 text-primary"></i>Payment
                        Receipt</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center bg-white p-4">
                    <img src="" id="modalImage" class="img-fluid rounded-4 shadow-sm" alt="Receipt Proof">
                </div>
                <div class="modal-footer border-0 p-4 pt-0">
                    <a href="#" id="openNewTabLink" target="_blank" class="btn btn-primary rounded-pill px-4 fw-bold">
                        <i class="fas fa-external-link-alt me-2"></i> Open Original
                    </a>
                </div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        $(document).on('click', '.view-proof-btn', function () {
            var imageUrl = $(this).data('image');
            $('#modalImage').attr('src', imageUrl);
            $('#openNewTabLink').attr('href', imageUrl);
        });

        $(document).ready(function () {
            flatpickr("#date_range", {
                mode: "range",
                dateFormat: "Y-m-d",
                onClose: function () {
                    fetchOrders();
                }
            });

            function fetchOrders() {
                let search = $('#search').val();
                let method = $('#filter_method').val();
                let status = $('#filter_status').val();
                let dateRange = $('#date_range').val();
                let startDate = '';
                let endDate = '';

                if (dateRange) {
                    let dates = dateRange.split(' to ');
                    startDate = dates[0];
                    endDate = dates.length > 1 ? dates[1] : startDate;
                }

                $('#orders-table').css('opacity', '0.5');

                $.ajax({
                    url: "{{ route('orders.index') }}",
                    data: {
                        search: search,
                        payment_method: method,
                        payment_status: status,
                        start_date: startDate,
                        end_date: endDate
                    },
                    success: function (data) {
                        $('#orders-table').html(data);
                        $('#orders-table').css('opacity', '1');
                    },
                    error: function() {
                        $('#orders-table').css('opacity', '1');
                        console.log('Error fetching orders');
                    }
                });
            }

            $('#search').on('keyup', fetchOrders);
            $('#filter_method').on('change', fetchOrders);
            $('#filter_status').on('change', fetchOrders);

            $('#search').on('search', fetchOrders);
        });
    </script>
@endsection
