<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
<meta charset="UTF-8">
<title>New Review</title>
<style>
    body { font-family: Arial, sans-serif; background: #f1f5f9; margin: 0; padding: 30px 0; }
    .wrap { max-width: 580px; margin: 0 auto; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
    .top-bar { background: #f59e0b; height: 5px; }
    .header { background: #1e293b; padding: 28px 32px; text-align: center; }
    .header h1 { color: #fff; font-size: 20px; margin: 0 0 4px; }
    .header p { color: #94a3b8; font-size: 13px; margin: 0; }
    .body { padding: 28px 32px; }
    .alert-box { background: #fffbeb; border: 1.5px solid #fde68a; border-left: 4px solid #f59e0b; border-radius: 8px; padding: 14px 18px; margin-bottom: 22px; }
    .alert-box p { margin: 0; font-size: 14px; color: #92400e; font-weight: 600; }
    .info-table { width: 100%; border-collapse: collapse; margin-bottom: 22px; }
    .info-table tr { border-bottom: 1px solid #f1f5f9; }
    .info-table tr:last-child { border-bottom: none; }
    .info-table td { padding: 10px 4px; font-size: 13px; vertical-align: top; }
    .info-table td:first-child { color: #94a3b8; font-weight: 600; width: 38%; }
    .info-table td:last-child { color: #1e293b; font-weight: 700; }
    .stars { color: #f59e0b; font-size: 18px; letter-spacing: 2px; }
    .badge { display: inline-block; background: #fef3c7; color: #92400e; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
    .btn { display: inline-block; background: #4f46e5; color: #fff !important; text-decoration: none; padding: 13px 28px; border-radius: 8px; font-size: 14px; font-weight: 700; margin-top: 8px; }
    .footer { background: #f8fafc; padding: 16px 32px; text-align: center; font-size: 11px; color: #94a3b8; border-top: 1px solid #e2e8f0; }
</style>
</head>
<body>
<div class="wrap">
    <div class="top-bar"></div>

    <div class="header">
        <h1>⭐ New Review Submitted</h1>
        <p>A customer has left a review that needs your approval.</p>
    </div>

    <div class="body">
        <div class="alert-box">
            <p>A new review has been submitted and is <strong>awaiting your approval</strong>. Please review it and approve or reject it from the dashboard.</p>
        </div>

        <table class="info-table">
            <tr>
                <td>Reviewer</td>
                <td>{{ $review->reviewer_name }}</td>
            </tr>
            <tr>
                <td>Trip</td>
                <td>{{ $review->item?->title_ar ?? $review->item?->title_en ?? 'Trip #' . $review->item_id }}</td>
            </tr>
            <tr>
                <td>Rating</td>
                <td>
                    <span class="stars">
                        @for($i = 1; $i <= 5; $i++)
                            {{ $i <= $review->rating ? '★' : '☆' }}
                        @endfor
                    </span>
                    ({{ $review->rating }}/5)
                </td>
            </tr>
            @if($review->comment)
            <tr>
                <td>Comment</td>
                <td style="font-style:italic;color:#475569;">{{ $review->comment }}</td>
            </tr>
            @endif
            <tr>
                <td>Status</td>
                <td><span class="badge">Pending Approval</span></td>
            </tr>
            <tr>
                <td>Submitted At</td>
                <td>{{ now()->format('d M Y, h:i A') }}</td>
            </tr>
        </table>

        <a href="{{ url('/admin/reviews') }}" class="btn">Review in Dashboard →</a>
    </div>

    <div class="footer">
        This is an automated notification from Rehltna Dashboard. Do not reply to this email.
    </div>
</div>
</body>
</html>
