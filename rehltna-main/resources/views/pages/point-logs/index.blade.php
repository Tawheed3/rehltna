@extends('layouts.app')

@section('styles')
<style>
    body { background-color: #f8fafc; }

    .custom-card {
        border: none;
        border-radius: 24px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.03);
        background: #fff;
        overflow: visible !important;
        margin-top: 20px;
    }

    .hero-section {
        background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
        border-radius: 24px;
        padding: 40px 35px;
        margin-bottom: 35px;
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 20px 30px rgba(0,0,0,0.12);
    }

    .table thead th {
        background-color: #f1f5f9 !important;
        color: #475569 !important;
        text-transform: uppercase !important;
        font-size: 11px !important;
        font-weight: 800 !important;
        letter-spacing: 1.5px !important;
        padding: 20px 18px !important;
        border: none !important;
        border-bottom: 2px solid #e2e8f0 !important;
    }

    .table td {
        padding: 18px;
        vertical-align: middle;
        color: #334155;
        border-top: 1px solid #f1f5f9;
    }

    .btn-action {
        width: 40px; height: 40px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 12px;
        transition: all 0.3s;
        background: #fff;
        border: 1px solid #e2e8f0;
        color: #64748b;
        text-decoration: none;
    }
    .btn-action:hover { transform: scale(1.12); box-shadow: 0 8px 15px rgba(0,0,0,0.08); }
    .btn-view:hover   { color: #4f46e5; background: #eef2ff; border-color: #c7d2fe; }
    .btn-dl:hover     { color: #10b981; background: #f0fdf4; border-color: #bbf7d0; }

    .form-control-deluxe {
        border-radius: 12px !important;
        border: 2px solid #f1f5f9 !important;
        font-weight: 600 !important;
        padding: 10px 15px !important;
        height: auto !important;
    }
    .form-control-deluxe:focus {
        border-color: #4f46e5 !important;
        box-shadow: 0 0 0 4px rgba(79,70,229,0.1) !important;
    }

    .points-badge {
        font-weight: 800;
        font-size: 15px;
        color: #f59e0b;
    }
</style>
@endsection

@section('content')

<div class="breadcrumb-header justify-content-between mb-4 mt-3">
    <div class="my-auto">
        <h4 class="content-title mb-0 fw-bold" style="color:#1e293b;letter-spacing:-0.8px;font-size:1.7rem;">
            Points Logs
        </h4>
        <p class="text-muted mb-0 small fw-medium">Users / <span class="text-primary">Points History</span></p>
    </div>
</div>

<div class="hero-section">
    <div>
        <h3 class="mb-2 fw-bold" style="letter-spacing:-0.5px;">Points History</h3>
        <p class="mb-0 opacity-75 fw-medium">View and download each customer's full points history as a PDF.</p>
    </div>
    <div style="font-size:48px;">⭐</div>
</div>

<div class="row">
    <div class="col-xl-12">
        <div class="card custom-card">
            <div class="card-header pb-0 border-bottom-0 p-4">
                <div class="d-flex flex-wrap gap-3 align-items-center">
                    <div class="input-group flex-grow-1" style="max-width:380px;">
                        <span class="input-group-text bg-light border-0" style="border-radius:12px 0 0 12px;">
                            <i class="fas fa-search text-muted"></i>
                        </span>
                        <input autofocus type="text" id="search" class="form-control-deluxe border-start-0"
                               style="border-radius:0 12px 12px 0 !important;flex:1;"
                               placeholder="Search by name, email, phone..." value="{{ request('search') }}">
                    </div>
                    <select id="sort-select" class="form-select form-control-deluxe" style="max-width:220px;">
                        <option value="desc" {{ request('sort','desc') === 'desc' ? 'selected' : '' }}>
                            ⭐ Points: High → Low
                        </option>
                        <option value="asc" {{ request('sort') === 'asc' ? 'selected' : '' }}>
                            ⭐ Points: Low → High
                        </option>
                    </select>
                </div>
            </div>

            <div class="card-body p-0" id="point-logs-table">
                @include('pages.point-logs.partials.table', ['users' => $users])
            </div>

            <div class="card-footer bg-transparent border-0 p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <p class="text-muted small mb-0 fw-bold">
                        Showing {{ $users->count() }} of {{ $users->total() }} users
                    </p>
                    {!! $users->appends(['search' => request('search')])->links() !!}
                </div>
            </div>
        </div>
    </div>
</div>

@endsection

@section('scripts')
<script>
    $(document).ready(function () {
        function fetchData() {
            $.ajax({
                url: "{{ route('point-logs.index') }}",
                data: {
                    search: $('#search').val(),
                    sort:   $('#sort-select').val()
                },
                success: function (data) {
                    $('#point-logs-table').html(data);
                }
            });
        }

        $('#search').on('keyup', fetchData);
        $('#sort-select').on('change', fetchData);
    });
</script>
@endsection
