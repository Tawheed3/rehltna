@extends('layouts.app')

@section('styles')
    <style>
        body {
            background-color: #f8fafc;
        }

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

        .btn-edit-gal:hover {
            color: #4f46e5;
            border-color: #4f46e5;
            background: #f5f3ff;
        }

        .btn-delete-gal:hover {
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
                Tourist Attractions
            </h4>
            <p class="text-muted mb-0 small fw-medium">Management / <span class="text-primary">Attractions</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Tourist Attractions Hub</h3>
            <p class="mb-0 opacity-75 fw-medium">Manage and showcase beautiful destinations and landmarks.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a href="{{ route('events-galleries.create') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #1e293b; height: 48px;">
                <i class="fas fa-plus-circle me-2 text-primary"></i> Add Attraction
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
                                <th class="text-center" width="80">#</th>
                                @foreach(get_active_langs() as $lang)
                                    <th>Attraction Title <span class="lang-tag">{{ strtoupper($lang) }}</span></th>
                                @endforeach
                                <th>Country</th>
                                <th class="text-center">Order</th>
                                <th class="text-center">Featured</th>
                                <th class="text-center">Visibility</th>
                                <th class="text-center px-4">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($eventGalleries as $eventGallery)
                                <tr>
                                    <td class="text-center fw-bold text-muted">{{ $loop->iteration }}</td>

                                    @foreach(get_active_langs() as $lang)
                                        <td>
                                            <div class="fw-bold text-dark"
                                                 style="max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                {{ $eventGallery->{'title_'.$lang} }}
                                            </div>
                                        </td>
                                    @endforeach

                                    <td>
                                        <span
                                            class="badge bg-light text-dark border">{{ $eventGallery->country ? (transDB($eventGallery->country, 'title') ?? $eventGallery->country->name) : 'N/A' }}</span>
                                    </td>

                                    <td class="text-center">
                                        <div class="order-indicator mx-auto">{{ $eventGallery->order ?? 0}}</div>
                                    </td>

                                    <td class="text-center">
                                        <div
                                            class="toggle-is-feature-btn main-toggle mx-auto {{ $eventGallery->is_feature == 1 ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                                            data-id="{{ $eventGallery->id }}">
                                            <span></span>
                                        </div>
                                    </td>

                                    <td class="text-center">
                                        <div
                                            class="toggle-status-btn main-toggle mx-auto {{ $eventGallery->status == 1 ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                                            data-id="{{ $eventGallery->id }}">
                                            <span></span>
                                        </div>
                                    </td>

                                    <td class="text-center px-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a class="btn-action btn-edit-gal"
                                               href="{{ route('events-galleries.edit', encrypt($eventGallery->id)) }}"
                                               title="Edit Attraction">
                                                <i class="las la-pen fs-18"></i>
                                            </a>
                                            <a class="btn-action btn-delete-gal delete-btn"
                                               data-route="{{ route('events-galleries.destroy',$eventGallery->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"
                                               title="Remove Attraction">
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
                        <p class="text-muted small mb-0 fw-bold">Items: {{ $eventGalleries->firstItem() }}
                            - {{ $eventGalleries->lastItem() }} / Total: {{ $eventGalleries->total() }}</p>
                        {{ $eventGalleries->links() }}
                    </div>
                </div>
            </div>

            @include('pages.models.confirm-delete')

        </div>
    </div>
@endsection

@section('scripts')
    <script>
        $(document).on('click', '.toggle-status-btn', function () {
            let button = $(this);
            let eventGalleryId = button.data('id');
            $.ajax({
                url: "{{ route('events.galleries.change.status', ['id' => ':id']) }}".replace(':id', eventGalleryId),
                type: 'POST',
                data: {_token: '{{ csrf_token() }}'},
                success: function (response) {
                    toastr.success("Visibility updated");
                    if (response.status == 1) {
                        button.removeClass('main-toggle-danger of').addClass('main-toggle-success on');
                    } else {
                        button.removeClass('main-toggle-success on').addClass('main-toggle-danger of');
                    }
                }
            });
        });

        $(document).on('click', '.toggle-is-feature-btn', function () {
            let button = $(this);
            let eventGalleryId = button.data('id');
            $.ajax({
                url: "{{ route('events.galleries.change.is_feature', ['id' => ':id']) }}".replace(':id', eventGalleryId),
                type: 'POST',
                data: {_token: '{{ csrf_token() }}'},
                success: function (response) {
                    toastr.success("Featured status updated");
                    if (response.is_feature == 1) {
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
