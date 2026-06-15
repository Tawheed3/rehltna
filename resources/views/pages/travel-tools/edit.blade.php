@extends('layouts.app')

@section('styles')
<style>
    body { background-color: #f8fafc; }
    .form-card { background:#fff; border-radius:24px; box-shadow:0 10px 40px rgba(0,0,0,0.04); padding:36px; margin-top:20px; }
    .form-label { font-weight:700; font-size:13px; color:#374151; margin-bottom:6px; }
    .form-control, .form-select { border-radius:12px; border:1.5px solid #e5e7eb; padding:12px 16px; font-size:14px; transition:border-color .2s; }
    .form-control:focus { border-color:#2c5f8a; box-shadow:0 0 0 3px rgba(44,95,138,0.1); }
    .emoji-grid { display:flex; flex-wrap:wrap; gap:8px; margin-top:10px; }
    .emoji-btn { font-size:22px; cursor:pointer; padding:8px; border-radius:10px; border:2px solid transparent; transition:all .15s; background:#f8fafc; }
    .emoji-btn:hover { background:#e0f2fe; border-color:#38bdf8; }
    .emoji-btn.selected { background:#dbeafe; border-color:#2563eb; }
    .btn-save { background:linear-gradient(135deg,#1a3a5c,#2c5f8a); color:#fff; border:none; border-radius:14px; padding:13px 32px; font-weight:700; font-size:15px; cursor:pointer; }
    .btn-cancel { background:#f1f5f9; color:#475569; border:none; border-radius:14px; padding:13px 24px; font-weight:600; font-size:14px; cursor:pointer; text-decoration:none; }
</style>
@endsection

@section('content')
<div class="container-fluid" dir="rtl">
    <div style="display:flex;align-items:center;gap:12px;margin-bottom:24px;margin-top:10px">
        <a href="{{ route('travel-tools.index') }}" style="color:#64748b;text-decoration:none;font-size:14px">← أدوات السفر</a>
        <span style="color:#cbd5e1">/</span>
        <span style="font-weight:700;font-size:15px;color:#1e293b">تعديل: {{ $tool->title }}</span>
    </div>

    @if($errors->any())
        <div class="alert alert-danger rounded-4 mb-3">
            <ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul>
        </div>
    @endif

    <form action="{{ route('travel-tools.update', encrypt($tool->id)) }}" method="POST">
        @csrf @method('PUT')
        <div class="form-card">
            <div class="row g-4">

                {{-- Icon --}}
                <div class="col-12">
                    <label class="form-label">الأيقونة (emoji)</label>
                    <input type="text" name="icon" id="iconInput" class="form-control"
                           value="{{ old('icon', $tool->icon) }}" placeholder="مثال: ✈️" maxlength="10"
                           style="font-size:24px;width:100px">
                    <div class="emoji-grid mt-2">
                        @foreach(['✈️','🧳','🗺️','🏨','🚢','🏖️','🏔️','🌍','💊','📋','🔐','💳','📱','🌐','⚡','🎫','🛂','🚗','🚂','🎒','🧭','⛽','🏥','🌡️','💰','📞','🔌','📷','🌤️','☀️','🕋'] as $e)
                            <span class="emoji-btn {{ old('icon', $tool->icon) === $e ? 'selected' : '' }}"
                                  onclick="setEmoji('{{ $e }}')">{{ $e }}</span>
                        @endforeach
                    </div>
                </div>

                {{-- Title --}}
                <div class="col-12">
                    <label class="form-label">العنوان <span style="color:red">*</span></label>
                    <input type="text" name="title" class="form-control"
                           value="{{ old('title', $tool->title) }}" required>
                </div>

                {{-- Description --}}
                <div class="col-12">
                    <label class="form-label">الوصف / التفاصيل</label>
                    <textarea name="description" class="form-control" rows="4">{{ old('description', $tool->description) }}</textarea>
                </div>

                {{-- Order + Status --}}
                <div class="col-md-4">
                    <label class="form-label">الترتيب</label>
                    <input type="number" name="order" class="form-control"
                           value="{{ old('order', $tool->order) }}" min="0">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <div class="form-check form-switch" style="padding-top:8px">
                        <input class="form-check-input" type="checkbox" name="is_active"
                               id="isActive" value="1"
                               {{ old('is_active', $tool->is_active) ? 'checked' : '' }}>
                        <label class="form-check-label" for="isActive" style="font-weight:600">نشط (يظهر في التطبيق)</label>
                    </div>
                </div>
            </div>

            <div class="mt-4 d-flex gap-3">
                <button type="submit" class="btn-save">💾 حفظ التعديلات</button>
                <a href="{{ route('travel-tools.index') }}" class="btn-cancel">إلغاء</a>
            </div>
        </div>
    </form>
</div>

<script>
function setEmoji(e) {
    document.getElementById('iconInput').value = e;
    document.querySelectorAll('.emoji-btn').forEach(b => b.classList.remove('selected'));
    event.target.classList.add('selected');
}
</script>
@endsection
