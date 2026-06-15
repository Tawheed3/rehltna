@extends('layouts.app')

@section('styles')
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Edit News</span>
            </div>
        </div>
    </div>

    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-body">
                    <form action="{{ route('news.update', $new->id) }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        @method('PUT')

                        <div class="row">
                            {{-- Dynamic Titles & Slugs --}}
                            @foreach(get_active_langs() as $lang)
                                <div class="{{ colClass() }} mb-3">
                                    <label>Title ({{ strtoupper($lang) }})</label>
                                    <input type="text" name="title_{{ $lang }}" class="form-control"
                                           value="{{ old('title_'.$lang, $new->{'title_'.$lang}) }}" required>
                                </div>
                                <div class="{{ colClass() }} mb-3">
                                    <label>Slug ({{ strtoupper($lang) }})</label>
                                    <input type="text" name="slug_{{ $lang }}" class="form-control"
                                           value="{{ old('slug_'.$lang, $new->{'slug_'.$lang}) }}" readonly>
                                </div>
                            @endforeach

                            <hr>

                            {{-- Dynamic Short Descriptions --}}
                            @foreach(get_active_langs() as $lang)
                                <div class="{{ colClass() }} mb-3">
                                    <label>Short Description ({{ strtoupper($lang) }})</label>
                                    <textarea name="short_description_{{ $lang }}" class="form-control"
                                              rows="3">{{ old('short_description_'.$lang, $new->{'short_description_'.$lang}) }}</textarea>
                                </div>
                            @endforeach

                            {{-- Dynamic Descriptions --}}
                            @foreach(get_active_langs() as $lang)
                                <div class="{{ colClass() }} mb-3">
                                    <label>Description ({{ strtoupper($lang) }})</label>
                                    <textarea name="description_{{ $lang }}" id="description_{{ $lang }}"
                                              class="form-control">{{ old('description_'.$lang, $new->{'description_'.$lang}) }}</textarea>
                                </div>
                            @endforeach

                            <hr>

                            {{-- Dynamic Banners --}}
                            @foreach(get_active_langs() as $lang)
                                <div class="{{ colClass() }} mb-3">
                                    <label>Banner ({{ strtoupper($lang) }})</label>
                                    <input type="file" name="banner_{{ $lang }}" class="form-control">
                                    @if($new->{'banner_'.$lang})
                                        <img src="{{ asset($new->{'banner_'.$lang}) }}" width="100" class="mt-2 rounded">
                                    @endif
                                </div>
                            @endforeach

                            <hr>

                            {{-- Shared Meta Image --}}
                            <div class="col-md-12 mb-3">
                                <label>Meta Image</label>
                                <input type="file" name="meta_img" class="form-control">
                                @if($new->meta_img)
                                    <img src="{{ asset($new->meta_img) }}" width="100" class="mt-2 rounded">
                                @endif
                            </div>

                            {{-- Dynamic SEO Fields --}}
                            @foreach(get_active_langs() as $lang)
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title ({{ strtoupper($lang) }})</label>
                                    <input type="text" name="meta_title_{{ $lang }}" class="form-control"
                                           value="{{ old('meta_title_'.$lang, $new->{'meta_title_'.$lang}) }}">
                                </div>
                            @endforeach

                            @foreach(get_active_langs() as $lang)
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description ({{ strtoupper($lang) }})</label>
                                    <textarea name="meta_description_{{ $lang }}"
                                              class="form-control">{{ old('meta_description_'.$lang, $new->{'meta_description_'.$lang}) }}</textarea>
                                </div>
                            @endforeach

                            @foreach(get_active_langs() as $lang)
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords ({{ strtoupper($lang) }})</label>
                                    <textarea name="meta_keywords_{{ $lang }}"
                                              class="form-control">{{ old('meta_keywords_'.$lang, $new->{'meta_keywords_'.$lang}) }}</textarea>
                                </div>
                            @endforeach

                            <hr>

                            {{-- Shared Settings --}}
                            <div class="col-md-4 mb-3">
                                <label>Link</label>
                                <input type="text" name="link" class="form-control" placeholder="https://example.com"
                                       value="{{ old('link', $new->link) }}">
                            </div>

                            <div class="col-md-2 mb-3">
                                <label>Status</label>
                                <select name="status" class="form-control">
                                    <option value="1" {{ $new->status == 1 ? 'selected' : '' }}>Active</option>
                                    <option value="0" {{ $new->status == 0 ? 'selected' : '' }}>Inactive</option>
                                </select>
                            </div>

                            <div class="col-md-2 mb-3">
                                <label>Feature</label>
                                <select name="is_feature" class="form-control">
                                    <option value="1" {{ $new->is_feature == 1 ? 'selected' : '' }}>Feature</option>
                                    <option value="0" {{ $new->is_feature == 0 ? 'selected' : '' }}>Not a Feature</option>
                                </select>
                            </div>

                            <div class="col-md-2 mb-3">
                                <label>Type</label>
                                <select name="type" class="form-control">
                                    <option value="locales" {{ $new->type == 'locales' ? 'selected' : '' }}>Locales</option>
                                    <option value="international" {{ $new->type == 'international' ? 'selected' : '' }}>International</option>
                                </select>
                            </div>

                            <div class="col-md-2 mb-3">
                                <label>Order</label>
                                <select name="order" class="form-control" required>
                                    <option value="">-- Select Order --</option>
                                    @for($i=1 ; $i <= 5 ; $i++)
                                        <option value="{{ $i }}" {{ $new->order == $i ? 'selected' : '' }}>{{ $i }}</option>
                                    @endfor
                                </select>
                            </div>

                        </div>

                        <button type="submit" class="btn btn-primary mt-3">Update News</button>
                        <a href="{{ route('news.index') }}" class="btn btn-secondary mt-3">Cancel</a>
                    </form>
                </div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
    <script>
        // Slugify Helper Function
        function slugify(text) {
            return text.toString().toLowerCase()
                .replace(/\s+/g, '-')
                .replace(/[^a-zA-Z0-9\u0600-\u06FF\-]/g, '')
                .replace(/\-\-+/g, '-')
                .replace(/^-+/, '')
                .replace(/-+$/, '');
        }

        document.addEventListener('DOMContentLoaded', function () {
            // Get active languages from PHP
            const activeLangs = @json(get_active_langs());

            activeLangs.forEach(lang => {
                // 1. Dynamic Slug Generation
                const titleInput = document.querySelector(`input[name="title_${lang}"]`);
                const slugInput = document.querySelector(`input[name="slug_${lang}"]`);

                if (titleInput && slugInput) {
                    titleInput.addEventListener('input', function () {
                        slugInput.value = slugify(this.value);
                    });
                }

                // 2. Dynamic Summernote Initialization
                if ($(`#description_${lang}`).length) {
                    $(`#description_${lang}`).summernote({
                        height: 200,
                        lang: lang === 'ar' ? 'ar-AR' : 'en-US',
                        direction: lang === 'ar' ? 'rtl' : 'ltr'
                    });
                }
            });
        });
    </script>
@endsection
