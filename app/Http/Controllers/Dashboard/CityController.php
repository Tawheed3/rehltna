<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\City;
use App\Models\Country;
use App\Models\State;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class CityController extends Controller
{
    public function index(): View
    {
        $states = State::with('country')->get();
        $countries = Country::all();
        $cities = City::query()->with(['state', 'country'])->paginate(10);
        return view('pages.cities.index', compact('cities', 'states', 'countries'));
    }

    public function store(Request $request): RedirectResponse
    {
        try {
            $existing = $this->findDuplicateCity($request->title_ar, $request->title_en);
            if ($existing) {
                return redirect()->back()
                    ->withInput()
                    ->with('error', "هذه المدينة موجودة بالفعل: «{$existing->title_ar}»");
            }

            $data = $request->all();

            if ($request->filled('state_id')) {
                $state = State::query()->findOrFail($request->get('state_id'));
                $data['country_id'] = $state->country_id;
            } else {
                $data['state_id'] = null;
                $data['country_id'] = $request->filled('country_id') ? $request->get('country_id') : null;
            }

            $city = City::query()->create($data);

            return redirect()->route('cities.index')->with('success', 'City created successfully');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $city = City::query()->findOrFail($id);
            $data = $request->all();

            if ($request->filled('state_id')) {
                $state = State::query()->findOrFail($request->get('state_id'));
                $data['country_id'] = $state->country_id;
            } else {
                $data['state_id'] = null;
                $data['country_id'] = $request->filled('country_id') ? $request->get('country_id') : null;
            }

            $city->update($data);

            return redirect()->route('cities.index')->with('success', 'City updated successfully');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function destroy($id): RedirectResponse
    {
        try {

            $city = City::query()->findOrFail($id);
            $city->delete();

            return redirect()->route('cities.index')->with('success', 'City deleted successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function quickCreate(Request $request): JsonResponse
    {
        $request->validate(['name' => 'required|string|max:255']);

        $existing = $this->findDuplicateCity($request->name, $request->name);
        if ($existing) {
            return response()->json([
                'id'   => $existing->id,
                'name' => $existing->title_ar ?: $existing->title_en,
            ]);
        }

        $city = City::create([
            'title_en' => $request->name,
            'title_ar' => $request->name,
            'status'   => true,
        ]);

        return response()->json(['id' => $city->id, 'name' => $request->name]);
    }

    private function normalizeArabic(string $text): string
    {
        $text = mb_strtolower(trim($text), 'UTF-8');
        $text = str_replace(['أ', 'إ', 'آ', 'ٱ'], 'ا', $text);
        $text = str_replace('ى', 'ي', $text);
        $text = preg_replace('/[\x{064B}-\x{065F}\x{0670}]/u', '', $text);
        $text = str_replace('ـ', '', $text);
        return $text;
    }

    private function findDuplicateCity(?string $titleAr, ?string $titleEn): ?City
    {
        if (!$titleAr && !$titleEn) return null;

        $normalizedAr = $titleAr ? $this->normalizeArabic($titleAr) : null;
        $normalizedEn = $titleEn ? mb_strtolower(trim($titleEn), 'UTF-8') : null;

        return City::all()->first(function ($city) use ($normalizedAr, $normalizedEn) {
            if ($normalizedAr && $normalizedAr !== '' && $this->normalizeArabic($city->title_ar ?? '') === $normalizedAr) {
                return true;
            }
            if ($normalizedEn && $normalizedEn !== '' && mb_strtolower(trim($city->title_en ?? ''), 'UTF-8') === $normalizedEn) {
                return true;
            }
            return false;
        });
    }

    public function cityChangeStatus($id): JsonResponse
    {
        $city = City::query()->findOrFail($id);
        if ($city->status == 1) {
            $city->status = 0;
            $city->save();
        } else {
            $city->status = 1;
            $city->save();
        }
        return response()->json(['status' => $city->status]);
    }
}
