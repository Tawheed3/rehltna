<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\News;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class NewsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $news = News::query()->orderByDesc('id')->paginate(10);
        return view('pages.news.index', compact('news'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): view
    {
        return view('pages.news.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {
            $activeLangs = get_active_langs();

            // 1. Identify fields to exclude from mass assignment
            $filesToExclude = ['meta_img'];
            foreach ($activeLangs as $lang) {
                $filesToExclude[] = 'banner_' . $lang;
            }

            $data = $request->except($filesToExclude);

            // 2. Upload Dynamic Banners
            foreach ($activeLangs as $lang) {
                if ($request->hasFile('banner_' . $lang)) {
                    $data['banner_' . $lang] = uploadFile($request->file('banner_' . $lang), 'news/banners', 'banner_' . $lang);
                }
            }

            // 3. Upload Meta Image
            if ($request->hasFile('meta_img')) {
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            // 4. Create News
            $new = News::query()->create($data);
            $new->setAttribute('order', $request->get('order'));
            $new->save();

            return redirect()->route('news.index')->with('success', 'News created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(News $news)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $new = News::query()->findOrFail(decrypt($id));
        return view('pages.news.edit', compact('new'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $new = News::query()->findOrFail($id);
            $activeLangs = get_active_langs();

            // 1. Identify fields to exclude
            $filesToExclude = ['meta_img'];
            foreach ($activeLangs as $lang) {
                $filesToExclude[] = 'banner_' . $lang;
            }

            $data = $request->except($filesToExclude);

            // 2. Handle Dynamic Banners (Delete Old, Upload New)
            foreach ($activeLangs as $lang) {
                if ($request->hasFile('banner_' . $lang)) {
                    // Delete old file if exists
                    if ($new->{'banner_' . $lang}) {
                        deleteFiles([$new->{'banner_' . $lang}]);
                    }
                    // Upload new file
                    $data['banner_' . $lang] = uploadFile($request->file('banner_' . $lang), 'news/banners', 'banner_' . $lang);
                }
            }

            // 3. Handle Meta Image
            if ($request->hasFile('meta_img')) {
                if ($new->meta_img) {
                    deleteFiles([$new->meta_img]);
                }
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            $new->fill($data);
            $new->setAttribute('order', $request->get('order'));
            $new->save();

            return redirect()->route('news.index')->with('success', 'News updated successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        try {
            $new = News::query()->findOrFail($id);

            $filesToDelete = [];

            // Collect Banner files dynamically
            foreach (get_active_langs() as $lang) {
                if ($new->{'banner_' . $lang}) {
                    $filesToDelete[] = $new->{'banner_' . $lang};
                }
            }

            // Collect Meta Image
            if ($new->meta_img) {
                $filesToDelete[] = $new->meta_img;
            }

            // Physical Delete
            if (!empty($filesToDelete)) {
                deleteFiles($filesToDelete);
            }

            $new->delete();

            return redirect()->route('news.index')->with('success', 'News deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function newsChangeStatus($id): JsonResponse
    {
        $new = News::query()->findOrFail($id);
        $new->status = !$new->status;
        $new->save();
        return response()->json(['status' => $new->status]);
    }

    public function newsChangeIsFeature($id): JsonResponse
    {
        $new = News::query()->findOrFail($id);
        $new->is_feature = !$new->is_feature;
        $new->save();
        return response()->json(['is_feature' => $new->is_feature]);
    }
}
