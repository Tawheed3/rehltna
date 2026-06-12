@php
    function decode_setting($key) {
        $val = get_setting($key);
        if (is_string($val)) {
            return json_decode($val, true) ?? [];
        } elseif (is_array($val)) {
            return $val;
        } else {
            return [];
        }
    }
@endphp

@extends('layouts.app')

@section('styles')
    <style>
        /* Custom Styles for "Deluxe" Look */
        .settings-nav .nav-link {
            color: #5b6e88;
            font-weight: 600;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 8px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
        }

        .settings-nav .nav-link i {
            font-size: 1.2rem;
            margin-inline-end: 10px;
        }

        .settings-nav .nav-link:hover {
            background-color: #f0f2f5;
            color: #2c3e50;
        }

        .settings-nav .nav-link.active {
            background-color: #0d6efd; /* Primary Color */
            color: #fff;
            box-shadow: 0 4px 15px rgba(13, 110, 253, 0.3);
        }

        .card-setting {
            border: none;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.03);
            border-radius: 15px;
            overflow: visible !important;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #333;
            border-bottom: 2px solid #f0f2f5;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }

        .lang-card {
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }

        .lang-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }

        .lang-check-wrapper input:checked + .card-content {
            border-color: #0d6efd !important;
            background-color: #f8fbff;
        }

        .logo-preview-box {
            background: #f8f9fa;
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            min-height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 10px;
            position: relative;
            overflow: hidden;
        }

        /* Media Selector Styles */
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
            padding: 8px 15px;
            font-weight: 600;
            font-size: 12px;
            white-space: nowrap;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <h4 class="content-title mb-0 my-auto fw-bold text-dark">
                <i class="las la-cog me-2"></i>System Settings
            </h4>
            <span class="text-muted small">Manage your website configuration, languages, and integrations.</span>
        </div>
    </div>

    <form action="{{ route('update.settings') }}" method="POST" enctype="multipart/form-data">
        @csrf

        <div class="row">
            {{-- Left Navigation --}}
            <div class="col-lg-3 mb-4">
                <div class="card card-setting sticky-top" style="top: 20px; z-index: 1;">
                    <div class="card-body p-3">
                        <div class="nav flex-column nav-pills settings-nav" id="v-pills-tab" role="tablist"
                             aria-orientation="vertical">
                            <button class="nav-link active" id="v-pills-general-tab" data-bs-toggle="pill"
                                    data-bs-target="#v-pills-general" type="button" role="tab">
                                <i class="las la-globe"></i> General & Languages
                            </button>
                            <button class="nav-link" id="v-pills-contact-tab" data-bs-toggle="pill"
                                    data-bs-target="#v-pills-contact" type="button" role="tab">
                                <i class="las la-map-marker"></i> Addresses & Contact
                            </button>
                            <button class="nav-link" id="v-pills-media-tab" data-bs-toggle="pill"
                                    data-bs-target="#v-pills-media" type="button" role="tab">
                                <i class="las la-image"></i> Logos & Media
                            </button>
                            <button class="nav-link" id="v-pills-social-tab" data-bs-toggle="pill"
                                    data-bs-target="#v-pills-social" type="button" role="tab">
                                <i class="las la-share-alt"></i> Social Links
                            </button>
{{--                            <button class="nav-link" id="v-pills-payment-tab" data-bs-toggle="pill"--}}
{{--                                    data-bs-target="#v-pills-payment" type="button" role="tab">--}}
{{--                                <i class="las la-credit-card"></i> Payment & Fees--}}
{{--                            </button>--}}
                        </div>
                    </div>
                </div>
            </div>

            {{-- Right Content --}}
            <div class="col-lg-9">
                <div class="card card-setting">
                    <div class="card-body p-4">
                        <div class="tab-content" id="v-pills-tabContent">

                            {{-- 1. General Tab --}}
                            <div class="tab-pane fade show active" id="v-pills-general" role="tabpanel">
                                <h5 class="section-title">Global Configuration</h5>

                                {{-- Active Languages --}}
                                <div class="mb-4">
                                    <label class="form-label fw-bold mb-3">Active Languages</label>
                                    @php
//                                        $available_langs = ['ar' => 'Arabic', 'en' => 'English', 'fr' => 'French', 'de' => 'German'];
                                        $available_langs = ['ar' => 'Arabic', 'en' => 'English'];
                                        $saved_langs = decode_setting('active_langs');
                                        if(empty($saved_langs)) $saved_langs = get_active_langs();
                                    @endphp

                                    <input type="hidden" name="active_langs" value="">

                                    <div class="row g-3">
                                        @foreach($available_langs as $code => $label)
                                            @php $isChecked = in_array($code, $saved_langs); @endphp
                                            <div class="col-md-6 col-6">
                                                <label class="w-100 lang-check-wrapper" style="cursor: pointer;">
                                                    <input type="checkbox" name="active_langs[]" value="{{ $code }}"
                                                           class="d-none lang-input" {{ $isChecked ? 'checked' : '' }}>
                                                    <div class="card h-100 border lang-card {{ $isChecked ? 'border-primary bg-light' : '' }} card-content">
                                                        <div class="card-body p-3 d-flex align-items-center justify-content-between">
                                                            <div>
                                                                <span class="d-block fw-bold text-dark">{{ $label }}</span>
                                                                <span class="badge bg-secondary text-uppercase" style="font-size: 0.7rem;">{{ $code }}</span>
                                                            </div>
                                                            <div class="check-icon-area">
                                                                @if($isChecked)
                                                                    <i class="las la-check-circle text-primary fs-3"></i>
                                                                @endif
                                                            </div>
                                                        </div>
                                                    </div>
                                                </label>
                                            </div>
                                        @endforeach
                                    </div>
                                </div>

                                <div class="row mt-4">
                                    @foreach(get_active_langs() as $lang)
                                        <div class="col-md-12 mb-3">
                                            <label class="form-label text-muted small text-uppercase fw-bold">Site Name
                                                ({{ $lang }})</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light"><i
                                                        class="las la-pen"></i></span>
                                                <input type="text" name="site_name_{{ $lang }}"
                                                       value="{{ get_setting('site_name_'.$lang) }}"
                                                       class="form-control" dir="{{ $lang == 'ar' ? 'rtl' : 'ltr' }}">
                                            </div>
                                        </div>
                                    @endforeach

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Support Email</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light"><i
                                                    class="las la-envelope"></i></span>
                                            <input type="email" name="site_email"
                                                   value="{{ get_setting('site_email') }}" class="form-control">
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Hotline / Phone</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light"><i class="las la-phone"></i></span>
                                            <input type="text" name="site_phone" value="{{ get_setting('site_phone') }}"
                                                   class="form-control">
                                        </div>
                                    </div>
                                </div>

{{--                                <hr class="my-4">--}}
{{--                                <h5 class="section-title">About Us Page Videos</h5>--}}
{{--                                <div class="alert alert-danger border-0 shadow-sm">--}}
{{--                                    <i class="las la-exclamation-triangle me-1"></i>--}}
{{--                                    <strong>Important:</strong> These fields accept <strong>YouTube</strong> links only.--}}
{{--                                    <br>--}}
{{--                                    <small>Example: <em>https://www.youtube.com/watch?v=dQw4w9WgXcQ</em> OR <em>https://youtu.be/dQw4w9WgXcQ</em></small>--}}
{{--                                </div>--}}

{{--                                <div class="row">--}}
{{--                                    --}}{{-- Mission Video --}}
{{--                                    <div class="col-md-6 mb-3">--}}
{{--                                        <label class="form-label fw-bold">Mission Video URL</label>--}}
{{--                                        <div class="input-group">--}}
{{--                                            <span class="input-group-text text-danger"><i class="lab la-youtube fs-4"></i></span>--}}
{{--                                            <input type="url" name="mission_video_url"--}}
{{--                                                   value="{{ get_setting('mission_video_url') }}"--}}
{{--                                                   class="form-control"--}}
{{--                                                   placeholder="Paste Mission YouTube link here...">--}}
{{--                                        </div>--}}
{{--                                    </div>--}}

{{--                                    --}}{{-- Vision Video --}}
{{--                                    <div class="col-md-6 mb-3">--}}
{{--                                        <label class="form-label fw-bold">Vision Video URL</label>--}}
{{--                                        <div class="input-group">--}}
{{--                                            <span class="input-group-text text-danger"><i class="lab la-youtube fs-4"></i></span>--}}
{{--                                            <input type="url" name="vision_video_url"--}}
{{--                                                   value="{{ get_setting('vision_video_url') }}"--}}
{{--                                                   class="form-control"--}}
{{--                                                   placeholder="Paste Vision YouTube link here...">--}}
{{--                                        </div>--}}
{{--                                    </div>--}}
{{--                                </div>--}}
                            </div>

                            {{-- 2. Contact Tab --}}
                            <div class="tab-pane fade" id="v-pills-contact" role="tabpanel">
                                <h5 class="section-title">Physical Locations</h5>
                                @foreach(get_active_langs() as $lang)
                                    <div class="mb-4 p-3 bg-light rounded border">
                                        <label class="fw-bold mb-2"><i class="las la-map-pin text-danger"></i> Site
                                            Address ({{ strtoupper($lang) }})</label>
                                        <div class="repeater" data-name="site_address_{{ $lang }}">
                                            @php $addresses = decode_setting('site_address_'.$lang); @endphp
                                            <div class="repeater-items">
                                                @forelse($addresses as $addr)
                                                    <div class="d-flex align-items-center mb-2 repeater-item">
                                                        <input type="text" name="site_address_{{ $lang }}[]"
                                                               value="{{ $addr }}" class="form-control me-2"
                                                               dir="{{ $lang == 'ar' ? 'rtl' : 'ltr' }}">
                                                        <button type="button"
                                                                class="btn btn-light text-danger border btn-sm remove-item hover-shadow">
                                                            <i class="las la-trash"></i></button>
                                                    </div>
                                                @empty
                                                    <div class="d-flex align-items-center mb-2 repeater-item">
                                                        <input type="text" name="site_address_{{ $lang }}[]"
                                                               class="form-control me-2"
                                                               dir="{{ $lang == 'ar' ? 'rtl' : 'ltr' }}">
                                                        <button type="button"
                                                                class="btn btn-light text-danger border btn-sm remove-item hover-shadow">
                                                            <i class="las la-trash"></i></button>
                                                    </div>
                                                @endforelse
                                            </div>
                                            <button type="button"
                                                    class="btn btn-sm btn-outline-primary add-item mt-2 rounded-pill px-3">
                                                <i class="las la-plus"></i> Add Line
                                            </button>
                                        </div>
                                    </div>
                                @endforeach
                            </div>

                            {{-- 3. Media Tab (Gallery for Branding, Normal for Profiles) --}}
                            <div class="tab-pane fade" id="v-pills-media" role="tabpanel">
                                <h5 class="section-title">Branding & Files</h5>
                                <div class="row">
                                    {{-- Light Logo (Gallery) --}}
                                    <div class="col-md-4 mb-4">
                                        <label class="form-label fw-bold">Light Logo</label>
                                        <div class="media-selector-group">
                                            <input type="text" name="main_logo_light" id="main_logo_light"
                                                   value="{{ get_setting('main_logo_light') ? asset(get_setting('main_logo_light')) : '' }}"
                                                   readonly placeholder="Select from gallery...">
                                            <button type="button" class="btn btn-primary btn-choose open-gallery"
                                                    data-input="main_logo_light" data-preview="preview_logo_light">
                                                Choose
                                            </button>
                                        </div>
                                        <div class="logo-preview-box" id="preview_logo_light">
                                            @if(get_setting('main_logo_light'))
                                                <img src="{{ asset(get_setting('main_logo_light')) }}" style="max-height:80px; max-width:100%;">
                                            @else
                                                <span class="text-muted small">No Image</span>
                                            @endif
                                        </div>
                                    </div>

                                    {{-- Dark Logo (Gallery) --}}
                                    <div class="col-md-4 mb-4">
                                        <label class="form-label fw-bold">Dark Logo</label>
                                        <div class="media-selector-group">
                                            <input type="text" name="main_logo_dark" id="main_logo_dark"
                                                   value="{{ get_setting('main_logo_dark') ? asset(get_setting('main_logo_dark')) : '' }}"
                                                   readonly placeholder="Select from gallery...">
                                            <button type="button" class="btn btn-primary btn-choose open-gallery"
                                                    data-input="main_logo_dark" data-preview="preview_logo_dark">Choose
                                            </button>
                                        </div>
                                        <div class="logo-preview-box bg-dark" id="preview_logo_dark">
                                            @if(get_setting('main_logo_dark'))
                                                <img src="{{ asset(get_setting('main_logo_dark')) }}" style="max-height:80px; max-width:100%;">
                                            @else
                                                <span class="text-white small">No Image</span>
                                            @endif
                                        </div>
                                    </div>

                                    {{-- Favicon (Gallery) --}}
                                    <div class="col-md-4 mb-4">
                                        <label class="form-label fw-bold">Favicon</label>
                                        <div class="media-selector-group">
                                            <input type="text" name="favicon" id="favicon"
                                                   value="{{ get_setting('favicon') ? asset(get_setting('favicon')) : '' }}"
                                                   readonly placeholder="Select from gallery...">
                                            <button type="button" class="btn btn-primary btn-choose open-gallery"
                                                    data-input="favicon" data-preview="preview_favicon">Choose
                                            </button>
                                        </div>
                                        <div class="logo-preview-box" id="preview_favicon">
                                            @if(get_setting('favicon'))
                                                <img src="{{ asset(get_setting('favicon')) }}" style="max-height:40px;">
                                            @else
                                                <span class="text-muted small">No Icon</span>
                                            @endif
                                        </div>
                                    </div>
                                </div>

                                <hr class="my-4">
                                <label class="fw-bold mb-3">Company Profiles (PDF - Manual Upload)</label>
                                <div class="row">
                                    @foreach(get_active_langs() as $lang)
                                        <div class="col-md-6 mb-3">
                                            <div class="border rounded p-3 d-flex justify-content-between align-items-center bg-light">
                                                <div>
                                                    <strong>Profile ({{ strtoupper($lang) }})</strong>
                                                    @if(get_setting('company_profile_'.$lang))
                                                        <div class="text-success small mt-1"><i class="las la-check"></i> Uploaded</div>
                                                    @else
                                                        <div class="text-muted small mt-1">Not uploaded yet</div>
                                                    @endif
                                                </div>
                                                <div class="text-end">
                                                    <input type="file" name="company_profile_{{ $lang }}" class="form-control form-control-sm mb-1" style="width: 200px;">

                                                    @if(get_setting('company_profile_'.$lang))
                                                        <button type="button" class="btn btn-xs btn-primary view-pdf py-0"
                                                                data-src="{{ asset(get_setting('company_profile_'.$lang)) }}">
                                                            View Current
                                                        </button>
                                                    @endif
                                                </div>
                                            </div>
                                        </div>
                                    @endforeach
                                </div>
                            </div>

                            {{-- 4. Social Tab --}}
                            <div class="tab-pane fade" id="v-pills-social" role="tabpanel">
                                <h5 class="section-title">Social Presence</h5>
                                <div class="row">
                                    @php
                                        $socials = [
                                            'facebook' => ['label' => 'Facebook', 'icon' => 'la-facebook-f', 'color' => '#3b5998'],
                                            'instagram' => ['label' => 'Instagram', 'icon' => 'la-instagram', 'color' => '#C13584'],
                                            'twitter' => ['label' => 'Twitter', 'icon' => 'la-twitter', 'color' => '#1DA1F2'],
                                            'whatsapp' => ['label' => 'WhatsApp', 'icon' => 'la-whatsapp', 'color' => '#25D366'],
                                            'linkedin' => ['label' => 'LinkedIn', 'icon' => 'la-linkedin-in', 'color' => '#0077b5'],
                                            'youtube' => ['label' => 'YouTube', 'icon' => 'la-youtube', 'color' => '#FF0000'],
                                            'tiktok' => ['label' => 'TikTok', 'icon' => '', 'color' => '#010101', 'svg' => '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" fill="currentColor" width="18" height="18" class="me-1"><path d="M448 209.9a210.1 210.1 0 0 1-122.8-39.3V349.4A162.6 162.6 0 1 1 185 188.3V278.2a74.6 74.6 0 1 0 52.2 71.2V0h88a121.2 121.2 0 0 0 1.9 22.2A122.2 122.2 0 0 0 381 102.4a121.4 121.4 0 0 0 67 20.1z"/></svg>'],
                                            'snapchat' => ['label' => 'Snapchat', 'icon' => 'la-snapchat-ghost', 'color' => '#FFFC00'],
                                        ];
                                    @endphp

                                    @foreach($socials as $key => $meta)
                                        <div class="col-md-6 mb-4">
                                            <div class="card h-100 border-0 bg-light">
                                                <div class="card-body">
                                                    <label class="fw-bold mb-2" style="color: {{ $meta['color'] }}">
                                                        @if(!empty($meta['svg']))
                                                            {!! $meta['svg'] !!}
                                                        @else
                                                            <i class="lab {{ $meta['icon'] }} fs-4 me-1"></i>
                                                        @endif
                                                        {{ $meta['label'] }}
                                                    </label>
                                                    <div class="repeater" data-name="{{ $key }}">
                                                        @php $values = decode_setting($key); @endphp
                                                        <div class="repeater-items">
                                                            @forelse($values as $val)
                                                                <div
                                                                    class="d-flex align-items-center mb-2 repeater-item">
                                                                    <input type="text" name="{{ $key }}[]"
                                                                           value="{{ $val }}"
                                                                           class="form-control form-control-sm me-2"
                                                                           placeholder="https://...">
                                                                    <button type="button"
                                                                            class="btn btn-danger btn-sm remove-item p-1 px-2">
                                                                        <i class="las la-times"></i></button>
                                                                </div>
                                                            @empty
                                                                <div
                                                                    class="d-flex align-items-center mb-2 repeater-item">
                                                                    <input type="text" name="{{ $key }}[]"
                                                                           class="form-control form-control-sm me-2"
                                                                           placeholder="https://...">
                                                                    <button type="button"
                                                                            class="btn btn-danger btn-sm remove-item p-1 px-2">
                                                                        <i class="las la-times"></i></button>
                                                                </div>
                                                            @endforelse
                                                        </div>
                                                        <button type="button"
                                                                class="btn btn-sm btn-link text-decoration-none add-item p-0 mt-1">
                                                            + Add Another Link
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    @endforeach
                                </div>
                            </div>

                            {{-- 5. Payment Tab --}}
                            <div class="tab-pane fade" id="v-pills-payment" role="tabpanel">
                                <h5 class="section-title">Finance & Gateway</h5>
                                <div class="alert alert-info border-0 shadow-sm mb-4">
                                    <i class="las la-info-circle me-1"></i> These settings affect how prices are
                                    calculated at checkout.
                                </div>

                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <div class="p-3 border rounded h-100">
                                            <label class="form-label fw-bold text-success">Currency Exchange
                                                Rate</label>
                                            <div class="input-group mb-2">
                                                <span class="input-group-text">$1 USD = </span>
                                                <input type="number" step="0.01" name="currency_rate"
                                                       value="{{ get_setting('currency_rate', 50) }}"
                                                       class="form-control fw-bold">
                                                <span class="input-group-text">EGP</span>
                                            </div>
                                            <small class="text-muted d-block">Used for real-time conversion on the
                                                frontend.</small>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="p-3 border rounded h-100">
                                            <label class="form-label fw-bold">Platform Commission</label>
                                            <div class="input-group mb-2">
                                                <input type="number" step="0.01" name="payment_commission_percentage"
                                                       value="{{ get_setting('payment_commission_percentage', 3) }}"
                                                       class="form-control">
                                                <span class="input-group-text">%</span>
                                            </div>
                                            <small class="text-muted">Percentage taken from each transaction.</small>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="p-3 border rounded h-100">
                                            <label class="form-label fw-bold">Fixed Transaction Fee</label>
                                            <div class="input-group mb-2">
                                                <span class="input-group-text">+</span>
                                                <input type="number" step="0.01" name="payment_fixed_amount"
                                                       value="{{ get_setting('payment_fixed_amount', 3) }}"
                                                       class="form-control">
                                                <span class="input-group-text">EGP</span>
                                            </div>
                                            <small class="text-muted">Flat fee added to the total.</small>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="p-3 border rounded h-100">
                                            <label class="form-label fw-bold">Extra / Hidden Fees</label>
                                            <div class="input-group mb-2">
                                                <span class="input-group-text">+</span>
                                                <input type="number" step="0.01" name="payment_extra_fees"
                                                       value="{{ get_setting('payment_extra_fees', 0) }}"
                                                       class="form-control">
                                                <span class="input-group-text">%</span>
                                            </div>
                                            <small class="text-muted">Miscellaneous charges.</small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div> {{-- End Tab Content --}}
                    </div>

                    <div class="card-footer bg-white border-top p-3 d-flex justify-content-end">
                        <button class="btn btn-primary btn-lg px-5 rounded-pill shadow-sm" type="submit">
                            <i class="las la-save"></i> Save Changes
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    @include('pages.models.gallery-modal')

    {{-- Preview Modal --}}
    <div class="modal fade" id="previewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title fw-bold">File Preview</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center bg-light p-5" id="previewContent"></div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // --- GALLERY CALLBACK ---
            window.setSingleFile = function (url, type) {
                let targetInputId = window.galleryState.inputId;
                let targetPreviewId = window.galleryState.previewId;

                $(`#${targetInputId}`).val(url);

                if (targetPreviewId !== 'preview_none') {
                    let previewHtml = '';
                    if (type === 'video') {
                        previewHtml = `<video controls width="100%" style="max-height:80px;"><source src="${url}"></video>`;
                    } else {
                        previewHtml = `<img src="${url}" style="max-height:80px; max-width:100%;">`;
                    }
                    $(`#${targetPreviewId}`).html(previewHtml);
                }
            };

            // Modal Logic
            const modalEl = document.getElementById('previewModal');
            const modal = new bootstrap.Modal(modalEl);
            const content = document.getElementById('previewContent');

            // PDF Preview Click
            document.querySelectorAll('.view-pdf').forEach(btn => {
                btn.addEventListener('click', function () {
                    content.innerHTML = `<iframe src="${this.dataset.src}" width="100%" height="700px" style="border:none; border-radius:8px;"></iframe>`;
                    modal.show();
                });
            });

            // Handle Language Card Click UI
            const langInputs = document.querySelectorAll('.lang-input');
            langInputs.forEach(input => {
                input.addEventListener('change', function () {
                    const card = this.nextElementSibling;
                    const iconArea = card.querySelector('.check-icon-area');

                    if (this.checked) {
                        card.classList.add('border-primary', 'bg-light');
                        iconArea.innerHTML = `<i class="las la-check-circle text-primary fs-3"></i>`;
                    } else {
                        card.classList.remove('border-primary', 'bg-light');
                        iconArea.innerHTML = '';
                    }
                });
            });
            // Repeater Logic
            document.querySelectorAll('.repeater').forEach(repeater => {
                const addBtn = repeater.querySelector('.add-item');
                const container = repeater.querySelector('.repeater-items');
                const fieldName = repeater.dataset.name;
                let dir = fieldName.includes('_ar') ? 'rtl' : 'ltr';

                addBtn.addEventListener('click', function () {
                    const item = document.createElement('div');
                    item.classList.add('d-flex', 'align-items-center', 'mb-2', 'repeater-item');
                    item.innerHTML = `
                        <input type="text" name="${fieldName}[]" class="form-control form-control-sm me-2" dir="${dir}" placeholder="...">
                        <button type="button" class="btn btn-danger btn-sm remove-item p-1 px-2"><i class="las la-times"></i></button>
                    `;
                    container.appendChild(item);
                    item.querySelector('input').focus();
                });

                container.addEventListener('click', function (e) {
                    if (e.target.closest('.remove-item')) {
                        e.target.closest('.repeater-item').remove();
                    }
                });
            });
        });
    </script>
@endsection
