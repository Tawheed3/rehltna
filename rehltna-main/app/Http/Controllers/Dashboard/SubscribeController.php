<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Subscribe;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use App\Exports\SubscribersExport;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\HttpFoundation\BinaryFileResponse;

class SubscribeController extends Controller
{
    /**
     * Display a listing of the resource.
     */

    public function index(Request $request): view|string
    {
        $query = Subscribe::query();

        if ($request->has('search')) {
            $query->when($request->get('search'), function ($q) use ($request) {
                $q->where('email', 'like', "%{$request->get('search')}%");
            });
        }

        $subscribes = $query->latest()
            ->paginate(10);

        if ($request->ajax()) {
            return view('pages.subscribes.partials.table', compact('subscribes'))->render();
        }

        return view('pages.subscribes.index', compact('subscribes'));

    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(Subscribe $subscribe)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Subscribe $subscribe)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Subscribe $subscribe)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        Subscribe::query()->findOrFail($id)->delete();
        return redirect()->back()->with('success', 'Subscribe deleted successfully.');
    }

    public function bulkDelete(Request $request): RedirectResponse
    {
        $ids = $request->get('ids');
        if (!is_array($ids) || count($ids) === 0) {
            return redirect()->back()->with('warning', 'No messages selected for deletion.');
        }

        Subscribe::query()->whereIn('id', $ids)->delete();
        return redirect()->back()->with('success', 'Subscribe deleted successfully.');
    }

    public function exportSubscribeExcel(): BinaryFileResponse
    {
        return Excel::download(new SubscribersExport, 'subscribers.xlsx');
    }
}
