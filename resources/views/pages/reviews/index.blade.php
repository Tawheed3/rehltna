@extends('layouts.app')

@push('styles')
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
<style>
.select2-container .select2-selection--single { height: 38px !important; border: 1px solid #ced4da; display: flex; align-items: center; border-radius: 6px; }
.select2-container--default .select2-selection--single .select2-selection__arrow { height: 36px !important; }
.select2-container--default .select2-selection--single .select2-selection__rendered { line-height: 36px !important; padding-left: 12px; }
</style>
@endpush

@section('content')
<div class="container-fluid">

    {{-- Header --}}
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="fw-bold mb-0">Reviews</h2>
            <small class="text-muted">Manage customer trip reviews</small>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createReviewModal">
            <i class="fe fe-plus me-1"></i> Add Review
        </button>
    </div>

    {{-- Alerts --}}
    @if(session('success'))
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            {{ session('success') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    @endif

    {{-- Filters --}}
    <div class="card mb-4 border-0 shadow-sm">
        <div class="card-body">
            <form method="GET" action="{{ route('reviews.index') }}" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label fw-semibold text-muted small">Search by Name</label>
                    <input type="text" name="search" class="form-control" placeholder="Reviewer name..." value="{{ request('search') }}">
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold text-muted small">Status</label>
                    <select name="status" class="form-select">
                        <option value="">All</option>
                        <option value="pending" {{ request('status') === 'pending' ? 'selected' : '' }}>Pending</option>
                        <option value="approved" {{ request('status') === 'approved' ? 'selected' : '' }}>Approved</option>
                        <option value="rejected" {{ request('status') === 'rejected' ? 'selected' : '' }}>Rejected</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-secondary w-100">Filter</button>
                </div>
                <div class="col-md-2">
                    <a href="{{ route('reviews.index') }}" class="btn btn-outline-secondary w-100">Reset</a>
                </div>
            </form>
        </div>
    </div>

    {{-- Table --}}
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Reviewer</th>
                            <th>Trip</th>
                            <th>Rating</th>
                            <th>Comment</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($reviews as $review)
                        <tr>
                            <td class="text-muted small">{{ $review->id }}</td>
                            <td class="fw-semibold">{{ $review->reviewer_name }}</td>
                            <td class="text-muted small">
                                {{ $review->item?->title_ar ?? $review->item?->title_en ?? '—' }}
                            </td>
                            <td>
                                <span style="color:#f59e0b;font-size:16px;letter-spacing:1px;">
                                    @for($i = 1; $i <= 5; $i++)
                                        {{ $i <= $review->rating ? '★' : '☆' }}
                                    @endfor
                                </span>
                                <small class="text-muted">({{ $review->rating }}/5)</small>
                            </td>
                            <td class="text-muted small" style="max-width:200px;">
                                {{ $review->comment ? Str::limit($review->comment, 80) : '—' }}
                            </td>
                            <td>
                                @if($review->is_admin_created)
                                    <span class="badge bg-purple text-white" style="background:#7c3aed!important;">Admin</span>
                                @else
                                    <span class="badge bg-light text-dark">Customer</span>
                                @endif
                            </td>
                            <td>
                                @if($review->status === 'approved')
                                    <span class="badge bg-success">Approved</span>
                                @elseif($review->status === 'pending')
                                    <span class="badge bg-warning text-dark">Pending</span>
                                @else
                                    <span class="badge bg-danger">Rejected</span>
                                @endif
                            </td>
                            <td class="text-muted small">{{ $review->created_at->format('d M Y') }}</td>
                            <td>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-sm btn-primary btn-edit-review"
                                        title="Edit"
                                        data-id="{{ $review->id }}"
                                        data-item-id="{{ $review->item_id ?? '' }}"
                                        data-name="{{ $review->reviewer_name }}"
                                        data-rating="{{ $review->rating }}"
                                        data-comment="{{ $review->comment ?? '' }}"
                                        data-status="{{ $review->status }}">
                                        <i class="fe fe-edit"></i>
                                    </button>
                                    @if($review->status !== 'approved')
                                        <form method="POST" action="{{ route('reviews.approve', $review->id) }}">
                                            @csrf @method('PATCH')
                                            <button class="btn btn-sm btn-success" title="Approve">✓</button>
                                        </form>
                                    @endif
                                    @if($review->status !== 'rejected')
                                        <form method="POST" action="{{ route('reviews.reject', $review->id) }}">
                                            @csrf @method('PATCH')
                                            <button class="btn btn-sm btn-warning" title="Reject">✕</button>
                                        </form>
                                    @endif
                                    <form method="POST" action="{{ route('reviews.destroy', $review->id) }}"
                                          onsubmit="return confirm('Delete this review?')">
                                        @csrf @method('DELETE')
                                        <button class="btn btn-sm btn-danger" title="Delete">
                                            <i class="fe fe-trash-2"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="9" class="text-center text-muted py-5">No reviews found.</td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
        @if($reviews->hasPages())
        <div class="card-footer bg-transparent border-0">
            {{ $reviews->links() }}
        </div>
        @endif
    </div>
</div>

{{-- Create Review Modal --}}
<div class="modal fade" id="createReviewModal" tabindex="-1">
    <div class="modal-dialog">
        <form method="POST" action="{{ route('reviews.store') }}">
            @csrf
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add Review on Behalf</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Trip <span class="text-muted small">(optional — leave empty for general review)</span></label>
                        <select name="item_id" id="tripSelect" class="form-select" style="width:100%">
                            <option value="">-- General Review (no specific trip) --</option>
                            @foreach($items as $item)
                                <option value="{{ $item->id }}">
                                    {{ $item->title_ar ?: $item->title_en }}
                                    @if($item->season) — {{ $item->season }} @endif
                                </option>
                            @endforeach
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Reviewer Name <span class="text-danger">*</span></label>
                        <input type="text" name="reviewer_name" class="form-control" required placeholder="e.g. Ahmed Ali">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Rating <span class="text-danger">*</span></label>
                        <select name="rating" class="form-select" required>
                            <option value="">-- Select Rating --</option>
                            <option value="5">★★★★★ (5/5)</option>
                            <option value="4">★★★★☆ (4/5)</option>
                            <option value="3">★★★☆☆ (3/5)</option>
                            <option value="2">★★☆☆☆ (2/5)</option>
                            <option value="1">★☆☆☆☆ (1/5)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Comment</label>
                        <textarea name="comment" class="form-control" rows="3" placeholder="Optional comment..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Review</button>
                </div>
            </div>
        </form>
    </div>
</div>
{{-- Edit Review Modal --}}
<div class="modal fade" id="editReviewModal" tabindex="-1">
    <div class="modal-dialog">
        <form method="POST" id="editReviewForm">
            @csrf @method('PUT')
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Edit Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Trip <span class="text-muted small">(optional)</span></label>
                        <select name="item_id" id="editTripSelect" class="form-select" style="width:100%">
                            <option value="">-- General Review (no specific trip) --</option>
                            @foreach($items as $item)
                                <option value="{{ $item->id }}">
                                    {{ $item->title_ar ?: $item->title_en }}
                                    @if($item->season) — {{ $item->season }} @endif
                                </option>
                            @endforeach
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Reviewer Name <span class="text-danger">*</span></label>
                        <input type="text" name="reviewer_name" id="editReviewerName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Rating <span class="text-danger">*</span></label>
                        <select name="rating" id="editRating" class="form-select" required>
                            <option value="5">★★★★★ (5/5)</option>
                            <option value="4">★★★★☆ (4/5)</option>
                            <option value="3">★★★☆☆ (3/5)</option>
                            <option value="2">★★☆☆☆ (2/5)</option>
                            <option value="1">★☆☆☆☆ (1/5)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Status <span class="text-danger">*</span></label>
                        <select name="status" id="editStatus" class="form-select" required>
                            <option value="pending">Pending</option>
                            <option value="approved">Approved</option>
                            <option value="rejected">Rejected</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Comment</label>
                        <textarea name="comment" id="editComment" class="form-control" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </div>
        </form>
    </div>
</div>
@endsection

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
    $(document).ready(function () {
        $('#tripSelect').select2({
            dropdownParent: $('#createReviewModal'),
            placeholder: '-- ابحث عن رحلة --',
            allowClear: true,
            width: '100%',
        });
        $('#editTripSelect').select2({
            dropdownParent: $('#editReviewModal'),
            placeholder: '-- ابحث عن رحلة --',
            allowClear: true,
            width: '100%',
        });
    });

    $(document).on('click', '.btn-edit-review', function () {
        const btn = $(this);
        const id       = btn.data('id');
        const itemId   = btn.data('item-id');
        const name     = btn.data('name');
        const rating   = btn.data('rating');
        const comment  = btn.data('comment');
        const status   = btn.data('status');

        $('#editReviewForm').attr('action', '/admin/reviews/' + id);
        $('#editReviewerName').val(name);
        $('#editRating').val(rating);
        $('#editComment').val(comment);
        $('#editStatus').val(status);
        $('#editTripSelect').val(itemId || '').trigger('change');

        new bootstrap.Modal(document.getElementById('editReviewModal')).show();
    });
</script>
@endpush
