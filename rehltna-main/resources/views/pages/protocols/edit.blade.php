@extends('layouts.app')

@section('styles')
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Edit Protocol</span>
            </div>
        </div>
    </div>

    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-body">
                    <form action="{{ route('protocols.update', $Protocol->id) }}" method="POST"
                          enctype="multipart/form-data">
                        @csrf
                        @method('PUT')

                        <div class="row">
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Title (English)</label>
                                    <input type="text" name="title_en" class="form-control"
                                           value="{{ old('title_en', $Protocol->title_en) }}" required>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Title (Arabic)</label>
                                    <input type="text" name="title_ar" class="form-control"
                                           value="{{ old('title_ar', $Protocol->title_ar) }}" required>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Slug (English)</label>
                                    <input type="text" name="slug_en" class="form-control"
                                           value="{{ old('slug_en', $Protocol->slug_en) }}" readonly>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Slug (Arabic)</label>
                                    <input type="text" name="slug_ar" class="form-control"
                                           value="{{ old('slug_ar', $Protocol->slug_ar) }}" readonly>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Short Description (English)</label>
                                    <textarea name="short_description_en" class="form-control"
                                              rows="3">{{ old('short_description_en', $Protocol->short_description_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Short Description (Arabic)</label>
                                    <textarea name="short_description_ar" class="form-control"
                                              rows="3">{{ old('short_description_ar', $Protocol->short_description_ar) }}</textarea>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Description (English)</label>
                                    <textarea name="description_en" id="description_en"
                                              class="form-control">{{ old('description_en', $Protocol->description_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Description (Arabic)</label>
                                    <textarea name="description_ar" id="description_ar"
                                              class="form-control">{{ old('description_ar', $Protocol->description_ar) }}</textarea>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Banner (English)</label>
                                    <input type="file" name="banner_en" class="form-control">
                                    @if($Protocol->banner_en)
                                        <img src="{{ asset($Protocol->banner_en) }}" width="100" class="mt-2">
                                    @endif
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Banner (Arabic)</label>
                                    <input type="file" name="banner_ar" class="form-control">
                                    @if($Protocol->banner_ar)
                                        <img src="{{ asset($Protocol->banner_ar) }}" width="100" class="mt-2">
                                    @endif
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title (English)</label>
                                    <input type="text" name="meta_title_en" class="form-control"
                                           value="{{ old('meta_title_en', $Protocol->meta_title_en) }}">
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title (Arabic)</label>
                                    <input type="text" name="meta_title_ar" class="form-control"
                                           value="{{ old('meta_title_ar', $Protocol->meta_title_ar) }}">
                                </div>
                            @endif

                            <div class="col-md-12 mb-3">
                                <label>Meta Image</label>
                                <input type="file" name="meta_img" class="form-control">
                                @if($Protocol->meta_img)
                                    <img src="{{ asset($Protocol->meta_img) }}" width="100" class="mt-2">
                                @endif
                            </div>

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description (English)</label>
                                    <textarea name="meta_description_en"
                                              class="form-control">{{ old('meta_description_en', $Protocol->meta_description_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description (Arabic)</label>
                                    <textarea name="meta_description_ar"
                                              class="form-control">{{ old('meta_description_ar', $Protocol->meta_description_ar) }}</textarea>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords (English)</label>
                                    <textarea name="meta_keywords_en"
                                              class="form-control">{{ old('meta_keywords_en', $Protocol->meta_keywords_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords (Arabic)</label>
                                    <textarea name="meta_keywords_ar"
                                              class="form-control">{{ old('meta_keywords_ar', $Protocol->meta_keywords_ar) }}</textarea>
                                </div>
                            @endif

                            <div class="col-md-3 mb-3">
                                <label>Link</label>
                                <input type="text" name="link" class="form-control" placeholder="https://example.com"
                                       value="{{ old('link', $Protocol->link) }}">
                            </div>

                            <div class="col-md-3 mb-3">
                                <label>Status</label>
                                <select name="status" class="form-control">
                                    <option value="1" {{ $Protocol->status == 1 ? 'selected' : '' }}>Active</option>
                                    <option value="0" {{ $Protocol->status == 0 ? 'selected' : '' }}>Inactive</option>
                                </select>
                            </div>

                            <div class="col-md-3 mb-3">
                                <label>Feature</label>
                                <select name="is_feature" class="form-control">
                                    <option value="1" {{ $Protocol->is_feature == 1 ? 'selected' : '' }}>Feature
                                    </option>
                                    <option value="0" {{ $Protocol->is_feature == 0 ? 'selected' : '' }}>Not a Feature
                                    </option>
                                </select>
                            </div>

                            <!-- Order -->
                            <div class="col-md-3 mb-3">
                                <label>Order</label>
                                <select name="order" class="form-control" required>
                                    <option value="">-- Select Order --</option>
                                    @for($i=1 ; $i <= 5 ; $i++)
                                        <option
                                            value="{{ $i }}" {{ $Protocol->order == $i ? 'selected' : '' }}>{{ $i }}</option>
                                    @endfor
                                </select>
                            </div>

                        </div>

                        <button type="submit" class="btn btn-primary mt-3">Update Protocol</button>
                        <a href="{{ route('protocols.index') }}" class="btn btn-secondary mt-3">Cancel</a>
                    </form>
                </div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')
    <script>
        function slugify(text) {
            return text.toString().toLowerCase()
                .replace(/\s+/g, '-')
                .replace(/[^a-zA-Z0-9\u0600-\u06FF\-]/g, '')
                .replace(/\-\-+/g, '-')
                .replace(/^-+/, '')
                .replace(/-+$/, '');
        }

        document.addEventListener('DOMContentLoaded', function () {
            const titleAr = document.querySelector('input[name="title_ar"]');
            const titleEn = document.querySelector('input[name="title_en"]');
            const slugAr = document.querySelector('input[name="slug_ar"]');
            const slugEn = document.querySelector('input[name="slug_en"]');

            if (titleAr && slugAr) {
                titleAr.addEventListener('input', function () {
                    slugAr.value = slugify(this.value);
                });
            }

            if (titleEn && slugEn) {
                titleEn.addEventListener('input', function () {
                    slugEn.value = slugify(this.value);
                });
            }
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#description_ar').summernote({
                height: 200,
                lang: 'ar-AR',
                direction: 'rtl'
            });

            $('#description_en').summernote({
                height: 200,
                direction: 'ltr'
            });
        });
    </script>
@endsection
