@extends('layouts.app')

@section('styles')
<style>
    body { background-color: #f8fafc; }
    .hero-section { background: linear-gradient(135deg, #1e293b 0%, #334155 100%); border-radius: 24px; padding: 35px; margin-bottom: 30px; color: white; box-shadow: 0 20px 30px rgba(0,0,0,0.12); }
    .form-card { border: none; border-radius: 24px; box-shadow: 0 10px 40px rgba(0,0,0,0.04); background: #fff; padding: 35px; margin-bottom: 24px; }
    .section-label { font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1.5px; color: #64748b; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 2px solid #f1f5f9; }
    .form-label { font-size: 13px; font-weight: 700; color: #374151; margin-bottom: 6px; }
    .form-control, .form-select { border-radius: 12px; border: 1.5px solid #e2e8f0; font-size: 14px; padding: 10px 14px; }
    .form-control:focus, .form-select:focus { border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
    .detail-row { display: flex; gap: 10px; align-items: start; margin-bottom: 12px; }
    .detail-row .form-control { flex: 1; }
    .btn-remove-row { background: #fef2f2; color: #ef4444; border: none; border-radius: 10px; width: 36px; height: 40px; display: flex; align-items: center; justify-content: center; cursor: pointer; flex-shrink: 0; font-size: 16px; }
    .btn-remove-row:hover { background: #fee2e2; }
    .btn-add-row { background: #eff6ff; color: #2563eb; border: 1.5px dashed #93c5fd; border-radius: 12px; padding: 10px 20px; font-size: 13px; font-weight: 700; cursor: pointer; width: 100%; text-align: center; margin-top: 8px; }
    .btn-add-row:hover { background: #dbeafe; }
    .user-card { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border: 1.5px solid #e2e8f0; border-radius: 14px; cursor: pointer; transition: all 0.2s; margin-bottom: 8px; }
    .user-card:hover { border-color: #6366f1; background: #fafafe; }
    .user-card input[type=checkbox]:checked ~ .user-info .user-name { color: #4f46e5; }
    .user-card.selected { border-color: #6366f1; background: #f0f0ff; }
    .user-avatar { width: 38px; height: 38px; border-radius: 50%; background: linear-gradient(135deg, #6366f1, #8b5cf6); display: flex; align-items: center; justify-content: center; color: white; font-weight: 800; font-size: 14px; flex-shrink: 0; }
    .user-name { font-weight: 700; font-size: 13px; color: #1e293b; }
    .user-meta { font-size: 11px; color: #94a3b8; }
    .pdf-upload-area { border: 2px dashed #e2e8f0; border-radius: 16px; padding: 30px; text-align: center; cursor: pointer; transition: all 0.2s; }
    .pdf-upload-area:hover { border-color: #6366f1; background: #fafafe; }
    .users-search { margin-bottom: 12px; }
</style>
@endsection

@section('content')
<div class="container-fluid px-4 py-4">

    <div class="hero-section">
        <div>
            <a href="{{ route('trip-documents.index') }}" class="text-white opacity-75 text-decoration-none" style="font-size:13px;">
                <i class="fas fa-arrow-right me-1"></i> وثائق الرحلات
            </a>
            <h1 class="fw-black mb-0 mt-2" style="font-size:26px;">إضافة وثيقة رحلة</h1>
        </div>
    </div>

    @if($errors->any())
        <div class="alert alert-danger border-0 rounded-3 mb-4">
            <ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul>
        </div>
    @endif

    <form action="{{ route('trip-documents.store') }}" method="POST" enctype="multipart/form-data">
        @csrf

        <div class="row g-4">
            {{-- Left column --}}
            <div class="col-lg-8">

                {{-- Trip selection --}}
                <div class="form-card">
                    <div class="section-label"><i class="fas fa-plane me-2"></i> الرحلة</div>
                    <label class="form-label">اختر الرحلة <span class="text-danger">*</span></label>
                    <select name="item_id" class="form-select" required>
                        <option value="">— اختر الرحلة —</option>
                        @foreach($trips as $trip)
                            <option value="{{ $trip->id }}" {{ old('item_id') == $trip->id ? 'selected' : '' }}>
                                {{ $trip->title_ar }}{{ $trip->season ? ' — '.$trip->season : '' }}{{ $trip->start_date ? ' — '.($trip->start_date instanceof \Carbon\Carbon ? $trip->start_date->format('Y-m-d') : $trip->start_date) : '' }}
                            </option>
                        @endforeach
                    </select>
                </div>

                {{-- Key-Value Details --}}
                <div class="form-card">
                    <div class="section-label"><i class="fas fa-list-ul me-2"></i> تفاصيل الرحلة</div>
                    <p class="text-muted mb-3" style="font-size:13px;">أضف المحاور والتفاصيل — مثل: <strong>اليوم الأول</strong> ← <strong>وصف اليوم</strong></p>

                    <div id="details-container">
                        @forelse(old('details', []) as $i => $row)
                        <div class="detail-row">
                            <div style="width:200px; flex-shrink:0;">
                                <input type="text" name="details[{{ $i }}][key]" class="form-control"
                                       placeholder="العنوان (مثال: اليوم الأول)"
                                       value="{{ $row['key'] ?? '' }}">
                            </div>
                            <textarea name="details[{{ $i }}][value]" class="form-control" rows="2"
                                      placeholder="التفاصيل...">{{ $row['value'] ?? '' }}</textarea>
                            <button type="button" class="btn-remove-row" onclick="removeRow(this)">×</button>
                        </div>
                        @empty
                        <div class="detail-row">
                            <div style="width:200px; flex-shrink:0;">
                                <input type="text" name="details[0][key]" class="form-control" placeholder="العنوان (مثال: اليوم الأول)">
                            </div>
                            <textarea name="details[0][value]" class="form-control" rows="2" placeholder="التفاصيل..."></textarea>
                            <button type="button" class="btn-remove-row" onclick="removeRow(this)">×</button>
                        </div>
                        @endforelse
                    </div>

                    <button type="button" class="btn-add-row" onclick="addRow()">
                        <i class="fas fa-plus me-1"></i> إضافة محور جديد
                    </button>
                </div>

                {{-- PDF Upload --}}
                <div class="form-card">
                    <div class="section-label"><i class="fas fa-file-pdf me-2"></i> ملف PDF (اختياري)</div>
                    <label class="pdf-upload-area d-block" for="pdf-input">
                        <i class="fas fa-cloud-upload-alt fa-2x text-muted mb-2 d-block"></i>
                        <div class="fw-bold text-muted" id="pdf-label">اضغط لاختيار ملف PDF أو اسحبه هنا</div>
                        <div class="text-muted mt-1" style="font-size:12px;">PDF فقط — حد أقصى 20 ميجابايت</div>
                    </label>
                    <input type="file" name="pdf" id="pdf-input" accept=".pdf" class="d-none"
                           onchange="document.getElementById('pdf-label').textContent = this.files[0]?.name || 'اضغط لاختيار ملف PDF'">
                </div>

            </div>

            {{-- Right column — Users --}}
            <div class="col-lg-4">
                <div class="form-card" style="position:sticky; top:80px;">
                    <div class="section-label"><i class="fas fa-users me-2"></i> المستخدمون المصرح لهم</div>
                    <input type="text" class="form-control users-search" placeholder="بحث عن مستخدم..." id="user-search">

                    <div style="max-height:500px; overflow-y:auto;" id="users-list">
                        @foreach($users as $user)
                        <label class="user-card d-flex" id="user-card-{{ $user->id }}">
                            <input type="checkbox" name="users[]" value="{{ $user->id }}" class="user-checkbox d-none"
                                   {{ in_array($user->id, old('users', [])) ? 'checked' : '' }}
                                   onchange="toggleCard(this)">
                            <div class="user-avatar">{{ strtoupper(substr($user->name, 0, 1)) }}</div>
                            <div class="user-info">
                                <div class="user-name">{{ $user->name }}</div>
                                <div class="user-meta">{{ $user->email }}</div>
                            </div>
                        </label>
                        @endforeach
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex gap-3 mt-2 mb-5">
            <button type="submit" class="btn btn-primary fw-bold px-5 py-2" style="border-radius:14px;">
                <i class="fas fa-save me-2"></i> حفظ الوثيقة
            </button>
            <a href="{{ route('trip-documents.index') }}" class="btn btn-light fw-bold px-4 py-2" style="border-radius:14px;">إلغاء</a>
        </div>
    </form>
</div>
@endsection

@section('scripts')
<script>
let rowIndex = {{ max(1, count(old('details', [[]]))) }};

function addRow() {
    const container = document.getElementById('details-container');
    const div = document.createElement('div');
    div.className = 'detail-row';
    div.innerHTML = `
        <div style="width:200px;flex-shrink:0;">
            <input type="text" name="details[${rowIndex}][key]" class="form-control" placeholder="العنوان (مثال: اليوم الأول)">
        </div>
        <textarea name="details[${rowIndex}][value]" class="form-control" rows="2" placeholder="التفاصيل..."></textarea>
        <button type="button" class="btn-remove-row" onclick="removeRow(this)">×</button>`;
    container.appendChild(div);
    rowIndex++;
}

function removeRow(btn) {
    const rows = document.querySelectorAll('.detail-row');
    if (rows.length <= 1) {
        btn.closest('.detail-row').querySelectorAll('input,textarea').forEach(el => el.value = '');
        return;
    }
    btn.closest('.detail-row').remove();
}

function toggleCard(checkbox) {
    const card = checkbox.closest('.user-card');
    card.classList.toggle('selected', checkbox.checked);
}

// Init selected state on load
document.querySelectorAll('.user-checkbox').forEach(cb => {
    if (cb.checked) cb.closest('.user-card').classList.add('selected');
});

// Search filter
document.getElementById('user-search').addEventListener('input', function () {
    const q = this.value.toLowerCase();
    document.querySelectorAll('.user-card').forEach(card => {
        const text = card.querySelector('.user-name').textContent.toLowerCase()
                   + ' ' + (card.querySelector('.user-meta').textContent.toLowerCase());
        card.style.display = text.includes(q) ? '' : 'none';
    });
});
</script>
@endsection
