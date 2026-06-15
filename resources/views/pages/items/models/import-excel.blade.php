<style>
    /* Deluxe Excel Import Modal Styling */
    .modal-import-items-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(16, 185, 129, 0.2);
    }

    .modal-import-items-deluxe .modal-header {
        background: #f0fdf4;
        border-bottom: 1px solid #dcfce7;
        padding: 25px 30px;
    }

    .modal-import-items-deluxe .modal-title {
        font-weight: 800;
        color: #166534;
        letter-spacing: -0.5px;
    }

    .modal-import-items-deluxe .modal-body {
        padding: 35px 30px;
    }

    /* Fix: Ensuring Text doesn't clip in file input */
    .modal-import-items-deluxe .form-control {
        border-radius: 14px;
        padding: 12px 18px !important;
        border: 2px dashed #cbd5e1;
        background: #f8fafc;
        transition: all 0.3s ease;
        font-weight: 600;
        color: #1e293b;
        line-height: 1.6 !important;
        height: auto !important;
        vertical-align: middle !important;
    }

    .modal-import-items-deluxe .form-control:focus {
        border-color: #10b981;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        outline: none;
    }

    .modal-import-items-deluxe .modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 20px 30px 30px;
        gap: 12px;
    }

    /* Process Button */
    .btn-process-items {
        background: #10b981 !important;
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 35px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-process-items:hover {
        background: #059669 !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(16, 185, 129, 0.2);
    }
</style>

<div class="modal fade" id="importExcel" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-import-items-deluxe">
            <form action="{{ route('items.import-excel') }}" method="POST" enctype="multipart/form-data">
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        {{-- الأيقونة الزجاجية (Excel Theme) --}}
                        <div
                            style="background: rgba(16, 185, 129, 0.12); padding: 12px; border-radius: 14px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-database" style="color: #10b981; font-size: 1.6rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0">Bulk Items Import</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body text-center">
                    <div class="mb-4">
                        <label for="excel_file" class="form-label fw-bold text-muted small text-uppercase mb-3 d-block">Select
                            Excel/CSV Document</label>
                        <input type="file" name="excel_file" id="excel_file"
                               class="form-control"
                               accept=".xlsx, .xls, .csv"
                               required>
                    </div>

                    <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 15px; padding: 15px;"
                         class="text-start">
                        <h6 class="fw-bold text-dark small mb-2"><i class="las la-info-circle me-1 text-primary"></i>
                            Quick Tips:</h6>
                        <ul class="text-muted small mb-0 ps-3">
                            <li>Make sure the columns match the template.</li>
                            <li>Supported extensions: <strong>.xlsx, .xls, .csv</strong></li>
                        </ul>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold"
                            style="background: #f1f5f9; color: #64748b; border: none; border-radius: 14px; padding: 12px 25px;"
                            data-bs-dismiss="modal">Cancel
                    </button>
                    <button type="submit" class="btn btn-process-items shadow-sm">
                        <i class="las la-file-upload me-2"></i> Start Importing
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
