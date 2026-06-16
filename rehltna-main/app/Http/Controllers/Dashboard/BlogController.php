<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Jobs\GenerateBlogsFromAI;
use App\Models\Ai;
use App\Models\Blog;
use App\Models\Category;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\View\View;

class BlogController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): view
    {
        $blogs = Blog::query()->orderByDesc('id')->paginate(10);
        $categories = Category::all();
        $ais = Ai::all();
        return view('pages.blogs.index', compact('blogs', 'categories', 'ais'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): view
    {
        $categories = Category::all();
        return view('pages.blogs.create', compact('categories'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {
            $activeLangs = get_active_langs();

            $exclude = ['meta_img'];
            foreach ($activeLangs as $lang) {
                $exclude[] = 'banner_' . $lang;
            }

            $data = $request->except($exclude);

            foreach ($activeLangs as $lang) {
                if ($request->filled('banner_' . $lang)) {
                    $data['banner_' . $lang] = $this->cleanPath($request->input('banner_' . $lang));
                }
            }

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            $blog = Blog::query()->create($data);
            $blog->setAttribute('order', $request->get('order'));
            $blog->save();

            return redirect()->route('blogs.index')->with('success', 'Blog created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $blog = Blog::query()->findOrFail(decrypt($id));
        $categories = Category::all();
        return view('pages.blogs.edit', compact('blog', 'categories'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $blog = Blog::query()->findOrFail($id);
            $activeLangs = get_active_langs();

            $exclude = ['meta_img'];
            foreach ($activeLangs as $lang) {
                $exclude[] = 'banner_' . $lang;
            }

            $data = $request->except($exclude);

            foreach ($activeLangs as $lang) {
                if ($request->filled('banner_' . $lang)) {
                    $data['banner_' . $lang] = $this->cleanPath($request->input('banner_' . $lang));
                }
            }

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            $blog->fill($data);
            $blog->setAttribute('order', $request->get('order'));
            $blog->save();

            return redirect()->route('blogs.index')->with('success', 'Blog updated successfully.');

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

            $blog = Blog::query()->findOrFail($id);

            $blog->delete();

            return redirect()->route('blogs.index')->with('success', 'Blog deleted successfully.');

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

    public function createBlogsWithAi(Request $request): RedirectResponse
    {
        try {
            GenerateBlogsFromAI::dispatch(
                $request->get('title'),
                $request->get('count'),
                $request->get('ai_model_id'),
                $request->get('category_id'),
                session('tenant_id')
            );

            return redirect()->route('blogs.index')->with('success', 'Blog creation has been queued.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    public function blogsChangeStatus($id): JsonResponse
    {
        $blog = Blog::query()->findOrFail($id);
        $blog->status = $blog->status == 1 ? 0 : 1;
        $blog->save();
        return response()->json(['status' => $blog->status]);
    }

    public function blogsChangeIsFeature($id): JsonResponse
    {
        $blog = Blog::query()->findOrFail($id);
        $blog->is_feature = $blog->is_feature == 1 ? 0 : 1;
        $blog->save();
        return response()->json(['is_feature' => $blog->is_feature]);
    }

    public function failedJobs(): view
    {
        $failedJobs = DB::table('failed_jobs')->get();
        return view('pages.failedJobs.index', compact('failedJobs'));
    }

    public function failedJobsRetry($id): RedirectResponse
    {
        Artisan::call("queue:retry", ['id' => $id]);
        return redirect()->back()->with('success', 'Job retry has been queued.');
    }
}
