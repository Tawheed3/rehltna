<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Package;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class PackageController extends Controller
{
    public function index(): View
    {
        $packages = Package::query()->orderBy('price', 'asc')->get();
        return view('pages.packages.index', compact('packages'));
    }

    public function create(): View
    {
        return view('pages.packages.create');
    }

    public function store(Request $request): RedirectResponse
    {
        try {
            $activeLangs = get_active_langs();
            $data = ['price' => $request->price];

            foreach ($activeLangs as $lang) {
                $data['name_' . $lang] = $request->input('name_' . $lang);
            }

            $features = [];
            $firstLang = $activeLangs[0];

            if ($request->has('feature_' . $firstLang)) {
                $rowCount = count($request->input('feature_' . $firstLang));

                for ($i = 0; $i < $rowCount; $i++) {
                    $featureRow = [];
                    $hasData = false;

                    foreach ($activeLangs as $lang) {
                        $val = $request->input('feature_' . $lang)[$i] ?? '';
                        $featureRow[$lang] = $val;
                        if (!empty($val)) $hasData = true;
                    }

                    if ($hasData) {
                        $features[] = $featureRow;
                    }
                }
            }
            $data['features'] = $features;
            $data['icon'] = $request->input('icon');
            $data['points_multiplier'] = $request->points_multiplier ?? 1;

            Package::query()->create($data);

            return redirect()->route('packages.index')->with('success', 'Package created successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong: ' . $e->getMessage());
        }
    }

    public function edit($id): View
    {
        $package = Package::query()->findOrFail(decrypt($id));
        return view('pages.packages.edit', compact('package'));
    }

    public function update(Request $request, $id): RedirectResponse
    {
        $package = Package::query()->findOrFail($id);

        try {
            $activeLangs = get_active_langs();
            $data = ['price' => $request->price];

            foreach ($activeLangs as $lang) {
                $data['name_' . $lang] = $request->input('name_' . $lang);
            }

            $features = [];
            $firstLang = $activeLangs[0];

            if ($request->has('feature_' . $firstLang)) {
                $rowCount = count($request->input('feature_' . $firstLang));

                for ($i = 0; $i < $rowCount; $i++) {
                    $featureRow = [];
                    $hasData = false;

                    foreach ($activeLangs as $lang) {
                        $val = $request->input('feature_' . $lang)[$i] ?? '';
                        $featureRow[$lang] = $val;
                        if (!empty($val)) $hasData = true;
                    }

                    if ($hasData) {
                        $features[] = $featureRow;
                    }
                }
            }
            $data['features'] = $features;
            $data['icon'] = $request->input('icon');
            $data['points_multiplier'] = $request->points_multiplier ?? 1;

            $package->update($data);

            return redirect()->route('packages.index')->with('success', 'Package updated successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    public function destroy($id): RedirectResponse
    {
        $package = Package::query()->findOrFail($id);
        $package->delete();
        return redirect()->route('packages.index')->with('success', 'Package deleted successfully');
    }
}
