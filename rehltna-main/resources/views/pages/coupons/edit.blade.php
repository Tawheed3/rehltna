@extends('layouts.app')

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Edit Coupon</span>
            </div>
        </div>
    </div>

    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-body">
                    <form action="{{ route('coupons.update', $coupon->id) }}" method="POST">
                        @csrf
                        @method('PUT')

                        <div class="row">
                            {{-- Coupon Code --}}
                            <div class="col-md-6 mb-3">
                                <label>Coupon Code <span class="text-danger">*</span></label>
                                <input type="text" name="code" class="form-control"
                                       value="{{ old('code', $coupon->code) }}" required>
                                @error('code') <span class="text-danger tx-12">{{ $message }}</span> @enderror
                            </div>

                            {{-- Type --}}
                            <div class="col-md-3 mb-3">
                                <label>Type <span class="text-danger">*</span></label>
                                <select name="type" class="form-control" required>
                                    <option
                                        value="percent" {{ old('type', $coupon->type) == 'percent' ? 'selected' : '' }}>
                                        Percentage (%)
                                    </option>
                                    <option value="fixed" {{ old('type', $coupon->type) == 'fixed' ? 'selected' : '' }}>
                                        Fixed Amount
                                    </option>
                                </select>
                            </div>

                            {{-- Value --}}
                            <div class="col-md-3 mb-3">
                                <label>Value <span class="text-danger">*</span></label>
                                <input type="number" step="0.01" name="value" class="form-control"
                                       value="{{ old('value', $coupon->value) }}" required>
                            </div>

                            {{-- Usage Limit --}}
                            <div class="col-md-4 mb-3">
                                <label>Usage Limit (Optional)</label>
                                <input type="number" name="usage_limit" class="form-control"
                                       value="{{ old('usage_limit', $coupon->usage_limit) }}">
                                <small class="text-muted">Leave empty for unlimited usage.</small>
                            </div>

                            {{-- Expiry Date --}}
                            <div class="col-md-4 mb-3">
                                <label>Expiry Date (Optional)</label>
                                <input type="date" name="expires_at" class="form-control"
                                       value="{{ old('expires_at', $coupon->expires_at) }}">
                            </div>

                            {{-- Status --}}
                            <div class="col-md-4 mb-3">
                                <label>Status</label>
                                <select name="status" class="form-control">
                                    <option value="1" {{ $coupon->status == 1 ? 'selected' : '' }}>Active</option>
                                    <option value="0" {{ $coupon->status == 0 ? 'selected' : '' }}>Inactive</option>
                                </select>
                            </div>

                            {{-- Items Selection --}}
                            <div class="col-md-12 mb-3">
                                <label>Applicable Items (Optional)</label>
                                <select name="items[]" class="form-control select2" multiple="multiple">
                                    @foreach($items as $item)
                                        <option value="{{ $item->id }}"
                                            {{ (in_array($item->id, old('items', $selectedItems ?? []))) ? 'selected' : '' }}>
                                            {{ $item->title_ar ?: $item->title_en }}@if($item->season) — {{ $item->season }}@endif
                                        </option>
                                    @endforeach
                                </select>
                                <small class="text-muted">Leave empty to apply to all items.</small>
                            </div>

                        </div>

                        <button type="submit" class="btn btn-primary mt-3">Update Coupon</button>
                        <a href="{{ route('coupons.index') }}" class="btn btn-secondary mt-3">Cancel</a>
                    </form>
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
