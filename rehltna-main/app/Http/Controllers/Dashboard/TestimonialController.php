<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Testimonial;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\RedirectResponse;
use Illuminate\View\View;

class TestimonialController extends Controller
{
    public function index(Request $request): View|string
    {
        $query = Testimonial::query();

        if ($request->has('search')) {
            $query->when($request->get('search'), function ($q) use ($request) {
                $q->where('name', 'like', "%{$request->get('search')}%")
                    ->orWhere('email', 'like', "%{$request->get('search')}%")
                    ->orWhere('testimonial', 'like', "%{$request->get('search')}%");
            });
        }

        $testimonials = $query->latest()->paginate(10);

        if ($request->ajax()) {
            return view('pages.testimonials.partials.table', compact('testimonials'))->render();
        }

        return view('pages.testimonials.index', compact('testimonials'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        return view('pages.testimonials.create');
    }

    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->except('image');

            if ($request->filled('image')) {
                $data['image'] = $this->cleanPath($request->input('image'));
            }

            Testimonial::query()->create($data);

            return redirect()->route('testimonials.index')->with('success', 'Testimonial created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): View
    {
        $testimonial = Testimonial::query()->findOrFail(decrypt($id));
        return view('pages.testimonials.edit', compact('testimonial'));
    }

    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $testimonial = Testimonial::query()->findOrFail($id);

            $data = $request->except('image', '_method', '_token');

            if ($request->filled('image')) {
                $data['image'] = $this->cleanPath($request->input('image'));
            }

            $testimonial->update($data);

            return redirect()->route('testimonials.index')->with('success', 'Testimonial updated successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function destroy($id): RedirectResponse
    {
        $testimonial = Testimonial::query()->findOrFail($id);

        $testimonial->delete();

        return redirect()->back()->with('success', 'Testimonial deleted successfully.');
    }

    public function bulkDelete(Request $request): RedirectResponse
    {
        $ids = $request->get('ids');
        if (!is_array($ids) || count($ids) === 0) {
            return redirect()->back()->with('warning', 'No testimonials selected for deletion.');
        }

        Testimonial::query()->whereIn('id', $ids)->delete();

        return redirect()->back()->with('success', 'Testimonials deleted successfully.');
    }

    public function changeStatus($id): JsonResponse
    {
        $testimonial = Testimonial::query()->findOrFail($id);
        $testimonial->status = !$testimonial->status;
        $testimonial->save();

        return response()->json(['status' => $testimonial->status]);
    }

    /**
     * Helper to clean domain from URL
     */
    private function cleanPath($path): array|string
    {
        return str_replace(url('/'), '', $path);
    }
}
