<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\NotificationTemplate;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class NotificationTemplateController extends Controller
{

    public function index(): View
    {
        $templates = NotificationTemplate::latest()->get();
        return view('pages.notification_templates.index', compact('templates'));
    }

    public function store(Request $request): RedirectResponse
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'body' => 'required|string',
        ]);

        NotificationTemplate::create($request->only(['title', 'body']));

        return redirect()->back()->with('success', 'Template added successfully.');
    }

    public function update(Request $request, $id): RedirectResponse
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'body' => 'required|string',
        ]);

        $template = NotificationTemplate::findOrFail($id);
        $template->update($request->only(['title', 'body']));

        return redirect()->back()->with('success', 'Template updated successfully.');
    }

    public function destroy($id): RedirectResponse
    {
        NotificationTemplate::findOrFail($id)->delete();
        return redirect()->back()->with('success', 'Template deleted successfully.');
    }
}
