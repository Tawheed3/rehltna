@extends('layouts.app')

@section('styles')
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
    <style>
        /* Form Layout Styles */
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

        .media-preview-card img {
            border-radius: 6px;
            display: block;
            max-width: 100%;
            object-fit: cover;
        }

        /* FIX: Mobile Select Issue */
        .card-body {
            overflow: visible !important;
        }

        .card {
            overflow: visible !important;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <h4 class="content-title mb-0 my-auto text-dark">Create Testimonial</h4>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-12">
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-4">
                    <form action="{{ route('testimonials.store') }}" method="POST" enctype="multipart/form-data">
                        @csrf

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Client Name <span class="text-danger">*</span></label>
                                <input type="text" name="name" class="form-control" placeholder="e.g. John Doe"
                                       required>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email Address</label>
                                <input type="email" name="email" class="form-control" placeholder="john@example.com">
                            </div>

                            <div class="col-md-12 mb-4">
                                <label class="form-label">Testimonial Text <span class="text-danger">*</span></label>
                                <textarea name="testimonial" id="testimonial" class="form-control" rows="5"></textarea>
                            </div>

                            <div class="col-12">
                                <hr class="my-4 border-light">
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Client Photo</label>
                                <div class="media-selector-group">
                                    <input type="text" id="image" name="image" readonly
                                           placeholder="Select from gallery..." onclick="$('#btn_image').click()">
                                    <button type="button" id="btn_image" class="btn btn-primary btn-choose open-gallery"
                                            data-input="image"
                                            data-preview="preview_image">
                                        Choose Photo
                                    </button>
                                </div>
                                <div id="preview_image"></div>
                            </div>

                            <div class="col-md-3 mb-3">
                                <label class="form-label">Status</label>
                                <select name="status" class="form-select">
                                    <option value="1" selected>Active (Visible)</option>
                                    <option value="0">Inactive (Hidden)</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="form-label">Rating (Stars) <span class="text-danger">*</span></label>
                                <select name="stars" class="form-select" required>
                                    <option value="5" selected>⭐⭐⭐⭐⭐ - 5 Stars</option>
                                    <option value="4">⭐⭐⭐⭐ - 4 Stars</option>
                                    <option value="3">⭐⭐⭐ - 3 Stars</option>
                                    <option value="2">⭐⭐ - 2 Stars</option>
                                    <option value="1">⭐ - 1 Star</option>
                                </select>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top text-end">
                            <button class="btn btn-success px-5" type="submit">
                                <i class="fas fa-check-circle me-1"></i> Create Testimonial
                            </button>
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
        $(document).ready(function () {
            // Summernote Init
            if ($('#testimonial').length) {
                $('#testimonial').summernote({
                    height: 150,
                    toolbar: [
                        ['style', ['bold', 'italic', 'underline', 'clear']],
                        ['para', ['ul', 'ol', 'paragraph']],
                        ['insert', ['link']],
                        ['view', ['fullscreen', 'codeview']]
                    ]
                });
            }

            // Gallery Logic Callbacks
            window.setSingleFile = function (url, type) {
                let targetInputId = window.galleryState.inputId;
                let targetPreviewId = window.galleryState.previewId;

                $(`#${targetInputId}`).val(url);
                let previewHtml = `<div class="media-preview-card"><img src="${url}" width="120" height="120" style="object-fit:cover;"></div>`;
                $(`#${targetPreviewId}`).html(previewHtml);
            };
        });
    </script>
@endsection
