@extends('layouts.app')

@section('styles')
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .card-hover {
            border-radius: 16px;
            transition: transform 0.3s, box-shadow 0.3s, background 0.3s;
            cursor: pointer;
            background: #fff;
        }

        .card-hover:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        }

        .icon-circle {
            width: 55px;
            height: 55px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            background-color: rgba(0, 0, 0, 0.05);
            color: #555;
            transition: all 0.3s;
        }

        .card-hover:hover .icon-circle {
            transform: scale(1.2);
        }

        .status-badge {
            font-size: 13px;
            padding: 4px 10px;
            border-radius: 20px;
            transition: all 0.3s;
        }

        .small-card {
            border-radius: 12px;
            transition: all 0.3s;
            cursor: pointer;
        }

        .small-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            background: #f8f9fa;
        }

        .small-card img {
            border-radius: 8px;
            object-fit: cover;
            width: 100%;
            height: 150px;
        }

        .chart-container {
            height: 480px;
            max-height: 450px;
        }
    </style>
    <style>
        .stat-card {
            position: relative;
            overflow: hidden;
            border-radius: 18px;
            transition: all .35s ease;
            background: linear-gradient(135deg, #ffffff, #f8f9fa);
        }

        .stat-card::after {
            content: "";
            position: absolute;
            top: 0;
            right: -40%;
            width: 80%;
            height: 100%;
            background: rgba(255, 255, 255, .15);
            transform: skewX(-20deg);
            transition: .5s;
        }

        .stat-card:hover::after {
            right: 120%;
        }

        .stat-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 20px 45px rgba(0, 0, 0, .15);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            color: #fff;
            flex-shrink: 0;
        }

        .stat-link {
            text-decoration: none;
            color: inherit;
        }

        .stat-link:hover {
            color: inherit;
        }

        .stat-title {
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: .7;
        }

        .stat-count {
            font-size: 32px;
            font-weight: bold;
        }
    </style>
    <style>
        .integration-card {
            border: none;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            height: 100%;
        }

        .integration-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
        }

        .brand-line {
            height: 4px;
            width: 100%;
            position: absolute;
            top: 0;
            left: 0;
        }

        .brand-icon-box {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 15px;
        }

        .id-box {
            background-color: #f8f9fa;
            border: 1px dashed #ced4da;
            border-radius: 8px;
            padding: 8px 12px;
            font-family: 'Courier New', Courier, monospace;
            font-size: 13px;
            color: #555;
            margin: 15px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .id-box i {
            color: #adb5bd;
            font-size: 12px;
        }

        .status-indicator {
            display: inline-flex;
            align-items: center;
            font-size: 12px;
            font-weight: 600;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 6px;
            display: inline-block;
        }

        .status-active {
            background-color: #28a745;
            box-shadow: 0 0 0 rgba(40, 167, 69, 0.4);
            animation: pulse-green 2s infinite;
        }

        .status-inactive {
            background-color: #dc3545;
        }

        @keyframes pulse-green {
            0% {
                box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.4);
            }
            70% {
                box-shadow: 0 0 0 6px rgba(40, 167, 69, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(40, 167, 69, 0);
            }
        }

        .btn-manage {
            border-radius: 8px;
            font-weight: 500;
            font-size: 13px;
            padding: 8px 15px;
            background-color: #f8f9fa;
            color: #333;
            border: 1px solid #e9ecef;
            transition: 0.2s;
        }

        .btn-manage:hover {
            background-color: #e9ecef;
            color: #000;
        }
    </style>
    <style>

        .section-container {
            background: #fff;
            border-radius: 16px;
            padding: 20px;
            height: 100%;
            border: 1px solid #f0f0f0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.02);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px dashed #eee;
        }

        .section-title {
            font-size: 16px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            width: 30px;
            height: 30px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        .mini-list-item {
            display: flex;
            align-items: center;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 10px;
            transition: all 0.2s ease-in-out;
            text-decoration: none !important;
            border: 1px solid transparent;
        }

        .mini-list-item:hover {
            background-color: #f9fafb;
            border-color: #edf2f7;
            transform: translateX(5px);
        }

        .item-thumb {
            width: 60px;
            height: 60px;
            border-radius: 10px;
            object-fit: cover;
            flex-shrink: 0;
            border: 1px solid #eee;
        }

        .item-content {
            margin-left: 15px;
            flex-grow: 1;
            overflow: hidden;
        }

        .item-title {
            font-size: 14px;
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: block;
        }

        .item-date {
            font-size: 11px;
            color: #888;
            display: flex;
            align-items: center;
        }

        .item-date i {
            margin-right: 4px;
            font-size: 10px;
        }

        .view-all-link {
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: 0.2s;
        }
    </style>
@endsection

@section('content')
    @php
        $tenantOptions = explode(',', getTenantInfo()?->options ?? '');
    @endphp
    <div class="container-fluid">

        <!-- Breadcrumb -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0 mt-3">Dashboard</h4>
        </div>
        @php

            $cards = [];

            if (auth()->user()->hasPermission('manage_blogs')) {
                $cards['blogs'] = [
                    'title' => 'Blogs',
                    'route' => 'blogs.index',
                    'icon'  => 'fas fa-blog',
                    'color' => '#1877F2',
                ];
            }

            if (auth()->user()->hasPermission('manage_trips')) {
                $cards['items'] = [
                     'title' => 'Trips',
                    'route' => 'items.index',
                    'icon'  => 'fas fa-box',
                    'color' => '#FFC107',
                ];
            }

            if (auth()->user()->hasPermission('manage_customers')) {
                $cards['residency_users'] = [
                     'title' => 'Users',
                    'route' => 'residency-users.index',
                    'icon'  => 'fas fa-users',
                    'color' => '#495057',
                ];
                $cards['subscribes'] = [
                     'title' => 'Subscribers',
                    'route' => 'subscribes.index',
                    'icon'  => 'fas fa-envelope-open',
                    'color' => '#FD7E14',
                ];
                $cards['contact'] = [
                   'title' => 'Contact Messages',
                    'route' => 'contact-us.index',
                    'icon'  => 'fas fa-envelope',
                    'color' => '#0dcaf0',
                ];
            }

            if (auth()->user()->hasPermission('manage_payments')) {
                $cards['orders'] = [
                    'title' => 'Orders',
                    'route' => 'orders.index',
                    'icon'  => 'fas fa-shopping-cart',
                    'color' => '#5b73e8',
                ];
                   $cards['coupons'] = [
                     'title' => 'Coupons',
                    'route' => 'coupons.index',
                    'icon'  => 'fas fa-ticket-alt',
                    'color' => '#5b73e6',
                ];
            }

            if (auth()->user()->hasPermission('manage_website')) {
                $cards['sliders'] = [
                    'title' => 'Sliders',
                    'route' => 'sliders.index',
                    'icon'  => 'fas fa-images',
                    'color' => '#DC3545',
                ];
                  $cards['testimonials'] = [
                    'title' => 'Testimonials',
                    'route' => 'testimonials.index',
                    'icon'  => 'fas fa-comments',
                    'color' => '#198754',
                ];
                    $cards['custom_pages'] = [
                     'title' => 'Custom Pages',
                    'route' => 'custom-pages.index',
                    'icon'  => 'fas fa-file-alt',
                    'color' => '#495057',
                ];
            }

            $cards += [
                'offers' => [
                    'title' => 'Offers',
                    'route' => 'offers.index',
                    'icon'  => 'fas fa-tags',
                    'color' => '#0F9D58',
                ],
                'jobs' => [
                    'title' => 'Jobs',
                    'route' => 'careers.index',
                    'icon'  => 'fas fa-briefcase',
                    'color' => '#6F42C1',
                ],
                'leads' => [
                    'title' => 'Leads',
                    'route' => 'leads.index',
                    'icon'  => 'fas fa-user-plus',
                    'color' => '#20C997',
                ],

                'portfolios' => [
                    'title' => 'Portfolios',
                    'route' => 'portfolios.index',
                    'icon'  => 'fas fa-layer-group',
                    'color' => '#0DCAF0',
                ],
                'register_users' => [
                    'title' => 'Register Users',
                    'route' => 'register-users.index',
                    'icon'  => 'fas fa-users',
                    'color' => '#5b73e6',
                ],

            ];
        @endphp

            <!-- Quick Stats Cards -->
        <div class="row g-4 mb-4">
            @foreach($cards as $key => $card)
                @if(in_array($key, $tenantOptions))
                    <div class="col-xl-3 col-lg-4 col-md-6">
                        <a href="{{ route($card['route']) }}" class="stat-link">
                            <div class="card stat-card border-0 h-100">
                                <div class="card-body d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="stat-title">{{ $card['title'] }}</div>
                                        <div class="stat-count">
                                            {{ $stats[$key]['count'] ?? 0 }}
                                        </div>
                                    </div>
                                    <div class="stat-icon" style="background: {{ $card['color'] }}">
                                        <i class="{{ $card['icon'] }}"></i>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                @endif
            @endforeach
        </div>

        {{-- Pending Action Items --}}
        @if($pendingOrders || $pendingReviews)
            <div class="row g-3 mb-4">
                @if(!is_null($pendingOrders) && $pendingOrders > 0)
                    <div class="col-md-6">
                        <a href="{{ route('orders.index', ['payment_status' => 'reviewing']) }}" class="text-decoration-none">
                            <div class="card border-0 h-100" style="background: linear-gradient(135deg, #fff3cd, #ffe8a1); border-left: 4px solid #f59e0b !important;">
                                <div class="card-body d-flex align-items-center gap-3">
                                    <div style="width:52px;height:52px;border-radius:14px;background:#f59e0b;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                                        <i class="fas fa-clock text-white fs-5"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark" style="font-size:1.5rem;">{{ $pendingOrders }}</div>
                                        <div class="text-muted fw-semibold small">Pending Orders — awaiting approval</div>
                                    </div>
                                    <div class="ms-auto">
                                        <i class="fas fa-arrow-right text-muted"></i>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                @endif
                @if(!is_null($pendingReviews) && $pendingReviews > 0)
                    <div class="col-md-6">
                        <a href="{{ route('reviews.index', ['status' => 'pending']) }}" class="text-decoration-none">
                            <div class="card border-0 h-100" style="background: linear-gradient(135deg, #e0f2fe, #bae6fd); border-left: 4px solid #3b82f6 !important;">
                                <div class="card-body d-flex align-items-center gap-3">
                                    <div style="width:52px;height:52px;border-radius:14px;background:#3b82f6;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                                        <i class="fas fa-star-half-alt text-white fs-5"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark" style="font-size:1.5rem;">{{ $pendingReviews }}</div>
                                        <div class="text-muted fw-semibold small">Pending Reviews — awaiting moderation</div>
                                    </div>
                                    <div class="ms-auto">
                                        <i class="fas fa-arrow-right text-muted"></i>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                @endif
            </div>
        @endif

        @if(in_array('blogs', $tenantOptions) || in_array('offers', $tenantOptions) || in_array('items', $tenantOptions) || in_array('orders', $tenantOptions))
            <!-- Monthly Activity Chart -->
            <div class="card card-hover shadow-sm border-0 chart-container">
                <div class="card-header">
                    <h5>Monthly Activity In ({{ date('Y') }})</h5>
                </div>
                <div class="card-body h-100">
                    <canvas id="activityChart"></canvas>
                </div>
            </div>
        @endif

        <!-- Social Pixels / Integration Cards -->
        @php
            $settings = [
                ['title'=>'Facebook Pixel','key'=>'facebook_pixel','id_key'=>'facebook_pixel_id','icon'=>'fab fa-facebook-f','color'=>'#1877F2'],
                ['title'=>'Google Analytics','key'=>'google_analytics','id_key'=>'google_analytics_id','icon'=>'fab fa-google','color'=>'#EA4335'],
                ['title'=>'Google Tag Manager','key'=>'google_manager','id_key'=>'google_manager_id','icon'=>'fas fa-tags','color'=>'#0F9D58'],
                ['title'=>'TikTok Pixel','key'=>'tiktok_analytics','id_key'=>'tiktok_analytics_id','icon'=>'fa-brands fa-tiktok','color'=>'#000000'],
                ['title'=>'Snapchat Pixel','key'=>'snapchat_pixel','id_key'=>'snapchat_pixel_id','icon'=>'fab fa-snapchat-ghost','color'=>'#FFFC00'],
                ['title'=>'X (Twitter) Pixel','key'=>'twitter_pixel','id_key'=>'twitter_pixel_id','icon'=>'fa-brands fa-x-twitter','color'=>'#000000'],
                ['title'=>'Pinterest Tag','key'=>'pinterest_tag','id_key'=>'pinterest_tag_id','icon'=>'fa-brands fa-pinterest','color'=>'#E60023'],
            ];
        @endphp

        @if(in_array('social_integration', $tenantOptions) && auth()->user()->hasPermission('manage_settings'))
            <div class="row g-4 mb-4">
                @foreach($settings as $item)
                    @php
                        $status = get_setting($item['key']) == 1;
                        $value = get_setting($item['id_key']);
                    @endphp
                    <div class="col-xl-3 col-lg-4 col-md-6">
                        <div class="integration-card">
                            <div class="brand-line" style="background-color: {{ $item['color'] }};"></div>

                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="brand-icon-box"
                                         style="background-color: {{ $item['color'] }}15; color: {{ $item['color'] }};">
                                        <i class="{{ $item['icon'] }}"></i>
                                    </div>

                                    <div class="status-indicator {{ $status ? 'text-success' : 'text-muted' }}">
                                        <span
                                            class="status-dot {{ $status ? 'status-active' : 'status-inactive' }}"></span>
                                        {{ $status ? 'Connected' : 'Inactive' }}
                                    </div>
                                </div>

                                <h6 class="font-weight-bold text-dark mb-1"
                                    style="font-size: 16px;">{{ $item['title'] }}</h6>
                                <p class="text-muted mb-0" style="font-size: 12px;">
                                    {{ $status ? 'Tracking data is being collected.' : 'Integration is currently disabled.' }}
                                </p>

                                <div class="id-box">
                            <span class="text-truncate" style="max-width: 85%;">
                                {{ $value ?: 'Not Configured' }}
                            </span>
                                    @if($value)
                                        <i class="fas fa-check-circle text-success" title="Configured"></i>
                                    @else
                                        <i class="fas fa-exclamation-circle text-warning" title="Missing ID"></i>
                                    @endif
                                </div>

                                <a href="{{ route('social.integration') }}"
                                   class="btn btn-manage w-100 d-flex justify-content-between align-items-center">
                                    <span>Configure</span>
                                    <i class="fas fa-arrow-right" style="font-size: 11px;"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>
        @endif

        <!-- Latest 3 Blogs, Offers, Items -->
        <div class="row g-4 mb-4">

            @if(in_array('blogs', $tenantOptions) && $latestBlogs->count() > 0 && auth()->user()->hasPermission('manage_blogs'))
                <div class="col-lg-6">
                    <div class="section-container">
                        <div class="section-header">
                            <h5 class="section-title">
                                <span style="#eaf3ff; color: #1877F2;"><i class="fas fa-blog"></i></span>
                                Latest Blogs
                            </h5>
                            <a href="{{ route('blogs.index') }}" class="view-all-link text-primary">View All <i
                                    class="fas fa-arrow-right ms-1"></i></a>
                        </div>

                        @foreach($latestBlogs as $blog)
                            <a href="{{ route('blogs.edit', encrypt($blog->id)) }}" class="mini-list-item">
                                <img src="{{ asset($blog->banner_en ?? $blog->banner_ar) }}" alt="img"
                                     class="item-thumb">
                                <div class="item-content">
                                    <span class="item-title">{{ $blog->title_en ?? $blog->title_ar }}</span>
                                    <span class="item-date"><i class="far fa-clock"></i> {{ $blog->created_at }}</span>
                                </div>
                            </a>
                        @endforeach
                    </div>
                </div>
            @endif

            {{--            @if(in_array('offers', $tenantOptions) && $latestOffers->count() > 0)--}}
            {{--                <div class="col-lg-4">--}}
            {{--                    <div class="section-container">--}}
            {{--                        <div class="section-header">--}}
            {{--                            <h5 class="section-title">--}}
            {{--                                <span style="color: #0F9D58;"><i class="fas fa-tags"></i></span>--}}
            {{--                                Latest Offers--}}
            {{--                            </h5>--}}
            {{--                            <a href="{{ route('offers.index') }}" class="view-all-link text-success">View All <i class="fas fa-arrow-right ms-1"></i></a>--}}
            {{--                        </div>--}}

            {{--                        @foreach($latestOffers as $offer)--}}
            {{--                            <a href="{{ route('offers.edit', encrypt($offer->id)) }}" class="mini-list-item">--}}
            {{--                                <img src="{{ asset($offer->banner_en ?? $offer->banner_ar) }}" alt="img" class="item-thumb">--}}
            {{--                                <div class="item-content">--}}
            {{--                                    <span class="item-title">{{ $offer->title_en ?? $offer->title_ar }}</span>--}}
            {{--                                    <span class="item-date"><i class="far fa-calendar-check"></i> {{ $offer->created_at }}</span>--}}
            {{--                                </div>--}}
            {{--                            </a>--}}
            {{--                        @endforeach--}}
            {{--                    </div>--}}
            {{--                </div>--}}
            {{--            @endif--}}

            @if(in_array('items', $tenantOptions) && $latestItems->count() > 0 && auth()->user()->hasPermission('manage_trips'))
                <div class="col-lg-6">
                    <div class="section-container">
                        <div class="section-header">
                            <h5 class="section-title">
                                <span style="color: #FFC107;"><i class="fas fa-box"></i></span>
                                Latest Trips
                            </h5>
                            <a href="{{ route('items.index') }}" class="view-all-link text-warning">View All <i
                                    class="fas fa-arrow-right ms-1"></i></a>
                        </div>

                        @foreach($latestItems as $item)
                            <a href="{{ route('items.edit', encrypt($item->id)) }}" class="mini-list-item">
                                <img src="{{ asset($item->banner_en ?? $item->banner_ar) }}" alt="img"
                                     class="item-thumb">
                                <div class="item-content">
                                    <span class="item-title">{{ $item->title_en ?? $item->title_ar }}</span>
                                    <span class="item-date"><i
                                            class="fas fa-box-open"></i> {{ $item->created_at }}</span>
                                </div>
                            </a>
                        @endforeach
                    </div>
                </div>
            @endif

        </div>

    </div>
@endsection

@section('scripts')
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://kit.fontawesome.com/a2d9d5e64c.js" crossorigin="anonymous"></script>
    <script>
        const ctx = document.getElementById('activityChart').getContext('2d');
        const activityChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: {!! json_encode($months) !!},
                datasets: [
                        @if(in_array('blogs', $tenantOptions) && auth()->user()->hasPermission('manage_blogs'))
                    {
                        label: 'Blogs',
                        data: {!! json_encode($blogsPerMonth) !!},
                        backgroundColor: '#1877F2',
                        borderRadius: 10,
                        barThickness: 25
                    },
                        @endif

                        @if(in_array('offers', $tenantOptions))
                    {
                        label: 'Offers',
                        data: {!! json_encode($offersPerMonth) !!},
                        backgroundColor: '#0F9D58',
                        borderRadius: 10,
                        barThickness: 25
                    },
                        @endif

                        @if(in_array('items', $tenantOptions) && auth()->user()->hasPermission('manage_trips'))
                    {
                        label: 'Trips',
                        data: {!! json_encode($itemsPerMonth) !!},
                        backgroundColor: '#FFC107',
                        borderRadius: 10,
                        barThickness: 25
                    },
                        @endif
                        @if(in_array('orders', $tenantOptions) && auth()->user()->hasPermission('manage_payments'))
                    {
                        label: 'Orders',
                        data: {!! json_encode($ordersPerMonth) !!},
                        backgroundColor: '#dc3545',
                        borderRadius: 10,
                        barThickness: 25
                    }
                    @endif
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {legend: {position: 'top'}, tooltip: {mode: 'index', intersect: false}},
                interaction: {mode: 'nearest', intersect: false},
                scales: {
                    x: {
                        grid: {display: false},
                        stacked: false
                    },
                    y: {
                        beginAtZero: true,
                        grid: {color: '#e9ecef'}
                    }
                }

            }
        });
    </script>
@endsection
