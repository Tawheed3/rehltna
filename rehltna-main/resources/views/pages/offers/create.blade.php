@extends('layouts.app')

@section('styles')

@endsection

@section('content')

    <!-- breadcrumb -->
    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Create Offers</span>
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

                        <form action="{{ route('offers.store') }}" method="POST" enctype="multipart/form-data">
                            @csrf

                            <div class="row">
                                <!-- Titles -->
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

                                <!-- Slugs -->
                                @if(hasEnglish())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Slug (English)</label>
                                        <input type="text" name="slug_en" class="form-control" readonly>
                                    </div>
                                @endif
                                @if(hasArabic())
                                    <div class="{{ colClass() }} mb-3">
                                        <label>Slug (Arabic)</label>
                                        <input type="text" name="slug_ar" class="form-control" readonly>
                                    </div>
                                @endif

                                <!-- Banners -->
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

                                <!-- Price -->
                                <div class="col-md-12 mb-3">
                                    <label>Price</label>
                                    <input type="number" name="price" class="form-control" required>
                                </div>

                                <!-- Meta titles -->
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

                                <!-- Meta Descriptions -->
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

                                <!-- Meta Keywords -->
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

                                <!-- Category -->
                                <div class="col-md-3 mb-3">
                                    <label>Type Offer</label>
                                    <select name="type_offer_id" class="form-control" required="">
                                        <option value="">-- Select Type Offer --</option>
                                        @foreach($typeOffers as $typeOffer)
                                            <option value="{{ $typeOffer->id }}">{{ hasEnglish() ? $typeOffer->title_en : $typeOffer->title_ar }}</option>
                                        @endforeach
                                    </select>
                                </div>

                                <!-- Status -->
                                <div class="col-md-3 mb-3">
                                    <label>Status</label>
                                    <select name="status" class="form-control">
                                        <option value="1" selected>Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>

                                {{-- Feature --}}
                                <div class="col-md-3 mb-3">
                                    <label>Feature</label>
                                    <select name="is_feature" class="form-control">
                                        <option value="1" selected>Feature</option>
                                        <option value="0">Not a Feature</option>
                                    </select>
                                </div>

                                <!-- Order -->
                                <div class="col-md-3 mb-3">
                                    <label>Order</label>
                                    <select name="order" class="form-control" required>
                                        <option selected disabled>-- Select Order --</option>
                                        @for($i=1 ; $i <= 5 ; $i++)
                                            <option value="{{ $i }}">{{ $i }}</option>
                                        @endfor
                                    </select>
                                </div>

                            </div>

                            <button class="btn btn-primary mt-3" type="submit">Create Offer</button>
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


