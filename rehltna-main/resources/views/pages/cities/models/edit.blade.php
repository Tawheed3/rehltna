{{-- Edit Modal --}}
<div class="modal fade" id="editCityModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form method="POST" id="editCityForm" class="w-100">
            @method('put')
            @csrf
            <div class="modal-content custom-modal-content">

                <div class="modal-header custom-modal-header d-flex justify-content-between align-items-center">
                    <h5 class="modal-title fw-bold" style="color: #1e293b; font-size: 1.3rem;">
                        <i class="fas fa-edit me-2" style="color: #4f46e5;"></i> Update City
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body custom-modal-body">
                    {{-- Select Country for Edit --}}
                    <div class="mb-4">
                        <label class="form-label custom-label">Country</label>
                        <select name="country_id" id="edit-country_id" class="form-select custom-select">
                            <option value="" disabled>-- Select Country --</option>
                            @foreach($countries as $country)
                                <option value="{{ $country->id }}">{{ $country->title_en }}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="form-label custom-label">State / Region</label>
                        <select name="state_id" id="edit-state_id" class="form-select custom-select">
                            @foreach($states as $state)
                                <option value="{{ $state->id }}">
                                    {{ $state->title_en }} ({{ $state->country->title_en ?? 'N/A' }})
                                </option>
                            @endforeach
                        </select>
                    </div>

                    @if(hasEnglish())
                        <div class="mb-4">
                            <label class="form-label custom-label">City Name (English)</label>
                            <input type="text" name="title_en" id="edit-title_en" class="form-control custom-input"
                                   placeholder="e.g. New York" required>
                        </div>
                    @endif

                    @if(hasArabic())
                        <div class="mb-4">
                            <label class="form-label custom-label">City Name (Arabic)</label>
                            <input type="text" name="title_ar" id="edit-title_ar" class="form-control custom-input"
                                   placeholder="مثال: نيويورك" required dir="rtl">
                        </div>
                    @endif

                    <div class="mb-2">
                        <label class="form-label custom-label">Status</label>
                        <select name="status" id="edit-status" class="form-select custom-select" required>
                            <option value="1">Active & Visible</option>
                            <option value="0">Inactive (Hidden)</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer custom-modal-footer d-flex justify-content-end gap-2">
                    <button type="button" class="btn-modal-cancel" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-modal-save">
                        <i class="fas fa-sync-alt me-1"></i> Update City
                    </button>
                </div>

            </div>
        </form>
    </div>
</div>
