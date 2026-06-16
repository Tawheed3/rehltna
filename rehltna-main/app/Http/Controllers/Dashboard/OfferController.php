<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Offer;
use App\Models\TypeOffer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class OfferController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): view
    {
        $offers = Offer::query()->orderByDesc('id')->paginate(10);
        return view('pages.offers.index', compact('offers'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): view
    {
        $typeOffers = TypeOffer::all();
        return view('pages.offers.create', compact('typeOffers'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->except(['banner_ar', 'banner_en', 'meta_img']);

            if ($request->hasFile('banner_ar')) {
                $data['banner_ar'] = uploadFile($request->file('banner_ar'), 'banners', 'ar');
            }
            if ($request->hasFile('banner_en')) {
                $data['banner_en'] = uploadFile($request->file('banner_en'), 'banners', 'en');
            }
            if ($request->hasFile('meta_img')) {
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            $offer = Offer::query()->create($data);
            $offer->setAttribute('order', $request->get('order'));
            $offer->save();

            return redirect()->route('offers.index')->with('success', 'Offer created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Offer $offer)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $offer = Offer::query()->findOrFail(decrypt($id));
        $typeOffers = TypeOffer::all();
        return view('pages.offers.edit', compact('offer', 'typeOffers'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $offer = Offer::query()->findOrFail($id);

            $data = $request->except(['banner_ar', 'banner_en', 'meta_img']);

            if ($request->hasFile('banner_ar')) {
                deleteFiles([$offer->banner_ar]);
                $data['banner_ar'] = uploadFile($request->file('banner_ar'), 'banners', 'ar');
            }

            if ($request->hasFile('banner_en')) {
                deleteFiles([$offer->banner_en]);
                $data['banner_en'] = uploadFile($request->file('banner_en'), 'banners', 'en');
            }

            if ($request->hasFile('meta_img')) {
                deleteFiles([$offer->meta_img]);
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            $offer->fill($data);
            $offer->setAttribute('order', $request->get('order'));
            $offer->save();

            return redirect()->route('offers.index')->with('success', 'Offer updated successfully.');

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

            $offer = Offer::query()->findOrFail($id);

            deleteFiles([$offer->banner_ar, $offer->banner_en, $offer->meta_img]);
            $offer->delete();

            return redirect()->route('offers.index')->with('success', 'Offer deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    public function offersChangeStatus($id): JsonResponse
    {
        $offer = Offer::query()->findOrFail($id);
        if ($offer->status == 1) {
            $offer->status = 0;
            $offer->save();
        } else {
            $offer->status = 1;
            $offer->save();
        }
        return response()->json(['status' => $offer->status]);
    }

    public function offersChangeIsFeature($id): JsonResponse
    {
        $offer = Offer::query()->findOrFail($id);
        if ($offer->is_feature == 1) {
            $offer->is_feature = 0;
            $offer->save();
        } else {
            $offer->is_feature = 1;
            $offer->save();
        }
        return response()->json(['is_feature' => $offer->is_feature]);
    }
}
