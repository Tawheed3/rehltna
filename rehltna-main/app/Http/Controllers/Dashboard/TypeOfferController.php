<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\TypeOffer;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class TypeOfferController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): view
    {
        $typeOffers = TypeOffer::query()->orderByDesc('id')->withCount('offers')->paginate(10);
        return view('pages.type-offers.index', compact('typeOffers'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): view
    {
        return view('pages.type-offers.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->except(['meta_img']);

            if ($request->hasFile('meta_img')) {
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            TypeOffer::query()->create($data);

            return redirect()->route('type-offers.index')->with('success', 'Type offer added successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(TypeOffer $typeOffer)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $typeOffer = TypeOffer::query()->findOrFail(decrypt($id));
        return view('pages.type-offers.edit', compact('typeOffer'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $typeOffer = TypeOffer::query()->findOrFail($id);
            $data = $request->except(['meta_img']);
            if ($request->hasFile('meta_img')) {
                deleteFiles([$typeOffer->meta_img]);
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            $typeOffer->update($data);

            return redirect()->route('type-offers.index')->with('success', 'Type offer updated successfully.');

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

            $typeOffer = TypeOffer::query()->findOrFail($id);

            deleteFiles([$typeOffer->meta_img]);

            $typeOffer->delete();
            return redirect()->route('type-offers.index')->with('success', 'Type offer deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }
}
