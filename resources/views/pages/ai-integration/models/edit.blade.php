<style>
    /* Deluxe AI Edit Modal Styling */
    .modal-ai-edit-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
    }

    .modal-ai-edit-deluxe .modal-header {
        background: #f5f7ff;
        border-bottom: 1px solid #eef2ff;
        padding: 25px 30px;
    }

    .modal-ai-edit-deluxe .modal-body {
        padding: 30px 30px;
    }

    /* Form Elements Fix - Preventing Text Clipping */
    .modal-ai-edit-deluxe .form-label {
        font-weight: 700;
        color: #475569;
        font-size: 0.85rem;
        margin-bottom: 10px;
        display: block;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .modal-ai-edit-deluxe .form-control,
    .modal-ai-edit-deluxe .form-select {
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

    .modal-ai-edit-deluxe .form-control:focus,
    .modal-ai-edit-deluxe .form-select:focus {
        border-color: #4338ca;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(67, 56, 202, 0.1);
        outline: none;
    }

    /* Select Arrow Fix */
    .modal-ai-edit-deluxe .form-select {
        background-position: right 0.75rem center !important;
        padding-right: 40px !important;
    }

    .modal-ai-edit-deluxe .modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 20px 30px 30px;
        gap: 12px;
    }

    /* Update Button Animation */
    .btn-update-ai {
        background: #4338ca !important;
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 30px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-update-ai:hover {
        background: #3730a3 !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(67, 56, 202, 0.25);
    }
</style>

<div class="modal fade" id="editModel" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-ai-edit-deluxe">
            <form method="POST" id="editForm">
                @method('put')
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div
                            style="background: rgba(67, 56, 202, 0.1); padding: 12px; border-radius: 14px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-cog" style="color: #4338ca; font-size: 1.6rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0" style="font-weight: 800; color: #1e293b; letter-spacing: -0.5px;">
                            Update AI Configuration</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 mb-4">
                            <label for="edit-name" class="form-label">Model Display Name</label>
                            <input type="text" name="name" id="edit-name" class="form-control" placeholder="..."
                                   required>
                        </div>

                        <div class="col-md-12 mb-4">
                            <label for="edit-key" class="form-label">API Secret Key</label>
                            <div class="position-relative">
                                <input type="text" name="key" id="edit-key" class="form-control" placeholder="..."
                                       required style="padding-right: 45px;">
                                <i class="las la-shield-alt position-absolute top-50 end-0 translate-middle-y me-3 text-muted"></i>
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="edit-type" class="form-label">Model Provider</label>
                            <select name="type" id="edit-type" class="form-select" required>
                                <option value="Gemini">Google Gemini</option>
                                <option value="OpenAI">OpenAI ChatGPT</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="edit-status" class="form-label">Operation Status</label>
                            <select name="status" id="edit-status" class="form-select" required>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold"
                            style="background: #f1f5f9; color: #64748b; border: none; border-radius: 14px; padding: 12px 25px;"
                            data-bs-dismiss="modal">
                        Discard
                    </button>
                    <button type="submit" class="btn btn-update-ai shadow-sm">
                        <i class="las la-sync-alt me-2"></i> Update Model
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
