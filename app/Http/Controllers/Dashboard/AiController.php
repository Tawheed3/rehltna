<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Ai;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class AiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): view
    {
        $ais = Ai::all();
        return view('pages.ai-integration.index', compact('ais'));
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
    public function store(Request $request): RedirectResponse
    {
        try {

            Ai::query()->create([
                'name' => $request->get('name'),
                'key' => $request->get('key'),
                'status' => $request->get('status'),
            ]);

            return redirect()->route('ai-integration.index')->with('success', 'Ai Model Created Successfully');

        } catch (\Exception $exception) {
            return back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Ai $ai)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Ai $ai)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $ai_model = Ai::query()->findOrFail($id);
            $ai_model->update([
                'name' => $request->get('name'),
                'key' => $request->get('key'),
                'status' => $request->get('status'),
            ]);

            return redirect()->route('ai-integration.index')->with('success', 'Ai Model Updated Successfully');

        } catch (\Exception $exception) {
            return back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        $ai_model = Ai::query()->findOrFail($id);
        $ai_model->delete();
        return redirect()->route('ai-integration.index')->with('success', 'Ai Model Deleted Successfully');
    }
}
