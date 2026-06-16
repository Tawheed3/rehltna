<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Members;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class MembersController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $members = Members::query()->orderByDesc('id')->paginate(10);
        return view('pages.members.index', compact('members'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): view
    {
        return view('pages.members.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->except(['img', 'meta_img']);


            if ($request->filled('img')) {
                $data['img'] = $this->cleanPath($request->input('img'));
            }

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            $member = Members::query()->create($data);
            $member->setAttribute('order', $request->get('order'));
            $member->save();

            return redirect()->route('members.index')->with('success', 'Member created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $member = Members::query()->findOrFail(decrypt($id));
        return view('pages.members.edit', compact('member'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $member = Members::query()->findOrFail($id);
            $data = $request->except(['img', 'meta_img']);

            if ($request->filled('img')) {
                $data['img'] = $this->cleanPath($request->input('img'));
            }

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            $member->fill($data);
            $member->setAttribute('order', $request->get('order'));
            $member->save();

            return redirect()->route('members.index')->with('success', 'Member updated successfully.');

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

            $member = Members::query()->findOrFail($id);

            $member->delete();

            return redirect()->route('members.index')->with('success', 'Member deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Helper to clean domain from URL
     */
    private function cleanPath($path): array|string
    {
        return str_replace(url('/'), '', $path);
    }

    public function membersChangeStatus($id): JsonResponse
    {
        $member = Members::query()->findOrFail($id);
        $member->status = $member->status == 1 ? 0 : 1;
        $member->save();
        return response()->json(['status' => $member->status]);
    }
}
