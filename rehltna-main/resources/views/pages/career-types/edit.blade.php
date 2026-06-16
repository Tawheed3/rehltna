@extends('layouts.app')

@section('styles')

@endsection

@section('content')

    <!-- Breadcrumb -->
    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Edit Career Type</span>
            </div>
        </div>
    </div>

    <!-- Form -->
    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-body">

                    <form action="{{ route('career-types.update', $careerType->id) }}" method="POST"
                          enctype="multipart/form-data">
                        @csrf
                        @method('PUT')

                        <div class="row">
                            <!-- Title -->
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Title (English)</label>
                                    <input type="text" name="title_en" class="form-control"
                                           value="{{ old('title_en', $careerType->title_en) }}" required>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Title (Arabic)</label>
                                    <input type="text" name="title_ar" class="form-control"
                                           value="{{ old('title_ar', $careerType->title_ar) }}" required>
                                </div>
                            @endif

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Banner (English)</label>
                                    <input type="file" name="banner_en" class="form-control">
                                    @if($careerType->banner_en)
                                        <img src="{{ asset($careerType->banner_en) }}" width="100" class="mt-2">
                                    @endif
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Banner (Arabic)</label>
                                    <input type="file" name="banner_ar" class="form-control">
                                    @if($careerType->banner_ar)
                                        <img src="{{ asset($careerType->banner_ar) }}" width="100" class="mt-2">
                                    @endif
                                </div>
                            @endif

                            <!-- Meta Info -->
                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title (English)</label>
                                    <input type="text" name="meta_title_en" class="form-control"
                                           value="{{ old('meta_title_en', $careerType->meta_title_en) }}">
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Title (Arabic)</label>
                                    <input type="text" name="meta_title_ar" class="form-control"
                                           value="{{ old('meta_title_ar', $careerType->meta_title_ar) }}">
                                </div>
                            @endif

                            <!-- Meta Image -->
                            <div class="col-md-12 mb-3">
                                <label>Meta Image</label>
                                <input type="file" name="meta_img" class="form-control">
                                @if($careerType->meta_img)
                                    <img src="{{ asset($careerType->meta_img) }}" width="100" class="mt-2">
                                @endif
                            </div>

                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description (English)</label>
                                    <textarea name="meta_description_en"
                                              class="form-control">{{ old('meta_description_en', $careerType->meta_description_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Description (Arabic)</label>
                                    <textarea name="meta_description_ar"
                                              class="form-control">{{ old('meta_description_ar', $careerType->meta_description_ar) }}</textarea>
                                </div>
                            @endif


                            @if(hasEnglish())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords (English)</label>
                                    <textarea name="meta_keywords_en"
                                              class="form-control">{{ old('meta_keywords_en', $careerType->meta_keywords_en) }}</textarea>
                                </div>
                            @endif

                            @if(hasArabic())
                                <div class="{{ colClass() }} mb-3">
                                    <label>Meta Keywords (Arabic)</label>
                                    <textarea name="meta_keywords_ar"
                                              class="form-control">{{ old('meta_keywords_ar', $careerType->meta_keywords_ar) }}</textarea>
                                </div>
                            @endif

                        </div>

                        <button type="submit" class="btn btn-primary mt-3">Update Type</button>
                        <a href="{{ route('career-types.index') }}" class="btn btn-secondary mt-3">Cancel</a>

                    </form>

                </div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')

@endsection
