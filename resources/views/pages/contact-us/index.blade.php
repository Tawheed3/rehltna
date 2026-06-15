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
        }

        .btn-reply-action:hover {
            color: #10b981;
            border-color: #10b981;
            background: #f0fdf4;
        }

        .btn-delete-action:hover {
            color: #ef4444;
            background: #fef2f2;
            border-color: #fecaca;
        }

        /* Form Controls */
        .form-control-deluxe {
            border-radius: 12px !important;
            border: 2px solid #f1f5f9 !important;
            font-weight: 600 !important;
            padding: 10px 15px !important;
            height: auto !important;
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
                Contact Center</h4>
            <p class="text-muted mb-0 small fw-medium">Support / <span class="text-primary">Inbound Messages</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Message Management</h3>
            <p class="mb-0 opacity-75 fw-medium">Respond to customer inquiries and manage support communications.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <button type="submit" form="bulk-delete-form"
                    class="btn btn-light rounded-pill px-4 fw-bold border-0 text-danger" style="height: 48px;">
                <i class="fas fa-trash-alt me-2"></i> Delete Selected
            </button>
            <a href="{{ route('contact-us.export-excel') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #10b981; height: 48px;">
                <i class="fas fa-file-excel me-2"></i> Export Excel
            </a>
        </div>
    </div>

    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card custom-card">
                <div class="card-header pb-0 border-bottom-0 p-4">
                    <div class="flex-grow-1" style="max-width: 400px;">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0" style="border-radius: 12px 0 0 12px;"><i
                                    class="fas fa-search text-muted"></i></span>
                            <input autofocus type="text" id="search" class="form-control-deluxe border-start-0"
                                   style="border-radius: 0 12px 12px 0 !important;" placeholder="Search messages..."
                                   value="{{ request('search') }}">
                        </div>
                    </div>
                </div>

                <form method="POST" action="{{ route('contact-us.bulk-delete') }}" id="bulk-delete-form">
                    @csrf
                    <div class="card-body p-0" id="contacts-table">
                        @include('pages.contact-us.partials.table', ['contacts' => $contacts])
                    </div>
                </form>

                <div class="card-footer bg-transparent border-0 p-4 mt-2">
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="text-muted small mb-0 fw-bold">Showing {{ $contacts->count() }}
                            of {{ $contacts->total() }} messages</p>
                        {!! $contacts->appends(['search' => request('search')])->links() !!}
                    </div>
                </div>
            </div>
        </div>
    </div>

    @include('pages.models.confirm-delete')
    @include('pages.contact-us.models.reply')

@endsection

@section('scripts')
    <script>
        $(document).ready(function () {
            $('#search').on('keyup', function () {
                let search = $(this).val();
                $.ajax({
                    url: "{{ route('contact-us.index') }}",
                    data: {search: search},
                    success: function (data) {
                        $('#contacts-table').html(data);
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
        });
    </script>
@endsection
