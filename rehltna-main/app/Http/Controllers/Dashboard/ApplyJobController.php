<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\ApplyJob;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class ApplyJobController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request): View|JsonResponse
    {
        $query = ApplyJob::query();

        if ($request->has('search')) {
            $query->when($request->get('search'), function ($q) use ($request) {
                $q->where('name', 'like', "%{$request->get('search')}%")
                    ->orWhere('email', 'like', "%{$request->get('search')}%")
                    ->orWhere('phone', 'like', "%{$request->get('search')}%");
            });
        }

        if ($request->filled('status')) {
            $query->where('status', $request->get('status'));
        }

        $applyJobs = $query->orderByRaw("FIELD(status, 'pending', 'accepted','rejected')")
            ->latest()
            ->paginate(10);

        if ($request->ajax()) {
            return view('pages.apply-jobs.partials.table', compact('applyJobs'));
        }

        return view('pages.apply-jobs.index', compact('applyJobs'));
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
    public function show($id): View
    {
        $applyJob = ApplyJob::query()->findOrFail(decrypt($id));
        return view('pages.apply-jobs.show', compact('applyJob'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(ApplyJob $applyJob)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $applyJob = ApplyJob::query()->findOrFail($id);
            $applyJob->update([
                'status' => $request->get('status'),
            ]);

            return redirect()->route('apply-jobs.index')->with('success', 'Application updated successfully');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        try {

            $application = ApplyJob::query()->findOrFail($id);

            if ($application->cv && file_exists(public_path($application->cv))) {
                unlink(public_path($application->cv));
            }

            $application->delete();

            return redirect()->route('apply-jobs.index')->with('success', 'Application deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }
}
