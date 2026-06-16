@extends('layouts.app')

@section('styles')
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
    <style>
        /* Wizard & Layout Styles */
        .wizard-steps {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            position: relative;
        }

        .wizard-steps::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: #e9ecef;
            transform: translateY(-50%);
            z-index: 0;
        }

        .step-item {
            position: relative;
            z-index: 1;
            text-align: center;
            width: 100%;
            cursor: default;
        }

        .step-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #fff;
            border: 2px solid #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            font-weight: bold;
            color: #6c757d;
            transition: all 0.3s;
        }

        .step-item.active .step-circle {
            background: #0d6efd;
            border-color: #0d6efd;
            color: #fff;
            box-shadow: 0 0 0 4px rgba(13, 110, 253, 0.2);
        }

        .step-item.completed .step-circle {
            background: #198754;
            border-color: #198754;
            color: #fff;
        }

        .step-label {
            font-size: 12px;
            font-weight: 600;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .step-item.active .step-label {
            color: #0d6efd;
        }

        .step-content {
            display: none;
            animation: fadeIn 0.4s ease-in-out;
        }

        /* FIX: Mobile Select Issue */
        .step-content.active {
            display: block;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Form Controls */
        .form-label {
            font-weight: 600;
            font-size: 0.9rem;
            color: #344767;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border: 1px solid #e0e6ed;
            border-radius: 8px;
            padding: 10px 15px;
            transition: all 0.2s;
            background-color: #fcfcfc;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
            background-color: #fff;
        }

        .form-control.is-invalid, .form-select.is-invalid {
            border-color: #dc3545;
            background-image: none;
        }

        /* Media Selector */
        .media-selector-group {
            position: relative;
            display: flex;
            align-items: center;
            border: 1px solid #e1e5ef;
            border-radius: 8px;
            background-color: #fff;
            padding: 4px;
            transition: all 0.3s;
        }

        .media-selector-group:hover {
            border-color: #0d6efd;
        }

        .media-selector-group input {
            border: none;
            box-shadow: none;
            background: transparent !important;
            padding-left: 10px;
            color: #555;
            font-weight: 500;
            width: 100%;
            cursor: pointer;
        }

        .media-selector-group .btn-choose {
            border-radius: 6px;
            padding: 8px 20px;
            font-weight: 600;
            font-size: 12px;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        .media-preview-card {
            margin-top: 10px;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 5px;
            background: #fafafa;
            display: inline-block;
            position: relative;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .media-preview-card img, .media-preview-card video {
            border-radius: 6px;
            display: block;
            max-width: 100%;
        }

        .card, .card-body {
            overflow: visible !important;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex align-items-center">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark hover-primary">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Create Blog</span>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-12">

            <div class="wizard-steps">
                <div class="step-item active" data-step="1">
                    <div class="step-circle"><i class="fas fa-info"></i></div>
                    <div class="step-label">Basic Info</div>
                </div>
                <div class="step-item" data-step="2">
                    <div class="step-circle"><i class="fas fa-align-left"></i></div>
                    <div class="step-label">Content</div>
                </div>
                <div class="step-item" data-step="3">
                    <div class="step-circle"><i class="fas fa-photo-video"></i></div>
                    <div class="step-label">Media & SEO</div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-4">
                    <form action="{{ route('blogs.store') }}" method="POST" enctype="multipart/form-data"
                          id="createForm">
                        @csrf

                        <div class="step-content active" id="step-1">
                            <h5 class="mb-4 text-primary fw-bold border-bottom pb-2">Step 1: Basic Information</h5>
                            <div class="row">
                                {{-- Dynamic Titles --}}
                                @foreach(get_active_langs() as $lang)
                                    <div class="{{ colClass() }} mb-3">
                                        <label class="form-label">Title ({{ strtoupper($lang) }}) <span
                                                class="text-danger">*</span></label>
                                        <input type="text" name="title_{{ $lang }}" class="form-control form-control-lg"
                                               required>
                                    </div>
                                @endforeach

                                {{-- Dynamic Slugs --}}
                                @foreach(get_active_langs() as $lang)
                                    <div class="{{ colClass() }} mb-3">
                                        <label class="form-label">Slug ({{ strtoupper($lang) }})</label>
                                        <input type="text" name="slug_{{ $lang }}" class="form-control bg-light"
                                               readonly>
                                    </div>
                                @endforeach

                                <div class="col-12 my-2"></div>

                                {{-- Category --}}
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Category <span class="text-danger">*</span></label>
                                    <select name="category_id" class="form-select" required>
                                        <option value="" disabled selected>-- Select Category --</option>
                                        @foreach($categories as $category)
                                            <option
                                                value="{{ $category->id }}">{{ transDB($category, 'name') }}</option>
                                        @endforeach
                                    </select>
                                </div>

                                {{-- Status --}}
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Status</label>
                                    <select name="status" class="form-select">
                                        <option value="1" selected>Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>

                                {{-- Feature --}}
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Feature</label>
                                    <select name="is_feature" class="form-select">
                                        <option value="1" selected>Feature</option>
                                        <option value="0">Not a Feature</option>
                                    </select>
                                </div>

                                {{-- Order --}}
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Order <span class="text-danger">*</span></label>
                                    <select name="order" class="form-select" required>
                                        <option value="" disabled selected>-- Select --</option>
                                        @for($i=1 ; $i <= 5 ; $i++)
                                            <option value="{{ $i }}">{{ $i }}</option>
                                        @endfor
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="step-content" id="step-2">
                            <h5 class="mb-4 text-primary fw-bold border-bottom pb-2">Step 2: Blog Content</h5>
                            <div class="row">
                                {{-- Short Description --}}
                                @foreach(get_active_langs() as $lang)
                                    <div class="{{ colClass() }} mb-3">
                                        <label class="form-label">Short Description ({{ strtoupper($lang) }})</label>
                                        <textarea name="short_description_{{ $lang }}" class="form-control"
                                                  rows="3"></textarea>
                                    </div>
                                @endforeach

                                <div class="col-12">
                                    <hr class="my-4 border-light">
                                </div>

                                {{-- Full Description --}}
                                @foreach(get_active_langs() as $lang)
                                    <div class="{{ colClass() }} mb-4">
                                        <label class="form-label">Full Description ({{ strtoupper($lang) }})</label>
                                        <textarea name="description_{{ $lang }}" id="description_{{ $lang }}"
                                                  class="form-control"></textarea>
                                    </div>
                                @endforeach
                            </div>
                        </div>

                        <div class="step-content" id="step-3">
                            <h5 class="mb-4 text-primary fw-bold border-bottom pb-2">Step 3: Media & SEO</h5>

                            <div class="row mb-4">
                                @foreach(get_active_langs() as $lang)
                                    <div class="{{ colClass() }} mb-3">
                                        <label class="form-label">Banner ({{ strtoupper($lang) }})</label>
                                        <div class="media-selector-group">
                                            <input type="text" id="banner_{{ $lang }}" name="banner_{{ $lang }}"
                                                   readonly placeholder="Select image..."
                                                   onclick="$('#btn_banner_{{ $lang }}').click()">
                                            <button type="button" id="btn_banner_{{ $lang }}"
                                                    class="btn btn-primary btn-choose open-gallery"
                                                    data-input="banner_{{ $lang }}"
                                                    data-preview="preview_banner_{{ $lang }}">
                                                Choose
                                            </button>
                                        </div>
                                        <div id="preview_banner_{{ $lang }}"></div>
                                    </div>
                                @endforeach
                            </div>

                            <div class="col-12">
                                <hr class="my-4 border-light">
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Meta Image</label>
                                <div class="media-selector-group">
                                    <input type="text" id="meta_img" name="meta_img" readonly
                                           placeholder="Select meta image..." onclick="$('#btn_meta').click()">
                                    <button type="button" id="btn_meta" class="btn btn-dark btn-choose open-gallery"
                                            data-input="meta_img"
                                            data-preview="preview_meta_img">
                                        Choose
                                    </button>
                                </div>
                                <div id="preview_meta_img"></div>
                            </div>

                            @foreach(get_active_langs() as $lang)
                                <div class="card bg-light border-0 mb-3">
                                    <div class="card-body">
                                        <h6 class="text-dark fw-bold mb-3 border-bottom pb-2">SEO
                                            ({{ strtoupper($lang) }})</h6>
                                        <div class="row">
                                            <div class="col-md-12 mb-3">
                                                <label class="form-label">Meta Title</label>
                                                <input type="text" name="meta_title_{{ $lang }}" class="form-control">
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Meta Description</label>
                                                <textarea name="meta_description_{{ $lang }}" class="form-control"
                                                          rows="3"></textarea>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Meta Keywords</label>
                                                <textarea name="meta_keywords_{{ $lang }}" class="form-control"
                                                          rows="3"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            @endforeach
                        </div>

                        <div class="d-flex justify-content-between mt-5 pt-3 border-top">
                            <button type="button" class="btn btn-secondary px-4" id="prevBtn" style="display:none;"
                                    onclick="nextPrev(-1)">
                                <i class="fas fa-arrow-left me-1"></i> Previous
                            </button>

                            <div class="ms-auto">
                                <button type="button" class="btn btn-primary px-4" id="nextBtn" onclick="nextPrev(1)">
                                    Next <i class="fas fa-arrow-right ms-1"></i>
                                </button>
                                <button type="submit" class="btn btn-success px-5" id="submitBtn" style="display:none;">
                                    <i class="fas fa-check-circle me-1"></i> Create Blog
                                </button>
                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

    @include('pages.models.gallery-modal')

@endsection

@section('scripts')
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {

            // --- Helper: Slugify ---
            function slugify(text) {
                return text.toString().toLowerCase().replace(/\s+/g, '-').replace(/[^a-zA-Z0-9\u0600-\u06FF\-]/g, '').replace(/\-\-+/g, '-').replace(/^-+/, '').replace(/-+$/, '');
            }

            // --- Init Logic ---
            const activeLangs = @json(get_active_langs());
            activeLangs.forEach(lang => {
                // Slugify Title
                const titleInput = document.querySelector(`input[name="title_${lang}"]`);
                const slugInput = document.querySelector(`input[name="slug_${lang}"]`);
                if (titleInput && slugInput) {
                    titleInput.addEventListener('input', function () {
                        slugInput.value = slugify(this.value);
                    });
                }

                // Summernote
                if ($(`#description_${lang}`).length) {
                    $(`#description_${lang}`).summernote({
                        height: 200,
                        lang: lang === 'ar' ? 'ar-AR' : 'en-US',
                        direction: lang === 'ar' ? 'rtl' : 'ltr'
                    });
                }
            });

            // --- Wizard Logic with Validation ---
            let currentTab = 0;
            const steps = document.querySelectorAll(".step-content");
            const stepIndicators = document.querySelectorAll(".step-item");

            showTab(currentTab);

            window.nextPrev = function (n) {
                if (n == 1 && !validateForm()) return false;

                currentTab = currentTab + n;
                if (currentTab >= steps.length) return false;

                showTab(currentTab);
                window.scrollTo(0, 0);
            }

            function showTab(n) {
                steps.forEach(s => s.classList.remove('active'));
                steps[n].classList.add('active');

                document.getElementById("prevBtn").style.display = (n == 0) ? "none" : "inline-block";

                if (n == (steps.length - 1)) {
                    document.getElementById("nextBtn").style.display = "none";
                    document.getElementById("submitBtn").style.display = "inline-block";
                } else {
                    document.getElementById("nextBtn").style.display = "inline-block";
                    document.getElementById("submitBtn").style.display = "none";
                }
                updateIndicators(n);
            }

            function validateForm() {
                let valid = true;
                const currentStepDiv = document.getElementsByClassName("step-content")[currentTab];
                const inputs = currentStepDiv.querySelectorAll("input[required], select[required], textarea[required]");

                for (let i = 0; i < inputs.length; i++) {
                    if (inputs[i].value.trim() === "") {
                        inputs[i].classList.add("is-invalid");
                        valid = false;
                    } else {
                        inputs[i].classList.remove("is-invalid");
                    }
                }
                return valid;
            }

            function updateIndicators(n) {
                stepIndicators.forEach((ind, idx) => {
                    ind.classList.remove('active');
                    if (idx < n) ind.classList.add('completed');
                    if (idx === n) {
                        ind.classList.remove('completed');
                        ind.classList.add('active');
                    }
                });
            }

            document.addEventListener('input', function (e) {
                if (e.target.classList.contains('is-invalid')) e.target.classList.remove('is-invalid');
            });

            // --- Gallery Modal Callback Functions ---

            let targetInputId = null;
            let targetPreviewId = null;
            let isMulti = false;

            $(document).on('click', '.open-gallery', function () {
                targetInputId = $(this).data('input');
                targetPreviewId = $(this).data('preview');
                isMulti = $(this).data('multi') || false;

                window.galleryState.inputId = targetInputId;
                window.galleryState.previewId = targetPreviewId;
                window.galleryState.isMulti = isMulti;

                $('#galleryPickerModal').modal('show');
                if (window.loadPicker) window.loadPicker('root');
            });

            // Callback for Single selection (Banner/Meta)
            window.setSingleFile = function (url, type) {
                $(`#${targetInputId}`).val(url);
                let previewHtml = (type === 'video')
                    ? `<div class="media-preview-card"><video controls width="300" height="180"><source src="${url}"></video><div class="mt-1 text-center small text-muted">Video Selected</div></div>`
                    : `<div class="media-preview-card"><img src="${url}" width="200"></div>`;
                $(`#${targetPreviewId}`).html(previewHtml);
            };

            // (Optional) Add Multi if you ever need it in Blogs
            window.addMultiFile = function (url, type) {
                // ... logic here if needed later
            };

        });
    </script>
@endsection
