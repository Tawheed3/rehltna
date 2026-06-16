@extends('layouts.app')

@section('styles')
    <style>
        /* Global Background */
        body {
            background-color: #f8fafc;
        }

        /* Card Deluxe Styling */
        .slider-card {
            border: none;
            border-radius: 24px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
            background: #fff;
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            overflow: hidden;
        }

        .slider-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
        }

        /* Hero Header Section */
        .hero-section {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            border-radius: 24px;
            padding: 45px 35px;
            margin-bottom: 35px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 20px 30px rgba(0, 0, 0, 0.12);
        }

        /* Banner Container */
        .banner-wrapper {
            position: relative;
            border-radius: 16px;
            overflow: hidden;
            background: #f1f5f9;
            box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.05);
        }

        .banner-media {
            height: 180px;
            object-fit: cover;
            width: 100%;
            transition: 0.5s;
        }

        .slider-card:hover .banner-media {
            transform: scale(1.05);
        }

        /* Badge Styling */
        .lang-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255, 255, 255, 0.9);
            color: #1e293b;
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 10px;
            font-weight: 800;
            backdrop-filter: blur(4px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        /* Action Buttons - Animated Scale & Rotate */
        .btn-action {
            height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: #fff;
            border: 1px solid #e2e8f0;
            font-weight: 700;
        }

        .btn-action:hover {
            transform: scale(1.02) translateY(-2px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.05);
        }

        .btn-edit-gal:hover {
            color: #4f46e5;
            border-color: #4f46e5;
            background: #f5f3ff;
        }

        .btn-delete-gal:hover {
            color: #ef4444;
            border-color: #ef4444;
            background: #fef2f2;
        }

        .order-indicator {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            padding: 4px 12px;
            border-radius: 10px;
            font-weight: 800;
            color: #475569;
            font-size: 12px;
        }

        .main-toggle {
            cursor: pointer;
            transform: scale(0.9);
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Slider Management
            </h4>
            <p class="text-muted mb-0 small fw-medium">Media / <span class="text-primary">Hero Banners</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Visual Storytelling</h3>
            <p class="mb-0 opacity-75 fw-medium">Manage your website's first impression with high-quality banners and
                videos.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <a href="{{ route('sliders.create') }}"
               class="btn btn-primary rounded-pill px-4 shadow-lg fw-bold border-0 d-flex align-items-center"
               style="background: #ffffff; color: #4f46e5; height: 48px;">
                <i class="fas fa-plus-circle me-2"></i> Add New Slider
            </a>
        </div>
    </div>

    <div class="row">
        @foreach($sliders as $slider)
            <div class="col-md-6 col-xl-6 mb-4">
                <div class="card slider-card">
                    <div class="card-body p-4 d-flex flex-column">

                        {{-- Banners Grid --}}
                        <div class="row mb-4 g-3">
                            @foreach(get_active_langs() as $lang)
                                @if($slider->{'banner_'.$lang})
                                    <div class="col">
                                        <div class="banner-wrapper">
                                            @php
                                                $fileUrl = $slider->{'banner_'.$lang};
                                                $extension = strtolower(pathinfo($fileUrl, PATHINFO_EXTENSION));
                                                $videoExtensions = ['mp4', 'webm', 'ogg', 'mov', 'avi'];
                                            @endphp

                                            @if(in_array($extension, $videoExtensions))
                                                <video class="banner-media rounded" controls>
                                                    <source src="{{ asset($fileUrl) }}" type="video/{{ $extension }}">
                                                </video>
                                            @else
                                                <img src="{{ asset($fileUrl) }}" class="banner-media rounded"
                                                     alt="Banner {{ strtoupper($lang) }}">
                                            @endif
                                            <span class="lang-badge">{{ strtoupper($lang) }}</span>
                                        </div>
                                    </div>
                                @endif
                            @endforeach
                        </div>

                        {{-- Combined Titles --}}
                        <h5 class="fw-bold mb-3 text-dark text-center">
                            @foreach(get_active_langs() as $lang)
                                {{ $slider->{'title_'.$lang} }}
                                @if(!$loop->last)
                                    <span class="text-muted mx-2 opacity-50">|</span>
                                @endif
                            @endforeach
                        </h5>

                        <div class="d-flex justify-content-between align-items-center mb-4 p-2 bg-light rounded-3">
                            <span class="small fw-bold text-muted">Rank: <span
                                    class="order-indicator ms-1">{{ $slider->order }}</span></span>
                            <div
                                class="toggle-status-btn main-toggle {{ $slider->status == 1 ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                                data-id="{{ $slider->id }}">
                                <span></span>
                            </div>
                        </div>

                        <div class="mt-auto d-flex gap-2">
                            <a href="{{ route('sliders.edit', encrypt($slider->id)) }}"
                               class="btn btn-action btn-edit-gal flex-fill">
                                <i class="las la-pen me-2"></i> Edit Content
                            </a>
                            <a class="btn btn-action btn-delete-gal delete-btn flex-fill"
                               data-route="{{ route('sliders.destroy', $slider->id) }}"
                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal">
                                <i class="las la-trash me-2"></i> Remove
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        @endforeach
    </div>

    @include('pages.models.confirm-delete')
@endsection

@section('scripts')
    <script>
        // AJAX Status Logic
        $(document).on('click', '.toggle-status-btn', function () {
            let button = $(this);
            let sliderId = button.data('id');
            $.ajax({
                url: "{{ route('sliders.change.status', ['id' => ':id']) }}".replace(':id', sliderId),
                type: 'POST',
                data: {_token: '{{ csrf_token() }}'},
                success: function (response) {
                    toastr.success("Slider status synchronized");
                    if (response.status == 1) {
                        button.removeClass('main-toggle-danger of').addClass('main-toggle-success on');
                    } else {
                        button.removeClass('main-toggle-success on').addClass('main-toggle-danger of');
                    }
                }
            });
        });

        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete();
        });
    </script>
@endsection
