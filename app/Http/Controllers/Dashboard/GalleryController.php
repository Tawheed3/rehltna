<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use App\Models\Gallery;
use App\Models\Folder;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class GalleryController extends Controller
{
    public function index(Request $request): View
    {
        $currentFolder = null;
        $folders = collect();
        $galleries = collect();

        if ($request->has('folder_id') && $request->folder_id != null) {
            $currentFolder = Folder::query()->findOrFail($request->folder_id);
            $galleries = $currentFolder->galleries()
                ->latest()
                ->paginate(18)
                ->appends(['folder_id' => $request->folder_id]);
            $folders = collect();
        } else {
            $folders = Folder::query()->latest()->get();
            $galleries = Gallery::query()->whereNull('galleryable_id')
                ->latest()
                ->paginate(18);
        }

        return view('pages.gallery.index', compact('folders', 'galleries', 'currentFolder'));
    }

    public function storeFolder(Request $request): JsonResponse|RedirectResponse
    {
        $request->validate([
            'name' => 'required|string|max:255',
        ]);

        Folder::query()->create([
            'name' => $request->get('name'),
        ]);

        if ($request->ajax()) {
            return response()->json(['success' => true, 'message' => 'Folder Created']);
        }

        return redirect()->back()->with('success', 'Folder Created Successfully');
    }

    public function updateFolder(Request $request, $id): RedirectResponse
    {
        $request->validate([
            'name' => 'required|string|max:255',
        ]);
        $folder = Folder::query()->findOrFail($id);
        $folder->update(['name' => $request->get('name')]);
        return redirect()->back()->with('success', 'Folder Updated Successfully');
    }

    public function storeGallery(Request $request): JsonResponse|RedirectResponse
    {

        $request->validate([
            'files' => 'required',
            'files.*' => 'file|max:102400',
            'folder_id' => 'nullable',
        ]);

        $folderName = 'general';
        $folder = null;

        if ($request->get('folder_id') && $request->get('folder_id') !== 'root') {
            $folder = Folder::query()->find($request->get('folder_id'));
            if ($folder) {
                $folderName = $folder->name;
            }
        }

        if ($request->hasFile('files')) {
            foreach ($request->file('files') as $file) {
                $mimeType = $file->getMimeType();
                $type = str_contains($mimeType, 'video') ? 'video' : 'general';

                $path = uploadFile($file, $folderName, $type);

                $data = [
                    'image' => $path,
                    'type' => $type,
                ];

                if ($folder) {
                    $folder->galleries()->create($data);
                } else {
                    Gallery::query()->create($data);
                }
            }
        }

        if ($request->ajax()) {
            return response()->json(['success' => true, 'message' => 'Uploaded Successfully']);
        }

        return redirect()->back()->with('success', 'Files Uploaded Successfully');
    }

    public function destroy($id): RedirectResponse
    {
        $gallery = Gallery::query()->findOrFail($id);
        deleteFiles([$gallery->image]);
        $gallery->delete();
        return redirect()->back()->with('success', 'File Deleted');
    }

    public function destroyFolder($id): RedirectResponse
    {
        $folder = Folder::query()->findOrFail($id);
        foreach ($folder->galleries as $file) {
            deleteFiles([$file->image]);
            $file->delete();
        }
        $folder->delete();
        return redirect()->back()->with('success', 'Folder Deleted');
    }

    public function moveFile(Request $request): JsonResponse
    {
        $request->validate([
            'file_id' => ['required', Rule::exists(Gallery::class, 'id')],
            'folder_id' => 'nullable',
        ]);
        $file = Gallery::query()->findOrFail($request->get('file_id'));
        $file->update([
            'galleryable_type' => $request->get('folder_id') ? 'App\Models\Folder' : null,
            'galleryable_id' => $request->get('folder_id')
        ]);
        return response()->json(['success' => true]);
    }

    public function picker(Request $request): View
    {
        $currentFolder = null;
        $folders = collect();
        $galleries = collect();

        if ($request->has('folder_id') && $request->folder_id != null && $request->folder_id != 'root') {
            $currentFolder = Folder::find($request->folder_id);
            if($currentFolder) {
                $galleries = $currentFolder->galleries()->latest()->paginate(45);
            }
        } else {
            $folders = Folder::latest()->get();
            $galleries = Gallery::whereNull('galleryable_id')->latest()->paginate(45);
        }

        $folderIdParam = $request->folder_id ?? 'root';
        $galleries->appends(['folder_id' => $folderIdParam]);

        return view('pages.gallery.picker_partial', compact('folders', 'galleries', 'currentFolder'));
    }
}
