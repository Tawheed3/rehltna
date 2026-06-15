<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\CustomPage;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class CustomPageController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $pages = CustomPage::query()->orderByDesc('id')->paginate(10);
        return view('pages.custom-pages.index', compact('pages'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        return view('pages.custom-pages.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->except(['meta_img', 'files']);

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            CustomPage::query()->create($data);

            return redirect()->route('custom-pages.index')->with('success', 'Page created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): View
    {
        $page = CustomPage::query()->findOrFail(decrypt($id));
        return view('pages.custom-pages.edit', compact('page'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $page = CustomPage::query()->findOrFail($id);

            $data = $request->except(['meta_img', 'files']);

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            $page->update($data);

            return redirect()->route('custom-pages.index')->with('success', 'Page updated successfully.');

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

            $page = CustomPage::query()->findOrFail($id);

            $page->delete();

            return redirect()->route('custom-pages.index')->with('success', 'Page deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Helper to clean URL domain from the path
     */
    private function cleanPath($path): array|string
    {
        return str_replace(url('/'), '', $path);
    }

    public function pagesChangeStatus($id): JsonResponse
    {
        $page = CustomPage::query()->findOrFail($id);
        $page->status = $page->status == 1 ? 0 : 1;
        $page->save();

        return response()->json(['status' => $page->status]);
    }

    public function preview($id): JsonResponse
    {
        $page = CustomPage::query()->findOrFail($id);
        $html = view('pages.custom-pages.partials.preview', compact('page'))->render();
        return response()->json(['html' => $html]);
    }
}
