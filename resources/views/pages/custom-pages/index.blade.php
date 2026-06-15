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

        .btn-preview-action:hover {
            color: #10b981;
            border-color: #10b981;
            background: #ecfdf5;
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

        /* Copy Button - Deluxe Hover */
        .btn-copy-link {
            background: #f1f5f9;
            color: #4f46e5;
            border: 1px solid #e2e8f0;
            font-weight: 700;
            padding: 8px 16px;
            border-radius: 12px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .btn-copy-link:hover {
            background: #4f46e5 !important;
            color: #ffffff !important;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(79, 70, 229, 0.2) !important;
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
                Custom Pages
            </h4>
            <p class="text-muted mb-0 small fw-medium">Management / <span class="text-primary">Static Content</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Content Builder Hub</h3>
            <p class="mb-0 opacity-75 fw-medium">Create and publish standalone pages for your website's specialized
                content.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a href="{{ route('custom-pages.create') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #4f46e5; height: 48px;">
                <i class="fas fa-plus-circle me-2"></i> Add New Page
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
                                @foreach(get_active_langs() as $lang)
                                    <th>Title <span class="lang-tag">{{ strtoupper($lang) }}</span></th>
                                @endforeach
                                <th>Slug Link</th>
                                <th class="text-center">Status</th>
                                <th class="text-center px-4">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($pages as $page)
                                <tr>
                                    <td class="text-center fw-bold text-muted">{{ $loop->iteration }}</td>

                                    @foreach(get_active_langs() as $lang)
                                        <td class="fw-bold text-dark">{{ $page->{'title_'.$lang} }}</td>
                                    @endforeach

                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <span
                                                class="small fw-bold text-muted border-bottom border-dashed">{{ $page->slug }}</span>
                                            <button class="btn btn-copy-link copy-link-btn shadow-sm"
                                                    data-link="{{ env('WEBSITE_URL').'/'.$page->slug }}"
                                                    title="Copy URL">
                                                <i class="las la-copy"></i>
                                            </button>
                                        </div>
                                    </td>

                                    <td class="text-center">
                                        <div
                                            class="toggle-status-btn main-toggle mx-auto {{ $page->status == 1 ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                                            data-id="{{ $page->id }}">
                                            <span></span>
                                        </div>
                                    </td>

                                    <td class="text-center px-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <button class="btn-action btn-preview-action preview-ajax-btn"
                                                    data-id="{{ $page->id }}" data-bs-toggle="modal"
                                                    data-bs-target="#previewModal"
                                                    title="Preview Page">
                                                <i class="las la-eye fs-18"></i>
                                            </button>

                                            <a class="btn-action btn-edit-action"
                                               href="{{ route('custom-pages.edit', encrypt($page->id)) }}"
                                               title="Edit Content">
                                                <i class="las la-pen fs-18"></i>
                                            </a>

                                            <a class="btn-action btn-delete-action delete-btn"
                                               data-route="{{ route('custom-pages.destroy',$page->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"
                                               title="Remove Page">
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
                        <p class="text-muted small mb-0 fw-bold">Pages: {{ $pages->count() }}
                            of {{ $pages->total() }}</p>
                        {{ $pages->links() }}
                    </div>
                </div>
            </div>

            @include('pages.models.confirm-delete')

        </div>
    </div>

    {{-- Preview Modal --}}
    <div class="modal fade" id="previewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px; overflow: hidden;">
                <div class="modal-header bg-light border-0 px-4 py-3">
                    <h5 class="modal-title fw-bold text-dark">Page Live Preview</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-5 row" id="preview-body">
                    {{-- Loader --}}
                </div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')
    <script>
        // Preview Logic
        $(document).on('click', '.preview-ajax-btn', function () {
            let pageId = $(this).data('id');
            $('#preview-body').html('<div class="text-center w-100 py-5"><span class="spinner-border text-primary"></span><p class="mt-2 text-muted">Building preview...</p></div>');

            $.ajax({
                url: "{{ route('custom-pages.preview', ['id' => ':id']) }}".replace(':id', pageId),
                type: 'GET',
                success: function (response) {
                    $('#preview-body').html(response.html);
                },
                error: function () {
                    $('#preview-body').html('<div class="alert alert-danger w-100">Failed to load preview. Please try again.</div>');
                }
            });
        });

        // Smart Copy Logic
        $(document).on('click', '.copy-link-btn', function () {
            let button = $(this);
            let icon = button.find('i');
            let originalIcon = 'la-copy';
            let successIcon = 'la-check';
            let link = button.data('link');

            navigator.clipboard.writeText(link).then(function () {
                toastr.success("Link copied to clipboard");
                icon.removeClass(originalIcon).addClass(successIcon);
                button.css('background', '#10b981').css('color', '#fff').css('border-color', '#10b981');
                setTimeout(function () {
                    icon.removeClass(successIcon).addClass(originalIcon);
                    button.css('background', '').css('color', '').css('border-color', '');
                }, 2000);
            });
        });

        // AJAX Status Toggle
        $(document).on('click', '.toggle-status-btn', function () {
            let button = $(this);
            let pageId = button.data('id');
            $.ajax({
                url: "{{ route('pages.change.status', ['id' => ':id']) }}".replace(':id', pageId),
                type: 'POST',
                data: {_token: '{{ csrf_token() }}'},
                success: function (response) {
                    toastr.success("Visibility updated successfully");
                    if (response.status == 1) {
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
