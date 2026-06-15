<style>
    /* Deluxe Marketing Modal Styling */
    .modal-marketing-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
    }

    .modal-marketing-deluxe .modal-header {
        background: #f0fdf4;
        border-bottom: 1px solid #dcfce7;
        padding: 25px 30px;
    }

    .modal-marketing-deluxe .modal-title {
        font-weight: 800;
        color: #166534;
        letter-spacing: -0.5px;
    }

    /* Input & Select Fix - Preventing Text Clipping */
    .modal-marketing-deluxe .form-control {
        border-radius: 14px;
        padding: 12px 18px !important;
        border: 2px solid #f1f5f9;
        background: #f8fafc;
        transition: all 0.3s ease;
        font-weight: 600;
        color: #1e293b;
        line-height: 1.6 !important;
        height: auto !important;
        vertical-align: middle !important;
    }

    .modal-marketing-deluxe .form-control:focus {
        border-color: #10b981;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        outline: none;
    }

    .btn-save-marketing {
        background: #10b981 !important;
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 30px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-save-marketing:hover {
        background: #059669 !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(16, 185, 129, 0.2);
    }
</style>
<div class="modal fade" id="LeadMagnetTypeCreate" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-marketing-deluxe">
            <form action="{{ route('lead-magnet-types.store') }}" method="POST">
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div
                            style="background: rgba(16, 185, 129, 0.12); padding: 12px; border-radius: 14px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-tags" style="color: #10b981; font-size: 1.6rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0">Add Magnet Type</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    @foreach(get_active_langs() as $lang)
                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted small text-uppercase">Name
                                ({{ strtoupper($lang) }})</label>
                            <input type="text" name="name_{{ $lang }}" id="name_{{ $lang }}"
                                   class="form-control" placeholder="e.g. PDF Guide, Video Course..." required>
                        </div>
                    @endforeach
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold"
                            style="border-radius: 14px; padding: 12px 25px;" data-bs-dismiss="modal">Cancel
                    </button>
                    <button type="submit" class="btn btn-save-marketing shadow-sm">
                        <i class="las la-check-circle me-2"></i> Save Type
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
