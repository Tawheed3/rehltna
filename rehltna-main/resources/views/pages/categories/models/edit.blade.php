<style>
    /* Deluxe Category Edit Modal Styling */
    .modal-category-edit-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
    }

    .modal-category-edit-deluxe .modal-header {
        background: #f5f7ff;
        border-bottom: 1px solid #eef2ff;
        padding: 25px 30px;
    }

    .modal-category-edit-deluxe .modal-title {
        font-weight: 800;
        color: #1e1b4b;
        letter-spacing: -0.5px;
    }

    .modal-category-edit-deluxe .modal-body {
        padding: 35px 30px;
    }

    /* Form Elements Fix - Preventing Text Clipping */
    .modal-category-edit-deluxe .form-label {
        font-weight: 700;
        color: #475569;
        font-size: 0.85rem;
        margin-bottom: 10px;
        display: block;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .modal-category-edit-deluxe .form-control {
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

    .modal-category-edit-deluxe .form-control:focus {
        border-color: #4f46e5;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        outline: none;
    }

    .modal-category-edit-deluxe .modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 20px 30px 30px;
        gap: 12px;
    }

    /* Update Button Animation */
    .btn-update-category {
        background: #4f46e5 !important;
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 30px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-update-category:hover {
        background: #4338ca !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(79, 70, 229, 0.2);
    }

    .lang-tag-inline {
        font-size: 10px;
        background: #e2e8f0;
        color: #475569;
        padding: 2px 6px;
        border-radius: 4px;
        margin-left: 5px;
    }
</style>

<div class="modal fade" id="editModel" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content modal-category-edit-deluxe">
            <form method="POST" id="editForm">
                @method('put')
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div
                            style="background: rgba(79, 70, 229, 0.1); padding: 12px; border-radius: 14px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-edit" style="color: #4f46e5; font-size: 1.6rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0">Update Category Info</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="row">
                        @foreach(get_active_langs() as $lang)
                            <div class="{{ colClass() }} mb-3">
                                <label for="edit-name_{{ $lang }}" class="form-label">
                                    Category Name <span class="lang-tag-inline">{{ strtoupper($lang) }}</span>
                                </label>
                                <input type="text"
                                       name="name_{{ $lang }}"
                                       id="edit-name_{{ $lang }}"
                                       class="form-control"
                                       placeholder="Modify name..."
                                    {{ $lang == 'en' ? 'required' : '' }}>
                            </div>
                        @endforeach
                    </div>
                    <p class="text-muted small mt-2 mb-0">
                        <i class="las la-history me-1"></i> Updating this category will immediately reflect on all
                        associated blogs and products.
                    </p>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold"
                            style="background: #f1f5f9; color: #64748b; border: none; border-radius: 14px; padding: 12px 25px;"
                            data-bs-dismiss="modal">Discard
                    </button>
                    <button type="submit" class="btn btn-update-category shadow-sm">
                        <i class="las la-sync-alt me-2"></i> Update Category
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
