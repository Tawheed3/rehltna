@extends('layouts.app')

@section('styles')
    <style>
        body { background-color: #f8fafc; }
        .custom-card { border: none; border-radius: 24px; box-shadow: 0 10px 40px rgba(0,0,0,0.03); }
        .perm-group-title { font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: #64748b; margin-bottom: 12px; }
        .perm-card { transition: all 0.3s; border: 1px solid #e2e8f0; border-radius: 12px; cursor: pointer; user-select: none; }
        .perm-card:hover { border-color: #0d6efd; box-shadow: 0 5px 15px rgba(13,110,253,0.1); transform: translateY(-2px); }
        .perm-card.is-checked { border-color: #198754 !important; background-color: #f4fbf8 !important; }
        .perm-card.is-checked .card-text-label { color: #198754 !important; }
    </style>
@endsection

@section('content')
    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto"><h4 class="content-title mb-0 fw-bold">Edit Role: {{ $role->name }}</h4></div>
    </div>

    <div class="card custom-card">
        <div class="card-body p-4">
            <form action="{{ route('roles.update', $role->id) }}" method="POST">
                @csrf
                @method('PUT')
                <div class="mb-5">
                    <label class="form-label fw-bold fs-15">Role Name <span class="text-danger">*</span></label>
                    <input type="text" name="name" class="form-control form-control-lg bg-light border-0"
                           value="{{ $role->name }}" required>
                </div>

                <h5 class="fw-bold mb-4 border-bottom pb-3">
                    <i class="las la-shield-alt text-primary me-2"></i> Assign Permissions
                </h5>

                @foreach($permissions as $groupName => $groupPerms)
                    <div class="mb-4">
                        <div class="perm-group-title">{{ $groupName }}</div>
                        <div class="row">
                            @foreach($groupPerms as $key => $label)
                                <div class="col-xl-3 col-lg-4 col-md-6 mb-3">
                                    <div class="card perm-card bg-white h-100">
                                        <div class="card-body p-3 d-flex align-items-center justify-content-between">
                                            <span class="fw-bold text-secondary card-text-label">{{ $label }}</span>
                                            <label class="aiz-switch aiz-switch-success mb-0">
                                                <input type="checkbox" name="permissions[]" class="perm-checkbox"
                                                       value="{{ $key }}" {{ in_array($key, $role->permissions ?? []) ? 'checked' : '' }}>
                                                <span class="slider round"></span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            @endforeach
                        </div>
                    </div>
                    @if(!$loop->last)
                        <hr class="my-2">
                    @endif
                @endforeach

                <div class="mt-5 text-end border-top pt-4">
                    <a href="{{ route('roles.index') }}" class="btn btn-light px-4 me-2 fw-bold">Cancel</a>
                    <button type="submit" class="btn btn-primary px-5 fw-bold">
                        <i class="fas fa-save me-1"></i> Update Role
                    </button>
                </div>
            </form>
        </div>
    </div>
@endsection

@section('scripts')
    <script>
        $(document).ready(function () {
            $('.perm-checkbox:checked').each(function () {
                $(this).closest('.perm-card').addClass('is-checked');
            });
            $('.perm-card').on('click', function (e) {
                if ($(e.target).closest('.aiz-switch').length === 0) {
                    let checkbox = $(this).find('.perm-checkbox');
                    checkbox.prop('checked', !checkbox.prop('checked')).trigger('change');
                }
            });
            $('.perm-checkbox').on('change', function () {
                $(this).closest('.perm-card').toggleClass('is-checked', $(this).is(':checked'));
            });
        });
    </script>
@endsection
