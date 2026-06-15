<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\PointLog;
use App\Models\ResidencyUser;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Mpdf\Mpdf;

class PointLogsController extends Controller
{
    public function index(Request $request): View|string
    {
        $query = ResidencyUser::query()->withCount('pointLogs');

        if ($request->filled('search')) {
            $search = $request->get('search');
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%")
                    ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        $sort = $request->get('sort', 'desc');
        $query->orderBy('available_points', $sort === 'asc' ? 'asc' : 'desc');

        $users = $query->paginate(15);

        if ($request->ajax()) {
            return view('pages.point-logs.partials.table', compact('users', 'sort'))->render();
        }

        return view('pages.point-logs.index', compact('users'));
    }

    private function buildPdf($userId): array
    {
        $user = ResidencyUser::query()->findOrFail($userId);
        $logs = PointLog::with('order.items.item')
            ->where('residency_user_id', $userId)
            ->orderBy('created_at', 'asc')
            ->get();

        $html = view('pages.point-logs.pdf', compact('user', 'logs'))->render();

        $mpdf = new Mpdf([
            'mode'            => 'utf-8',
            'format'          => 'A4',
            'margin_left'     => 15,
            'margin_right'    => 15,
            'margin_top'      => 15,
            'margin_bottom'   => 15,
        ]);

        $mpdf->autoScriptToLang = true;
        $mpdf->autoLangToFont   = true;
        $mpdf->SetDirectionality('ltr');
        $mpdf->WriteHTML($html);

        return [$mpdf, $user];
    }

    public function viewPdf($userId)
    {
        [$mpdf, $user] = $this->buildPdf($userId);

        return response($mpdf->Output('points-history-' . $user->id . '.pdf', 'S'))
            ->header('Content-Type', 'application/pdf')
            ->header('Content-Disposition', 'inline; filename="points-history-' . $user->id . '.pdf"');
    }

    public function downloadPdf($userId)
    {
        [$mpdf, $user] = $this->buildPdf($userId);

        return response($mpdf->Output('points-history-' . $user->id . '.pdf', 'S'))
            ->header('Content-Type', 'application/pdf')
            ->header('Content-Disposition', 'attachment; filename="points-history-' . $user->id . '.pdf"');
    }
}
