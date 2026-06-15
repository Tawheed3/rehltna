{{--         create model        --}}
<div class="modal fade" id="DiseaseTypeCreate" tabindex="-1"
     aria-labelledby="DiseaseTypeCreateModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form action="{{ route('disease-types.store') }}" method="POST">
            @csrf
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="DiseaseTypeCreateModalLabel">Add New Disease Type</h5>
                </div>
                <div class="modal-body">
                    @if(hasEnglish())
                        <div class="mb-3">
                            <label for="name_en" class="form-label">Name EN</label>
                            <input type="text" name="name_en" id="name_en" class="form-control" required>
                        </div>
                    @endif
                    @if(hasArabic())
                        <div class="mb-3">
                            <label for="name_ar" class="form-label">Name AR</label>
                            <input type="text" name="name_ar" id="name_ar" class="form-control">
                        </div>
                    @endif
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-outline-success">Save</button>
                    <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">
                        Cancel
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>
{{--       end create model     --}}
