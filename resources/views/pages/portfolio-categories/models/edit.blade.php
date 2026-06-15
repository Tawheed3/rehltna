{{-- edit --}}
<div class="modal fade" id="editModel" tabindex="-1"
     aria-labelledby="AiModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form method="POST" id="editForm">
            @method('put')
            @csrf
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="CategoryModalLabel">Update
                        Portfolio Category</h5>
                </div>
                <div class="modal-body">
                    @if(hasEnglish())
                        <div class="mb-3">
                            <label for="edit-name_en" class="form-label">Name EN</label>
                            <input type="text" name="name_en" id="edit-name_en"
                                   class="form-control"
                                   required>
                        </div>
                    @endif
                    @if(hasArabic())
                        <div class="mb-3">
                            <label for="edit-name_ar" class="form-label">Name AR</label>
                            <input type="text" name="name_ar" id="edit-name_ar"
                                   class="form-control"
                                   required>
                        </div>
                    @endif
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-outline-success">Update
                    </button>
                    <button type="button" class="btn btn-outline-danger"
                            data-bs-dismiss="modal">
                        Cancel
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>
{{--   end adit    --}}
