{{-- Create Modal --}}
<style>
    /* Custom Modal Deluxe Styling */
    .custom-modal-content {
        border: none;
        border-radius: 24px;
        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.1);
    }

    .custom-modal-header {
        border-bottom: 1px solid #f1f5f9;
        padding: 25px 30px 20px;
    }

    .custom-modal-body {
        padding: 25px 30px;
    }

    .custom-modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 20px 30px 25px;
        background-color: #f8fafc;
        border-bottom-left-radius: 24px;
        border-bottom-right-radius: 24px;
    }

    /* Input Styling */
    .custom-input {
        border-radius: 12px;
        border: 1px solid #e2e8f0;
        padding: 12px 18px;
        background-color: #f8fafc;
        color: #334155;
        transition: all 0.3s ease;
        font-weight: 500;
    }

    .custom-input:focus {
        background-color: #ffffff;
        border-color: #4f46e5;
        box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        outline: none;
    }

    .custom-label {
        font-weight: 700;
        color: #475569;
        font-size: 0.9rem;
        margin-bottom: 10px;
    }

    /* Button Styling */
    .btn-modal-save {
        background-color: #4f46e5;
        color: #fff;
        border-radius: 12px;
        padding: 10px 28px;
        font-weight: 700;
        border: none;
        transition: all 0.3s ease;
    }

    .btn-modal-save:hover {
        background-color: #4338ca;
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(79, 70, 229, 0.25);
        color: #fff;
    }

    .btn-modal-cancel {
        background-color: #e2e8f0;
        color: #475569;
        border-radius: 12px;
        padding: 10px 24px;
        font-weight: 700;
        border: none;
        transition: all 0.3s ease;
    }

    .btn-modal-cancel:hover {
        background-color: #cbd5e1;
        color: #1e293b;
    }

    /* Custom Select Styling */
    .custom-select {
        border-radius: 12px;
        border: 1px solid #e2e8f0;
        padding-top: 12px;
        padding-bottom: 12px;
        background-color: #f8fafc;
        color: #334155;
        transition: all 0.3s ease;
        font-weight: 500;
        cursor: pointer;
        height: auto !important;
        min-height: 48px;
    }

    .custom-select:focus {
        background-color: #ffffff;
        border-color: #4f46e5;
        box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        outline: none;
    }
</style>
<div class="modal fade" id="CityCreate" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form action="{{ route('cities.store') }}" method="POST" class="w-100">
            @csrf
            <div class="modal-content custom-modal-content">

                <div class="modal-header custom-modal-header d-flex justify-content-between align-items-center">
                    <h5 class="modal-title fw-bold" style="color: #1e293b; font-size: 1.3rem;">
                        <i class="fas fa-city me-2" style="color: #4f46e5;"></i> Add New City
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body custom-modal-body">
                    {{-- Select Country --}}
                    <div class="mb-4">
                        <label class="form-label custom-label">Country</label>
                        <select name="country_id" class="form-select custom-select">
                            <option value="" selected disabled>-- Select Country --</option>
                            @foreach($countries as $country)
                                <option value="{{ $country->id }}">{{ $country->title_en }}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="form-label custom-label">State / Region</label>
                        <select name="state_id" class="form-select custom-select">
                            <option value="" selected disabled>-- Choose a State --</option>
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
                            <input type="text" name="title_en" class="form-control custom-input"
                                   placeholder="e.g. New York" required>
                        </div>
                    @endif

                    @if(hasArabic())
                        <div class="mb-4">
                            <label class="form-label custom-label">City Name (Arabic)</label>
                            <input type="text" name="title_ar" class="form-control custom-input"
                                   placeholder="مثال: نيويورك" required dir="rtl">
                        </div>
                    @endif

                    <div class="mb-2">
                        <label class="form-label custom-label">Status</label>
                        <select name="status" class="form-select custom-select" required>
                            <option value="1">Active & Visible</option>
                            <option value="0">Inactive (Hidden)</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer custom-modal-footer d-flex justify-content-end gap-2">
                    <button type="button" class="btn-modal-cancel" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-modal-save">
                        <i class="fas fa-save me-1"></i> Save City
                    </button>
                </div>

            </div>
        </form>
    </div>
</div>
