<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\TravelTool;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class TravelToolController extends Controller
{
    public function index(): View
    {
        $tools = TravelTool::query()->orderBy('order')->orderByDesc('id')->paginate(20);
        return view('pages.travel-tools.index', compact('tools'));
    }

    public function create(): View
    {
        return view('pages.travel-tools.create');
    }

    public function store(Request $request): RedirectResponse
    {
        $request->validate([
            'title'       => 'required|string|max:255',
            'description' => 'nullable|string',
            'icon'        => 'nullable|string|max:10',
            'order'       => 'nullable|integer|min:0',
        ]);

        try {
            TravelTool::query()->create([
                'title'       => $request->input('title'),
                'description' => $request->input('description'),
                'icon'        => $request->input('icon'),
                'order'       => $request->input('order', 0),
                'is_active'   => $request->boolean('is_active', true),
            ]);

            return redirect()->route('travel-tools.index')->with('success', 'تم إضافة الأداة بنجاح');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'حدث خطأ أثناء الحفظ')->withInput();
        }
    }

    public function edit($id): View
    {
        $tool = TravelTool::query()->findOrFail(decrypt($id));
        return view('pages.travel-tools.edit', compact('tool'));
    }

    public function update(Request $request, $id): RedirectResponse
    {
        $request->validate([
            'title'       => 'required|string|max:255',
            'description' => 'nullable|string',
            'icon'        => 'nullable|string|max:10',
            'order'       => 'nullable|integer|min:0',
        ]);

        try {
            $tool = TravelTool::query()->findOrFail(decrypt($id));
            $tool->update([
                'title'       => $request->input('title'),
                'description' => $request->input('description'),
                'icon'        => $request->input('icon'),
                'order'       => $request->input('order', 0),
                'is_active'   => $request->boolean('is_active'),
            ]);

            return redirect()->route('travel-tools.index')->with('success', 'تم تحديث الأداة بنجاح');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'حدث خطأ أثناء الحفظ')->withInput();
        }
    }

    public function destroy($id): RedirectResponse
    {
        try {
            TravelTool::query()->findOrFail(decrypt($id))->delete();
            return redirect()->route('travel-tools.index')->with('success', 'تم الحذف بنجاح');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'حدث خطأ أثناء الحذف');
        }
    }
}
