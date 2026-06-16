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

        /* Action Buttons - Deluxe Style */
        .btn-action {
            width: 40px;
            height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: #fff;
            border: 1px solid #e2e8f0;
            color: #64748b;
        }

        .btn-action:hover {
            transform: scale(1.15) rotate(5deg);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.08);
        }

        .btn-link-action:hover {
            color: #4f46e5;
            border-color: #4f46e5;
            background: #f5f3ff;
        }

        .btn-reply-action:hover {
            color: #10b981;
            border-color: #10b981;
            background: #f0fdf4;
        }

        .btn-delete-action:hover {
            color: #ef4444;
            border-color: #ef4444;
            background: #fef2f2;
        }

        /* Form Controls */
        .form-control-deluxe {
            border-radius: 12px !important;
            border: 2px solid #f1f5f9 !important;
            font-weight: 600 !important;
            padding: 10px 15px !important;
            transition: 0.3s;
        }

        .form-control-deluxe:focus {
            border-color: #4f46e5 !important;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1) !important;
        }

        .reply-badge {
            background: #f1f5f9;
            color: #475569;
            padding: 5px 10px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            border: 1px solid #e2e8f0;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Registered Users</h4>
            <p class="text-muted mb-0 small fw-medium">Registrations / <span
                    class="text-primary">User Applications</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Applications Hub</h3>
            <p class="mb-0 opacity-75 fw-medium">Generate payment links, reply to applicants, and manage registration
                records.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <button type="submit" form="bulk-delete-form"
                    class="btn btn-light rounded-pill px-4 fw-bold border-0 text-danger" style="height: 48px;">
                <i class="fas fa-trash-alt me-2"></i> Delete Selected
            </button>
        </div>
    </div>

    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card custom-card">
                <div class="card-header pb-0 border-bottom-0 p-4">
                    <div class="flex-grow-1">
                        <div class="input-group" style="max-width: 400px;">
                            <span class="input-group-text bg-light border-0" style="border-radius: 12px 0 0 12px;"><i
                                    class="fas fa-search text-muted"></i></span>
                            <input autofocus type="text" id="search" class="form-control-deluxe border-start-0"
                                   style="border-radius: 0 12px 12px 0 !important;"
                                   placeholder="Search users..." value="{{ request('search') }}">
                        </div>
                    </div>
                </div>

                <form method="POST" action="{{ route('register-users.bulk-delete') }}" id="bulk-delete-form">
                    @csrf
                    <div class="card-body p-0" id="register-table">
                        @include('pages.register-users.partials.table', ['registerUsers' => $registerUsers])
                    </div>
                </form>

                <div class="card-footer bg-transparent border-0 p-4 mt-2">
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="text-muted small mb-0 fw-bold">Showing {{ $registerUsers->count() }}
                            of {{ $registerUsers->total() }} entries</p>
                        {!! $registerUsers->appends(['search' => request('search')])->links() !!}
                    </div>
                </div>
            </div>
        </div>
    </div>

    {{-- Generated Link Modal --}}
    <div class="modal fade" id="linkResultModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius: 24px; overflow: hidden;">
                <div class="modal-header border-0 bg-light p-4">
                    <h5 class="modal-title fw-bold text-dark"><i class="las la-link me-2 text-primary"></i>Payment Link
                        Ready</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="form-group mb-0">
                        <label class="fw-bold text-muted small text-uppercase mb-2">Share this link with user:</label>
                        <div class="input-group">
                            <input type="text" class="form-control-deluxe w-100" id="generatedLinkInput" readonly
                                   style="background: #f8fafc;">
                            <button class="btn btn-primary rounded-3 ms-2 px-3 shadow-sm mt-2" type="button"
                                    id="copyLinkBtn">
                                <i class="las la-copy fs-20"></i> Copy Link
                            </button>
                        </div>
                        <p class="text-success small d-none mt-2 fw-bold" id="copySuccessMsg"><i
                                class="fas fa-check-circle me-1"></i> Link copied to clipboard!</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    @include('pages.models.confirm-delete')
    @include('pages.register-users.models.reply')

@endsection

@section('scripts')
    <script>
        $(document).ready(function () {
            $('#search').on('keyup', function () {
                let search = $(this).val();
                $.ajax({
                    url: "{{ route('register-users.index') }}",
                    data: {search: search},
                    success: function (data) {
                        $('#register-table').html(data);
                        rebindEvents();
                    }
                });
            });

            function attachReplyBtns() {
                document.querySelectorAll(".reply-btn").forEach(btn => {
                    btn.addEventListener("click", () => {
                        const replyInput = document.getElementById("reply-input");
                        if (replyInput) replyInput.value = btn.dataset.reply;
                        document.getElementById("replyForm").action = btn.dataset.route;
                    });
                });
            }

            function rebindEvents() {
                attachReplyBtns();
                if (typeof confirmDelete === 'function') confirmDelete();
            }

            window.toggle = function (source) {
                document.querySelectorAll('input[name="ids[]"]').forEach(cb => cb.checked = source.checked);
            }

            rebindEvents();

            $(document).on('click', '.create-link-btn', function (e) {
                e.preventDefault();
                let btn = $(this);
                let url = btn.data('url');
                let originalContent = btn.html();
                btn.html('<i class="fas fa-spinner fa-spin"></i>').prop('disabled', true);

                $.ajax({
                    url: url,
                    type: "POST",
                    data: {_token: "{{ csrf_token() }}"},
                    success: function (response) {
                        btn.html(originalContent).prop('disabled', false);
                        if (response.status === 'success') {
                            $('#generatedLinkInput').val(response.link);
                            $('#copySuccessMsg').addClass('d-none');
                            $('#linkResultModal').modal('show');
                        } else {
                            toastr.error('Error: ' + response.message);
                        }
                    }
                });
            });

            $('#copyLinkBtn').on('click', function () {
                let copyText = document.getElementById("generatedLinkInput");
                copyText.select();
                navigator.clipboard.writeText(copyText.value).then(function () {
                    $('#copySuccessMsg').removeClass('d-none');
                    toastr.success("Link Copied!");
                });
            });
        });

        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete();
        });
    </script>
@endsection
