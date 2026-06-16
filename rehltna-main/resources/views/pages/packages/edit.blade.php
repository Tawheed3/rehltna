@extends('layouts.app')

@section('styles')
    <style>
        .card-deluxe {
            border-radius: 24px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.03);
            border: none;
        }

        .form-control {
            border-radius: 14px;
            padding: 12px 18px;
            background: #f8fafc;
            border: 2px solid #f1f5f9;
        }

        .form-control:focus {
            background: #fff;
            border-color: #4f46e5;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        }

        .feature-row {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            padding: 15px;
            border-radius: 16px;
            margin-bottom: 15px;
        }
    </style>
@endsection

@section('content')
    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold">Edit Package: <span
                    class="text-primary">{{ $package->name_en ?? 'Package' }}</span></h4>
        </div>
    </div>

    <div class="card card-deluxe">
        <div class="card-body p-4">
            <form action="{{ route('packages.update', $package->id) }}" method="POST">
                @csrf
                @method('PUT')

                <div class="row mb-4">
                    @foreach(get_active_langs() as $lang)
                        <div class="col-md-3 mb-3">
                            <label class="fw-bold mb-2">Name ({{ strtoupper($lang) }}) <span
                                    class="text-danger">*</span></label>
                            <input type="text" name="name_{{ $lang }}" class="form-control"
                                   value="{{ old('name_'.$lang, $package->{'name_'.$lang}) }}" required>
                        </div>
                    @endforeach

                    <div class="col-md-2 mb-3">
                        <label class="fw-bold mb-2">Price ($) <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" name="price" class="form-control"
                               value="{{ old('price', $package->price) }}" required>
                    </div>

                    <div class="col-md-2 mb-3">
                        <label class="fw-bold mb-2">Points Multiplier</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light fw-bold">X</span>
                            <input type="number" step="0.1" name="points_multiplier" class="form-control"
                                   value="{{ old('points_multiplier', $package->points_multiplier) }}" required>
                        </div>
                    </div>

                    <div class="col-md-2 mb-3">
                        <label class="fw-bold mb-2">Icon <span class="text-danger">*</span></label>
                        <select name="icon" class="form-select fw-bold" required>
                            <option value="fas fa-cube" {{ $package->icon == 'fas fa-cube' ? 'selected' : '' }}>📦 Box
                            </option>
                            <option value="fas fa-star" {{ $package->icon == 'fas fa-star' ? 'selected' : '' }}>⭐ Star
                            </option>
                            <option value="fas fa-medal" {{ $package->icon == 'fas fa-medal' ? 'selected' : '' }}>🏅
                                Medal
                            </option>
                            <option value="fas fa-crown" {{ $package->icon == 'fas fa-crown' ? 'selected' : '' }}>👑
                                Crown
                            </option>
                            <option value="fas fa-gem" {{ $package->icon == 'fas fa-gem' ? 'selected' : '' }}>💎 Gem
                            </option>
                            <option value="fas fa-trophy" {{ $package->icon == 'fas fa-trophy' ? 'selected' : '' }}>🏆
                                Trophy
                            </option>
                            <option value="fas fa-rocket" {{ $package->icon == 'fas fa-rocket' ? 'selected' : '' }}>🚀
                                Rocket
                            </option>
                            <option
                                value="fas fa-shield-alt" {{ $package->icon == 'fas fa-shield-alt' ? 'selected' : '' }}>
                                🛡️ Shield
                            </option>
                            <option value="fas fa-bolt" {{ $package->icon == 'fas fa-bolt' ? 'selected' : '' }}>⚡ Bolt
                            </option>
                        </select>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-3 border-top pt-4">
                    <h5 class="fw-bold mb-0">Package Features</h5>
                    <button type="button" class="btn btn-outline-primary rounded-pill btn-sm" onclick="addFeatureRow()">
                        <i class="fas fa-plus me-1"></i> Add Feature
                    </button>
                </div>

                <div id="features-container">
                    @if(is_array($package->features) && count($package->features) > 0)
                        @foreach($package->features as $feature)
                            <div class="feature-row row align-items-center">
                                <div class="col-md-11">
                                    <div class="row">
                                        @foreach(get_active_langs() as $lang)
                                            <div class="col-md mt-2 mt-md-0">
                                                <input type="text" name="feature_{{ $lang }}[]"
                                                       class="form-control bg-white" value="{{ $feature[$lang] ?? '' }}"
                                                       placeholder="Feature ({{ strtoupper($lang) }})">
                                            </div>
                                        @endforeach
                                    </div>
                                </div>
                                <div class="col-md-1 text-center mt-3 mt-md-0">
                                    <button type="button"
                                            class="btn btn-light text-danger rounded-circle remove-feature"><i
                                            class="fas fa-trash"></i></button>
                                </div>
                            </div>
                        @endforeach
                    @else
                        <div class="feature-row row align-items-center">
                            <div class="col-md-11">
                                <div class="row">
                                    @foreach(get_active_langs() as $lang)
                                        <div class="col-md mt-2 mt-md-0">
                                            <input type="text" name="feature_{{ $lang }}[]"
                                                   class="form-control bg-white"
                                                   placeholder="Feature ({{ strtoupper($lang) }})">
                                        </div>
                                    @endforeach
                                </div>
                            </div>
                            <div class="col-md-1 text-center mt-3 mt-md-0">
                                <button type="button" class="btn btn-light text-danger rounded-circle remove-feature"><i
                                        class="fas fa-trash"></i></button>
                            </div>
                        </div>
                    @endif
                </div>

                <div class="mt-4 pt-3 text-end">
                    <a href="{{ route('packages.index') }}" class="btn btn-light rounded-pill px-4 me-2">Cancel</a>
                    <button type="submit" class="btn btn-primary rounded-pill px-5"><i class="fas fa-sync-alt me-1"></i>
                        Update Package
                    </button>
                </div>
            </form>
        </div>
    </div>
@endsection

@section('scripts')
    <script>
        let featureRowTemplate = `
            <div class="feature-row row align-items-center" style="display:none;">
                <div class="col-md-11">
                    <div class="row">
                        @foreach(get_active_langs() as $lang)
        <div class="col-md mt-2 mt-md-0">
            <input type="text" name="feature_{{ $lang }}[]" class="form-control bg-white" placeholder="Feature ({{ strtoupper($lang) }})">
                                            </div>
                                        @endforeach
        </div>
    </div>
    <div class="col-md-1 text-center mt-3 mt-md-0">
        <button type="button" class="btn btn-light text-danger rounded-circle remove-feature"><i class="fas fa-trash"></i></button>
    </div>
</div>
`;

        function addFeatureRow() {
            $('#features-container').append(featureRowTemplate);
            $('.feature-row').last().fadeIn(300);
        }

        $(document).on('click', '.remove-feature', function () {
            if ($('.feature-row').length > 1) {
                $(this).closest('.feature-row').fadeOut(300, function () {
                    $(this).remove();
                });
            } else {
                $(this).closest('.feature-row').find('input').val('');
            }
        });
    </script>
@endsection
