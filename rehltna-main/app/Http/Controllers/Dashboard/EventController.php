<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Event;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class EventController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $events = Event::query()->orderByDesc('id')->paginate(10);
        return view('pages.events.index', compact('events'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): view
    {
        return view('pages.events.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {
            $activeLangs = get_active_langs();

            // 1. Identify fields to exclude (banners + specific files)
            $filesToExclude = ['meta_img', 'gallery'];
            foreach ($activeLangs as $lang) {
                $filesToExclude[] = 'banner_' . $lang;
            }

            $data = $request->except($filesToExclude);

            // 2. Upload Dynamic Banners
            foreach ($activeLangs as $lang) {
                if ($request->hasFile('banner_' . $lang)) {
                    $data['banner_' . $lang] = uploadFile($request->file('banner_' . $lang), 'events/banners', 'banner_' . $lang);
                }
            }

            // 3. Upload Meta Image
            if ($request->hasFile('meta_img')) {
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            // 4. Create Event
            $event = Event::query()->create($data);
            $event->setAttribute('order', $request->get('order'));
            $event->save();

            // 5. Handle Gallery
            if ($request->hasFile('gallery')) {
                foreach ($request->file('gallery') as $file) {
                    $path = uploadFile($file, 'events/gallery', 'gallery');
                    $event->galleries()->create(['image' => $path]);
                }
            }

            return redirect()->route('events.index')->with('success', 'Event created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Event $event)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $event = Event::query()->findOrFail(decrypt($id));
        return view('pages.events.edit', compact('event'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $event = Event::query()->findOrFail($id);
            $activeLangs = get_active_langs();

            // 1. Identify exclusions
            $filesToExclude = ['meta_img', 'gallery'];
            foreach ($activeLangs as $lang) {
                $filesToExclude[] = 'banner_' . $lang;
            }

            $data = $request->except($filesToExclude);

            // 2. Handle Dynamic Banners (Delete Old, Upload New)
            foreach ($activeLangs as $lang) {
                if ($request->hasFile('banner_' . $lang)) {
                    if ($event->{'banner_' . $lang}) {
                        deleteFiles([$event->{'banner_' . $lang}]);
                    }
                    $data['banner_' . $lang] = uploadFile($request->file('banner_' . $lang), 'events/banners', 'banner_' . $lang);
                }
            }

            // 3. Handle Meta Image
            if ($request->hasFile('meta_img')) {
                if ($event->meta_img) {
                    deleteFiles([$event->meta_img]);
                }
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            // 4. Handle Gallery (Replace logic based on original code)
            if ($request->hasFile('gallery')) {
                // Delete old gallery images physically and from DB
                foreach ($event->galleries as $gallery) {
                    deleteFiles([$gallery->image]);
                    $gallery->delete();
                }

                // Upload new images
                foreach ($request->file('gallery') as $file) {
                    $path = uploadFile($file, 'events/gallery', 'gallery');
                    $event->galleries()->create(['image' => $path]);
                }
            }

            $event->fill($data);
            $event->setAttribute('order', $request->get('order'));
            $event->save();

            return redirect()->route('events.index')->with('success', 'Event updated successfully.');

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
            $event = Event::query()->findOrFail($id);

            $filesToDelete = [];

            // Collect Banner files
            foreach (get_active_langs() as $lang) {
                if ($event->{'banner_' . $lang}) {
                    $filesToDelete[] = $event->{'banner_' . $lang};
                }
            }

            // Collect Meta Image
            if ($event->meta_img) {
                $filesToDelete[] = $event->meta_img;
            }

            // Collect Gallery Images
            if ($event->galleries) {
                foreach ($event->galleries as $gallery) {
                    if ($gallery->image) {
                        $filesToDelete[] = $gallery->image;
                    }
                    // No need to manually delete record here, cascade or $event->delete() handles it usually,
                    // but strict cleanup:
                    $gallery->delete();
                }
            }

            // Physical Delete
            if (!empty($filesToDelete)) {
                deleteFiles($filesToDelete);
            }

            $event->delete();

            return redirect()->route('events.index')->with('success', 'Event deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function eventsChangeStatus($id): JsonResponse
    {
        $event = Event::query()->findOrFail($id);
        $event->status = !$event->status;
        $event->save();
        return response()->json(['status' => $event->status]);
    }

    public function eventsChangeIsFeature($id): JsonResponse
    {
        $event = Event::query()->findOrFail($id);
        $event->is_feature = !$event->is_feature;
        $event->save();
        return response()->json(['is_feature' => $event->is_feature]);
    }
}
