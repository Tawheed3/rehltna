<style>
    /* Deluxe Excel Import Modal Styling */
    .modal-import-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(16, 185, 129, 0.2);
    }

    .modal-import-deluxe .modal-header {
        background: #f0fdf4;
        border-bottom: 1px solid #dcfce7;
        padding: 25px 30px;
    }

    .modal-import-deluxe .modal-title {
        font-weight: 800;
        color: #166534;
        letter-spacing: -0.5px;
    }

    .modal-import-deluxe .modal-body {
        padding: 35px 30px;
    }

    /* File Input Styling - Professional Look */
    .modal-import-deluxe .form-label {
        font-weight: 700;
        color: #475569;
        font-size: 0.85rem;
        margin-bottom: 12px;
        display: block;
        text-transform: uppercase;
    }

    .modal-import-deluxe .form-control {
        border-radius: 16px;
        padding: 12px 18px !important;
        border: 2px dashed #cbd5e1;
        background: #f8fafc;
        transition: all 0.3s ease;
        font-weight: 600;
        color: #1e293b;
        line-height: 1.6 !important;
        height: auto !important;
    }

    .modal-import-deluxe .form-control:focus {
        border-color: #10b981;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        outline: none;
    }

    .modal-import-deluxe .modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 20px 30px 30px;
        gap: 12px;
    }

    /* Success/Upload Button */
    .btn-upload-deluxe {
        background: #10b981 !important;
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 35px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-upload-deluxe:hover {
        background: #059669 !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(16, 185, 129, 0.2);
    }
</style>

<div class="modal fade" id="importExcel" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-import-deluxe">
            <form action="{{ route('item-types.import-excel') }}" method="POST" enctype="multipart/form-data">
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div
                            style="background: rgba(16, 185, 129, 0.12); padding: 12px; border-radius: 14px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-file-excel" style="color: #10b981; font-size: 1.6rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0">Import System Data</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-0">
                        <label for="excel_file" class="form-label text-center w-100 mb-3">
                            Spreadsheet Selection
                        </label>
                        <div class="position-relative text-center">
                            <input type="file" name="excel_file" id="excel_file"
                                   class="form-control"
                                   accept=".xlsx, .xls, .csv"
                                   required>
                        </div>
                        <div class="mt-3 p-3 rounded-3 bg-light border border-dashed text-center">
                            <p class="small text-muted mb-0">
                                <i class="las la-info-circle me-1"></i>
                                Only <strong>.xlsx, .xls or .csv</strong> files are supported. <br>
                                Please ensure headers match the system template.
                            </p>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold"
                            style="background: #f1f5f9; color: #64748b; border: none; border-radius: 14px; padding: 12px 25px;"
                            data-bs-dismiss="modal">Discard
                    </button>
                    <button type="submit" class="btn btn-upload-deluxe shadow-sm">
                        <i class="las la-cloud-upload-alt me-2"></i> Process & Import
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
