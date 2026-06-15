<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
<meta charset="UTF-8">
<title>Points History Report</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
        font-family: 'dejavusans', Arial, sans-serif;
        background: #f8fafc;
        color: #334155;
        font-size: 12px;
    }
    .page { padding: 28px 32px; }

    /* ── HEADER ── */
    .header {
        background: #1e293b;
        border-radius: 14px;
        padding: 26px 30px;
        margin-bottom: 20px;
        color: #fff;
    }
    .header table { width: 100%; }
    .header td { vertical-align: middle; }
    .header-title { font-size: 21px; font-weight: bold; color: #ffffff; margin-bottom: 3px; }
    .header-sub   { font-size: 10px; color: #94a3b8; }
    .header-badge {
        display: inline-block;
        background: #f59e0b; color: #1e293b;
        font-size: 9px; font-weight: bold;
        letter-spacing: 1.5px; text-transform: uppercase;
        padding: 4px 13px; border-radius: 20px;
        margin-top: 10px;
    }
    .header-icon {
        width: 54px; height: 54px;
        background: rgba(245,158,11,0.18);
        border-radius: 13px;
        text-align: center; line-height: 54px;
        font-size: 26px;
    }

    /* ── CUSTOMER CARD ── */
    .info-card {
        border: 1.5px solid #e2e8f0;
        border-radius: 12px;
        margin-bottom: 16px;
        overflow: hidden;
        background: #ffffff;
    }
    .info-card table { width: 100%; border-collapse: collapse; }
    .info-card td { vertical-align: middle; }
    .customer-side { padding: 18px 22px; border-right: 1.5px solid #e2e8f0; width: 62%; }
    .customer-label { font-size: 8px; font-weight: bold; color: #94a3b8; letter-spacing: 1.5px; text-transform: uppercase; margin-bottom: 7px; }
    .customer-name  { font-size: 15px; font-weight: bold; color: #0f172a; margin-bottom: 5px; }
    .customer-meta  { font-size: 10px; color: #64748b; }
    .balance-side { padding: 18px 22px; text-align: right; }
    .balance-label { font-size: 8px; font-weight: bold; color: #94a3b8; letter-spacing: 1.5px; text-transform: uppercase; margin-bottom: 5px; }
    .balance-val   { font-size: 30px; font-weight: bold; color: #f59e0b; line-height: 1; }
    .balance-unit  { font-size: 12px; color: #94a3b8; font-weight: normal; }
    .balance-rate  { font-size: 9px; color: #cbd5e1; margin-top: 4px; }

    /* ── SECTION TITLE ── */
    .sec-head {
        font-size: 9px; font-weight: bold; color: #475569;
        text-transform: uppercase; letter-spacing: 1.5px;
        padding-bottom: 7px; margin-bottom: 12px;
        border-bottom: 2px solid #e2e8f0;
    }

    /* ── FOOTER ── */
    .footer {
        margin-top: 24px;
        padding-top: 12px;
        border-top: 1px solid #e2e8f0;
        text-align: center;
        font-size: 9px; color: #94a3b8;
    }
</style>
</head>
<body>
<div class="page">

{{-- ══ HEADER ══ --}}
<div class="header">
    <table><tr>
        <td>
            <div class="header-title">Points History Report</div>
            <div class="header-sub">Generated on {{ now()->format('d M Y, h:i A') }}</div>
            <span class="header-badge">Official Report</span>
        </td>
        <td width="60" style="text-align:right;">
            <div class="header-icon">&#11088;</div>
        </td>
    </tr></table>
</div>

{{-- ══ CUSTOMER + BALANCE ══ --}}
@php
    $totalEarned = $logs->where('points', '>', 0)->sum('points');
    $totalUsed   = abs($logs->where('points', '<', 0)->sum('points'));
    $current     = (int) $user->available_points;
@endphp

<div class="info-card">
    <table><tr>
        <td class="customer-side">
            <div class="customer-label">Customer</div>
            <div class="customer-name">{{ $user->name }}</div>
            <div class="customer-meta">{{ $user->email }} &nbsp;|&nbsp; {{ $user->phone }}</div>
        </td>
        <td class="balance-side">
            <div class="balance-label">Available Balance</div>
            <div class="balance-val">{{ number_format($current) }} <span class="balance-unit">pts</span></div>
            <div class="balance-rate">50 pts = 1 SAR &nbsp;&#8594;&nbsp; {{ number_format($current / 50, 2) }} SAR</div>
        </td>
    </tr></table>
</div>

{{-- ══ STATS ROW ══ --}}
<table style="width:100%;border-collapse:collapse;margin-bottom:18px;">
<tr>
    <td style="width:33%;padding-right:6px;vertical-align:top;">
        <table style="width:100%;border-collapse:collapse;border:1.5px solid #a7f3d0;border-radius:10px;overflow:hidden;">
        <tr>
            <td style="width:5px;background:#10b981;padding:0;"></td>
            <td style="background:#f0fdf4;padding:12px 14px;">
                <div style="font-size:8px;color:#065f46;font-weight:800;text-transform:uppercase;letter-spacing:1.2px;margin-bottom:5px;">Total Earned</div>
                <div style="font-size:20px;font-weight:900;color:#10b981;line-height:1;">+{{ number_format($totalEarned) }}</div>
                <div style="font-size:8px;color:#6ee7b7;margin-top:3px;font-weight:600;">points earned</div>
            </td>
        </tr>
        </table>
    </td>
    <td style="width:33%;padding:0 3px;vertical-align:top;">
        <table style="width:100%;border-collapse:collapse;border:1.5px solid #fecaca;border-radius:10px;overflow:hidden;">
        <tr>
            <td style="width:5px;background:#ef4444;padding:0;"></td>
            <td style="background:#fef2f2;padding:12px 14px;">
                <div style="font-size:8px;color:#991b1b;font-weight:800;text-transform:uppercase;letter-spacing:1.2px;margin-bottom:5px;">Total Used</div>
                <div style="font-size:20px;font-weight:900;color:#ef4444;line-height:1;">&minus;{{ number_format($totalUsed) }}</div>
                <div style="font-size:8px;color:#fca5a5;margin-top:3px;font-weight:600;">points redeemed</div>
            </td>
        </tr>
        </table>
    </td>
    <td style="width:34%;padding-left:6px;vertical-align:top;">
        <table style="width:100%;border-collapse:collapse;border:1.5px solid #fde68a;border-radius:10px;overflow:hidden;">
        <tr>
            <td style="width:5px;background:#f59e0b;padding:0;"></td>
            <td style="background:#fffbeb;padding:12px 14px;">
                <div style="font-size:8px;color:#92400e;font-weight:800;text-transform:uppercase;letter-spacing:1.2px;margin-bottom:5px;">Net Balance</div>
                <div style="font-size:20px;font-weight:900;color:#f59e0b;line-height:1;">{{ number_format($current) }}</div>
                <div style="font-size:8px;color:#fcd34d;margin-top:3px;font-weight:600;">= {{ number_format($current / 50, 2) }} SAR</div>
            </td>
        </tr>
        </table>
    </td>
</tr>
</table>

{{-- ══ TRANSACTION CARDS ══ --}}
<div class="sec-head">Transaction History &nbsp;&#8212;&nbsp; {{ $logs->count() }} records</div>

@if($logs->isEmpty())
    <div style="text-align:center;padding:40px;color:#94a3b8;border:2px dashed #e2e8f0;border-radius:10px;font-weight:600;">
        No transactions found for this customer.
    </div>
@else

@foreach($logs as $i => $log)
@php
    if ($log->type === 'trip_earned') {
        $accent      = '#10b981';
        $cardBg      = '#f0fdf4';
        $cardBorder  = '#a7f3d0';
        $divBorder   = '#d1fae5';
        $badgeBg     = '#d1fae5';
        $badgeColor  = '#065f46';
        $badgeLabel  = 'Trip Earned';
    } elseif ($log->type === 'employee_adjusted') {
        $accent      = '#f59e0b';
        $cardBg      = '#fffbeb';
        $cardBorder  = '#fde68a';
        $divBorder   = '#fef3c7';
        $badgeBg     = '#fef3c7';
        $badgeColor  = '#92400e';
        $badgeLabel  = 'Employee Adj.';
    } else {
        $accent      = '#ef4444';
        $cardBg      = '#fef2f2';
        $cardBorder  = '#fecaca';
        $divBorder   = '#fee2e2';
        $badgeBg     = '#fee2e2';
        $badgeColor  = '#991b1b';
        $badgeLabel  = 'Points Used';
    }
    $ptsColor = $log->points >= 0 ? '#10b981' : '#ef4444';
@endphp

<div style="margin-bottom:9px;">
<table style="width:100%;border-collapse:collapse;border:1.5px solid {{ $cardBorder }};border-radius:10px;overflow:hidden;">
<tr>
    {{-- Accent strip --}}
    <td style="width:5px;background:{{ $accent }};padding:0;font-size:1px;">&nbsp;</td>

    {{-- Card body --}}
    <td style="background:{{ $cardBg }};padding:0;">
        <table style="width:100%;border-collapse:collapse;">
        <tr>
            {{-- # + Badge --}}
            <td style="width:72px;padding:13px 10px 13px 14px;vertical-align:top;">
                <div style="font-size:9px;color:#94a3b8;font-weight:700;margin-bottom:6px;letter-spacing:0.5px;">#{{ $i + 1 }}</div>
                <span style="display:inline-block;background:{{ $badgeBg }};color:{{ $badgeColor }};padding:3px 8px;border-radius:10px;font-size:8px;font-weight:800;white-space:nowrap;letter-spacing:0.3px;">{{ $badgeLabel }}</span>
            </td>

            {{-- Details --}}
            <td style="padding:13px 10px;vertical-align:top;">
                @if($log->type === 'trip_earned')
                    @php $item = $log->order?->items?->first()?->item; @endphp
                    <div style="font-weight:800;color:#0f172a;font-size:11px;margin-bottom:4px;">{{ $item?->title_en ?? $log->trip_name ?? 'Trip' }}</div>
                    @if($item?->start_date)
                        <div style="font-size:9px;color:#64748b;margin-top:3px;">
                            <span style="color:#94a3b8;">Dates:</span>
                            {{ \Carbon\Carbon::parse($item->start_date)->format('M d, Y') }}
                            @if($item->end_date) &rarr; {{ \Carbon\Carbon::parse($item->end_date)->format('M d, Y') }} @endif
                        </div>
                    @endif
                    @if($log->order)
                        <div style="margin-top:4px;">
                            <span style="font-size:9px;color:#94a3b8;">Total Paid:</span>
                            <span style="display:inline-block;background:#eff6ff;color:#4f46e5;border:1px solid #c7d2fe;padding:1px 7px;border-radius:5px;font-size:9px;font-weight:700;">{{ number_format($log->order->total_amount, 2) }} SAR</span>
                        </div>
                    @endif

                @elseif($log->type === 'employee_adjusted')
                    <div style="font-weight:800;color:#0f172a;font-size:11px;margin-bottom:4px;">{{ $log->reason }}</div>
                    <div style="font-size:9px;color:#64748b;margin-top:3px;">
                        <span style="color:#94a3b8;">By:</span> {{ $log->employee_name }}
                    </div>

                @else
                    @php $item = $log->order?->items?->first()?->item; @endphp
                    <div style="font-weight:800;color:#0f172a;font-size:11px;margin-bottom:4px;">{{ $item?->title_en ?? $log->trip_name ?? 'Trip' }}</div>
                    @if($log->order)
                        <div style="margin-top:4px;">
                            <span style="font-size:9px;color:#94a3b8;">SAR Saved:</span>
                            <span style="display:inline-block;background:#eff6ff;color:#4f46e5;border:1px solid #c7d2fe;padding:1px 7px;border-radius:5px;font-size:9px;font-weight:700;">{{ number_format(abs($log->points) / 50, 2) }} SAR</span>
                        </div>
                    @endif
                @endif
            </td>

            {{-- Points --}}
            <td style="width:90px;padding:13px 10px;vertical-align:middle;text-align:center;">
                <div style="font-size:21px;font-weight:900;color:{{ $ptsColor }};line-height:1;">
                    @if($log->points >= 0)
                        +{{ number_format($log->points) }}
                    @else
                        &minus;{{ number_format(abs($log->points)) }}
                    @endif
                </div>
                <div style="font-size:7px;color:#94a3b8;margin-top:4px;font-weight:700;text-transform:uppercase;letter-spacing:1px;">points</div>
            </td>

            {{-- Balance --}}
            <td style="width:120px;padding:13px 10px;vertical-align:middle;text-align:center;border-left:1px solid {{ $divBorder }};">
                <div style="font-size:14px;font-weight:900;color:#1e293b;line-height:1;">{{ number_format($log->balance_after) }}</div>
                <div style="font-size:8px;color:#94a3b8;margin-top:4px;line-height:1.5;">
                    {{ number_format($log->balance_before) }}
                    @if($log->points >= 0)
                        <span style="color:#10b981;font-weight:700;">+{{ number_format($log->points) }}</span>
                    @else
                        <span style="color:#ef4444;font-weight:700;">&minus;{{ number_format(abs($log->points)) }}</span>
                    @endif
                    = <span style="color:#475569;font-weight:700;">{{ number_format($log->balance_after) }}</span>
                </div>
                <div style="font-size:7px;color:#cbd5e1;margin-top:3px;font-weight:600;">pts remaining</div>
            </td>

            {{-- Date --}}
            <td style="width:76px;padding:13px 14px 13px 10px;vertical-align:middle;text-align:right;">
                <div style="font-size:10px;font-weight:700;color:#475569;">{{ $log->created_at->format('d M Y') }}</div>
                <div style="font-size:9px;color:#94a3b8;margin-top:3px;">{{ $log->created_at->format('h:i A') }}</div>
            </td>
        </tr>
        </table>
    </td>
</tr>
</table>
</div>

@endforeach
@endif

{{-- ══ FOOTER ══ --}}
<div class="footer">
    Points History for {{ $user->name }} &nbsp;|&nbsp; Generated by Rehltna Dashboard &nbsp;|&nbsp; {{ now()->year }}
</div>

</div>
</body>
</html>
