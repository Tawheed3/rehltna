@extends('layouts.app')

@section('styles')
<style>
    body { background-color: #f8fafc; }
    .hero-section {
        background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
        border-radius: 24px; padding: 40px 35px; margin-bottom: 30px;
        color: white; display: flex; justify-content: space-between; align-items: center;
        box-shadow: 0 20px 30px rgba(0,0,0,0.12);
    }
    .custom-card { border: none; border-radius: 24px; box-shadow: 0 10px 40px rgba(0,0,0,0.03); background: #fff; overflow: hidden; margin-top: 20px; }
    .table thead th { background-color: #f1f5f9 !important; color: #475569 !important; text-transform: uppercase !important; font-size: 11px !important; font-weight: 800 !important; letter-spacing: 1.5px !important; padding: 20px !important; border: none !important; border-bottom: 2px solid #e2e8f0 !important; }
    .table tbody td { padding: 16px 20px !important; vertical-align: middle !important; border-bottom: 1px solid #f1f5f9 !important; font-size: 14px; }
    .badge-user { display: inline-block; background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe; border-radius: 20px; padding: 3px 10px; font-size: 11px; font-weight: 700; margin: 2px; }
    .badge-detail { display: inline-block; background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; border-radius: 20px; padding: 3px 10px; font-size: 11px; font-weight: 700; margin: 2px; }
    .btn-action { border-radius: 10px; font-size: 12px; font-weight: 700; padding: 6px 14px; }
</style>
@endsection

@section('content')
<div class="container-fluid px-4 py-4">

    <div class="hero-section">
        <div>
            <h1 class="fw-black mb-1" style="font-size:26px;">وثائق الرحلات</h1>
            <p class="mb-0 opacity-75" style="font-size:14px;">إدارة الوثائق السرية لكل رحلة وتحديد المستخدمين المصرح لهم</p>
        </div>
        <a href="{{ route('trip-documents.create') }}" class="btn btn-warning fw-bold px-4 py-2" style="border-radius:14px;">
            <i class="fas fa-plus me-2"></i> إضافة وثيقة
        </a>
    </div>

    @if(session('success'))
        <div class="alert alert-success border-0 rounded-3 mb-4">{{ session('success') }}</div>
    @endif

    <div class="custom-card">
        <div class="table-responsive">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>الرحلة</th>
                        <th>تفاصيل (مفاتيح)</th>
                        <th>PDF</th>
                        <th>المستخدمون المصرح لهم</th>
                        <th>تاريخ الإنشاء</th>
                        <th>الإجراءات</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($documents as $doc)
                    <tr>
                        <td class="text-muted fw-bold">{{ $doc->id }}</td>
                        <td>
                            <div class="fw-bold">{{ $doc->item?->title_ar ?? '—' }}</div>
                            <div class="text-muted" style="font-size:12px;">{{ $doc->item?->title_en }}</div>
                        </td>
                        <td>
                            @forelse($doc->details ?? [] as $row)
                                <span class="badge-detail">{{ $row['key'] }}</span>
                            @empty
                                <span class="text-muted">—</span>
                            @endforelse
                        </td>
                        <td>
                            @if($doc->pdf_path)
                                <a href="{{ Storage::url($doc->pdf_path) }}" target="_blank" class="btn btn-sm btn-outline-danger btn-action">
                                    <i class="fas fa-file-pdf me-1"></i> عرض PDF
                                </a>
                            @else
                                <span class="text-muted">—</span>
                            @endif
                        </td>
                        <td>
                            @forelse($doc->users as $user)
                                <span class="badge-user" title="{{ $user->email }}">{{ $user->name }}</span>
                            @empty
                                <span class="text-muted text-sm">لا يوجد مستخدمون</span>
                            @endforelse
                        </td>
                        <td class="text-muted" style="font-size:12px;">{{ $doc->created_at->format('Y-m-d') }}</td>
                        <td>
                            <a href="{{ route('trip-documents.edit', $doc) }}" class="btn btn-sm btn-primary btn-action me-1">
                                <i class="fas fa-edit"></i> تعديل
                            </a>
                            <form action="{{ route('trip-documents.destroy', $doc) }}" method="POST" class="d-inline"
                                  onsubmit="return confirm('هل أنت متأكد من الحذف؟')">
                                @csrf @method('DELETE')
                                <button class="btn btn-sm btn-danger btn-action">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="7" class="text-center py-5 text-muted">
                            <i class="fas fa-folder-open fa-2x mb-3 d-block opacity-30"></i>
                            لا توجد وثائق بعد
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        @if($documents->hasPages())
        <div class="px-4 py-3">{{ $documents->links() }}</div>
        @endif
    </div>

</div>
@endsection
