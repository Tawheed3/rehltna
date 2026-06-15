<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\PortfolioCategory;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class PortfolioCategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): view
    {
        $categories = PortfolioCategory::query()->orderByDesc('id')->withCount('portfolios')->paginate(10);
        return view('pages.portfolio-categories.index', compact('categories'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {
            PortfolioCategory::query()->create([
                'name_en' => $request->get('name_en'),
                'name_ar' => $request->get('name_ar'),
            ]);
            return redirect()->route('portfolio-categories.index')->with('success', 'Category created successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(PortfolioCategory $portfolioCategory)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(PortfolioCategory $portfolioCategory)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $category = PortfolioCategory::query()->findOrFail($id);
            $category->update([
                'name_en' => $request->get('name_en'),
                'name_ar' => $request->get('name_ar'),
            ]);
            return redirect()->route('portfolio-categories.index')->with('success', 'Category updated successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        $category = PortfolioCategory::query()->findOrFail($id);
        $category->delete();
        return redirect()->route('portfolio-categories.index')->with('success', 'Category deleted successfully');
    }
}
