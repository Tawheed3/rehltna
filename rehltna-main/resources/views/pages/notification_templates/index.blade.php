@extends('layouts.app')

@section('styles')
    <style>
        /* Global Background */
        body {
            background-color: #f8fafc;
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

        /* Table Header Visibility & Space Fix */
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

        .btn-edit-cat:hover {
            color: #4f46e5;
            border-color: #4f46e5;
            background: #e0e7ff;
        }

        .btn-delete-cat:hover {
            color: #ef4444;
            border-color: #ef4444;
            background: #fef2f2;
        }

    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Notification Templates
            </h4>
            <p class="text-muted mb-0 small fw-medium">Settings / <span class="text-primary">Random Messages</span>
            </p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Manage Notification Templates</h3>
            <p class="mb-0 opacity-75 fw-medium">Organize Notification Templates</p>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card border-0 shadow-sm" style="border-radius: 20px;">
                <div class="card-body p-4">
                    <h6 class="fw-bold mb-3"><i class="las la-plus-circle text-primary me-2"></i> Add New Template</h6>

                    <div class="alert alert-light border border-info mb-4"
                         style="border-radius: 12px; font-size: 0.85rem;">
                        <i class="las la-info-circle text-info"></i>
                        <strong>Tip:</strong> You can use <code>{trip_name}</code> in the title or body, and the system
                        will replace it with the actual trip name!
                    </div>

                    <form action="{{ route('notification-templates.store') }}" method="POST">
                        @csrf
                        <div class="mb-3">
                            <label class="fw-bold small mb-1">Title</label>
                            <input type="text" name="title" class="form-control" style="border-radius: 10px;"
                                   placeholder="e.g. 🎒 New Trip: {trip_name}" required>
                        </div>
                        <div class="mb-4">
                            <label class="fw-bold small mb-1">Message Body</label>
                            <textarea name="body" class="form-control" rows="9" style="border-radius: 10px;"
                                      placeholder="e.g. Hurry up and book your spot for {trip_name} before it's too late!"
                                      required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold" style="border-radius: 10px;">Save
                            Template
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card border-0 shadow-sm" style="border-radius: 20px;">
                <div class="card-body p-4">
                    <h6 class="fw-bold mb-3"><i class="las la-list text-success me-2"></i> Available Templates</h6>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="bg-light">
                            <tr>
                                <th>Title</th>
                                <th>Body</th>
                                <th class="text-center px-4" width="120">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            @forelse($templates as $template)
                                <tr>
                                    <td class="fw-bold">{{ $template->title }}</td>
                                    <td class="text-muted small">{{ $template->body }}</td>
                                    <td class="text-center px-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <button type="button"
                                                    class="btn-action btn-edit-cat edit-template-btn shadow-sm"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#editTemplateModal"
                                                    data-id="{{ $template->id }}"
                                                    data-title="{{ $template->title }}"
                                                    data-body="{{ $template->body }}"
                                                    title="Edit Template">
                                                <i class="las la-pen fs-18"></i>
                                            </button>

                                            <a class="btn-action btn-delete-cat delete-btn shadow-sm"
                                               data-bs-effect="effect-scale"
                                               data-route="{{ route('notification-templates.destroy', $template->id) }}"
                                               data-bs-toggle="modal" href="#deleteModal"
                                               title="Delete Template">
                                                <i class="las la-trash fs-18"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="3" class="text-center py-4 text-muted">No templates added yet.</td>
                                </tr>
                            @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editTemplateModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0"
                 style="border-radius: 20px; overflow: visible; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <div class="modal-header bg-light border-0 p-4">
                    <h5 class="modal-title fw-bold text-dark"><i class="las la-pen text-primary me-2"></i> Edit Template
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editTemplateForm" method="POST">
                    @csrf
                    @method('PUT')
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="fw-bold small mb-1">Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" id="modalTemplateTitle" class="form-control"
                                   style="border-radius: 10px;" required>
                        </div>
                        <div class="mb-0">
                            <label class="fw-bold small mb-1">Message Body <span class="text-danger">*</span></label>
                            <textarea name="body" id="modalTemplateBody" class="form-control" rows="4"
                                      style="border-radius: 10px;" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">
                            Cancel
                        </button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    @include('pages.models.confirm-delete')

@endsection

@section('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            if (typeof confirmDelete === "function") {
                confirmDelete();
            }

            $(document).on('click', '.edit-template-btn', function () {
                let id = $(this).data('id');
                let title = $(this).data('title');
                let body = $(this).data('body');

                $('#modalTemplateTitle').val(title);
                $('#modalTemplateBody').val(body);

                let updateUrl = "{{ route('notification-templates.update', ':id') }}";
                updateUrl = updateUrl.replace(':id', id);
                $('#editTemplateForm').attr('action', updateUrl);
            });
        });
    </script>
@endsection
