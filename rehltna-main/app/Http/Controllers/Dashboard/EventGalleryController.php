<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\EventGallery;
use App\Models\Country; // <-- تم الإضافة
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class EventGalleryController extends Controller
{
    public function index(): View
    {
        $eventGalleries = EventGallery::with('country')->orderByDesc('id')->paginate(10);
        return view('pages.events-galleries.index', compact('eventGalleries'));
    }

    public function create(): view
    {
        $countries = Country::all();
        return view('pages.events-galleries.create', compact('countries'));
    }

    public function store(Request $request): RedirectResponse
    {
        try {
            $data = $request->except(['meta_img', 'gallery', 'youtube_links']);

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            $eventGallery = EventGallery::query()->create($data);
            $eventGallery->setAttribute('order', $request->get('order'));
            $eventGallery->save();

            if ($request->has('gallery')) {
                foreach ($request->input('gallery') as $imagePath) {
                    $eventGallery->galleries()->create([
                        'image' => $this->cleanPath($imagePath)
                    ]);
                }
            }

            if ($request->has('youtube_links')) {
                foreach ($request->input('youtube_links') as $link) {
                    if (!empty($link)) {
                        $eventGallery->galleries()->create([
                            'image' => $link
                        ]);
                    }
                }
            }

            return redirect()->route('events-galleries.index')->with('success', 'Tourist Attraction created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function edit($id): view
    {
        $eventGallery = EventGallery::query()->findOrFail(decrypt($id));
        $countries = Country::all();
        return view('pages.events-galleries.edit', compact('eventGallery', 'countries'));
    }

    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $eventGallery = EventGallery::query()->findOrFail($id);
            $data = $request->except(['meta_img', 'gallery', 'youtube_links']);

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            $eventGallery->galleries()->delete();

            if ($request->has('gallery')) {
                foreach ($request->input('gallery') as $imagePath) {
                    $eventGallery->galleries()->create([
                        'image' => $this->cleanPath($imagePath)
                    ]);
                }
            }

            if ($request->has('youtube_links')) {
                foreach ($request->input('youtube_links') as $link) {
                    if (!empty($link)) {
                        $eventGallery->galleries()->create([
                            'image' => $link
                        ]);
                    }
                }
            }

            $eventGallery->fill($data);
            $eventGallery->setAttribute('order', $request->get('order'));
            $eventGallery->save();

            return redirect()->route('events-galleries.index')->with('success', 'Tourist Attraction updated successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function destroy($id): RedirectResponse
    {
        try {
            $eventGallery = EventGallery::query()->findOrFail($id);
            $eventGallery->galleries()->delete();
            $eventGallery->delete();

            return redirect()->route('events-galleries.index')->with('success', 'Tourist Attraction deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    private function cleanPath($path): array|string
    {
        return str_replace(url('/'), '', $path);
    }

    public function eventGalleryChangeStatus($id): JsonResponse
    {
        $eventGallery = EventGallery::query()->findOrFail($id);
        $eventGallery->status = $eventGallery->status == 1 ? 0 : 1;
        $eventGallery->save();
        return response()->json(['status' => $eventGallery->status]);
    }

    public function eventGalleryChangeIsFeature($id): JsonResponse
    {
        $eventGallery = EventGallery::query()->findOrFail($id);
        $eventGallery->is_feature = $eventGallery->is_feature == 1 ? 0 : 1;
        $eventGallery->save();
        return response()->json(['is_feature' => $eventGallery->is_feature]);
    }
}
