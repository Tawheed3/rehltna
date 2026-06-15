<?php

namespace App\Http\Controllers\Dashboard;

use App\Exports\ItemTypesErrorUploadedExport;
use App\Exports\ItemTypesExport;
use App\Exports\ItemTypesTempExport;
use App\Http\Controllers\Controller;
use App\Imports\ItemTypesImport;
use App\Jobs\ImportItemTypesJob;
use App\Models\ErrorUploaded;
use App\Models\ItemType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\HttpFoundation\BinaryFileResponse;

class ItemTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): view
    {
        $itemTypes = ItemType::query()->orderByDesc('id')->withCount('items')->paginate(10);
        return view('pages.item-types.index', compact('itemTypes'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): view
    {
        $parents = ItemType::query()->whereNull('parent_id')->get();
        return view('pages.item-types.create', compact('parents'));
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

            if (empty($data['parent_id'])) {
                $data['parent_id'] = null;
            }

            foreach ($activeLangs as $lang) {
                if ($request->filled('banner_' . $lang)) {
                    $data['banner_' . $lang] = $this->cleanPath($request->input('banner_' . $lang));
                }
            }

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            $itemType = ItemType::query()->create($data);
            $itemType->setAttribute('order', $request->get('order'));
            $itemType->save();

            return redirect()->route('item-types.index')->with('success', 'Type item added successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $itemType = ItemType::query()->findOrFail(decrypt($id));
        $parents = ItemType::query()->whereNull('parent_id')->where('id', '!=', $itemType->id)->get();
        return view('pages.item-types.edit', compact('itemType', 'parents'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $itemType = ItemType::query()->findOrFail($id);
            $activeLangs = get_active_langs();

            $exclude = ['meta_img'];
            foreach ($activeLangs as $lang) {
                $exclude[] = 'banner_' . $lang;
            }

            $data = $request->except($exclude);

            if (empty($data['parent_id'])) {
                $data['parent_id'] = null;
            }

            foreach ($activeLangs as $lang) {
                if ($request->filled('banner_' . $lang)) {
                    $data['banner_' . $lang] = $this->cleanPath($request->input('banner_' . $lang));
                }
            }

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            $itemType->fill($data);
            $itemType->setAttribute('order', $request->get('order'));
            $itemType->save();

            return redirect()->route('item-types.index')->with('success', 'Type item updated successfully.');

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

            $itemType = ItemType::query()->findOrFail($id);

            $itemType->delete();

            return redirect()->route('item-types.index')->with('success', 'Type item deleted successfully.');

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

    public function itemTypesChangeIsFeature($id): JsonResponse
    {
        $itemType = ItemType::query()->findOrFail($id);
        $itemType->is_feature = $itemType->is_feature == 1 ? 0 : 1;
        $itemType->save();
        return response()->json(['is_feature' => $itemType->is_feature]);
    }

    public function exportItemTypesExcel(): BinaryFileResponse
    {
        return Excel::download(new ItemTypesExport, 'itemTypes.xlsx');
    }

    public function exportItemTypesTempExcel(): BinaryFileResponse
    {
        return Excel::download(new ItemTypesTempExport, 'itemTypesTemp.xlsx');
    }

    public function exportItemTypesErrorUploadedExcel(): BinaryFileResponse
    {
        return Excel::download(new ItemTypesErrorUploadedExport, 'itemTypesErrorUploaded.xlsx');
    }

    public function importExcel(Request $request): RedirectResponse
    {
        $request->validate([
            'excel_file' => 'required|mimes:xlsx,xls,csv'
        ]);
        $file = $request->file('excel_file');
        $fileName = uniqid() . '_' . time() . '_' . $file->getClientOriginalName();
        $filePath = public_path('uploads/tenant_' . getTenantId() . '/excels');
        if (!file_exists($filePath)) {
            mkdir($filePath, 0777, true);
        }
        $file->move($filePath, $fileName);

        ImportItemTypesJob::dispatch("uploads/tenant_" . getTenantId() . "/excels/{$fileName}");

        return back()->with('success', 'File uploaded successfully, import will start in background.');
    }
}
