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
        }

        /* FIX: Tools Button (No disappearing text) */
        .btn-tools-container .btn-tools {
            background-color: rgba(255, 255, 255, 0.12) !important;
            border: 1px solid rgba(255, 255, 255, 0.25) !important;
            color: #ffffff !important;
            font-weight: 600 !important;
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1) !important;
            backdrop-filter: blur(8px);
        }

        .btn-tools-container .btn-tools:hover {
            background-color: #ffffff !important;
            color: #1e293b !important;
            border-color: #ffffff !important;
            transform: translateY(-3px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.2) !important;
        }

        .btn-tools-container .btn-tools:hover .fa-file-excel {
            color: #10b981 !important;
        }

        /* Price Tag */
        .price-badge {
            background: #ecfdf5;
            color: #065f46;
            padding: 8px 16px;
            border-radius: 14px;
            font-weight: 800;
            border: 1px solid #d1fae5;
            display: inline-block;
            white-space: nowrap;
        }

        /* New Data Badges */
        .points-badge {
            background: #fffbeb;
            color: #d97706;
            padding: 8px 16px;
            border-radius: 14px;
            font-weight: 800;
            border: 1px solid #fde68a;
        }

        .season-badge {
            background: #f1f5f9;
            color: #475569;
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 12px;
            border: 1px solid #e2e8f0;
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

        .btn-edit-course:hover {
            color: #4f46e5;
            border-color: #4f46e5;
            background: #f5f3ff;
        }

        .btn-delete-course:hover {
            color: #ef4444;
            border-color: #ef4444;
            background: #fef2f2;
        }

        .btn-duplicate-course:hover {
            color: #10b981;
            border-color: #10b981;
            background: #ecfdf5;
        }

        .lang-tag {
            font-size: 9px;
            padding: 2px 6px;
            background: #64748b;
            color: white;
            border-radius: 5px;
            margin-left: 8px;
        }

        .main-toggle {
            cursor: pointer;
        }

        .btn-notification:hover {
            color: #d97706;
            border-color: #fde68a;
            background: #fffbeb;
        }

        .template-card {
            transition: all 0.2s ease;
            background-color: #f8fafc;
            border: 2px solid #e2e8f0 !important;
            position: relative;
        }

        .template-card:hover {
            background-color: #f1f5f9;
            transform: translateY(-2px);
        }

        .template-card.active {
            border-color: #f59e0b !important;
            background-color: #fffbeb;
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.1);
        }

        .template-card.active::after {
            content: '✓';
            position: absolute;
            top: 10px;
            right: 15px;
            color: #f59e0b;
            font-size: 18px;
            font-weight: bold;
        }

        .cursor-pointer {
            cursor: pointer;
        }

        .template-list-container::-webkit-scrollbar {
            width: 6px;
        }

        .template-list-container::-webkit-scrollbar-thumb {
            background-color: #cbd5e1;
            border-radius: 10px;
        }

    </style>

@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Trips Catalog
            </h4>
            <p class="text-muted mb-0 small fw-medium">Management / <span class="text-primary">Global Trips</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Premium Trips Hub</h3>
            <p class="mb-0 opacity-75 fw-medium">Customize your catalog visibility and pricing strategy in
                real-time.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a href="{{ route('items.create') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #4f46e5; height: 48px;">
                <i class="fas fa-plus-circle me-2"></i> New Trip
            </a>
        </div>
    </div>

    {{-- Filter Tabs --}}
    <div class="d-flex gap-2 mb-3">
        <a href="{{ route('items.index', ['filter' => 'active']) }}"
           class="btn fw-bold px-4 py-2 rounded-pill {{ $filter === 'active' ? 'btn-success' : 'btn-outline-success' }}">
            <i class="fas fa-plane-departure me-2"></i> الرحلات النشطة
        </a>
        <a href="{{ route('items.index', ['filter' => 'ended']) }}"
           class="btn fw-bold px-4 py-2 rounded-pill {{ $filter === 'ended' ? 'btn-secondary' : 'btn-outline-secondary' }}">
            <i class="fas fa-history me-2"></i> الرحلات المنتهية
        </a>
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
                                @foreach(get_active_langs() as $lang)
                                    <th>Title <span class="lang-tag">{{ strtoupper($lang) }}</span></th>
                                @endforeach
                                <th class="text-center">Season</th>
                                <th class="text-center">Duration</th>
                                <th class="text-center">Price</th>
                                <th class="text-center">Points</th>
                                <th class="text-center">Order</th>
                                <th class="text-center">Special Offer</th>
                                <th class="text-center">Out of Stock</th>
                                <th class="text-center">Visibility</th>
                                <th class="text-center px-4">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($items as $item)
                                <tr>
                                    <td class="text-center fw-bold text-muted">#{{ $loop->iteration }}</td>

                                    @foreach(get_active_langs() as $index => $lang)
                                        <td>
                                            <div class="fw-bold text-dark"
                                                 style="max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                {{ $item->{'title_'.$lang} }}
                                            </div>
                                            @if($index === 0)
                                                <div class="mt-2 d-flex gap-2">
                                                    @if($item->whatsapp)
                                                        <i class="fab fa-whatsapp text-success"
                                                           title="WhatsApp: {{ $item->whatsapp }}"
                                                           data-bs-toggle="tooltip"></i>
                                                    @endif
                                                    @if($item->quick_contact)
                                                        <i class="fas fa-phone-alt text-primary"
                                                           title="Call: {{ $item->quick_contact }}"
                                                           data-bs-toggle="tooltip"></i>
                                                    @endif
                                                    @if($item->contact_us)
                                                        <i class="fas fa-headset text-info"
                                                           title="Contact Info: {{ $item->contact_us }}"
                                                           data-bs-toggle="tooltip"></i>
                                                    @endif
                                                </div>
                                            @endif
                                        </td>
                                    @endforeach

                                    <td class="text-center">
                                        @if($item->season)
                                            <span class="season-badge">{{ $item->season }}</span>
                                        @else
                                            <span class="text-muted small">-</span>
                                        @endif
                                    </td>

                                    <td class="text-center">
                                        <div class="d-flex flex-column align-items-center">
                        <span class="fw-bold" style="color: #334155; font-size: 13px;">
                            <i class="fas fa-map-marker-alt me-1 text-danger"></i> {{ $item->itineraries->count() }} Cities
                        </span>
                                            <span class="text-muted mt-1" style="font-size: 11px;">
                            <i class="fas fa-moon me-1 text-primary"></i> {{ $item->itineraries->sum('nights') }} Nights
                        </span>
                                        </div>
                                    </td>

                                    <td class="text-center price-cell" id="price-cell-{{ $item->id }}"
                                        data-price="{{ $item->price }}"
                                        data-discount="{{ $item->discount }}"
                                        data-discount-type="{{ $item->discount_type }}">
                                        @if($item->price_after_discount < $item->price)
                                            <div class="d-flex flex-column align-items-center">
                                                <span class="price-badge mb-1">{{ number_format($item->price_after_discount, 0) }} SAR</span>
                                                <div class="d-flex align-items-center gap-1">
                                                    <span class="text-decoration-line-through text-muted" style="font-size: 11px;">{{ number_format($item->price, 0) }}</span>
                                                    <span class="badge bg-danger" style="font-size: 9px; padding: 3px 5px;">
                                                        -{{ $item->discount }}{{ $item->discount_type == 'percent' ? '%' : ' SAR' }}
                                                    </span>
                                                </div>
                                            </div>
                                        @else
                                            <span class="price-badge">{{ number_format($item->price, 0) }} SAR</span>
                                        @endif
                                    </td>

                                    <td class="text-center">
                                        <span class="points-badge d-inline-block">
                                            <i class="fas fa-coins me-1"></i> {{ $item->earned_points ?? 0 }}
                                        </span>
                                    </td>

                                    <td class="text-center">
                                        <div class="order-indicator mx-auto">{{ $item->order ?? 0}}</div>
                                    </td>

                                    <td class="text-center">
                                        <div
                                            class="toggle-is-feature-btn main-toggle mx-auto {{ $item->is_feature == 1 ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                                            data-id="{{ $item->id }}"
                                            data-is_feature="{{ $item->is_feature }}"
                                            title="{{ $item->featured_at ? 'Featured on: ' . \Carbon\Carbon::parse($item->featured_at)->format('Y-m-d') : '' }}"
                                            data-bs-toggle="tooltip">
                                            <span></span>
                                        </div>
                                        @if($item->is_feature == 1 && $item->featured_at)
                                            <div class="small text-success mt-1 fw-bold" style="font-size: 10px;">(7 Days Offer)</div>
                                        @endif
                                    </td>

                                    <td class="text-center">
                                        <div
                                            class="toggle-out-of-stock-btn main-toggle mx-auto {{ $item->out_of_stock == 1 ? 'main-toggle-danger on' : 'main-toggle-success of' }}"
                                            data-id="{{ $item->id }}"
                                            data-out_of_stock="{{ $item->out_of_stock }}"
                                            title="{{ $item->out_of_stock == 1 ? 'Out of Stock' : 'In Stock' }}">
                                            <span></span>
                                        </div>
                                        @if($item->out_of_stock == 1)
                                            <div class="small text-danger mt-1 fw-bold" style="font-size: 10px;">Out of stock</div>
                                        @endif
                                    </td>

                                    <td class="text-center">
                                        <div
                                            class="toggle-status-btn main-toggle mx-auto {{ $item->status == 1 ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                                            data-id="{{ $item->id }}"
                                            data-status="{{ $item->status }}">
                                            <span></span>
                                        </div>
                                    </td>

                                    <td class="text-center px-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a class="btn-action btn-duplicate-course"
                                               href="{{ route('items.duplicate', encrypt($item->id)) }}"
                                               title="Duplicate Trip">
                                                <i class="las la-copy fs-18"></i>
                                            </a>
                                            <a class="btn-action btn-notification open-notification-modal"
                                               data-id="{{ $item->id }}"
                                               data-title-en="{{ $item->title_en }}"
                                               data-title-ar="{{ $item->title_ar }}"
                                               href="javascript:void(0);"
                                               title="Send Notification">
                                                <i class="las la-bell fs-18"></i>
                                            </a>
                                            <a class="btn-action btn-edit-course"
                                               href="{{ route('items.edit', encrypt($item->id)) }}"
                                               title="Edit Item">
                                                <i class="las la-pen fs-18"></i>
                                            </a>
                                            <a class="btn-action btn-delete-course delete-btn"
                                               data-route="{{ route('items.destroy',$item->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"
                                               title="Remove Item">
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
                        <p class="text-muted small mb-0 fw-bold">Records: {{ $items->firstItem() }}
                            - {{ $items->lastItem() }} / Total: {{ $items->total() }}</p>
                        {{ $items->links() }}
                    </div>
                </div>
            </div>

            @include('pages.models.confirm-delete')
            @include('pages.items.models.import-excel')
            @include('pages.items.models.notification')

        </div>
    </div>
@endsection

@section('scripts')

    <script>

        $(document).on('click', '.open-notification-modal', function () {
            let id = $(this).data('id');
            let titleEn = $(this).data('title-en') || '';
            let titleAr = $(this).data('title-ar') || '';

            let displayHeader = titleEn ? titleEn : titleAr;
            if (displayHeader.length > 40) {
                displayHeader = displayHeader.substring(0, 40) + '...';
            }

            $('#notify_item_id').val(id);
            $('#notify_item_title').text(displayHeader).attr('title', displayHeader);

            $('#selected_template_id').val('');
            $('.template-card').removeClass('active');
            $('#sendNotificationBtn').prop('disabled', true);

            const arabicRegex = /[\u0600-\u06FF]/;

            $('.template-card').each(function() {
                let originalTitle = $(this).find('.original-title').text();
                let originalBody = $(this).find('.original-body').text();

                let nameToUse = titleEn;
                if (arabicRegex.test(originalTitle) || arabicRegex.test(originalBody)) {
                    nameToUse = titleAr ? titleAr : titleEn;
                } else {
                    nameToUse = titleEn ? titleEn : titleAr;
                }

                let newTitle = originalTitle.replace(/{trip_name}/g, nameToUse);
                let newBody = originalBody.replace(/{trip_name}/g, nameToUse);

                if (arabicRegex.test(originalTitle)) {
                    $(this).attr('dir', 'rtl').addClass('text-end');
                    $(this).find('.template-display-title').text(newTitle);
                    $(this).find('.template-display-body').text(newBody);
                } else {
                    $(this).attr('dir', 'ltr').removeClass('text-end');
                    $(this).find('.template-display-title').text(newTitle);
                    $(this).find('.template-display-body').text(newBody);
                }
            });

            $('#notificationModal').modal('show');
        });

        $(document).on('click', '.template-card', function() {
            $('.template-card').removeClass('active');
            $(this).addClass('active');

            $('#selected_template_id').val($(this).data('id'));
            $('#sendNotificationBtn').prop('disabled', false);
        });

        $('#sendNotificationBtn').on('click', function () {
            let itemId = $('#notify_item_id').val();
            let templateId = $('#selected_template_id').val();
            let btn = $(this);

            if (!templateId) {
                toastr.error('Please select a template first!');
                return;
            }

            btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i> Sending...');

            $.ajax({
                url: "{{ route('items.send_notification', ':id') }}".replace(':id', itemId),
                type: 'POST',
                data: {
                    _token: '{{ csrf_token() }}',
                    template_id: templateId
                },
                success: function (response) {
                    $('#notificationModal').modal('hide');
                    toastr.success(response.message);
                    btn.html('<i class="fas fa-paper-plane me-1"></i> Send Now');
                },
                error: function (xhr) {
                    toastr.error('Error sending notification.');
                    btn.prop('disabled', false).html('<i class="fas fa-paper-plane me-1"></i> Send Now');
                }
            });
        });

        // Status toggle
        $(document).on('click', '.toggle-status-btn', function () {
            let button = $(this);
            let itemId = button.data('id');
            $.ajax({
                url: "{{ route('items.change.status', ['id' => ':id']) }}".replace(':id', itemId),
                type: 'POST',
                data: {_token: '{{ csrf_token() }}'},
                success: function (response) {
                    toastr.success("Visibility Sync Successful");
                    if (response.status == 1) {
                        button.removeClass('main-toggle-danger of').addClass('main-toggle-success on');
                    } else {
                        button.removeClass('main-toggle-success on').addClass('main-toggle-danger of');
                    }
                }
            });
        });

        // Out of stock toggle
        $(document).on('click', '.toggle-out-of-stock-btn', function () {
            let button = $(this);
            let itemId = button.data('id');
            $.ajax({
                url: "{{ url('admin/items/change-out-of-stock') }}/" + itemId,
                type: 'POST',
                data: {_token: '{{ csrf_token() }}'},
                success: function (response) {
                    toastr.success("Stock status updated");
                    if (response.out_of_stock == 1) {
                        button.removeClass('main-toggle-success of').addClass('main-toggle-danger on');
                        button.attr('title', 'Out of Stock');
                        if(button.next('div').length === 0) {
                            button.after('<div class="small text-danger mt-1 fw-bold" style="font-size: 10px;">Out of stock</div>');
                        }
                    } else {
                        button.removeClass('main-toggle-danger on').addClass('main-toggle-success of');
                        button.attr('title', 'In Stock');
                        button.next('div.text-danger').remove();
                    }
                }
            });
        });

        // Feature toggle (Special Offer)
        $(document).on('click', '.toggle-is-feature-btn', function () {
            let button = $(this);
            let itemId = button.data('id');
            $.ajax({
                url: "{{ route('items.change.is_feature', ['id' => ':id']) }}".replace(':id', itemId),
                type: 'POST',
                data: {_token: '{{ csrf_token() }}'},
                success: function (response) {
                    toastr.success("Special Offer Updated (Valid for 7 days)");

                    if (response.is_feature == 1) {
                        button.removeClass('main-toggle-danger of').addClass('main-toggle-success on');
                        if(button.next('div').length === 0) {
                            button.after('<div class="small text-success mt-1 fw-bold" style="font-size: 10px;">(7 Days Offer)</div>');
                        }
                    } else {
                        button.removeClass('main-toggle-success on').addClass('main-toggle-danger of');
                        button.removeAttr('title');
                        button.next('div.text-success').remove();
                    }

                    let priceCell = $('#price-cell-' + itemId);
                    let price = parseFloat(priceCell.data('price')) || 0;
                    let discount = parseFloat(priceCell.data('discount')) || 0;
                    let discountType = priceCell.data('discount-type');

                    let html = '';

                    if (response.is_feature == 1 && discount > 0) {
                        let priceAfter = discountType === 'percent' ? price - (price * discount / 100) : price - discount;
                        priceAfter = Math.max(0, priceAfter);

                        let formattedPriceAfter = Math.round(priceAfter).toLocaleString('en-US');
                        let formattedPrice = Math.round(price).toLocaleString('en-US');
                        let discountLabel = discountType === 'percent' ? '%' : ' SAR';

                        html = `
                            <div class="d-flex flex-column align-items-center">
                                <span class="price-badge mb-1">${formattedPriceAfter} SAR</span>
                                <div class="d-flex align-items-center gap-1">
                                    <span class="text-decoration-line-through text-muted" style="font-size: 11px;">${formattedPrice}</span>
                                    <span class="badge bg-danger" style="font-size: 9px; padding: 3px 5px;">
                                        -${discount}${discountLabel}
                                    </span>
                                </div>
                            </div>
                        `;
                    } else {
                        let formattedPrice = Math.round(price).toLocaleString('en-US');
                        html = `<span class="price-badge">${formattedPrice} SAR</span>`;
                    }

                    priceCell.html(html);
                }
            });
        });

        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete();
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl)
            })
        });
    </script>
@endsection
