<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Portfolio;
use App\Models\PortfolioCategory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class PortfolioController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $portfolios = Portfolio::query()->orderByDesc('id')->paginate(10);
        return view('pages.portfolios.index', compact('portfolios'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): view
    {
        $categories = PortfolioCategory::query()->orderByDesc('id')->get();
        return view('pages.portfolios.create', compact('categories'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->except(['img', 'meta_img', 'gallery']);

            if ($request->hasFile('img')) {
                $data['img'] = uploadFile($request->file('img'), 'portfolios', 'portfolio');
            }

            if ($request->hasFile('meta_img')) {
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            $portfolio = Portfolio::query()->create($data);
            $portfolio->setAttribute('order', $request->get('order'));
            $portfolio->save();

            if ($request->hasFile('gallery')) {
                $galleries = $request->file('gallery');
                foreach ($galleries as $gallery) {
                    $path = uploadFile($gallery, 'gallery', 'gallery');
                    $portfolio->galleries()->create(['image' => $path]);
                }
            }

            return redirect()->route('portfolios.index')->with('success', 'Portfolio created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }


    /**
     * Display the specified resource.
     */
    public function show(Portfolio $portfolio)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $portfolio = Portfolio::query()->findOrFail(decrypt($id));
        $categories = PortfolioCategory::query()->orderByDesc('id')->get();
        return view('pages.portfolios.edit', compact('portfolio', 'categories'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $portfolio = Portfolio::query()->findOrFail($id);

            $data = $request->except(['img', 'meta_img', 'gallery']);

            if ($request->hasFile('img')) {
                deleteFiles([$portfolio->img]);
                $data['img'] = uploadFile($request->file('img'), 'portfolios', 'portfolio');
            }

            if ($request->hasFile('meta_img')) {
                deleteFiles([$portfolio->meta_img]);
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            if ($request->hasFile('gallery')) {
                foreach ($portfolio->galleries as $gallery) {
                    deleteFiles([$gallery->image]);
                    $gallery->delete();
                }
                $galleries = $request->file('gallery');
                foreach ($galleries as $gallery) {
                    $path = uploadFile($gallery, 'gallery', 'gallery');
                    $portfolio->galleries()->create(['image' => $path]);
                }
            }

            $portfolio->fill($data);
            $portfolio->setAttribute('order', $request->get('order'));
            $portfolio->save();

            return redirect()->route('portfolios.index')->with('success', 'Portfolio updated successfully.');

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

            $portfolio = Portfolio::query()->findOrFail($id);

            deleteFiles([$portfolio->img, $portfolio->meta_img]);

            if ($portfolio->galleries) {
                foreach ($portfolio->galleries as $gallery) {
                    deleteFiles([$gallery->image]);
                    $gallery->delete();
                }
            }

            $portfolio->delete();

            return redirect()->route('portfolios.index')->with('success', 'Portfolio deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function portfoliosChangeStatus($id): JsonResponse
    {
        $portfolio = Portfolio::query()->findOrFail($id);
        if ($portfolio->status == 1) {
            $portfolio->status = 0;
            $portfolio->save();
        } else {
            $portfolio->status = 1;
            $portfolio->save();
        }
        return response()->json(['status' => $portfolio->status]);
    }

}
