@extends('layouts.app')

@section('styles')

@endsection

@section('content')

    <!-- breadcrumb -->
    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Create Career Type</span>
            </div>
        </div>
    </div>
    <!-- breadcrumb -->

    <!-- row -->
    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-header pb-0">
                    <div class="card-body">

                        <form action="{{ route('career-types.store') }}" method="POST" enctype="multipart/form-data">
                            @csrf

                            <div class="row">
                                {{-- Titles --}}
                                @if(hasEnglish())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Title (English)</label>
                                        <input type="text" name="title_en" class="form-control" required>
                                    </div>
                                @endif
                                @if(hasArabic())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Title (Arabic)</label>
                                        <input type="text" name="title_ar" class="form-control" required>
                                    </div>
                                @endif

                                {{-- Banners --}}
                                @if(hasEnglish())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Banner (English)</label>
                                        <input type="file" name="banner_en" class="form-control">
                                    </div>
                                @endif
                                @if(hasArabic())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Banner (Arabic)</label>
                                        <input type="file" name="banner_ar" class="form-control">
                                    </div>
                                @endif

                                {{-- Meta Titles --}}
                                @if(hasEnglish())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Meta Title (English)</label>
                                        <input type="text" name="meta_title_en" class="form-control">
                                    </div>
                                @endif
                                @if(hasArabic())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Meta Title (Arabic)</label>
                                        <input type="text" name="meta_title_ar" class="form-control">
                                    </div>
                                @endif

                                <!-- Meta Image -->
                                <div class="col-md-12 mb-3">
                                    <label>Meta Image</label>
                                    <input type="file" name="meta_img" class="form-control">
                                </div>

                                {{-- Meta Descriptions --}}
                                @if(hasEnglish())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Meta Description (English)</label>
                                        <textarea name="meta_description_en" class="form-control"></textarea>
                                    </div>
                                @endif
                                @if(hasArabic())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Meta Description (Arabic)</label>
                                        <textarea name="meta_description_ar" class="form-control"></textarea>
                                    </div>
                                @endif

                                {{-- Meta Keywords --}}
                                @if(hasEnglish())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Meta Keywords (English)</label>
                                        <textarea name="meta_keywords_en" class="form-control"></textarea>
                                    </div>
                                @endif
                                @if(hasArabic())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Meta Keywords (Arabic)</label>
                                        <textarea name="meta_keywords_ar" class="form-control"></textarea>
                                    </div>
                                @endif

                            </div>

                            <button class="btn btn-primary mt-3" type="submit">Create Type</button>
                        </form>
                    </div>
                </div>
            </div>
            <!--/div-->
        </div>
    </div>
    <!-- row closed -->

@endsection

@section('scripts')

@endsection


