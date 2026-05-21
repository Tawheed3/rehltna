@php $existingPath = $existingPath ?? null; @endphp

<input type="hidden" name="pdf_path" id="pdf-path-input" value="{{ $existingPath ?? '' }}">

<div id="upload-area" style="border:2px dashed #e2e8f0; border-radius:16px; padding:30px; text-align:center; cursor:pointer; transition:all 0.2s;"
     onmouseover="this.style.borderColor='#6366f1'" onmouseout="this.style.borderColor='#e2e8f0'"
     onclick="document.getElementById('pdf-file-input').click()">
    <i class="fas fa-cloud-upload-alt fa-2x text-muted mb-2 d-block"></i>
    <div class="fw-bold text-muted" id="upload-label">
        @if($existingPath) اختر ملفاً جديداً لاستبدال الحالي @else اضغط لاختيار ملف PDF أو اسحبه هنا @endif
    </div>
    <div class="text-muted mt-1" style="font-size:12px;">PDF فقط — حد أقصى 200 ميجابايت</div>
</div>

<input type="file" id="pdf-file-input" accept=".pdf" class="d-none">

{{-- Progress UI --}}
<div id="upload-progress-wrap" class="mt-3 d-none">
    <div class="d-flex justify-content-between mb-1" style="font-size:13px;">
        <span id="upload-status-text" class="fw-bold text-primary">جاري الرفع...</span>
        <span id="upload-percent" class="fw-bold">0%</span>
    </div>
    <div class="progress" style="height:10px; border-radius:10px;">
        <div id="upload-bar" class="progress-bar bg-primary progress-bar-striped progress-bar-animated"
             style="width:0%; border-radius:10px; transition:width 0.3s;"></div>
    </div>
    <div id="upload-size-info" class="text-muted mt-1" style="font-size:11px;"></div>
</div>

<div id="upload-done-wrap" class="mt-3 d-none">
    <div class="d-flex align-items-center gap-2 p-3" style="background:#f0fdf4; border-radius:12px; border:1.5px solid #bbf7d0;">
        <i class="fas fa-check-circle text-success fa-lg"></i>
        <div>
            <div class="fw-bold" style="font-size:13px; color:#15803d;">تم رفع الملف بنجاح</div>
            <div id="upload-done-name" class="text-muted" style="font-size:11px;"></div>
        </div>
        <button type="button" class="btn btn-sm btn-outline-danger ms-auto" onclick="resetUploader()" style="border-radius:10px; font-size:11px;">
            <i class="fas fa-times me-1"></i> إلغاء
        </button>
    </div>
</div>

<script>
(function () {
    const CHUNK_SIZE     = 10 * 1024 * 1024; // 10 MB per chunk
    const DIRECT_LIMIT   = 10 * 1024 * 1024; // files ≤ 10 MB go in one request
    const uploadUrl  = '{{ route('trip-documents.upload-chunk') }}';
    const csrfToken  = '{{ csrf_token() }}';

    const fileInput     = document.getElementById('pdf-file-input');
    const pathInput     = document.getElementById('pdf-path-input');
    const progressWrap  = document.getElementById('upload-progress-wrap');
    const doneWrap      = document.getElementById('upload-done-wrap');
    const bar           = document.getElementById('upload-bar');
    const percentLabel  = document.getElementById('upload-percent');
    const statusText    = document.getElementById('upload-status-text');
    const sizeInfo      = document.getElementById('upload-size-info');
    const submitBtn     = document.getElementById('submit-btn');
    const uploadLabel   = document.getElementById('upload-label');

    // drag-and-drop
    const uploadArea = document.getElementById('upload-area');
    uploadArea.addEventListener('dragover', e => { e.preventDefault(); uploadArea.style.borderColor = '#6366f1'; });
    uploadArea.addEventListener('dragleave', () => { uploadArea.style.borderColor = '#e2e8f0'; });
    uploadArea.addEventListener('drop', e => {
        e.preventDefault();
        uploadArea.style.borderColor = '#e2e8f0';
        const f = e.dataTransfer.files[0];
        if (f && f.type === 'application/pdf') startUpload(f);
        else alert('يرجى اختيار ملف PDF فقط');
    });

    fileInput.addEventListener('change', function () {
        if (this.files[0]) startUpload(this.files[0]);
    });

    function fmt(bytes) {
        return bytes >= 1048576 ? (bytes / 1048576).toFixed(1) + ' MB' : (bytes / 1024).toFixed(0) + ' KB';
    }

    function generateId() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
            const r = Math.random() * 16 | 0;
            return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        });
    }

    async function startUpload(file) {
        const totalChunks = file.size <= DIRECT_LIMIT ? 1 : Math.ceil(file.size / CHUNK_SIZE);
        const uploadId    = generateId();

        progressWrap.classList.remove('d-none');
        doneWrap.classList.add('d-none');
        uploadArea.style.display = 'none';
        if (submitBtn) submitBtn.disabled = true;
        pathInput.value = '';

        for (let i = 0; i < totalChunks; i++) {
            const chunk = file.slice(i * CHUNK_SIZE, (i + 1) * CHUNK_SIZE);
            const formData = new FormData();
            formData.append('_token',      csrfToken);
            formData.append('chunk',       chunk, file.name);
            formData.append('chunkIndex',  i);
            formData.append('totalChunks', totalChunks);
            formData.append('uploadId',    uploadId);
            formData.append('fileName',    file.name);

            const pct = Math.round(((i) / totalChunks) * 100);
            bar.style.width      = pct + '%';
            percentLabel.textContent = pct + '%';
            statusText.textContent   = totalChunks === 1 ? 'جاري الرفع...' : `جاري الرفع — جزء ${i + 1} من ${totalChunks}`;
            sizeInfo.textContent     = `${fmt(Math.min((i + 1) * CHUNK_SIZE, file.size))} من ${fmt(file.size)}`;

            let resp;
            try {
                const r = await fetch(uploadUrl, { method: 'POST', body: formData });
                resp = await r.json();
            } catch (err) {
                progressWrap.classList.add('d-none');
                uploadArea.style.display = '';
                if (submitBtn) submitBtn.disabled = false;
                alert('فشل الرفع: ' + err.message);
                return;
            }

            if (resp.status === 'done') {
                bar.style.width          = '100%';
                percentLabel.textContent = '100%';
                progressWrap.classList.add('d-none');
                doneWrap.classList.remove('d-none');
                document.getElementById('upload-done-name').textContent = file.name + ' — ' + fmt(file.size);
                pathInput.value = resp.path;
                if (submitBtn) submitBtn.disabled = false;
                return;
            }
        }
    }

    window.resetUploader = function () {
        pathInput.value = '';
        fileInput.value = '';
        doneWrap.classList.add('d-none');
        progressWrap.classList.add('d-none');
        uploadArea.style.display = '';
        uploadLabel.textContent = 'اضغط لاختيار ملف PDF أو اسحبه هنا';
        if (submitBtn) submitBtn.disabled = false;
    };
})();
</script>
