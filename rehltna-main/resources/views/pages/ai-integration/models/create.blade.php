<style>
    /* Deluxe AI Modal Styling */
    .modal-ai-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
    }

    .modal-ai-deluxe .modal-header {
        background: #fcfaff;
        border-bottom: 1px solid #f3e8ff;
        padding: 25px 30px;
    }

    .modal-ai-deluxe .modal-title {
        font-weight: 800;
        color: #1e293b;
        letter-spacing: -0.5px;
    }

    .modal-ai-deluxe .modal-body {
        padding: 30px 30px;
    }

    /* Form Elements Styling */
    .modal-ai-deluxe .form-label {
        font-weight: 700;
        color: #475569;
        font-size: 0.85rem;
        margin-bottom: 8px;
        display: block;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .modal-ai-deluxe .form-control,
    .modal-ai-deluxe .form-select {
        border-radius: 14px;
        padding: 12px 18px;
        border: 2px solid #f1f5f9;
        background: #f8fafc;
        transition: all 0.3s ease;
        font-weight: 600;
        color: #1e293b;
    }

    .modal-ai-deluxe .form-control:focus,
    .modal-ai-deluxe .form-select:focus {
        border-color: #6366f1; /* Indigo color for AI theme */
        background: #fff;
        box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
        outline: none;
    }

    .modal-ai-deluxe .modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 20px 30px 30px;
        gap: 12px;
    }

    /* AI Magic Button */
    .btn-save-ai {
        background: #6366f1 !important; /* Indigo/Violet */
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 30px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-save-ai:hover {
        background: #4f46e5 !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(99, 102, 241, 0.25);
    }

    /* FIX: Select & Input Text Alignment */
    .modal-ai-deluxe .form-control,
    .modal-ai-deluxe .form-select {
        border-radius: 14px;
        padding: 12px 18px !important;
        border: 2px solid #f1f5f9;
        background: #f8fafc;
        transition: all 0.3s ease;
        font-weight: 600;
        color: #1e293b;

        line-height: 1.5 !important;
        height: auto !important;
        vertical-align: middle !important;
    }

    .modal-ai-deluxe .form-select {
        background-position: right 0.75 margin center !important;
        padding-right: 40px !important;
    }

    [dir="rtl"] .modal-ai-deluxe .form-select {
        background-position: left 0.75rem center !important;
        padding-left: 40px !important;
        padding-right: 18px !important;
    }
</style>

<div class="modal fade" id="AiCreate" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-ai-deluxe">
            <form action="{{ route('ai-integration.store') }}" method="POST">
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div
                            style="background: rgba(99, 102, 241, 0.12); padding: 12px; border-radius: 14px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-robot" style="color: #6366f1; font-size: 1.6rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0">Integrate AI Model</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label for="name" class="form-label">Model Name</label>
                            <input type="text" name="name" id="name" class="form-control"
                                   placeholder="e.g. Gemini Pro 1.5" required>
                        </div>

                        <div class="col-md-12 mb-3">
                            <label for="key" class="form-label">API Access Key</label>
                            <div class="position-relative">
                                <input type="password" name="key" id="key" class="form-control"
                                       placeholder="Paste your API key here..." required style="padding-right: 45px;">
                                <i class="las la-key position-absolute top-50 end-0 translate-middle-y me-3 text-muted"></i>
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="type" class="form-label">Provider Type</label>
                            <select name="type" id="type" class="form-select" required>
                                <option value="Gemini" selected>Google Gemini</option>
                                <option value="OpenAI">OpenAI (ChatGPT)</option>
                                <option value="Claude">Anthropic Claude</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="status" class="form-label">Deployment Status</label>
                            <select name="status" id="status" class="form-select" required>
                                <option value="active" selected>Active</option>
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
                    <button type="submit" class="btn btn-save-ai shadow-sm">
                        <i class="las la-magic me-2"></i> Deploy Model
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
