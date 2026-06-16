@extends('layouts.app')

@section('styles')
<style>
    body { background-color: #f8fafc; }
    .custom-card { border: none; border-radius: 24px; box-shadow: 0 10px 40px rgba(0,0,0,0.03); background: #fff; overflow: visible !important; margin-top: 20px; }
    .hero-section { background: linear-gradient(135deg, #1a3a5c 0%, #2c5f8a 100%); border-radius: 24px; padding: 40px 35px; margin-bottom: 30px; color: white; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 20px 30px rgba(0,0,0,0.12); }
    .table-responsive { border-radius: 18px; overflow: hidden; }
    .table thead th { background-color: #f1f5f9 !important; color: #475569 !important; text-transform: uppercase !important; font-size: 11px !important; font-weight: 800 !important; letter-spacing: 1.5px !important; padding: 20px 18px !important; border: none !important; border-bottom: 2px solid #e2e8f0 !important; }
    .table tbody tr:hover { background-color: #f8fafc; }
    .table td { padding: 18px; vertical-align: middle; color: #334155; border-top: 1px solid #f1f5f9; }
    .icon-box { width: 44px; height: 44px; border-radius: 12px; background: rgba(44,95,138,0.1); display: flex; align-items: center; justify-content: center; font-size: 22px; }
    .badge-active   { background: rgba(16,185,129,0.12); color: #059669; padding: 5px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; }
    .badge-inactive { background: rgba(239,68,68,0.10); color: #dc2626; padding: 5px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; }
</style>
@endsection

@section('content')
<div class="container-fluid" dir="rtl">

    {{-- Hero --}}
    <div class="hero-section">
        <div>
            <p style="font-size:13px;opacity:.7;margin:0">إدارة المحتوى</p>
            <h2 style="font-size:28px;font-weight:900;margin:4px 0 8px">أدوات السفر 🕋</h2>
            <p style="font-size:14px;opacity:.75;margin:0">تُعرض في تطبيق المسافر تحت قسم "من أجلك"</p>
        </div>
        <a href="{{ route('travel-tools.create') }}"
           style="background:rgba(255,255,255,0.15);border:1px solid rgba(255,255,255,0.3);color:#fff;padding:12px 24px;border-radius:14px;font-weight:700;text-decoration:none;font-size:14px;">
            + إضافة أداة
        </a>
    </div>

    @if(session('success'))
        <div class="alert alert-success alert-dismissible fade show rounded-4 mb-3" role="alert">
            {{ session('success') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    @endif
    @if(session('error'))
        <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-3" role="alert">
            {{ session('error') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    @endif

    {{-- Table --}}
    <div class="custom-card p-4">
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>الأيقونة</th>
                        <th>العنوان</th>
                        <th>الوصف</th>
                        <th>الترتيب</th>
                        <th>الحالة</th>
                        <th>الإجراءات</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($tools as $tool)
                    <tr>
                        <td>{{ $tool->id }}</td>
                        <td>
                            <div class="icon-box">{{ $tool->icon ?? '🔧' }}</div>
                        </td>
                        <td style="font-weight:700">{{ $tool->title }}</td>
                        <td style="max-width:260px;color:#64748b;font-size:13px">
                            {{ Str::limit($tool->description, 80) }}
                        </td>
                        <td>
                            <span style="background:#f1f5f9;padding:4px 12px;border-radius:8px;font-weight:700;font-size:13px">
                                {{ $tool->order }}
                            </span>
                        </td>
                        <td>
                            @if($tool->is_active)
                                <span class="badge-active">✓ نشط</span>
                            @else
                                <span class="badge-inactive">✕ معطّل</span>
                            @endif
                        </td>
                        <td>
                            <a href="{{ route('travel-tools.edit', encrypt($tool->id)) }}"
                               style="background:rgba(59,130,246,0.1);color:#2563eb;padding:7px 14px;border-radius:10px;font-weight:600;font-size:13px;text-decoration:none;margin-left:6px;">
                                تعديل
                            </a>
                            <form action="{{ route('travel-tools.destroy', encrypt($tool->id)) }}" method="POST" style="display:inline"
                                  onsubmit="return confirm('هل أنت متأكد من الحذف؟')">
                                @csrf @method('DELETE')
                                <button type="submit"
                                    style="background:rgba(239,68,68,0.1);color:#dc2626;padding:7px 14px;border-radius:10px;font-weight:600;font-size:13px;border:none;cursor:pointer;">
                                    حذف
                                </button>
                            </form>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="7" style="text-align:center;padding:50px;color:#94a3b8">
                            لا توجد أدوات حتى الآن — أضف أولى الأدوات!
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        <div class="mt-3">{{ $tools->links() }}</div>
    </div>
</div>
@endsection
