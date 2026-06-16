@extends('layouts.app')

@section('styles')
    <style>
        /* Global Background */
        body {
            background-color: #f8fafc;
        }

        /* Card Deluxe Styling */
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

        /* Tools Button Custom Style (No disappearing text) */
        .btn-tools-container .btn-tools {
            background-color: rgba(255, 255, 255, 0.12) !important;
            border: 1px solid rgba(255, 255, 255, 0.25) !important;
            color: #ffffff !important;
            font-weight: 600 !important;
            transition: all 0.4s ease !important;
            backdrop-filter: blur(8px);
        }

        .btn-tools-container .btn-tools:hover {
            background-color: #ffffff !important;
            color: #1e293b !important;
            border-color: #ffffff !important;
            transform: translateY(-3px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.2) !important;
        }

        /* Badges & Indicators */
        .count-badge {
            background: #eff6ff;
            color: #1e40af;
            padding: 6px 14px;
            border-radius: 12px;
            font-weight: 800;
            border: 1px solid #dbeafe;
        }

        .order-indicator {
            width: 32px;
            height: 32px;
            background: #fff;
            border: 2px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            font-weight: 800;
            color: #475569;
            font-size: 0.8rem;
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

        .btn-edit-type:hover {
            color: #4f46e5;
            border-color: #4f46e5;
            background: #f5f3ff;
        }

        .btn-delete-type:hover {
            color: #ef4444;
            border-color: #ef4444;
            background: #fef2f2;
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
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Categories Hub
            </h4>
            <p class="text-muted mb-0 small fw-medium">Dashboard / <span
                    class="text-primary">Classification Management</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Structure Your Catalog</h3>
            <p class="mb-0 opacity-75 fw-medium">Manage and export different types of items in your system.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            {{--            <div class="dropdown btn-tools-container">--}}
            {{--                <button class="btn btn-tools dropdown-toggle rounded-pill px-4 shadow-sm" type="button"--}}
            {{--                        data-bs-toggle="dropdown">--}}
            {{--                    <i class="fas fa-file-excel me-2 text-success"></i> Excel Tools--}}
            {{--                </button>--}}
            {{--                <ul class="dropdown-menu shadow-lg border-0 p-2 mt-3" style="border-radius: 18px; min-width: 220px;">--}}
            {{--                    @if(\App\Models\ErrorUploaded::query()->where('type','item_type')->count() > 0)--}}
            {{--                        <li><a class="dropdown-item rounded-3 py-2 text-danger fw-bold"--}}
            {{--                               href="{{ route('item-types.export-excel-error-uploaded') }}"><i--}}
            {{--                                    class="fas fa-exclamation-circle me-2"></i>Export Errors</a></li>--}}
            {{--                    @endif--}}
            {{--                    <li><a class="dropdown-item rounded-3 py-2" href="{{ route('item-types.export-excel-temp') }}"><i--}}
            {{--                                class="fas fa-download me-2 text-warning"></i>Get Template</a></li>--}}
            {{--                    @if($itemTypes->total() > 0)--}}
            {{--                        <li><a class="dropdown-item rounded-3 py-2" href="{{ route('item-types.export-excel') }}"><i--}}
            {{--                                    class="fas fa-file-excel me-2 text-info"></i>Export Full Data</a></li>--}}
            {{--                    @endif--}}
            {{--                    <li>--}}
            {{--                        <hr class="dropdown-divider opacity-50">--}}
            {{--                    </li>--}}
            {{--                    <li><a class="dropdown-item rounded-3 py-2 modal-effect" data-bs-toggle="modal" href="#importExcel"><i--}}
            {{--                                class="fas fa-upload me-2 text-success"></i>Bulk Import</a></li>--}}
            {{--                </ul>--}}
            {{--            </div>--}}

            <a href="{{ route('item-types.create') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #4f46e5; height: 48px;">
                <i class="fas fa-plus-circle me-2"></i> New Type
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
                                <th class="text-center" width="80">Index</th>
                                @foreach(get_active_langs() as $lang)
                                    <th>Title <span class="lang-tag">{{ strtoupper($lang) }}</span></th>
                                @endforeach
                                <th class="text-center">Order</th>
                                <th class="text-center">WhatsApp</th>
                                <th class="text-center">Item Count</th>
                                <th class="text-center">Featured</th>
                                <th class="text-center px-4">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($itemTypes as $itemType)
                                <tr>
                                    <td class="text-center fw-bold text-muted">#{{ $loop->iteration }}</td>

                                    @foreach(get_active_langs() as $lang)
                                        <td>
                                            <div class="fw-bold text-dark" style="font-size: 1rem;">
                                                {{ $itemType->{'title_'.$lang} }}
                                                @if($itemType->parent_id)
                                                    <span class="badge bg-light text-secondary border ms-1" style="font-size: 10px;">
                                    <i class="fas fa-level-up-alt fa-rotate-90 me-1"></i>Sub
                                </span>
                                                @endif
                                            </div>
                                        </td>
                                    @endforeach

                                    <td class="text-center">
                                        <div class="order-indicator mx-auto">{{ $itemType->order ?? 0}}</div>
                                    </td>

                                    <td class="text-center">
                                        @if($itemType->whatsapp)
                                            <a href="{{ str_starts_with($itemType->whatsapp, 'http') ? $itemType->whatsapp : 'https://wa.me/' . preg_replace('/[^0-9]/', '', $itemType->whatsapp) }}"
                                               target="_blank"
                                               class="btn-action mx-auto"
                                               style="color: #25D366; border-color: rgba(37, 211, 102, 0.3); background: #ebfbf0;"
                                               title="{{ $itemType->whatsapp }}">
                                                <i class="fab fa-whatsapp fs-20"></i>
                                            </a>
                                        @else
                                            <span class="text-muted opacity-50">-</span>
                                        @endif
                                    </td>

                                    <td class="text-center">
                    <span class="count-badge">
                        <i class="fas fa-layer-group me-1 opacity-50"></i> {{ $itemType->items_count }} Trips
                    </span>
                                    </td>

                                    <td class="text-center">
                                        <div
                                            class="toggle-is-feature-btn main-toggle mx-auto {{ $itemType->is_feature == 1 ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                                            data-id="{{ $itemType->id }}"
                                            data-is_feature="{{ $itemType->is_feature }}">
                                            <span></span>
                                        </div>
                                    </td>

                                    <td class="text-center px-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a class="btn-action btn-edit-type"
                                               href="{{ route('item-types.edit', encrypt($itemType->id)) }}"
                                               title="Edit Type">
                                                <i class="las la-pen fs-18"></i>
                                            </a>
                                            <a class="btn-action btn-delete-type delete-btn"
                                               data-route="{{ route('item-types.destroy',$itemType->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"
                                               title="Delete Type">
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
                        <p class="text-muted small mb-0 fw-bold">Records: {{ $itemTypes->firstItem() }}
                            - {{ $itemTypes->lastItem() }} / Total: {{ $itemTypes->total() }}</p>
                        {{ $itemTypes->links() }}
                    </div>
                </div>
            </div>

            @include('pages.models.confirm-delete')
            @include('pages.item-types.models.import-excel')

        </div>
    </div>
@endsection

@section('scripts')
    <script>

        $(document).on('click', '.toggle-is-feature-btn', function () {
            let button = $(this);
            let itemTypeId = button.data('id');
            $.ajax({
                url: "{{ route('item.types.change.is_feature', ['id' => ':id']) }}".replace(':id', itemTypeId),
                type: 'POST',
                data: {_token: '{{ csrf_token() }}'},
                success: function (response) {
                    toastr.success("Featured status synchronized");
                    if (response.is_feature == 1) {
                        button.removeClass('main-toggle-danger of').addClass('main-toggle-success on');
                    } else {
                        button.removeClass('main-toggle-success on').addClass('main-toggle-danger of');
                    }
                }
            });
        });

        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete()
        });
    </script>
@endsection
