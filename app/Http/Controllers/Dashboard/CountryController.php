<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Country;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class CountryController extends Controller
{
    public function index(): View
    {
        $countries = Country::query()->paginate(10);
        return view('pages.countries.index', compact('countries'));
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->all();
        try {
            Country::query()->create($data);
            return redirect()->route('countries.index')->with('success', 'Country added successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function update(Request $request, $id): RedirectResponse
    {
        $data = $request->all();
        try {
            $country = Country::query()->findOrFail($id);
            $country->update($data);
            return redirect()->route('countries.index')->with('success', 'Country updated successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function destroy($id): RedirectResponse
    {
        try {
            $country = Country::query()->findOrFail($id);
            $country->delete();
            return redirect()->route('countries.index')->with('success', 'Country deleted successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function countryChangeStatus($id): JsonResponse
    {
        $country = Country::query()->findOrFail($id);
        if ($country->status == 1) {
            $country->status = 0;
            $country->save();
        } else {
            $country->status = 1;
            $country->save();
        }
        return response()->json(['status' => $country->status]);
    }
}
