@extends('layouts.app')

@section('styles')

@endsection

@section('content')

    <!-- Breadcrumb -->
    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Edit Offer</span>
            </div>
        </div>
    </div>

    <!-- Form -->
    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-body">

                    <form action="{{ route('offers.update', $offer->id) }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        @method('PUT')

                        <div class="row">
                            <!-- Title -->
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Title (English)</label>
                                    <input type="text" name="title_en" class="form-control"
                                           value="{{ old('title_en', $offer->title_en) }}" required>
                                </div>
                            @endif
                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Title (Arabic)</label>
                                    <input type="text" name="title_ar" class="form-control"
                                           value="{{ old('title_ar', $offer->title_ar) }}" required>
                                </div>
                            @endif

                            <!-- Slug -->
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Slug (English)</label>
                                    <input type="text" name="slug_en" class="form-control"
                                           value="{{ old('slug_en', $offer->slug_en) }}" readonly>
                                </div>
                            @endif
                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Slug (Arabic)</label>
                                    <input type="text" name="slug_ar" class="form-control"
                                           value="{{ old('slug_ar', $offer->slug_ar) }}" readonly>
                                </div>
                            @endif

                            <!-- Banners -->
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Banner (English)</label>
                                    <input type="file" name="banner_en" class="form-control">
                                    @if($offer->banner_en)
                                        <img src="{{ asset($offer->banner_en) }}" width="100" class="mt-2">
                                    @endif
                                </div>
                            @endif
                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Banner (Arabic)</label>
                                    <input type="file" name="banner_ar" class="form-control">
                                    @if($offer->banner_ar)
                                        <img src="{{ asset($offer->banner_ar) }}" width="100" class="mt-2">
                                    @endif
                                </div>
                            @endif

                            <!-- Price -->
                            <div class="col-md-12 mb-3">
                                <label>Price</label>
                                <input type="number" name="price" value="{{ old('price' , $offer->price) }}"
                                       class="form-control" required>
                            </div>

                            <!-- Meta Info -->
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title (English)</label>
                                    <input type="text" name="meta_title_en" class="form-control"
                                           value="{{ old('meta_title_en', $offer->meta_title_en) }}">
                                </div>
                            @endif
                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title (Arabic)</label>
                                    <input type="text" name="meta_title_ar" class="form-control"
                                           value="{{ old('meta_title_ar', $offer->meta_title_ar) }}">
                                </div>
                            @endif

                            <!-- Meta Image -->
                            <div class="col-md-12 mb-3">
                                <label>Meta Image</label>
                                <input type="file" name="meta_img" class="form-control">
                                @if($offer->meta_img)
                                    <img src="{{ asset($offer->meta_img) }}" width="100" class="mt-2">
                                @endif
                            </div>

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description (English)</label>
                                    <textarea name="meta_description_en" class="form-control"
                                              rows="2">{{ old('meta_description_en', $offer->meta_description_en) }}</textarea>
                                </div>
                            @endif
                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description (Arabic)</label>
                                    <textarea name="meta_description_ar" class="form-control"
                                              rows="2">{{ old('meta_description_ar', $offer->meta_description_ar) }}</textarea>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords (English)</label>
                                    <textarea name="meta_keywords_en" class="form-control"
                                              rows="2">{{ old('meta_keywords_en', $offer->meta_keywords_en) }}</textarea>
                                </div>
                            @endif
                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords (Arabic)</label>
                                    <textarea name="meta_keywords_ar" class="form-control"
                                              rows="2">{{ old('meta_keywords_ar', $offer->meta_keywords_ar) }}</textarea>
                                </div>
                            @endif

                            <div class="col-md-3 mb-3">
                                <label>Type Offer</label>
                                <select name="type_offer_id" class="form-control" required>
                                    <option value="">-- Select Type Offer --</option>
                                    @foreach($typeOffers as $typeOffer)
                                        <option
                                            value="{{ $typeOffer->id }}" {{ $offer->type_offer_id == $typeOffer->id ? 'selected' : '' }}>
                                            {{ hasEnglish() ? $typeOffer->title_en : $typeOffer->title_ar }}
                                        </option>
                                    @endforeach
                                </select>
                            </div>

                            <!-- Status -->
                            <div class="col-md-3 mb-3">
                                <label>Status</label>
                                <select name="status" class="form-control">
                                    <option value="1" {{ $offer->status == 1 ? 'selected' : '' }}>Active</option>
                                    <option value="0" {{ $offer->status == 0 ? 'selected' : '' }}>Inactive</option>
                                </select>
                            </div>

                            <div class="col-md-3 mb-3">
                                <label>Feature</label>
                                <select name="is_feature" class="form-control">
                                    <option value="1" {{ $offer->is_feature == 1 ? 'selected' : '' }}>Feature</option>
                                    <option value="0" {{ $offer->is_feature == 0 ? 'selected' : '' }}>Not a Feature
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
                                            value="{{ $i }}" {{ $offer->order == $i ? 'selected' : '' }}>{{ $i }}</option>
                                    @endfor
                                </select>
                            </div>

                        </div>

                        <button type="submit" class="btn btn-primary mt-3">Update Offer</button>
                        <a href="{{ route('offers.index') }}" class="btn btn-secondary mt-3">Cancel</a>

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

@endsection
