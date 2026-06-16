@extends('layouts.app')

@section('styles')

@endsection

@section('content')

    <!-- Breadcrumb -->
    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Edit Type Offers</span>
            </div>
        </div>
    </div>

    <!-- Form -->
    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-body">

                    <form action="{{ route('type-offers.update', $typeOffer->id) }}" method="POST"
                          enctype="multipart/form-data">
                        @csrf
                        @method('PUT')

                        <div class="row">
                            <!-- Title -->
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Title (English)</label>
                                    <input type="text" name="title_en" class="form-control"
                                           value="{{ old('title_en', $typeOffer->title_en) }}" required>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Title (Arabic)</label>
                                    <input type="text" name="title_ar" class="form-control"
                                           value="{{ old('title_ar', $typeOffer->title_ar) }}" required>
                                </div>
                            @endif

                            <!-- Short Descriptions -->
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Short Description (English)</label>
                                    <textarea name="short_description_en" class="form-control"
                                              rows="3">{{ old('short_description_en', $typeOffer->short_description_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Short Description (Arabic)</label>
                                    <textarea name="short_description_ar" class="form-control"
                                              rows="3">{{ old('short_description_ar', $typeOffer->short_description_ar) }}</textarea>
                                </div>
                            @endif

                            <!-- Meta Info -->
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title (English)</label>
                                    <input type="text" name="meta_title_en" class="form-control"
                                           value="{{ old('meta_title_en', $typeOffer->meta_title_en) }}">
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title (Arabic)</label>
                                    <input type="text" name="meta_title_ar" class="form-control"
                                           value="{{ old('meta_title_ar', $typeOffer->meta_title_ar) }}">
                                </div>
                            @endif

                            <!-- Meta Image -->
                            <div class="col-md-12 mb-3">
                                <label>Meta Image</label>
                                <input type="file" name="meta_img" class="form-control">
                                @if($typeOffer->meta_img)
                                    <img src="{{ asset($typeOffer->meta_img) }}" width="100" class="mt-2">
                                @endif
                            </div>

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description (English)</label>
                                    <textarea name="meta_description_en"
                                              class="form-control">{{ old('meta_description_en', $typeOffer->meta_description_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description (Arabic)</label>
                                    <textarea name="meta_description_ar"
                                              class="form-control">{{ old('meta_description_ar', $typeOffer->meta_description_ar) }}</textarea>
                                </div>
                            @endif


                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords (English)</label>
                                    <textarea name="meta_keywords_en"
                                              class="form-control">{{ old('meta_keywords_en', $typeOffer->meta_keywords_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords (Arabic)</label>
                                    <textarea name="meta_keywords_ar"
                                              class="form-control">{{ old('meta_keywords_ar', $typeOffer->meta_keywords_ar) }}</textarea>
                                </div>
                            @endif

                        </div>

                        <button type="submit" class="btn btn-primary mt-3">Update Type</button>
                        <a href="{{ route('type-offers.index') }}" class="btn btn-secondary mt-3">Cancel</a>

                    </form>

                </div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')

@endsection
