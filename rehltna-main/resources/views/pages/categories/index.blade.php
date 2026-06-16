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

        /* Badge for Counts */
        .count-badge {
            background: #eef2ff;
            color: #4f46e5;
            padding: 6px 14px;
            border-radius: 12px;
            font-weight: 800;
            font-size: 0.85rem;
            border: 1px solid #e0e7ff;
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
            background: #f5f3ff;
        }

        .btn-delete-cat:hover {
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
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Categories Hub
            </h4>
            <p class="text-muted mb-0 small fw-medium">Content / <span class="text-primary">Blog Classifications</span>
            </p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Structure Your Content</h3>
            <p class="mb-0 opacity-75 fw-medium">Organize your blog articles into meaningful categories for better
                SEO.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a class="modal-effect btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #4f46e5; height: 48px;"
               data-bs-effect="effect-scale" data-bs-toggle="modal"
               href="#CategoryCreate">
                <i class="fas fa-plus-circle me-2"></i> Create New Category
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
                                    <th>Name <span class="lang-tag">{{ strtoupper($lang) }}</span></th>
                                @endforeach
                                <th class="text-center">Associated Blogs</th>
                                <th class="text-center px-4">Options</th>
                            </tr>
                            </thead>
                            <tbody>
                            @foreach($categories as $category)
                                <tr>
                                    <td class="text-center fw-bold text-muted">#{{ $loop->iteration }}</td>

                                    @foreach(get_active_langs() as $lang)
                                        <td>
                                            <div class="fw-bold text-dark" style="font-size: 1rem;">
                                                {{ $category->{'name_'.$lang} }}
                                            </div>
                                        </td>
                                    @endforeach

                                    <td class="text-center">
                                            <span class="count-badge">
                                                <i class="fas fa-file-alt me-1 opacity-50"></i> {{ $category->blogs_count }} Articles
                                            </span>
                                    </td>

                                    <td class="text-center px-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a class="btn-action btn-edit-cat edit-btn"
                                               @foreach(get_active_langs() as $lang)
                                                   data-name_{{ $lang }}="{{ $category->{'name_'.$lang} }}"
                                               @endforeach
                                               data-route="{{ route('categories.update',$category->id) }}"
                                               data-bs-effect="effect-scale"
                                               data-bs-toggle="modal" href="#" data-bs-target="#editModel"
                                               title="Edit Category">
                                                <i class="las la-pen fs-18"></i>
                                            </a>
                                            <a class="btn-action btn-delete-cat delete-btn"
                                               data-route="{{ route('categories.destroy',$category->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"
                                               title="Delete Category">
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
                        <p class="text-muted small mb-0 fw-bold">Records: {{ $categories->firstItem() }}
                            - {{ $categories->lastItem() }} / Total: {{ $categories->total() }}</p>
                        {{ $categories->links() }}
                    </div>
                </div>
            </div>

            @include('pages.models.confirm-delete')
            @include('pages.categories.models.create')
            @include('pages.categories.models.edit')

        </div>
    </div>
@endsection

@section('scripts')
    <script>

        function attachEditBtns() {
            const editBtns = document.querySelectorAll(".edit-btn");
            const activeLangs = @json(get_active_langs());

            editBtns.forEach(btn => {
                btn.addEventListener("click", () => {
                    activeLangs.forEach(lang => {
                        const inputId = `edit-name_${lang}`;
                        const input = document.getElementById(inputId);
                        const val = btn.getAttribute(`data-name_${lang}`);
                        if (input) {
                            input.value = val ? val : '';
                        }
                    });
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
