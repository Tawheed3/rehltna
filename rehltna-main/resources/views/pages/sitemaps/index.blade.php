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

        .sitemap-badge {
            background: #f1f5f9;
            color: #1e293b;
            padding: 6px 14px;
            border-radius: 10px;
            font-weight: 700;
            border: 1px solid #e2e8f0;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                SEO SiteMaps
            </h4>
            <p class="text-muted mb-0 small fw-medium">SEO / <span class="text-primary">Indexing Management</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Search Engine Connectivity</h3>
            <p class="mb-0 opacity-75 fw-medium">Manage your website's structure files to improve crawling and search
                visibility.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a class="modal-effect btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #4f46e5; height: 48px;"
               data-bs-effect="effect-scale" data-bs-toggle="modal"
               href="#SiteMapCreate">
                <i class="fas fa-plus-circle me-2"></i> Add SiteMap
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
                                <th>SiteMap Name</th>
                                <th class="text-center px-4">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($sitemaps as $sitemap)
                                <tr>
                                    <td class="text-center fw-bold text-muted">#{{ $loop->iteration }}</td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <i class="las la-sitemap me-2 text-primary fs-4"></i>
                                            <span class="sitemap-badge">{{ $sitemap->name }}</span>
                                        </div>
                                    </td>
                                    <td class="text-center px-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a class="btn-action btn-edit-action edit-btn"
                                               data-bs-effect="effect-scale"
                                               data-name="{{ $sitemap->name }}"
                                               data-route="{{ route('sitemaps.update',$sitemap->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#editModel"
                                               title="Edit SiteMap">
                                                <i class="las la-pen fs-18"></i>
                                            </a>

                                            <a class="btn-action btn-delete-action delete-btn"
                                               data-bs-effect="effect-scale"
                                               data-route="{{ route('sitemaps.destroy',$sitemap->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"
                                               title="Remove SiteMap">
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
                <div class="card-footer bg-transparent border-0 p-4">
                    <p class="text-muted small mb-0 fw-bold">Total Index Files: {{ $sitemaps->count() }}</p>
                </div>
            </div>

            @include('pages.models.confirm-delete')
            @include('pages.sitemaps.models.create')
            @include('pages.sitemaps.models.edit')

        </div>
    </div>
@endsection

@section('scripts')
    <script>

        function attachEditBtns() {
            const editBtns = document.querySelectorAll(".edit-btn");
            editBtns.forEach(btn => {
                btn.addEventListener("click", () => {
                    document.getElementById("edit-name").value = btn.dataset.name;
                    document.getElementById("editForm").action = btn.dataset.route;
                });
            });
        }

        document.addEventListener('DOMContentLoaded', function () {
            attachEditBtns()
            confirmDelete()
        });
    </script>
@endsection
