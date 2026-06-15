@extends('layouts.app')

@section('styles')
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Edit Portfolio</span>
            </div>
        </div>
    </div>

    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-body">
                    <form action="{{ route('portfolios.update', $portfolio->id) }}" method="POST"
                          enctype="multipart/form-data">
                        @csrf
                        @method('PUT')

                        <div class="row">
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Name (English)</label>
                                    <input type="text" name="name_en" class="form-control"
                                           value="{{ old('name_en', $portfolio->name_en) }}" required>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Name (Arabic)</label>
                                    <input type="text" name="name_ar" class="form-control"
                                           value="{{ old('name_ar', $portfolio->name_ar) }}" required>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Slug (English)</label>
                                    <input type="text" name="slug_en" class="form-control"
                                           value="{{ old('slug_en', $portfolio->slug_en) }}" readonly>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Slug (Arabic)</label>
                                    <input type="text" name="slug_ar" class="form-control"
                                           value="{{ old('slug_ar', $portfolio->slug_ar) }}" readonly>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Short Description (English)</label>
                                    <textarea name="short_description_en" class="form-control"
                                              rows="3">{{ old('short_description_en', $portfolio->short_description_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Short Description (Arabic)</label>
                                    <textarea name="short_description_ar" class="form-control"
                                              rows="3">{{ old('short_description_ar', $portfolio->short_description_ar) }}</textarea>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Description (English)</label>
                                    <textarea name="description_en" id="description_en"
                                              class="form-control">{{ old('description_en', $portfolio->description_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Description (Arabic)</label>
                                    <textarea name="description_ar" id="description_ar"
                                              class="form-control">{{ old('description_ar', $portfolio->description_ar) }}</textarea>
                                </div>
                            @endif

                            <div class="col-md-6 mb-3">
                                <label>Image (English)</label>
                                <input type="file" name="img" class="form-control">
                                @if($portfolio->img)
                                    <img src="{{ asset($portfolio->img) }}" width="100" class="mt-2">
                                @endif
                            </div>

                            <div class="col-md-6 mb-3">
                                <label>Gallery</label>
                                <input type="file" name="gallery[]" class="form-control" multiple>
                                @if($portfolio->galleries)
                                    @foreach($portfolio->galleries as $gallery)
                                        <img src="{{ asset($gallery->image) }}" width="100" class="mt-2">
                                    @endforeach
                                @endif
                            </div>

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title (English)</label>
                                    <input type="text" name="meta_title_en" class="form-control"
                                           value="{{ old('meta_title_en', $portfolio->meta_title_en) }}">
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title (Arabic)</label>
                                    <input type="text" name="meta_title_ar" class="form-control"
                                           value="{{ old('meta_title_ar', $portfolio->meta_title_ar) }}">
                                </div>
                            @endif

                            <div class="col-md-12 mb-3">
                                <label>Meta Image</label>
                                <input type="file" name="meta_img" class="form-control">
                                @if($portfolio->meta_img)
                                    <img src="{{ asset($portfolio->meta_img) }}" width="100" class="mt-2">
                                @endif
                            </div>

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description (English)</label>
                                    <textarea name="meta_description_en"
                                              class="form-control">{{ old('meta_description_en', $portfolio->meta_description_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description (Arabic)</label>
                                    <textarea name="meta_description_ar"
                                              class="form-control">{{ old('meta_description_ar', $portfolio->meta_description_ar) }}</textarea>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords (English)</label>
                                    <textarea name="meta_keywords_en"
                                              class="form-control">{{ old('meta_keywords_en', $portfolio->meta_keywords_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords (Arabic)</label>
                                    <textarea name="meta_keywords_ar"
                                              class="form-control">{{ old('meta_keywords_ar', $portfolio->meta_keywords_ar) }}</textarea>
                                </div>
                            @endif

                            <div class="col-md-3 mb-3">
                                <label>Link</label>
                                <input type="text" name="link" class="form-control" placeholder="https://example.com"
                                       value="{{ old('link', $portfolio->link) }}">
                            </div>

                            <div class="col-md-3 mb-3">
                                <label>Category</label>
                                <select name="portfolio_category_id" class="form-control" required>
                                    <option value="">-- Select Category --</option>
                                    @foreach($categories as $category)
                                        <option
                                            value="{{ $category->id }}" {{ $portfolio->portfolio_category_id == $category->id ? 'selected' : '' }}>
                                            {{ hasEnglish() ? $category->name_en : $category->name_ar }}
                                        </option>
                                    @endforeach
                                </select>
                            </div>

                            <div class="col-md-3 mb-3">
                                <label>Status</label>
                                <select name="status" class="form-control">
                                    <option value="1" {{ $portfolio->status == 1 ? 'selected' : '' }}>Active</option>
                                    <option value="0" {{ $portfolio->status == 0 ? 'selected' : '' }}>Inactive</option>
                                </select>
                            </div>

                            <!-- Order -->
                            <div class="col-md-3 mb-3">
                                <label>Order</label>
                                <select name="order" class="form-control" required>
                                    <option value="">-- Select Order --</option>
                                    @for($i=1 ; $i <= 5 ; $i++)
                                        <option
                                            value="{{ $i }}" {{ $portfolio->order == $i ? 'selected' : '' }}>{{ $i }}</option>
                                    @endfor
                                </select>
                            </div>

                        </div>

                        <button type="submit" class="btn btn-primary mt-3">Update Portfolio</button>
                        <a href="{{ route('portfolios.index') }}" class="btn btn-secondary mt-3">Cancel</a>
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
            const nameAr = document.querySelector('input[name="name_ar"]');
            const nameEn = document.querySelector('input[name="name_en"]');
            const slugAr = document.querySelector('input[name="slug_ar"]');
            const slugEn = document.querySelector('input[name="slug_en"]');

            if (nameAr && slugAr) {
                nameAr.addEventListener('input', function () {
                    slugAr.value = slugify(this.value);
                });
            }

            if (nameEn && slugEn) {
                nameEn.addEventListener('input', function () {
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
