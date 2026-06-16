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

        /* Testimonial Specific */
        .client-avatar {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            object-fit: cover;
            border: 2px solid #fff;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            cursor: pointer;
        }

        .testimonial-text {
            max-width: 300px;
            white-space: normal;
            line-height: 1.6;
            font-size: 0.9rem;
            color: #64748b;
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
                Client Testimonials</h4>
            <p class="text-muted mb-0 small fw-medium">Social Proof / <span class="text-primary">User Reviews</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Testimonials Management</h3>
            <p class="mb-0 opacity-75 fw-medium">Control and showcase your customers' success stories and feedback.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            {{-- Bulk Delete Button Linked to Form --}}
            <button type="submit" form="bulk-delete-form"
                    class="btn btn-light rounded-pill px-4 fw-bold border-0 text-danger" style="height: 48px;">
                <i class="fas fa-trash-alt me-2"></i> Delete Selected
            </button>
            <a href="{{ route('testimonials.create') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #4f46e5; height: 48px;">
                <i class="fas fa-plus-circle me-2"></i> Create Testimonial
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-12">
            <div class="card custom-card">
                <div class="card-header pb-0 border-bottom-0 p-4">
                    <div class="flex-grow-1">
                        <div class="input-group" style="max-width: 400px;">
                            <span class="input-group-text bg-light border-0"><i
                                    class="fas fa-search text-muted"></i></span>
                            <input type="text" id="search" class="form-control border-0 bg-light"
                                   placeholder="Search by name, email or content..." value="{{ request('search') }}">
                        </div>
                    </div>
                </div>

                <form method="POST" action="{{ route('testimonials.bulk-delete') }}" id="bulk-delete-form">
                    @csrf
                    <div class="card-body p-0" id="testimonials-table">
                        @include('pages.testimonials.partials.table', ['testimonials' => $testimonials])
                    </div>
                </form>

                <div class="card-footer bg-transparent border-0 p-4 mt-2">
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="text-muted small mb-0 fw-bold">Showing {{ $testimonials->count() }}
                            of {{ $testimonials->total() }} entries</p>
                        {{ $testimonials->links() }}
                    </div>
                </div>
            </div>
        </div>
    </div>

    @include('pages.models.confirm-delete')

    {{-- Image Modal --}}
    <div class="modal fade" id="imageModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 bg-transparent shadow-none">
                <div class="modal-body p-0 text-center">
                    <img src="" id="modalImage" class="img-fluid rounded-4 shadow-lg" alt="Preview">
                </div>
            </div>
        </div>
    </div>
@endsection

@section('scripts')
    <script>

        $(document).on('click', '.img-preview', function () {
            $('#modalImage').attr('src', this.dataset.src);
        });

        $(document).on('click', '.toggle-status-btn', function () {
            let button = $(this);
            let id = button.data('id');
            $.ajax({
                url: "{{ route('testimonials.change.status', ['id' => ':id']) }}".replace(':id', id),
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

        $(document).ready(function () {
            $('#search').on('keyup', function () {
                let search = $(this).val();
                $.ajax({
                    url: "{{ route('testimonials.index') }}",
                    data: {search: search},
                    success: function (data) {
                        $('#testimonials-table').html(data);
                        if (typeof confirmDelete === 'function') confirmDelete();
                    }
                });
            });

            window.toggle = function (source) {
                document.querySelectorAll('input[name="ids[]"]').forEach(cb => cb.checked = source.checked);
            }
        });

        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete();
        });

    </script>
@endsection
