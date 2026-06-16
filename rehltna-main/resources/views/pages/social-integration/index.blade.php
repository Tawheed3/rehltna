@extends('layouts.app')

@section('styles')
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <style>
        .card {
            border-radius: 16px;
            border: none;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
            height: 100%;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            background: #fff;
            border-bottom: 1px solid #f0f0f0;
            padding: 20px;
            font-weight: 700;
            color: #333;
            display: flex;
            align-items: center;
        }

        .icon-box {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 1.5rem;
            color: white;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        /* Platform specific colors for icons */
        .icon-facebook { background: linear-gradient(135deg, #1877F2 0%, #0d469b 100%); }
        .icon-google { background: linear-gradient(135deg, #4285F4 0%, #34A853 100%); }
        .icon-tiktok { background: linear-gradient(135deg, #000000 0%, #25F4EE 100%); }
        .icon-snapchat { background: linear-gradient(135deg, #FFFC00 0%, #FFD700 100%); color: #333; }
        .icon-twitter { background: linear-gradient(135deg, #000000 0%, #333333 100%); }
        .icon-pinterest { background: linear-gradient(135deg, #E60023 0%, #9c0017 100%); }
        .icon-tags { background: linear-gradient(135deg, #F4B400 0%, #F48C06 100%); }

        .form-switch .form-check-input {
            width: 3em;
            height: 1.5em;
            cursor: pointer;
        }

        .floating-save {
            position: fixed;
            bottom: 30px;
            right: 30px;
            z-index: 1050; /* Increased z-index to be above footer/modals */
            box-shadow: 0 5px 20px rgba(59, 130, 246, 0.4);
            padding: 12px 35px;
            border-radius: 50px;
            font-size: 16px;
            font-weight: bold;
            border: none;
            transition: all 0.3s ease;
        }

        .floating-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.6);
        }
    </style>
@endsection

@section('content')
    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Social Integration</span>
            </div>
        </div>
    </div>

    @php
        $settings = [
            ['title' => 'Facebook Pixel', 'key' => 'facebook_pixel_id', 'value' => get_setting('facebook_pixel_id'), 'status' => get_setting('facebook_pixel'), 'placeholder' => 'Enter Pixel ID (e.g., 123456789)', 'icon' => 'fab fa-facebook-f', 'style' => 'icon-facebook'],
            ['title' => 'Google Analytics', 'key' => 'google_analytics_id', 'value' => get_setting('google_analytics_id'), 'status' => get_setting('google_analytics'), 'placeholder' => 'Enter Measurement ID (e.g., G-XXXXXX)', 'icon' => 'fab fa-google', 'style' => 'icon-google'],
            ['title' => 'Google Tag Manager', 'key' => 'google_manager_id', 'value' => get_setting('google_manager_id'), 'status' => get_setting('google_manager'), 'placeholder' => 'Enter Container ID (e.g., GTM-XXXXXX)', 'icon' => 'fas fa-tags', 'style' => 'icon-tags'],
            ['title' => 'Tiktok Pixel', 'key' => 'tiktok_analytics_id', 'value' => get_setting('tiktok_analytics_id'), 'status' => get_setting('tiktok_analytics'), 'placeholder' => 'Enter Pixel ID', 'icon' => 'fab fa-tiktok', 'style' => 'icon-tiktok'],
            ['title' => 'Snapchat Pixel', 'key' => 'snapchat_pixel_id', 'value' => get_setting('snapchat_pixel_id'), 'status' => get_setting('snapchat_pixel'), 'placeholder' => 'Enter Pixel ID', 'icon' => 'fab fa-snapchat-ghost', 'style' => 'icon-snapchat'],
            ['title' => 'Twitter (X) Pixel', 'key' => 'twitter_pixel_id', 'value' => get_setting('twitter_pixel_id'), 'status' => get_setting('twitter_pixel'), 'placeholder' => 'Enter Pixel ID', 'icon' => 'fa-brands fa-x-twitter', 'style' => 'icon-twitter'],
            ['title' => 'Pinterest Tag', 'key' => 'pinterest_tag_id', 'value' => get_setting('pinterest_tag_id'), 'status' => get_setting('pinterest_tag'), 'placeholder' => 'Enter Tag ID', 'icon' => 'fab fa-pinterest-p', 'style' => 'icon-pinterest'],
        ];
    @endphp

    <form method="POST" action="{{ route('social.integration.update') }}">
        @csrf
        <div class="row g-4 pb-5 mb-5"> {{-- Added mb-5 to prevent content from being hidden behind button --}}
            @foreach ($settings as $setting)
                <div class="col-md-6 col-lg-6 col-xl-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <div class="icon-box {{ $setting['style'] }}">
                                <i class="{{ $setting['icon'] }}"></i>
                            </div>
                            <span class="flex-grow-1">{{ $setting['title'] }}</span>
                            <div class="form-check form-switch m-0">
                                <input class="form-check-input" type="checkbox"
                                       name="status[{{ $setting['key'] }}]"
                                       value="1"
                                       role="switch"
                                       @if($setting['status'] == 1) checked @endif
                                       title="Enable/Disable">
                            </div>
                        </div>
                        <div class="card-body d-flex flex-column justify-content-center">
                            {{-- Hidden input for the Key --}}
                            <input type="hidden" name="keys[]" value="{{ $setting['key'] }}">

                            <div class="form-group mb-0">
                                <label class="text-muted small mb-1">Tracking ID</label>
                                <div class="input-group">
                                    {{-- REMOVED 'required' from here --}}
                                    <input type="text" class="form-control form-control-lg"
                                           name="values[]"
                                           value="{{ $setting['value'] }}"
                                           placeholder="{{ $setting['placeholder'] }}">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            @endforeach
        </div>

        {{-- Sticky Save Button --}}
        <button type="submit" class="btn btn-primary floating-save">
            <i class="las la-save me-1"></i> Save All Changes
        </button>
    </form>
@endsection
