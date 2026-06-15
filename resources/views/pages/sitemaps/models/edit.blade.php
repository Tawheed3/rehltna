<style>
    /* Deluxe Edit Modal Styling */
    .modal-edit-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
    }

    .modal-edit-deluxe .modal-header {
        background: #fffaf5;
        border-bottom: 1px solid #fef3c7;
        padding: 25px 30px;
    }

    .modal-edit-deluxe .modal-body {
        padding: 35px 30px;
    }

    /* Form Control Focus for Edit */
    .modal-edit-deluxe .form-control {
        border-radius: 14px;
        padding: 12px 18px;
        border: 2px solid #f1f5f9;
        background: #f8fafc;
        transition: all 0.3s ease;
        font-weight: 600;
    }

    .modal-edit-deluxe .form-control:focus {
        border-color: #f59e0b; /* Amber/Orange color for Edit focus */
        background: #fff;
        box-shadow: 0 0 0 4px rgba(245, 158, 11, 0.1);
        outline: none;
    }

    .modal-edit-deluxe .modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 20px 30px 30px;
        gap: 12px;
    }

    /* Update Button Animation */
    .btn-update-deluxe {
        background: #f59e0b !important; /* Amber color */
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 30px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-update-deluxe:hover {
        background: #d97706 !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(245, 158, 11, 0.2);
    }
</style>

<div class="modal fade" id="editModel" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-edit-deluxe">
            <form method="POST" id="editForm">
                @method('put')
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div
                            style="background: rgba(245, 158, 11, 0.12); padding: 10px; border-radius: 12px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-pen-fancy" style="color: #f59e0b; font-size: 1.5rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0" style="font-weight: 800; color: #1e293b; letter-spacing: -0.5px;">
                            Update SiteMap</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-0">
                        <label for="edit-name" class="form-label"
                               style="font-weight: 700; color: #475569; font-size: 0.9rem; margin-bottom: 10px; display: block;">
                            SiteMap Display Name
                        </label>
                        <input type="text" name="name" id="edit-name"
                               class="form-control"
                               placeholder="Enter new name..."
                               required>
                        <small class="text-muted mt-2 d-block">Modify the sitemap name as it appears in the system
                            records.</small>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold"
                            style="background: #f1f5f9; color: #64748b; border: none; border-radius: 14px; padding: 12px 25px;"
                            data-bs-dismiss="modal">
                        Discard
                    </button>
                    <button type="submit" class="btn btn-update-deluxe shadow-sm">
                        <i class="las la-sync-alt me-2"></i> Update SiteMap
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
