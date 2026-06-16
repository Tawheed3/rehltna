<style>
    /* Deluxe Create Modal Styling */
    .modal-create-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
    }

    .modal-create-deluxe .modal-header {
        background: #f8fafc;
        border-bottom: 1px solid #e2e8f0;
        padding: 25px 30px;
    }

    .modal-create-deluxe .modal-title {
        font-weight: 800;
        color: #1e293b;
        letter-spacing: -0.5px;
    }

    .modal-create-deluxe .modal-body {
        padding: 35px 30px;
    }

    /* Form Styling Inside Modal */
    .modal-create-deluxe .form-label {
        font-weight: 700;
        color: #475569;
        font-size: 0.9rem;
        margin-bottom: 10px;
        display: block;
    }

    .modal-create-deluxe .form-control {
        border-radius: 14px;
        padding: 12px 18px;
        border: 2px solid #f1f5f9;
        background: #f8fafc;
        transition: all 0.3s ease;
        font-weight: 600;
    }

    .modal-create-deluxe .form-control:focus {
        border-color: #4f46e5;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        outline: none;
    }

    .modal-create-deluxe .modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 20px 30px 30px;
        gap: 12px;
    }

    /* Button Animations */
    .btn-save-deluxe {
        background: #4f46e5 !important;
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 30px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-save-deluxe:hover {
        background: #4338ca !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(79, 70, 229, 0.2);
    }

    .btn-cancel-deluxe {
        background: #f1f5f9 !important;
        color: #64748b !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 25px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }
</style>

<div class="modal fade" id="SiteMapCreate" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-create-deluxe">
            <form action="{{ route('sitemaps.store') }}" method="POST">
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div style="background: rgba(79, 70, 229, 0.12); padding: 10px; border-radius: 12px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-plus-circle" style="color: #4f46e5; font-size: 1.5rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0" style="font-weight: 800; color: #1e293b;">Add New SiteMap</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-0">
                        <label for="name" class="form-label">SiteMap Entry Name</label>
                        <div class="input-group-custom">
                            <input type="text" name="name" id="name"
                                   class="form-control"
                                   placeholder="e.g. Products Sitemap"
                                   required>
                        </div>
                        <small class="text-muted mt-2 d-block">Give your sitemap a clear name to distinguish it later.</small>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel-deluxe" data-bs-dismiss="modal">
                        Discard
                    </button>
                    <button type="submit" class="btn btn-save-deluxe shadow-sm">
                        <i class="las la-save me-2"></i> Save SiteMap
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
