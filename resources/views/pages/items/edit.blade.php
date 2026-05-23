@extends('layouts.app')

@section('styles')
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/css/tom-select.bootstrap5.min.css" rel="stylesheet">
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

        .remove-btn {
            position: absolute;
            top: -8px;
            right: -8px;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #ff4d4f;
            color: white;
            border: 2px solid #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            font-size: 12px;
            z-index: 10;
        }

        .card, .card-body {
            overflow: visible !important;
        }

    </style>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-hijri-datepicker@1.0.2/dist/css/bootstrap-datetimepicker.min.css"
          rel="stylesheet"/>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex align-items-center">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark hover-primary">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Edit Trip</span>
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
                    <div class="step-label">Media</div>
                </div>
                <div class="step-item" data-step="4">
                    <div class="step-circle"><i class="fas fa-route"></i></div>
                    <div class="step-label">Journey Details</div>
                </div>
                <div class="step-item" data-step="5">
                    <div class="step-circle"><i class="fas fa-search"></i></div>
                    <div class="step-label">SEO</div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-4">
                    <form action="{{ route('items.update', $item->id) }}" method="POST" enctype="multipart/form-data"
                          id="editForm">
                        @csrf
                        @method('PUT')

                        <div class="step-content active" id="step-1">
                            <h5 class="mb-4 text-primary fw-bold border-bottom pb-2">Step 1: Basic Information</h5>
                            <div class="row">
                                @foreach(get_active_langs() as $lang)
                                    <div class="{{ colClass() }} mb-3">
                                        <label class="form-label">Title ({{ strtoupper($lang) }}) <span
                                                class="text-danger">*</span></label>
                                        <input type="text" name="title_{{ $lang }}" class="form-control form-control-lg"
                                               value="{{ old('title_'.$lang, $item->{'title_'.$lang}) }}">
                                    </div>
                                @endforeach
                                @foreach(get_active_langs() as $lang)
                                    <div class="{{ colClass() }} mb-3">
                                        <label class="form-label">Slug ({{ strtoupper($lang) }})</label>
                                        <input type="text" name="slug_{{ $lang }}" class="form-control bg-light"
                                               value="{{ old('slug_'.$lang, $item->{'slug_'.$lang}) }}" readonly>
                                    </div>
                                @endforeach
                                <div class="col-md-3 mb-3"><label class="form-label">Type <span
                                            class="text-danger">*</span></label><select name="item_type_id"
                                                                                        class="form-select"
                                                                                       >@foreach($itemTypes as $t)
                                            <option
                                                value="{{$t->id}}" {{$item->item_type_id==$t->id?'selected':''}}>{{transDB($t,'title')}}</option>
                                        @endforeach</select></div>
                                <div class="col-md-3 mb-3"><label class="form-label">Status</label><select name="status"
                                                                                                           class="form-select">
                                        <option value="1" {{$item->status==1?'selected':''}}>Active</option>
                                        <option value="0" {{$item->status==0?'selected':''}}>Inactive</option>
                                    </select></div>
                                <div class="col-md-3 mb-3"><label class="form-label">Feature</label><select
                                        name="is_feature" class="form-select">
                                        <option value="1" {{$item->is_feature==1?'selected':''}}>Feature</option>
                                        <option value="0" {{$item->is_feature==0?'selected':''}}>Not Feature</option>
                                    </select></div>
                                <div class="col-md-3 mb-3"><label class="form-label">Order</label><select name="order"
                                                                                                          class="form-select"
                                                                                                         >@for($i=1;$i<=5;$i++)
                                            <option value="{{$i}}" {{$item->order==$i?'selected':''}}>{{$i}}</option>
                                        @endfor</select></div>
                                <div class="col-md-5 mb-3">
                                    <label class="form-label fw-bold">
                                        Responsible Employees
                                    </label>
                                    @php
                                        $selectedIds = $item->responsible_user_ids ?? ($item->user_id ? [$item->user_id] : []);
                                    @endphp
                                    <div style="border:1.5px solid #e2e8f0;border-radius:12px;padding:12px 16px;background:#f8fafc;max-height:180px;overflow-y:auto;">
                                        @foreach($employees as $employee)
                                            <div class="form-check mb-2">
                                                <input class="form-check-input responsible-check"
                                                       type="checkbox"
                                                       name="responsible_user_ids[]"
                                                       value="{{ $employee->id }}"
                                                       id="emp_e_{{ $employee->id }}"
                                                       {{ in_array($employee->id, $selectedIds) ? 'checked' : '' }}>
                                                <label class="form-check-label fw-medium" for="emp_e_{{ $employee->id }}">
                                                    {{ $employee->name }}
                                                </label>
                                            </div>
                                        @endforeach
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="step-content" id="step-2">
                            <h5 class="mb-4 text-primary fw-bold border-bottom pb-2">Step 2: Course Content</h5>
                            <div class="row">
                                @foreach(get_active_langs() as $lang)
                                    <div class="{{ colClass() }} mb-3"><label class="form-label">Short Description
                                            ({{ strtoupper($lang) }})</label><textarea
                                            name="short_description_{{ $lang }}" class="form-control"
                                            rows="3">{{ old('short_description_'.$lang, $item->{'short_description_'.$lang}) }}</textarea>
                                    </div>
                                @endforeach
                                <div class="col-12">
                                    <hr class="my-4">
                                </div>
                                @foreach(get_active_langs() as $lang)
                                    <div class="{{ colClass() }} mb-4"><label class="form-label">Full Description
                                            ({{ strtoupper($lang) }})</label><textarea name="description_{{ $lang }}"
                                                                                       id="description_{{ $lang }}"
                                                                                       class="form-control">{{ old('description_'.$lang, $item->{'description_'.$lang}) }}</textarea>
                                    </div>
                                @endforeach
                            </div>
                        </div>

                        <div class="step-content" id="step-3">
                            <h5 class="mb-4 text-primary fw-bold border-bottom pb-2">Step 3: Media & Assets</h5>
                            <div class="row mb-4">
                                @foreach(get_active_langs() as $lang)
                                    <div class="{{ colClass() }} mb-3">
                                        <label class="form-label">Banner ({{ strtoupper($lang) }})</label>
                                        <div class="media-selector-group">
                                            <input type="text" id="banner_{{ $lang }}" name="banner_{{ $lang }}"
                                                   value="{{ $item->{'banner_'.$lang} ? asset($item->{'banner_'.$lang}) : '' }}"
                                                   readonly placeholder="Select..."
                                                   onclick="$('#btn_banner_{{ $lang }}').click()">
                                            <button id="btn_banner_{{ $lang }}"
                                                    class="btn btn-primary btn-choose open-gallery" type="button"
                                                    data-input="banner_{{ $lang }}"
                                                    data-preview="preview_banner_{{ $lang }}">Choose
                                            </button>
                                        </div>
                                        <div id="preview_banner_{{ $lang }}">
                                            @if($item->{'banner_'.$lang})
                                                @php $ext = pathinfo($item->{'banner_'.$lang}, PATHINFO_EXTENSION); $isVid = in_array(strtolower($ext), ['mp4', 'mov', 'avi', 'mkv']); @endphp
                                                <div class="media-preview-card">
                                                    @if($isVid)
                                                        <video controls width="300" height="180">
                                                            <source src="{{ asset($item->{'banner_'.$lang}) }}">
                                                        </video>
                                                    @else
                                                        <img src="{{ asset($item->{'banner_'.$lang}) }}" width="200">
                                                    @endif
                                                </div>
                                            @endif
                                        </div>
                                    </div>
                                @endforeach
                            </div>

                            <div class="row">
                                <div class="col-md-12 mb-4">
                                    <h6 class="text-dark fw-bold mb-3 border-bottom pb-2">Gallery</h6>
                                    <div class="bg-light p-4 rounded border border-dashed text-center">
                                        <button class="btn btn-outline-primary mb-3 open-gallery" type="button"
                                                data-input="gallery" data-preview="gallery_container" data-multi="true">
                                            <i class="fas fa-images me-1"></i> Add Images
                                        </button>
                                        <div id="gallery_container"
                                             class="d-flex flex-wrap justify-content-center gap-2">
                                            @foreach($item->galleries as $gallery)
                                                <div
                                                    class="d-inline-block position-relative shadow-sm border rounded bg-white"
                                                    style="width: 100px; height: 100px;">
                                                    <input type="hidden" name="gallery[]"
                                                           value="{{ asset($gallery->image) }}">
                                                    @if(str_contains($gallery->image, 'mp4'))
                                                        <video width="100%" height="100%" class="rounded bg-black">
                                                            <source src="{{ asset($gallery->image) }}">
                                                        </video>
                                                    @else
                                                        <img src="{{ asset($gallery->image) }}"
                                                             class="w-100 h-100 rounded" style="object-fit:cover">
                                                    @endif
                                                    <button type="button" class="remove-btn btn btn-danger btn-sm p-0"
                                                            onclick="$(this).parent().remove()">×
                                                    </button>
                                                </div>
                                            @endforeach
                                        </div>
                                    </div>
                                </div>


                            </div>
                            <div class="row">
                                <div class="col-md-12 mb-3"><label class="form-label">PDF Attachment</label><input
                                        type="file" name="pdf" class="form-control"> @if($item->pdf)
                                        <a href="{{ asset($item->pdf) }}" target="_blank"
                                           class="small mt-1 d-block text-info">View current PDF</a>
                                    @endif</div>
                            </div>
                        </div>

                        <div class="step-content" id="step-4">
                            <h5 class="mb-4 text-primary fw-bold border-bottom pb-2">Step 4: Journey Details &
                                Contact</h5>

                            {{-- Price & Map Row --}}
                            <div class="row mb-3">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6 class="fw-bold mb-0 text-dark"><i class="fas fa-tags me-2 text-success"></i>
                                        Pricing Packages</h6>
                                    <button type="button" class="btn btn-outline-success btn-sm"
                                            onclick="addPriceRow()">
                                        <i class="fas fa-plus me-1"></i> Add Price Option
                                    </button>
                                </div>

                                <div id="price-repeater">
                                    @if(isset($item) && $item->prices && $item->prices->count() > 0)
                                        {{-- لو بنعمل Edit وفيه أسعار متسجلة --}}
                                        @foreach($item->prices as $price)
                                            <div class="row price-row mb-3 align-items-end p-3 rounded"
                                                 style="background-color: #f8f9fa; border: 1px solid #dee2e6;">
                                                <div class="col-md-3 mb-2 mb-md-0">
                                                    <label class="form-label fw-bold">Title (AR) <span
                                                            class="text-danger">*</span></label>
                                                    <input type="text" name="price_title_ar[]" class="form-control"
                                                           value="{{ $price->title_ar }}">
                                                </div>
                                                <div class="col-md-3 mb-2 mb-md-0">
                                                    <label class="form-label fw-bold">Title (EN)</label>
                                                    <input type="text" name="price_title_en[]" class="form-control"
                                                           value="{{ $price->title_en }}">
                                                </div>
                                                <div class="col-md-2 mb-2 mb-md-0">
                                                    <label class="form-label fw-bold">Price (SAR) <span
                                                            class="text-danger">*</span></label>
                                                    <input type="number" name="price_value[]" class="form-control"
                                                           value="{{ $price->price }}" step="0.01" min="0">
                                                </div>
                                                <div class="col-md-3 mb-2 mb-md-0">
                                                    <label class="form-label fw-bold">Discount</label>
                                                    <div class="input-group">
                                                        <input type="number" name="price_discount[]"
                                                               class="form-control" value="{{ $price->discount }}"
                                                               step="0.01" min="0">
                                                        <select name="price_discount_type[]"
                                                                class="form-select bg-light" style="flex: 0 0 110px;">
                                                            <option
                                                                value="amount" {{ $price->discount_type == 'amount' ? 'selected' : '' }}>
                                                                مبلغ (SAR)
                                                            </option>
                                                            <option
                                                                value="percent" {{ $price->discount_type == 'percent' ? 'selected' : '' }}>
                                                                نسبة (%)
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-1 mb-2 mb-md-0 text-center">
                                                    <button type="button"
                                                            class="btn btn-danger remove-price-row shadow-sm"
                                                            style="padding: 10px 15px; border-radius: 8px;"
                                                            title="Remove">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        @endforeach
                                    @else
                                        {{-- لو بنعمل Create (القيم الافتراضية) --}}
                                        @php
                                            $defaultPrices = [
                                                ['ar' => 'سعر الشخص بالغرفة المفردة', 'en' => 'Single Room Person Price'],
                                                ['ar' => 'سعر الشخص بالغرفة المزدوجة', 'en' => 'Double Room Person Price'],
                                                ['ar' => 'سعر الشخص بالغرفة الثلاثية', 'en' => 'Triple Room Person Price']
                                            ];
                                        @endphp
                                        @foreach($defaultPrices as $dp)
                                            <div class="row price-row mb-3 align-items-end p-3 rounded"
                                                 style="background-color: #f8f9fa; border: 1px solid #dee2e6;">
                                                <div class="col-md-3 mb-2 mb-md-0">
                                                    <label class="form-label fw-bold">Title (AR) <span
                                                            class="text-danger">*</span></label>
                                                    <input type="text" name="price_title_ar[]" class="form-control"
                                                           value="{{ $dp['ar'] }}">
                                                </div>
                                                <div class="col-md-3 mb-2 mb-md-0">
                                                    <label class="form-label fw-bold">Title (EN)</label>
                                                    <input type="text" name="price_title_en[]" class="form-control"
                                                           value="{{ $dp['en'] }}">
                                                </div>
                                                <div class="col-md-2 mb-2 mb-md-0">
                                                    <label class="form-label fw-bold">Price (SAR) <span
                                                            class="text-danger">*</span></label>
                                                    <input type="number" name="price_value[]" class="form-control"
                                                           step="0.01" min="0">
                                                </div>
                                                <div class="col-md-3 mb-2 mb-md-0">
                                                    <label class="form-label fw-bold">Discount</label>
                                                    <div class="input-group">
                                                        <input type="number" name="price_discount[]"
                                                               class="form-control" value="0" step="0.01" min="0">
                                                        <select name="price_discount_type[]"
                                                                class="form-select bg-light" style="flex: 0 0 110px;">
                                                            <option value="amount">مبلغ (SAR)</option>
                                                            <option value="percent">نسبة (%)</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-1 mb-2 mb-md-0 text-center">
                                                    <button type="button"
                                                            class="btn btn-danger remove-price-row shadow-sm"
                                                            style="padding: 10px 15px; border-radius: 8px;"
                                                            title="Remove">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        @endforeach
                                    @endif
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Stock Status</label>
                                    <select name="out_of_stock" class="form-select">
                                        <option value="0" {{ $item->out_of_stock == 0 ? 'selected' : '' }}>In Stock
                                        </option>
                                        <option value="1" {{ $item->out_of_stock == 1 ? 'selected' : '' }}>Out of
                                            Stock
                                        </option>
                                    </select>
                                </div>
                                <div class="col-md-9 mb-3"></div>
                            </div>
                            {{-- Dates Row (Gregorian & Hijri) --}}
                            <div class="row mb-4 p-3 bg-light rounded-3 border">
                                <h6 class="fw-bold mb-3 text-dark"><i class="fas fa-calendar-alt me-2 text-primary"></i>
                                    Schedule & Dates</h6>

                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Start Date (Gregorian) <span class="text-danger">*</span></label>
                                    <input type="date" name="start_date" class="form-control"
                                           value="{{ $item->start_date }}">
                                </div>

                                <div class="col-md-3 mb-3">
                                    <label class="form-label">End Date (Gregorian) <span
                                            class="text-danger">*</span></label>
                                    <input type="date" name="end_date" class="form-control"
                                           value="{{ $item->end_date }}">
                                </div>

                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Start Date (Hijri)</label>
                                    <input type="text" name="start_date_hijri" class="form-control hijri-date-input"
                                           placeholder="1446-01-01" dir="ltr" value="{{ $item->start_date_hijri }}">
                                </div>

                                <div class="col-md-3 mb-0">
                                    <label class="form-label">End Date (Hijri)</label>
                                    <input type="text" name="end_date_hijri" class="form-control hijri-date-input"
                                           placeholder="1446-01-10" dir="ltr" value="{{ $item->end_date_hijri }}">
                                </div>
                            </div>

                            <div class="col-12">
                                <hr class="my-4 border-light">
                            </div>

                            <div class="row mb-4">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Season <span class="text-danger">*</span></label>
                                    <input type="text" name="season" class="form-control" placeholder="e.g. Summer 2026"
                                           value="{{ $item->season ?? old('season') }}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Earned Points <span class="text-danger">*</span></label>
                                    <input type="number" name="earned_points" class="form-control"
                                           placeholder="Points user gets"
                                           value="{{ $item->earned_points ?? old('earned_points', 0) }}">
                                </div>
                            </div>

                            <h6 class="text-dark fw-bold mb-3">Contact Information</h6>
                            <div class="row mb-4">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label"><i class="fab fa-whatsapp text-success"></i> WhatsApp
                                        Number <span class="text-danger">*</span></label>
                                    <input type="text" name="whatsapp" class="form-control"
                                           placeholder="+9665xxxxxxxx"
                                           value="{{ $item->whatsapp ?? old('whatsapp') }}">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label"><i class="fas fa-phone-alt text-primary"></i> Quick
                                        Contact <span class="text-danger">*</span></label>
                                    <input type="text" name="quick_contact" class="form-control"
                                           placeholder="e.g. 05xxxxxxxx"
                                           value="{{ $item->quick_contact ?? old('quick_contact') }}">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label"><i class="fas fa-headset text-info"></i> Contact Us
                                        URL/Number <span class="text-danger">*</span></label>
                                    <input type="text" name="contact_us" class="form-control"
                                           placeholder="Link or info"
                                           value="{{ $item->contact_us ?? old('contact_us') }}">
                                </div>
                            </div>

                            <div class="col-12">
                                <hr class="my-4 border-light">
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h6 class="text-dark fw-bold mb-0">Itinerary (Cities & Dates)</h6>
                                <button type="button" class="btn btn-outline-primary btn-sm"
                                        onclick="addItineraryRow()">
                                    <i class="fas fa-plus me-1"></i> Add City
                                </button>
                            </div>

                            <div id="itinerary-repeater">
                                @if(isset($item) && $item->itineraries->count() > 0)
                                    @foreach($item->itineraries as $index => $itin)
                                        <div class="row itinerary-row mb-4 align-items-end p-3 rounded shadow-sm"
                                             style="background-color: #f4f6f9; border: 1px solid #e1e5ef;"
                                             data-index="{{ $index }}">
                                            <div class="col-12 drag-handle text-center py-1 mb-2" style="cursor: grab; color: #999; background: #e0e4ed; border-radius: 6px; user-select: none;" title="Drag to reorder">
                                                <i class="fas fa-grip-horizontal"></i>
                                            </div>
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label text-dark fw-bold">City <span
                                                        class="text-danger">*</span></label>
                                                <select class="city-select form-select bg-white shadow-sm">
                                                    <option value="">-- Select City --</option>
                                                    @foreach($cities as $city)
                                                        <option
                                                            value="{{ $city->id }}" {{ $itin->city_id == $city->id ? 'selected' : '' }}>{{ transDB($city, 'title') }}</option>
                                                    @endforeach
                                                </select>
                                                <input type="hidden" name="itinerary_city_id[]" class="city-id-input" value="{{ $itin->city_id }}">
                                            </div>
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label text-dark fw-bold">Start Date <span
                                                        class="text-danger">*</span></label>
                                                <input type="date" name="itinerary_start[]"
                                                       class="form-control start-date bg-white shadow-sm"
                                                       onchange="calculateNights(this)" value="{{ $itin->start_date }}"
                                                      >
                                            </div>
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label text-dark fw-bold">End Date <span
                                                        class="text-danger">*</span></label>
                                                <input type="date" name="itinerary_end[]"
                                                       class="form-control end-date bg-white shadow-sm"
                                                       onchange="calculateNights(this)" value="{{ $itin->end_date }}"
                                                      >
                                            </div>
                                            <div class="col-md-2 mb-2 mb-md-0">
                                                <label class="form-label text-dark fw-bold">Nights</label>
                                                <input type="number" name="itinerary_nights[]"
                                                       class="form-control nights-input"
                                                       style="background-color: #e9ecef; cursor: not-allowed;"
                                                       value="{{ $itin->nights }}" readonly>
                                            </div>
                                            <div class="col-md-1 mb-2 mb-md-0 text-center">
                                                <button type="button" class="btn btn-danger remove-row w-100 shadow-sm"
                                                        style="height: 46px; border-radius: 8px;"><i
                                                        class="fas fa-trash-alt"></i></button>
                                            </div>


                                            <div class="col-md-12 mt-3">
                                                <div
                                                    class="p-3 bg-white rounded border border-secondary border-opacity-25">
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <label class="form-label text-secondary fw-bold mb-0"><i
                                                                class="fas fa-map-signs me-1"></i> Tourist
                                                            Attractions</label>
                                                        <button type="button"
                                                                class="btn btn-sm btn-outline-secondary py-1 px-2"
                                                                onclick="addPlaceRow(this)">
                                                            <i class="fas fa-plus"></i> Add Place
                                                        </button>
                                                    </div>
                                                    <div class="places-repeater">
                                                        @if($itin->places && $itin->places->count() > 0)
                                                            @foreach($itin->places as $place)
                                                                <div class="row place-row mb-2 mt-2 align-items-center">
                                                                    <div class="col-md-5">
                                                                        <input type="text"
                                                                               name="itinerary_places_en[{{ $index }}][]"
                                                                               class="form-control form-control-sm"
                                                                               placeholder="Place Name (EN)"
                                                                               value="{{ $place->title_en }}">
                                                                    </div>
                                                                    <div class="col-md-5">
                                                                        <input type="text"
                                                                               name="itinerary_places_ar[{{ $index }}][]"
                                                                               class="form-control form-control-sm"
                                                                               placeholder="اسم المكان (AR)"
                                                                               value="{{ $place->title_ar }}">
                                                                    </div>
                                                                    <div class="col-md-2 text-end">
                                                                        <button type="button"
                                                                                class="btn btn-sm btn-danger remove-place-row">
                                                                            <i class="fas fa-times"></i></button>
                                                                    </div>
                                                                </div>
                                                            @endforeach
                                                        @endif
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    @endforeach
                                @else
                                    <div class="row itinerary-row mb-4 align-items-end p-3 rounded shadow-sm"
                                         style="background-color: #f4f6f9; border: 1px solid #e1e5ef;" data-index="0">
                                        <div class="col-12 drag-handle text-center py-1 mb-2" style="cursor: grab; color: #999; background: #e0e4ed; border-radius: 6px; user-select: none;" title="Drag to reorder">
                                            <i class="fas fa-grip-horizontal"></i>
                                        </div>
                                        <div class="col-md-3 mb-2 mb-md-0">
                                            <label class="form-label text-dark fw-bold">City <span
                                                    class="text-danger">*</span></label>
                                            <select class="city-select form-select bg-white shadow-sm">
                                                <option value="">-- Select City --</option>
                                                @foreach($cities as $city)
                                                    <option
                                                        value="{{ $city->id }}">{{ transDB($city, 'title') }}</option>
                                                @endforeach
                                            </select>
                                            <input type="hidden" name="itinerary_city_id[]" class="city-id-input" value="">
                                        </div>
                                        <div class="col-md-3 mb-2 mb-md-0">
                                            <label class="form-label text-dark fw-bold">Start Date <span
                                                    class="text-danger">*</span></label>
                                            <input type="date" name="itinerary_start[]"
                                                   class="form-control start-date bg-white shadow-sm"
                                                   onchange="calculateNights(this)">
                                        </div>
                                        <div class="col-md-3 mb-2 mb-md-0">
                                            <label class="form-label text-dark fw-bold">End Date <span
                                                    class="text-danger">*</span></label>
                                            <input type="date" name="itinerary_end[]"
                                                   class="form-control end-date bg-white shadow-sm"
                                                   onchange="calculateNights(this)">
                                        </div>
                                        <div class="col-md-2 mb-2 mb-md-0">
                                            <label class="form-label text-dark fw-bold">Nights</label>
                                            <input type="number" name="itinerary_nights[]"
                                                   class="form-control nights-input"
                                                   style="background-color: #e9ecef; cursor: not-allowed;" readonly>
                                        </div>
                                        <div class="col-md-1 mb-2 mb-md-0 text-center">
                                            <button type="button" class="btn btn-danger remove-row w-100 shadow-sm"
                                                    style="height: 46px; border-radius: 8px;"><i
                                                    class="fas fa-trash-alt"></i></button>
                                        </div>


                                        <div class="col-md-12 mt-3">
                                            <div class="p-3 bg-white rounded border border-secondary border-opacity-25">
                                                <div class="d-flex justify-content-between align-items-center mb-3">
                                                    <label class="form-label text-secondary fw-bold mb-0"><i
                                                            class="fas fa-map-signs me-1"></i> Tourist
                                                        Attractions</label>
                                                    <button type="button"
                                                            class="btn btn-sm btn-outline-secondary py-1 px-2"
                                                            onclick="addPlaceRow(this)">
                                                        <i class="fas fa-plus"></i> Add Place
                                                    </button>
                                                </div>
                                                <div class="places-repeater"></div>
                                            </div>
                                        </div>
                                    </div>
                                @endif
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h6 class="text-dark fw-bold mb-0"><i class="fas fa-check-circle me-2 text-success"></i>
                                    What's Included (ما تشمله الرحلة)</h6>
                                <button type="button" class="btn btn-outline-success btn-sm" onclick="addRouteRow()">
                                    <i class="fas fa-plus me-1"></i> Add Included Item
                                </button>
                            </div>

                            <div id="route-repeater" class="mb-5">
                                @if(isset($item) && $item->routes && $item->routes->count() > 0)
                                    {{-- لو بنعمل Edit وفيه داتا متسجلة --}}
                                    @foreach($item->routes as $route)
                                        @php $uid = uniqid(); @endphp
                                        <div class="row route-row mb-3 align-items-center p-3 rounded"
                                             style="background-color: #f0fdf4; border: 1px dashed #bbf7d0;">
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Title (EN)</label>
                                                <input type="text" name="route_title_en[]" class="form-control"
                                                       value="{{ $route->title_en }}">
                                            </div>
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Title (AR)</label>
                                                <input type="text" name="route_title_ar[]" class="form-control"
                                                       value="{{ $route->title_ar }}">
                                            </div>
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Icon/Image</label>
                                                <div class="media-selector-group">
                                                    <input type="text" id="route_icon_{{ $uid }}" name="route_icon[]"
                                                           readonly placeholder="Icon..."
                                                           value="{{ $route->icon ? asset($route->icon) : '' }}"
                                                           onclick="$('#btn_route_{{ $uid }}').click()">
                                                    <button type="button" id="btn_route_{{ $uid }}"
                                                            class="btn btn-primary btn-choose open-gallery"
                                                            data-input="route_icon_{{ $uid }}"
                                                            data-preview="preview_route_{{ $uid }}">Choose
                                                    </button>
                                                </div>
                                                <div id="preview_route_{{ $uid }}" class="mt-1">
                                                    @if($route->icon)
                                                        <img src="{{ asset($route->icon) }}" width="40" height="40"
                                                             class="rounded">
                                                    @endif
                                                </div>
                                            </div>
                                            <div class="col-md-2 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Order (الترتيب)</label>
                                                <input type="number" name="route_order[]" class="form-control"
                                                       value="{{ $route->order ?? 0 }}">
                                            </div>
                                            <div class="col-md-1 mt-4 text-center">
                                                <button type="button"
                                                        class="btn btn-danger remove-route-row w-100 shadow-sm"
                                                        title="Remove"><i class="fas fa-times"></i></button>
                                            </div>
                                        </div>
                                    @endforeach
                                @else
                                    {{-- القيم الافتراضية لما ييجي يضيف رحلة جديدة --}}
                                    @php
                                        $defaultIncludes = [
                                            ['ar' => 'طيران دولي', 'en' => 'International Flight'],
                                            ['ar' => 'طيران دولي و طيران داخلي', 'en' => 'International and Domestic Flights'],
                                            ['ar' => 'فنادق ٤ نجوم', 'en' => '4-Star Hotels'],
                                            ['ar' => 'فنادق ٥ نجوم', 'en' => '5-Star Hotels'],
                                            ['ar' => 'فنادق ٥ و ٤ نجوم', 'en' => '5 and 4-Star Hotels'],
                                            ['ar' => 'المواصلات والتنقلات', 'en' => 'Transportation and Transfers'],
                                            ['ar' => 'الجولات السياحية', 'en' => 'Sightseeing Tours'],
                                            ['ar' => 'مشرف سياحي', 'en' => 'Tour Escort'],
                                            ['ar' => 'مرشد سياحي', 'en' => 'Tour Guide'],
                                            ['ar' => 'خطوط اتصال', 'en' => 'SIM Cards / Communication'],
                                        ];
                                    @endphp

                                    @foreach($defaultIncludes as $index => $include)
                                        @php $uid = uniqid() . $index; @endphp
                                        <div class="row route-row mb-3 align-items-center p-3 rounded"
                                             style="background-color: #f0fdf4; border: 1px dashed #bbf7d0;">
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Title (EN)</label>
                                                <input type="text" name="route_title_en[]" class="form-control"
                                                       value="{{ $include['en'] }}">
                                            </div>
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Title (AR)</label>
                                                <input type="text" name="route_title_ar[]" class="form-control"
                                                       value="{{ $include['ar'] }}">
                                            </div>
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Icon/Image</label>
                                                <div class="media-selector-group">
                                                    <input type="text" id="route_icon_{{ $uid }}" name="route_icon[]"
                                                           readonly placeholder="Icon..."
                                                           onclick="$('#btn_route_{{ $uid }}').click()">
                                                    <button type="button" id="btn_route_{{ $uid }}"
                                                            class="btn btn-primary btn-choose open-gallery"
                                                            data-input="route_icon_{{ $uid }}"
                                                            data-preview="preview_route_{{ $uid }}">Choose
                                                    </button>
                                                </div>
                                                <div id="preview_route_{{ $uid }}" class="mt-1"></div>
                                            </div>
                                            <div class="col-md-2 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Order (الترتيب)</label>
                                                <input type="number" name="route_order[]" class="form-control"
                                                       value="{{ $index + 1 }}">
                                            </div>
                                            <div class="col-md-1 mt-4 text-center">
                                                <button type="button"
                                                        class="btn btn-danger remove-route-row w-100 shadow-sm"
                                                        title="Remove"><i class="fas fa-times"></i></button>
                                            </div>
                                        </div>
                                    @endforeach
                                @endif
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h6 class="text-dark fw-bold mb-0"><i class="fas fa-times-circle me-2 text-danger"></i>
                                    What's Excluded (Optional)</h6>
                                <button type="button" class="btn btn-outline-danger btn-sm" onclick="addExcludeRow()">
                                    <i class="fas fa-plus me-1"></i> Add Excluded Item
                                </button>
                            </div>

                            <div id="exclude-repeater">
                                @if(isset($item) && $item->excludes && $item->excludes->count() > 0)
                                    @foreach($item->excludes as $exclude)
                                        @php $uid = uniqid(); @endphp
                                        <div class="row exclude-row mb-3 align-items-center p-3 rounded"
                                             style="background-color: #fef2f2; border: 1px dashed #fecaca;">
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Title (EN)</label>
                                                <input type="text" name="exclude_title_en[]" class="form-control"
                                                       value="{{ $exclude->title_en }}">
                                            </div>
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Title (AR)</label>
                                                <input type="text" name="exclude_title_ar[]" class="form-control"
                                                       value="{{ $exclude->title_ar }}">
                                            </div>
                                            <div class="col-md-3 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Icon/Image</label>
                                                <div class="media-selector-group">
                                                    <input type="text" id="exclude_icon_{{ $uid }}"
                                                           name="exclude_icon[]" readonly placeholder="Icon..."
                                                           value="{{ $exclude->icon ? asset($exclude->icon) : '' }}"
                                                           onclick="$('#btn_exclude_{{ $uid }}').click()">
                                                    <button type="button" id="btn_exclude_{{ $uid }}"
                                                            class="btn btn-primary btn-choose open-gallery"
                                                            data-input="exclude_icon_{{ $uid }}"
                                                            data-preview="preview_exclude_{{ $uid }}">Choose
                                                    </button>
                                                </div>
                                                <div id="preview_exclude_{{ $uid }}" class="mt-1">
                                                    @if($exclude->icon)
                                                        <img src="{{ asset($exclude->icon) }}" width="40" height="40"
                                                             class="rounded">
                                                    @endif
                                                </div>
                                            </div>
                                            <div class="col-md-2 mb-2 mb-md-0">
                                                <label class="form-label fw-bold">Order (الترتيب)</label>
                                                <input type="number" name="exclude_order[]" class="form-control"
                                                       value="{{ $exclude->order ?? 0 }}">
                                            </div>
                                            <div class="col-md-1 mt-4 text-center">
                                                <button type="button"
                                                        class="btn btn-danger remove-exclude-row w-100 shadow-sm"
                                                        title="Remove"><i class="fas fa-times"></i></button>
                                            </div>
                                        </div>
                                    @endforeach
                                @endif
                            </div>
                        </div>


                        <div class="step-content" id="step-5">

                            <h5 class="mb-4 text-primary fw-bold border-bottom pb-2">Step 5: SEO Configuration</h5>

                            <div class="mb-4">
                                <label class="form-label">Meta Image</label>
                                <div class="media-selector-group">
                                    <input type="text" id="meta_img" name="meta_img"
                                           value="{{ $item->meta_img ? asset($item->meta_img) : '' }}" readonly
                                           placeholder="Select meta image..." onclick="$('#btn_meta').click()">
                                    <button id="btn_meta" class="btn btn-dark btn-choose open-gallery" type="button"
                                            data-input="meta_img" data-preview="preview_meta_img">Choose
                                    </button>
                                </div>
                                <div id="preview_meta_img">
                                    @if($item->meta_img)
                                        <div class="media-preview-card"><img src="{{ asset($item->meta_img) }}"
                                                                             width="150"></div>
                                    @endif
                                </div>
                            </div>

                            @foreach(get_active_langs() as $lang)
                                <div class="card bg-light border-0 mb-3">
                                    <div class="card-body">
                                        <h6 class="text-dark fw-bold mb-3 border-bottom pb-2">SEO
                                            ({{ strtoupper($lang) }})</h6>
                                        <div class="row">
                                            <div class="col-md-12 mb-3">
                                                <label class="form-label">Meta Title</label>
                                                <input type="text" name="meta_title_{{ $lang }}" class="form-control"
                                                       value="{{ old('meta_title_'.$lang, $item->{'meta_title_'.$lang}) }}">
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Meta Description</label>
                                                <textarea name="meta_description_{{ $lang }}" class="form-control"
                                                          rows="3">{{ old('meta_description_'.$lang, $item->{'meta_description_'.$lang}) }}</textarea>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Meta Keywords</label>
                                                <textarea name="meta_keywords_{{ $lang }}" class="form-control"
                                                          rows="3">{{ old('meta_keywords_'.$lang, $item->{'meta_keywords_'.$lang}) }}</textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            @endforeach
                        </div>

                        <div class="d-flex justify-content-between mt-5 pt-3 border-top">
                            <button type="button" class="btn btn-secondary px-4" id="prevBtn" style="display:none;"
                                    onclick="nextPrev(-1)"><i class="fas fa-arrow-left me-1"></i> Previous
                            </button>
                            <div class="ms-auto">
                                <button type="button" class="btn btn-primary px-4" id="nextBtn" onclick="nextPrev(1)">
                                    Next <i class="fas fa-arrow-right ms-1"></i></button>
                                <button type="submit" class="btn btn-success px-5" id="submitBtn" style="display:none;">
                                    <i class="fas fa-save"></i> Update Trip
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment-with-locales.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment-hijri@2.1.2/moment-hijri.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap-hijri-datepicker@1.0.2/dist/js/bootstrap-hijri-datetimepicker.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/js/tom-select.complete.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.3/Sortable.min.js"></script>
    <script>
        const ITINERARY_CITIES = [
            @foreach($cities as $city)
            { value: "{{ $city->id }}", text: "{{ addslashes(transDB($city, 'title')) }}" },
            @endforeach
        ];

        function initCitySelect(el) {
            if (el.tomselect) return;
            const preSelected = el.value;
            const hiddenInput = el.closest('.itinerary-row').querySelector('.city-id-input');
            new TomSelect(el, {
                valueField: 'value',
                labelField: 'text',
                searchField: 'text',
                options: ITINERARY_CITIES,
                items: preSelected ? [preSelected] : [],
                onChange: function (value) {
                    if (hiddenInput) hiddenInput.value = value;
                },
                create: function (input, callback) {
                    $.post('{{ route("cities.quick-create") }}', { name: input, _token: '{{ csrf_token() }}' })
                        .done(function (data) {
                            const opt = { value: String(data.id), text: data.name };
                            ITINERARY_CITIES.push(opt);
                            callback(opt);
                        })
                        .fail(function () { callback(); });
                },
                placeholder: 'Search or type to add...',
                persist: false,
                createOnBlur: false,
            });
        }

        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.itinerary-row .city-select').forEach(initCitySelect);
        });
    </script>
    <script>
        $(document).ready(function () {
            $(".hijri-date-input").hijriDatePicker({
                hijri: true,
                showSwitcher: false,
                hijriFormat: "iYYYY-iMM-iDD",
                locale: "ar-sa",
                showClear: true,
                showTodayButton: true,
                showClose: true,
                icons: {
                    previous: '<i class="fas fa-chevron-left"></i>',
                    next: '<i class="fas fa-chevron-right"></i>',
                    up: '<i class="fas fa-chevron-up"></i>',
                    down: '<i class="fas fa-chevron-down"></i>',
                    today: '<i class="fas fa-calendar-day me-1"></i> today',
                    clear: '<i class="fas fa-trash me-1"></i> clear',
                    close: '<i class="fas fa-times me-1"></i> close'
                }
            });
        });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {

            // --- Helper: Slugify ---
            function slugify(text) {
                return text.toString().toLowerCase().replace(/\s+/g, '-').replace(/[^a-zA-Z0-9\u0600-\u06FF\-]/g, '').replace(/\-\-+/g, '-').replace(/^-+/, '').replace(/-+$/, '');
            }

            // --- Init Summernote & Slugs ---
            const activeLangs = @json(get_active_langs());
            activeLangs.forEach(lang => {
                const titleInput = document.querySelector(`input[name="title_${lang}"]`);
                const slugInput = document.querySelector(`input[name="slug_${lang}"]`);
                if (titleInput && slugInput) {
                    titleInput.addEventListener('input', function () {
                        slugInput.value = slugify(this.value);
                    });
                }
                if ($(`#description_${lang}`).length) {
                    $(`#description_${lang}`).summernote({
                        height: 200,
                        lang: lang === 'ar' ? 'ar-AR' : 'en-US',
                        direction: lang === 'ar' ? 'rtl' : 'ltr'
                    });
                }
            });

            // --- Wizard Logic ---
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

            window.setSingleFile = function (url, type) {
                $(`#${targetInputId}`).val(url);
                let previewHtml = (type === 'video')
                    ? `<div class="media-preview-card"><video controls width="300" height="180"><source src="${url}"></video><div class="mt-1 text-center small text-muted">Video Selected</div></div>`
                    : `<div class="media-preview-card"><img src="${url}" width="200"></div>`;
                $(`#${targetPreviewId}`).html(previewHtml);
            };

            window.addMultiFile = function (url, type) {
                let inputName = targetInputId + "[]";
                let previewContent = (type === 'video')
                    ? `<video width="100%" height="100%" class="rounded bg-black"><source src="${url}"></video><i class="fas fa-play-circle position-absolute text-white" style="top:50%; left:50%; transform:translate(-50%,-50%);"></i>`
                    : `<img src="${url}" class="w-100 h-100 rounded" style="object-fit:cover">`;

                let itemHtml = `
                    <div class="d-inline-block position-relative shadow-sm border rounded bg-white me-2 mb-2" style="width: 100px; height: 100px;">
                        <input type="hidden" name="${inputName}" value="${url}">
                        ${previewContent}
                        <button type="button" class="remove-btn btn btn-danger btn-sm p-0 d-flex justify-content-center align-items-center" onclick="$(this).parent().remove()">×</button>
                    </div>
                `;
                $(`#${targetPreviewId}`).append(itemHtml);
            };

            // --- Itinerary Repeater Logic ---
            window.calculateNights = function (element) {
                let row = element.closest('.itinerary-row');
                let start = row.querySelector('.start-date').value;
                let end = row.querySelector('.end-date').value;
                let nightsInput = row.querySelector('.nights-input');

                if (start && end) {
                    let date1 = new Date(start);
                    let date2 = new Date(end);
                    if (date2 > date1) {
                        let diffTime = Math.abs(date2 - date1);
                        let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                        nightsInput.value = diffDays;
                    } else {
                        nightsInput.value = 0;
                    }
                } else {
                    nightsInput.value = '';
                }
            }

            window.addRouteRow = function () {
                let uid = Date.now();
                let rowHtml = `
        <div class="row route-row mb-3 align-items-center p-3 rounded" style="background-color: #f0fdf4; border: 1px dashed #bbf7d0; animation: fadeIn 0.3s;">
            <div class="col-md-3 mb-2 mb-md-0">
                <label class="form-label fw-bold">Title (EN)</label>
                <input type="text" name="route_title_en[]" class="form-control" placeholder="e.g. Flight ticket">
            </div>
            <div class="col-md-3 mb-2 mb-md-0">
                <label class="form-label fw-bold">Title (AR)</label>
                <input type="text" name="route_title_ar[]" class="form-control" placeholder="مثال: تذاكر الطيران">
            </div>
            <div class="col-md-3 mb-2 mb-md-0">
                <label class="form-label fw-bold">Icon/Image</label>
                <div class="media-selector-group">
                    <input type="text" id="route_icon_${uid}" name="route_icon[]" readonly placeholder="Icon..." onclick="$('#btn_route_${uid}').click()">
                    <button type="button" id="btn_route_${uid}" class="btn btn-primary btn-choose open-gallery" data-input="route_icon_${uid}" data-preview="preview_route_${uid}">Choose</button>
                </div>
                <div id="preview_route_${uid}" class="mt-1"></div>
            </div>
            <div class="col-md-2 mb-2 mb-md-0">
                <label class="form-label fw-bold">Order (الترتيب)</label>
                <input type="number" name="route_order[]" class="form-control" value="0">
            </div>
            <div class="col-md-1 mt-4 text-center">
                <button type="button" class="btn btn-danger remove-route-row w-100 shadow-sm"><i class="fas fa-times"></i></button>
            </div>
        </div>
    `;
                document.getElementById('route-repeater').insertAdjacentHTML('beforeend', rowHtml);
            }

            window.addExcludeRow = function () {
                let uid = Date.now();
                let rowHtml = `
        <div class="row exclude-row mb-3 align-items-center p-3 rounded" style="background-color: #fef2f2; border: 1px dashed #fecaca; animation: fadeIn 0.3s;">
            <div class="col-md-3 mb-2 mb-md-0">
                <label class="form-label fw-bold">Title (EN)</label>
                <input type="text" name="exclude_title_en[]" class="form-control" placeholder="e.g. Visas">
            </div>
            <div class="col-md-3 mb-2 mb-md-0">
                <label class="form-label fw-bold">Title (AR)</label>
                <input type="text" name="exclude_title_ar[]" class="form-control" placeholder="مثال: التأشيرات">
            </div>
            <div class="col-md-3 mb-2 mb-md-0">
                <label class="form-label fw-bold">Icon/Image</label>
                <div class="media-selector-group">
                    <input type="text" id="exclude_icon_${uid}" name="exclude_icon[]" readonly placeholder="Icon..." onclick="$('#btn_exclude_${uid}').click()">
                    <button type="button" id="btn_exclude_${uid}" class="btn btn-primary btn-choose open-gallery" data-input="exclude_icon_${uid}" data-preview="preview_exclude_${uid}">Choose</button>
                </div>
                <div id="preview_exclude_${uid}" class="mt-1"></div>
            </div>
            <div class="col-md-2 mb-2 mb-md-0">
                <label class="form-label fw-bold">Order (الترتيب)</label>
                <input type="number" name="exclude_order[]" class="form-control" value="0">
            </div>
            <div class="col-md-1 mt-4 text-center">
                <button type="button" class="btn btn-danger remove-exclude-row w-100 shadow-sm"><i class="fas fa-times"></i></button>
            </div>
        </div>
    `;
                document.getElementById('exclude-repeater').insertAdjacentHTML('beforeend', rowHtml);
            }

            $(document).on('click', '.remove-route-row', function () {
                $(this).closest('.route-row').remove();
            });


            $(document).on('click', '.remove-exclude-row', function () {
                $(this).closest('.exclude-row').remove();
            });

            let itineraryIndex = {{ (isset($item) && $item->itineraries) ? $item->itineraries->count() : 1 }};

            window.addItineraryRow = function () {
                let currentIndex = itineraryIndex++;
                let cityOptions = '<option value="">-- Select City --</option>';
                @foreach($cities as $city)
                    cityOptions += '<option value="{{ $city->id }}">{{ transDB($city, 'title') }}</option>';
                @endforeach

                let rowHtml = `
                    <div class="row itinerary-row mb-4 align-items-end p-3 rounded shadow-sm" style="background-color: #f4f6f9; border: 1px solid #e1e5ef; animation: fadeIn 0.3s;" data-index="${currentIndex}">
                        <div class="col-12 drag-handle text-center py-1 mb-2" style="cursor: grab; color: #999; background: #e0e4ed; border-radius: 6px; user-select: none;" title="Drag to reorder">
                            <i class="fas fa-grip-horizontal"></i>
                        </div>
                        <div class="col-md-3 mb-2 mb-md-0">
                            <label class="form-label text-dark fw-bold">City <span class="text-danger">*</span></label>
                            <select class="city-select form-select bg-white shadow-sm">${cityOptions}</select>
                            <input type="hidden" name="itinerary_city_id[]" class="city-id-input" value="">
                        </div>
                        <div class="col-md-3 mb-2 mb-md-0">
                            <label class="form-label text-dark fw-bold">Start Date <span class="text-danger">*</span></label>
                            <input type="date" name="itinerary_start[]" class="form-control start-date bg-white shadow-sm" onchange="calculateNights(this)">
                        </div>
                        <div class="col-md-3 mb-2 mb-md-0">
                            <label class="form-label text-dark fw-bold">End Date <span class="text-danger">*</span></label>
                            <input type="date" name="itinerary_end[]" class="form-control end-date bg-white shadow-sm" onchange="calculateNights(this)">
                        </div>
                        <div class="col-md-2 mb-2 mb-md-0">
                            <label class="form-label text-dark fw-bold">Nights</label>
                            <input type="number" name="itinerary_nights[]" class="form-control nights-input" style="background-color: #e9ecef; cursor: not-allowed;" readonly>
                        </div>
                        <div class="col-md-1 mb-2 mb-md-0 text-center">
                            <button type="button" class="btn btn-danger remove-row w-100 shadow-sm" style="height: 46px; border-radius: 8px;"><i class="fas fa-trash-alt"></i></button>
                        </div>


                        <div class="col-md-12 mt-3">
                            <div class="p-3 bg-white rounded border border-secondary border-opacity-25">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <label class="form-label text-secondary fw-bold mb-0"><i class="fas fa-map-signs me-1"></i> Tourist Attractions</label>
                                    <button type="button" class="btn btn-sm btn-outline-secondary py-1 px-2" onclick="addPlaceRow(this)">
                                        <i class="fas fa-plus"></i> Add Place
                                    </button>
                                </div>
                                <div class="places-repeater"></div>
                            </div>
                        </div>
                    </div>
                `;
                const repeater = document.getElementById('itinerary-repeater');
                repeater.insertAdjacentHTML('beforeend', rowHtml);
                initCitySelect(repeater.lastElementChild.querySelector('.city-select'));
                reindexRows();
            }

            window.addPlaceRow = function (btn) {
                let itineraryRow = $(btn).closest('.itinerary-row');
                let idx = itineraryRow.data('index');

                let placeHtml = `
                    <div class="row place-row mb-2 mt-2 align-items-center animation-fadeIn">
                        <div class="col-md-5">
                            <input type="text" name="itinerary_places_en[${idx}][]" class="form-control form-control-sm" placeholder="Place Name (EN)">
                        </div>
                        <div class="col-md-5">
                            <input type="text" name="itinerary_places_ar[${idx}][]" class="form-control form-control-sm" placeholder="اسم المكان (AR)">
                        </div>
                        <div class="col-md-2 text-end">
                            <button type="button" class="btn btn-sm btn-danger remove-place-row"><i class="fas fa-times"></i></button>
                        </div>
                    </div>
                `;
                itineraryRow.find('.places-repeater').append(placeHtml);
            }

            $(document).on('click', '.remove-place-row', function () {
                $(this).closest('.place-row').remove();
            });

            $(document).on('click', '.remove-row', function () {
                if ($('.itinerary-row').length > 1) {
                    $(this).closest('.itinerary-row').remove();
                } else {
                    $(this).closest('.itinerary-row').find('input').not('[type="button"]').val('');
                    $(this).closest('.itinerary-row').find('.places-repeater').empty();
                }
                reindexRows();
            });


            window.addPriceRow = function () {
                let rowHtml = `
        <div class="row price-row mb-3 align-items-end p-3 rounded" style="background-color: #f8f9fa; border: 1px solid #dee2e6; animation: fadeIn 0.3s;">
            <div class="col-md-3 mb-2 mb-md-0">
                <label class="form-label fw-bold">Title (AR) <span class="text-danger">*</span></label>
                <input type="text" name="price_title_ar[]" class="form-control" placeholder="مثال: سعر تذكرة الطفل">
            </div>
            <div class="col-md-3 mb-2 mb-md-0">
                <label class="form-label fw-bold">Title (EN)</label>
                <input type="text" name="price_title_en[]" class="form-control" placeholder="e.g. Child Ticket">
            </div>
            <div class="col-md-2 mb-2 mb-md-0">
                <label class="form-label fw-bold">Price (SAR) <span class="text-danger">*</span></label>
                <input type="number" name="price_value[]" class="form-control" step="0.01" min="0">
            </div>
            <div class="col-md-3 mb-2 mb-md-0">
                <label class="form-label fw-bold">Discount</label>
                <div class="input-group">
                    <input type="number" name="price_discount[]" class="form-control" value="0" step="0.01" min="0">
                    <select name="price_discount_type[]" class="form-select bg-light" style="flex: 0 0 110px;">
                        <option value="amount">مبلغ (SAR)</option>
                        <option value="percent">نسبة (%)</option>
                    </select>
                </div>
            </div>
            <div class="col-md-1 mb-2 mb-md-0 text-center">
                <button type="button" class="btn btn-danger remove-price-row shadow-sm" style="padding: 10px 15px; border-radius: 8px;" title="Remove">
                    <i class="fas fa-trash-alt"></i>
                </button>
            </div>
        </div>
    `;
                document.getElementById('price-repeater').insertAdjacentHTML('beforeend', rowHtml);
            }
            $(document).on('click', '.remove-price-row', function () {
                if ($('.price-row').length > 1) {
                    $(this).closest('.price-row').remove();
                } else {
                    alert('You must have at least one pricing option.');
                }
            });

            window.addMultiFile = function (url, type) {
                let inputName = targetInputId + "[]";
                let ext = url.split('.').pop().toLowerCase();
                let previewContent = '';

                if (['mp4', 'mov', 'avi', 'mkv'].includes(ext) || type === 'video') {
                    previewContent = `<video width="100%" height="100%" class="rounded bg-black"><source src="${url}"></video><i class="fas fa-play-circle position-absolute text-white" style="top:50%; left:50%; transform:translate(-50%,-50%);"></i>`;
                } else if (['pdf', 'doc', 'docx', 'xls', 'xlsx'].includes(ext)) {
                    previewContent = `
                        <div class="w-100 h-100 rounded bg-light d-flex flex-column align-items-center justify-content-center border">
                            <i class="fas fa-file-pdf fs-1 text-danger mb-1"></i>
                            <span class="small text-muted fw-bold">${ext.toUpperCase()}</span>
                        </div>`;
                } else {
                    previewContent = `<img src="${url}" class="w-100 h-100 rounded" style="object-fit:cover">`;
                }

                let itemHtml = `
                    <div class="d-inline-block position-relative shadow-sm border rounded bg-white me-2 mb-2" style="width: 100px; height: 100px; animation: fadeIn 0.3s;">
                        <input type="hidden" name="${inputName}" value="${url}">
                        ${previewContent}
                        <button type="button" class="remove-btn btn btn-danger btn-sm p-0 d-flex justify-content-center align-items-center" onclick="$(this).parent().remove()">×</button>
                    </div>
                `;
                $(`#${targetPreviewId}`).append(itemHtml);
            };

        });

    </script>
    <script>
        function reindexRows() {
            document.querySelectorAll('#itinerary-repeater .itinerary-row').forEach(function (row, newIndex) {
                row.dataset.index = newIndex;
                row.querySelectorAll('input[name^="itinerary_places_en["]').forEach(function (el) {
                    el.name = 'itinerary_places_en[' + newIndex + '][]';
                });
                row.querySelectorAll('input[name^="itinerary_places_ar["]').forEach(function (el) {
                    el.name = 'itinerary_places_ar[' + newIndex + '][]';
                });
            });
        }

        new Sortable(document.getElementById('itinerary-repeater'), {
            handle: '.drag-handle',
            animation: 150,
            onEnd: function () { reindexRows(); }
        });
    </script>
@endsection
