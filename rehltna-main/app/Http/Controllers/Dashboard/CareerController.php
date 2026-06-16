<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Career;
use App\Models\CareerType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class CareerController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $careers = Career::query()->paginate(10);
        return view('pages.careers.index', compact('careers'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        $careerTypes = CareerType::all();
        return view('pages.careers.create', compact('careerTypes'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->except(['meta_img']);

            if ($request->hasFile('meta_img')) {
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            Career::query()->create($data);

            return redirect()->route('careers.index')->with('success', 'Career created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Career $career)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): View
    {
        $career = Career::query()->findOrFail(decrypt($id));
        $careerTypes = CareerType::all();
        return view('pages.careers.edit', compact('career', 'careerTypes'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $career = Career::query()->findOrFail($id);

            $data = $request->except(['meta_img']);

            if ($request->hasFile('meta_img')) {
                deleteFiles([$career->meta_img]);
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            $career->update($data);

            return redirect()->route('careers.index')->with('success', 'Career updated successfully.');

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

            $career = Career::query()->findOrFail($id);
            deleteFiles([$career->meta_img]);
            $career->delete();

            return redirect()->route('careers.index')->with('success', 'Career deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    public function careersChangeStatus($id): JsonResponse
    {
        $career = Career::query()->findOrFail($id);
        if ($career->status == 1) {
            $career->status = 0;
            $career->save();
        } else {
            $career->status = 1;
            $career->save();
        }
        return response()->json(['status' => $career->status]);
    }
}
