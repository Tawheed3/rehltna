@extends('layouts.app')

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Create Coupon</span>
            </div>
        </div>
    </div>

    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-header pb-0">
                    <div class="card-body">

                        <form action="{{ route('coupons.store') }}" method="POST">
                            @csrf

                            <div class="row">
                                {{-- Coupon Code --}}
                                <div class="col-md-6 mb-3">
                                    <label>Coupon Code <span class="text-danger">*</span></label>
                                    <input type="text" name="code" class="form-control" placeholder="e.g. SUMMER2025"
                                           required value="{{ old('code') }}">
                                    @error('code') <span class="text-danger tx-12">{{ $message }}</span> @enderror
                                </div>

                                {{-- Type --}}
                                <div class="col-md-3 mb-3">
                                    <label>Type <span class="text-danger">*</span></label>
                                    <select name="type" class="form-control" required>
                                        <option value="percent" {{ old('type') == 'percent' ? 'selected' : '' }}>
                                            Percentage (%)
                                        </option>
                                        <option value="fixed" {{ old('type') == 'fixed' ? 'selected' : '' }}>Fixed
                                            Amount
                                        </option>
                                    </select>
                                </div>

                                {{-- Value --}}
                                <div class="col-md-3 mb-3">
                                    <label>Value <span class="text-danger">*</span></label>
                                    <input type="number" step="0.01" name="value" class="form-control"
                                           placeholder="e.g. 10 or 100" required value="{{ old('value') }}">
                                </div>

                                {{-- Usage Limit --}}
                                <div class="col-md-4 mb-3">
                                    <label>Usage Limit (Optional)</label>
                                    <input type="number" name="usage_limit" class="form-control"
                                           placeholder="Total times allowed" value="{{ old('usage_limit') }}">
                                    <small class="text-muted">Leave empty for unlimited usage.</small>
                                </div>

                                {{-- Expiry Date --}}
                                <div class="col-md-4 mb-3">
                                    <label>Expiry Date (Optional)</label>
                                    <input type="date" name="expires_at" class="form-control"
                                           value="{{ old('expires_at') }}">
                                </div>

                                {{-- Status --}}
                                <div class="col-md-4 mb-3">
                                    <label>Status</label>
                                    <select name="status" class="form-control">
                                        <option value="1" selected>Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>

                                {{-- Items Selection --}}
                                <div class="col-md-12 mb-3">
                                    <label>Applicable Items (Optional)</label>
                                    <select name="items[]" class="form-control select2" multiple="multiple">
                                        @foreach($items as $item)
                                            <option
                                                value="{{ $item->id }}" {{ (collect(old('items'))->contains($item->id)) ? 'selected' : '' }}>
                                                {{ $item->title_ar ?: $item->title_en }}@if($item->season) — {{ $item->season }}@endif
                                            </option>
                                        @endforeach
                                    </select>
                                    <small class="text-muted">Leave empty to apply to all items (Global Coupon).</small>
                                </div>

                            </div>

                            <button class="btn btn-primary mt-3" type="submit">Create Coupon</button>
                            <a href="{{ route('coupons.index') }}" class="btn btn-secondary mt-3">Cancel</a>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>

@endsection
@section('scripts')
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <script>
        $(document).ready(function () {
            $('.select2').select2({
                placeholder: "Select items",
                allowClear: true,
                width: '100%'
            });
        });
    </script>
@endsection
