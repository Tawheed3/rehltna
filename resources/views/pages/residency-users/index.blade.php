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

        .btn-delete-action:hover {
            color: #ef4444;
            background: #fef2f2;
            border-color: #fecaca;
        }

        /* Form Control Fix */
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

        /* Stats Badge */
        .count-badge {
            background: #eff6ff;
            color: #3b82f6;
            padding: 6px 12px;
            border-radius: 10px;
            font-weight: 800;
            border: 1px solid #3b82f630;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Residency Users</h4>
            <p class="text-muted mb-0 small fw-medium">Users / <span
                    class="text-primary">Medical Residency Registry</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Users Directory</h3>
            <p class="mb-0 opacity-75 fw-medium">Manage residency applicants, track their items, and monitor order
                history.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <button type="submit" form="bulk-delete-form"
                    class="btn btn-light rounded-pill px-4 fw-bold border-0 text-danger" style="height: 48px;">
                <i class="fas fa-trash-alt me-2"></i> Delete Selected
            </button>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-12">
            <div class="card custom-card">
                <div class="card-header pb-0 border-bottom-0 p-4">
                    <div class="d-flex flex-wrap gap-3">
                        <div class="input-group flex-grow-1" style="max-width: 400px;">
                            <span class="input-group-text bg-light border-0" style="border-radius: 12px 0 0 12px;">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input autofocus type="text" id="search" class="form-control-deluxe border-start-0 w-auto"
                                   style="border-radius: 0 12px 12px 0 !important; flex: 1;"
                                   placeholder="Search by name, email, phone..." value="{{ request('search') }}">
                        </div>

                        <div style="min-width: 200px;">
                            <select id="package-filter" class="form-select form-control-deluxe">
                                <option value="all">All Packages</option>
                                @foreach($packages as $pkg)
                                    <option
                                        value="{{ $pkg->id }}" {{ request('package_id') == $pkg->id ? 'selected' : '' }}>
                                        {{ $pkg->name_en }}
                                    </option>
                                @endforeach
                            </select>
                        </div>
                    </div>
                </div>

                <form method="POST" action="{{ route('residency-users.bulk-delete') }}" id="bulk-delete-form">
                    @csrf
                    <div class="card-body p-0" id="residency-table">
                        @include('pages.residency-users.partials.table', ['residencyUsers' => $residencyUsers])
                    </div>
                </form>

                <div class="card-footer bg-transparent border-0 p-4 mt-2">
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="text-muted small mb-0 fw-bold">Showing {{ $residencyUsers->count() }}
                            of {{ $residencyUsers->total() }} entries</p>
                        {!! $residencyUsers->appends(['search' => request('search'), 'package_id' => request('package_id')]) !!}
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="changePackageModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0"
                 style="border-radius: 20px; overflow: visible; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <div class="modal-header bg-light border-0 p-4">
                    <h5 class="modal-title fw-bold text-dark"><i class="las la-exchange-alt text-primary me-2"></i>
                        Change User Package</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="changePackageForm" method="POST">
                    @csrf
                    <div class="modal-body p-4">
                        <p class="mb-3">Select a new subscription package for <strong id="modalUserName"
                                                                                      class="text-primary"></strong>.
                        </p>

                        <div class="form-group mb-0">
                            <label class="form-label fw-bold text-muted mb-2">Available Packages</label>
                            <select name="package_id" id="modalPackageSelect"
                                    class="form-select form-control-deluxe w-100" required>
                                <option value="" disabled>-- Select Package --</option>
                                @foreach($packages as $pkg)
                                    <option value="{{ $pkg->id }}">
                                        {{ $pkg->name_en }} - ${{ number_format($pkg->price, 0) }}
                                    </option>
                                @endforeach
                            </select>
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

    {{-- Edit Points Modal --}}
    <div class="modal fade" id="editPointsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width:480px;">
            <div class="modal-content border-0" style="border-radius:20px;box-shadow:0 10px 30px rgba(0,0,0,0.12);">

                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold text-dark">
                        <i class="las la-star text-warning me-2"></i>
                        Manage Points — <span id="pointsModalUserName" class="text-primary"></span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">

                    {{-- Tabs --}}
                    <ul class="nav nav-pills mb-4 gap-2" id="pointsTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active fw-bold px-4" id="tab-balance-btn"
                                    data-bs-toggle="pill" data-bs-target="#tab-balance"
                                    type="button" style="border-radius:12px;">
                                <i class="las la-wallet me-1"></i> Balance
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link fw-bold px-4" id="tab-add-btn"
                                    data-bs-toggle="pill" data-bs-target="#tab-add"
                                    type="button" style="border-radius:12px;">
                                <i class="las la-plus-circle me-1"></i> Add
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link fw-bold px-4" id="tab-deduct-btn"
                                    data-bs-toggle="pill" data-bs-target="#tab-deduct"
                                    type="button" style="border-radius:12px;">
                                <i class="las la-minus-circle me-1"></i> Deduct
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content">

                        {{-- Tab 1: Current Balance --}}
                        <div class="tab-pane fade show active" id="tab-balance" role="tabpanel">
                            <div class="text-center py-3">
                                <div style="font-size:13px;color:#64748b;font-weight:600;margin-bottom:10px;">
                                    Current Available Points
                                </div>
                                <div id="balanceDisplay"
                                     style="font-size:52px;font-weight:900;color:#f59e0b;line-height:1;">
                                    0
                                </div>
                                <div style="font-size:12px;color:#94a3b8;margin-top:6px;">points</div>

                                <div class="mt-4 d-flex justify-content-center gap-3">
                                    <div style="background:#f0fdf4;border:2px solid #10b981;border-radius:12px;padding:12px 20px;min-width:120px;">
                                        <div style="font-size:10px;color:#065f46;font-weight:700;margin-bottom:4px;">TOTAL EARNED</div>
                                        <div id="totalEarnedDisplay" style="font-size:18px;font-weight:800;color:#10b981;">—</div>
                                    </div>
                                    <div style="background:#fef2f2;border:2px solid #ef4444;border-radius:12px;padding:12px 20px;min-width:120px;">
                                        <div style="font-size:10px;color:#991b1b;font-weight:700;margin-bottom:4px;">TOTAL EARNED (HIST.)</div>
                                        <div id="totalEarnedHistDisplay" style="font-size:18px;font-weight:800;color:#ef4444;">—</div>
                                    </div>
                                </div>

                                <p class="text-muted small mt-4 mb-0">
                                    Use the <strong>Add</strong> or <strong>Deduct</strong> tabs to adjust this balance.
                                </p>
                            </div>
                        </div>

                        {{-- Tab 2: Add Points --}}
                        <div class="tab-pane fade" id="tab-add" role="tabpanel">
                            <form id="addPointsForm" method="POST">
                                @csrf
                                <input type="hidden" name="action" value="add">
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-muted mb-2">
                                        Points to Add <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" name="points" id="addPointsInput"
                                           class="form-control form-control-deluxe" min="1" step="1" required
                                           placeholder="e.g. 500">
                                    <div class="mt-2 text-muted small" id="addPreview"></div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-muted mb-2">
                                        Reason <span class="text-danger">*</span>
                                    </label>
                                    <textarea name="reason" class="form-control form-control-deluxe" required
                                              rows="3" placeholder="e.g. Bonus, Compensation, Reward..."
                                              style="resize:none;"></textarea>
                                    <div class="mt-2 d-flex align-items-center gap-2"
                                         style="background:#fffbeb;border:1px solid #fde68a;border-radius:10px;padding:8px 12px;">
                                        <i class="las la-info-circle text-warning fs-16"></i>
                                        <span style="font-size:12px;font-weight:600;color:#92400e;direction:rtl;">
                                            رجاء كتابة السبب بالتفصيل
                                        </span>
                                    </div>
                                </div>
                                <button type="submit"
                                        class="btn btn-success rounded-pill px-5 fw-bold shadow-sm w-100"
                                        style="height:46px;">
                                    <i class="las la-plus-circle me-2"></i> Add Points
                                </button>
                            </form>
                        </div>

                        {{-- Tab 3: Deduct Points --}}
                        <div class="tab-pane fade" id="tab-deduct" role="tabpanel">
                            <form id="deductPointsForm" method="POST">
                                @csrf
                                <input type="hidden" name="action" value="deduct">
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-muted mb-2">
                                        Points to Deduct <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" name="points" id="deductPointsInput"
                                           class="form-control form-control-deluxe" min="1" step="1" required
                                           placeholder="e.g. 200">
                                    <div class="mt-2 text-muted small" id="deductPreview"></div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-muted mb-2">
                                        Reason <span class="text-danger">*</span>
                                    </label>
                                    <textarea name="reason" class="form-control form-control-deluxe" required
                                              rows="3" placeholder="e.g. Correction, Penalty..."
                                              style="resize:none;"></textarea>
                                    <div class="mt-2 d-flex align-items-center gap-2"
                                         style="background:#fffbeb;border:1px solid #fde68a;border-radius:10px;padding:8px 12px;">
                                        <i class="las la-info-circle text-warning fs-16"></i>
                                        <span style="font-size:12px;font-weight:600;color:#92400e;direction:rtl;">
                                            رجاء كتابة السبب بالتفصيل
                                        </span>
                                    </div>
                                </div>
                                <button type="submit"
                                        class="btn btn-danger rounded-pill px-5 fw-bold shadow-sm w-100"
                                        style="height:46px;">
                                    <i class="las la-minus-circle me-2"></i> Deduct Points
                                </button>
                            </form>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>

    @include('pages.models.confirm-delete')

@endsection

@section('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete();
        });
    </script>
    <script>
        $(document).on('click', '.edit-points-btn', function () {
            let userId        = $(this).data('userid');
            let userName      = $(this).data('username');
            let points        = Math.round($(this).data('points'));
            let earnedPoints  = Math.round($(this).data('earned') || 0);

            $('#pointsModalUserName').text(userName);
            $('#balanceDisplay').text(points.toLocaleString());
            $('#totalEarnedDisplay').text(points.toLocaleString());
            $('#totalEarnedHistDisplay').text(earnedPoints.toLocaleString());

            // Reset inputs & go to first tab
            $('#addPointsInput, #deductPointsInput').val('');
            $('#addPreview, #deductPreview').text('');
            $('#tab-balance-btn').tab('show');

            let updateUrl = "{{ route('residency-users.update-points', ':id') }}";
            updateUrl = updateUrl.replace(':id', userId);
            $('#addPointsForm, #deductPointsForm').attr('action', updateUrl);

            // Live preview for add
            $('#addPointsInput').off('input').on('input', function () {
                let v = parseInt($(this).val()) || 0;
                if (v > 0) {
                    $('#addPreview').html(
                        '<span class="text-success fw-bold">' + points.toLocaleString() +
                        ' + ' + v.toLocaleString() +
                        ' = ' + (points + v).toLocaleString() + ' pts</span>'
                    );
                } else {
                    $('#addPreview').text('');
                }
            });

            // Live preview for deduct
            $('#deductPointsInput').off('input').on('input', function () {
                let v = parseInt($(this).val()) || 0;
                if (v > 0) {
                    let result = Math.max(0, points - v);
                    $('#deductPreview').html(
                        '<span class="text-danger fw-bold">' + points.toLocaleString() +
                        ' − ' + v.toLocaleString() +
                        ' = ' + result.toLocaleString() + ' pts</span>'
                    );
                } else {
                    $('#deductPreview').text('');
                }
            });
        });

        $(document).on('click', '.edit-pkg-btn', function () {
            let userId = $(this).data('userid');
            let userName = $(this).data('username');
            let currentPkgId = $(this).data('pkgid');

            $('#modalUserName').text(userName);

            $('#modalPackageSelect').val(currentPkgId);

            let updateUrl = "{{ route('residency-users.change-package', ':id') }}";
            updateUrl = updateUrl.replace(':id', userId);
            $('#changePackageForm').attr('action', updateUrl);
        });

        $(document).ready(function () {

            function fetchFilteredData() {
                let search = $('#search').val();
                let package_id = $('#package-filter').val();

                $.ajax({
                    url: "{{ route('residency-users.index') }}",
                    data: {
                        search: search,
                        package_id: package_id
                    },
                    success: function (data) {
                        $('#residency-table').html(data);
                        if (typeof confirmDelete === 'function') confirmDelete();
                    }
                });
            }

            $('#search').on('keyup', function () {
                fetchFilteredData();
            });

            $('#package-filter').on('change', function () {
                fetchFilteredData();
            });

            window.toggle = function (source) {
                document.querySelectorAll('input[name="ids[]"]').forEach(cb => cb.checked = source.checked);
            }
        });

    </script>

@endsection
