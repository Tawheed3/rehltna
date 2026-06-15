@extends('layouts.app')

@section('styles')
    <style>
        body {
            background-color: #f4f7fe;
        }

        .hero-section {
            background: linear-gradient(135deg, #111827 0%, #374151 100%);
            border-radius: 24px;
            padding: 45px 35px;
            margin-bottom: 40px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 20px 40px rgba(17, 24, 39, 0.15);
        }

        /* --- Deluxe Package Card --- */
        .package-card {
            background: #ffffff;
            border-radius: 28px;
            border: none;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: visible;
            height: 100%;
            display: flex;
            flex-direction: column;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
            z-index: 1;
        }

        .package-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.1);
        }

        /* Gradient Header per Package Type */
        .pkg-header {
            padding: 35px 25px 25px;
            position: relative;
            border-bottom: 1px solid #f1f5f9;
            border-radius: 28px 28px 0 0;
        }

        /* Colors based on index */
        .col-md-3:nth-child(1n) .pkg-header {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
        }

        /* Basic/Silver */
        .col-md-3:nth-child(2n) .pkg-header {
            background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);
        }

        /* Gold */
        .col-md-3:nth-child(3n) .pkg-header {
            background: linear-gradient(135deg, #faf5ff 0%, #f3e8ff 100%);
        }

        /* Platinum */

        .col-md-3:nth-child(1n) .pkg-icon-box i {
            color: #64748b;
        }

        .col-md-3:nth-child(2n) .pkg-icon-box i {
            color: #d97706;
        }

        .col-md-3:nth-child(3n) .pkg-icon-box i {
            color: #7e22ce;
        }

        .pkg-icon-box {
            width: 60px;
            height: 60px;
            background: #ffffff;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.05);
            font-size: 1.8rem;
            position: absolute;
            top: -20px;
            right: 25px;
        }

        .pkg-title {
            font-weight: 800;
            font-size: 1.6rem;
            color: #1e293b;
            margin-bottom: 5px;
            letter-spacing: -0.5px;
        }

        .pkg-subtitle {
            font-weight: 600;
            color: #64748b;
            font-size: 0.9rem;
            margin-bottom: 0;
        }

        .pkg-price-box {
            background: #ffffff;
            padding: 20px 25px;
            border-bottom: 1px dashed #e2e8f0;
        }

        .pkg-price {
            font-size: 3rem;
            font-weight: 900;
            color: #0f172a;
            line-height: 1;
            display: flex;
            align-items: flex-start;
        }

        .pkg-price span {
            font-size: 1.2rem;
            font-weight: 700;
            color: #94a3b8;
            margin-top: 5px;
            margin-right: 5px;
        }

        .pkg-features-wrap {
            padding: 25px;
            flex-grow: 1;
            background: #ffffff;
        }

        .package-features {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .package-features li {
            padding: 12px 0;
            color: #334155;
            font-size: 0.95rem;
            display: flex;
            align-items: flex-start;
            border-bottom: 1px solid #f8fafc;
        }

        .package-features li:last-child {
            border-bottom: none;
        }

        .feat-icon {
            color: #10b981;
            background: #d1fae5;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            margin-right: 12px;
            margin-top: 3px;
            flex-shrink: 0;
        }

        .lang-badge {
            font-size: 9px;
            padding: 2px 6px;
            border-radius: 4px;
            background: #e2e8f0;
            color: #475569;
            margin-right: 5px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .pkg-actions {
            padding: 20px 25px;
            background: #f8fafc;
            display: flex;
            gap: 12px;
            border-top: 1px solid #f1f5f9;
            border-radius: 0 0 28px 28px;
        }

        .btn-pkg {
            border-radius: 14px;
            font-weight: 700;
            padding: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            border: none;
        }

        .btn-pkg-edit {
            background: #e0e7ff;
            color: #4f46e5;
            width: 50%;
        }

        .btn-pkg-edit:hover {
            background: #4f46e5;
            color: #ffffff;
        }

        .btn-pkg-delete {
            background: #fee2e2;
            color: #ef4444;
            width: 50%;
        }

        .btn-pkg-delete:hover {
            background: #ef4444;
            color: #ffffff;
        }

    </style>
@endsection

@section('content')
    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; font-size: 1.8rem; letter-spacing: -0.5px;">
                Packages Hub</h4>
            <p class="text-muted mb-0 small fw-medium">Plans / <span class="text-primary">Subscriptions</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Manage Subscriptions Plans</h3>
            <p class="mb-0 opacity-75 fw-medium">Control pricing and features to scale your business.</p>
        </div>
        <div>
            <a href="{{ route('packages.create') }}" class="btn btn-light rounded-pill px-4 fw-bold shadow-sm"
               style="color: #111827; height: 50px; display: inline-flex; align-items: center; font-size: 0.95rem;">
                <i class="fas fa-plus-circle me-2 text-primary"></i> Create New Package
            </a>
        </div>
    </div>

    <div class="row" style="margin-top: 40px;">
        @forelse($packages as $package)
            <div class="col-md-3 mb-5">
                <div class="package-card">

                    {{-- Package Header (Gradient + Icon) --}}
                    <div class="pkg-header">
                        <div class="pkg-icon-box">
                            <i class="{{ $package->icon ?? 'fas fa-cube' }}"></i>
                        </div>

                        @foreach(get_active_langs() as $index => $lang)
                            @if($index === 0)
                                <h4 class="pkg-title">{{ $package->{'name_'.$lang} }}</h4>
                            @else
                                <p class="pkg-subtitle">{{ $package->{'name_'.$lang} }}</p>
                            @endif
                        @endforeach
                    </div>

                    {{-- Package Price --}}
                    <div class="pkg-price-box">
                        <div class="pkg-price">
                            <span>SAR</span>{{ number_format($package->price, 0) }}
                        </div>
                    </div>
                    {{-- Points Multiplier Badge --}}
                    <div class="text-center" style="margin-top: -15px;">
                        <span class="badge rounded-pill shadow-sm"
                              style="background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); color: #fff; font-size: 0.85rem; padding: 6px 15px; border: 2px solid #fff;">
                            <i class="fas fa-coins me-1"></i> {{ $package->points_multiplier }}x Points Multiplier
                        </span>
                    </div>
                    {{-- Package Features --}}
                    <div class="pkg-features-wrap">
                        <ul class="package-features">
                            @if(is_array($package->features) && count($package->features) > 0)
                                @foreach($package->features as $feature)
                                    <li>
                                        <div class="feat-icon"><i class="fas fa-check"></i></div>
                                        <div>
                                            @foreach(get_active_langs() as $lang)
                                                @if(!empty($feature[$lang]))
                                                    <div
                                                        class="{{ $loop->first ? 'fw-bold text-dark' : 'text-muted mt-1' }}"
                                                        style="font-size: {{ $loop->first ? '0.95rem' : '0.85rem' }};">
                                                        <span
                                                            class="lang-badge">{{ $lang }}</span> {{ $feature[$lang] }}
                                                    </div>
                                                @endif
                                            @endforeach
                                        </div>
                                    </li>
                                @endforeach
                            @else
                                <li class="text-muted fst-italic justify-content-center pt-4 pb-4">
                                    <i class="fas fa-info-circle me-2"></i> No features listed yet.
                                </li>
                            @endif
                        </ul>
                    </div>

                    {{-- Package Actions --}}
                    <div class="pkg-actions justify-content-center">
                        @if($package->name_en === 'Silver' || $package->price == 0)
                            <div class="w-100 text-center py-2 text-muted fw-bold d-flex align-items-center justify-content-center" style="background-color: #f1f5f9; border-radius: 12px; font-size: 0.95rem;">
                                <i class="fas fa-lock me-2"></i> Default Package (System Reserved)
                            </div>
                        @else
                            <a href="{{ route('packages.edit', encrypt($package->id)) }}" class="btn-pkg btn-pkg-edit">
                                <i class="las la-pen me-2 fs-5"></i> Edit
                            </a>

                            <button type="button" class="btn-pkg btn-pkg-delete delete-btn"
                                    data-route="{{ route('packages.destroy', $package->id) }}"
                                    data-bs-toggle="modal" href="#" data-bs-target="#deleteModal">
                                <i class="las la-trash me-2 fs-5"></i> Delete
                            </button>
                        @endif
                    </div>

                </div>
            </div>
        @empty
            <div class="col-12 text-center py-5 mt-4">
                <div class="mb-4">
                    <i class="fas fa-box-open" style="font-size: 5rem; color: #cbd5e1;"></i>
                </div>
                <h4 class="text-dark fw-bold mb-2">No packages available yet</h4>
                <p class="text-muted">Click the "Create New Package" button above to add your first subscription
                    plan.</p>
            </div>
        @endforelse
    </div>

    @include('pages.models.confirm-delete')

@endsection

@section('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            if (typeof confirmDelete === "function") {
                confirmDelete();
            }
        });
    </script>
@endsection
