<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Protocol;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class ProtocolController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $protocols = Protocol::query()->orderByDesc('id')->paginate(10);
        return view('pages.protocols.index', compact('protocols'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        return view('pages.protocols.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->except(['banner_ar', 'banner_en', 'meta_img']);

            if ($request->hasFile('banner_ar')) {
                $bannerAr = $request->file('banner_ar');
                $bannerArName = time() . '_ar.' . $bannerAr->getClientOriginalExtension();
                $bannerAr->move(public_path('uploads/banners'), $bannerArName);
                $data['banner_ar'] = 'uploads/banners/' . $bannerArName;
            }
            if ($request->hasFile('banner_en')) {
                $bannerEn = $request->file('banner_en');
                $bannerEnName = time() . '_en.' . $bannerEn->getClientOriginalExtension();
                $bannerEn->move(public_path('uploads/banners'), $bannerEnName);
                $data['banner_en'] = 'uploads/banners/' . $bannerEnName;
            }
            if ($request->hasFile('meta_img')) {
                $metaImg = $request->file('meta_img');
                $metaImgName = time() . '_meta.' . $metaImg->getClientOriginalExtension();
                $metaImg->move(public_path('uploads/meta'), $metaImgName);
                $data['meta_img'] = 'uploads/meta/' . $metaImgName;
            }

            $Protocol = Protocol::query()->create($data);
            $Protocol->setAttribute('order', $request->get('order'));
            $Protocol->save();

            return redirect()->route('protocols.index')->with('success', 'Protocol created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }


    /**
     * Display the specified resource.
     */
    public function show(Protocol $protocol)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $Protocol = Protocol::query()->findOrFail(decrypt($id));
        return view('pages.protocols.edit', compact('Protocol'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $protocol = Protocol::query()->findOrFail($id);

            $data = $request->except(['banner_ar', 'banner_en', 'meta_img']);

            if ($request->hasFile('banner_ar')) {
                if ($protocol->banner_ar && file_exists(public_path($protocol->banner_ar))) {
                    unlink(public_path($protocol->banner_ar));
                }
                $file = $request->file('banner_ar');
                $name = time() . '_ar.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/banners'), $name);
                $data['banner_ar'] = 'uploads/banners/' . $name;
            }

            if ($request->hasFile('banner_en')) {
                if ($protocol->banner_en && file_exists(public_path($protocol->banner_en))) {
                    unlink(public_path($protocol->banner_en));
                }
                $file = $request->file('banner_en');
                $name = time() . '_en.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/banners'), $name);
                $data['banner_en'] = 'uploads/banners/' . $name;
            }

            if ($request->hasFile('meta_img')) {
                if ($protocol->meta_img && file_exists(public_path($protocol->meta_img))) {
                    unlink(public_path($protocol->meta_img));
                }
                $file = $request->file('meta_img');
                $name = time() . '_meta.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/meta'), $name);
                $data['meta_img'] = 'uploads/meta/' . $name;
            }

            $protocol->fill($data);
            $protocol->setAttribute('order', $request->get('order'));
            $protocol->save();

            return redirect()->route('protocols.index')->with('success', 'Protocol updated successfully.');

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

            $protocol = Protocol::query()->findOrFail($id);

            if ($protocol->banner_ar && file_exists(public_path($protocol->banner_ar))) {
                unlink(public_path($protocol->banner_ar));
            }

            if ($protocol->banner_en && file_exists(public_path($protocol->banner_en))) {
                unlink(public_path($protocol->banner_en));
            }

            if ($protocol->meta_img && file_exists(public_path($protocol->meta_img))) {
                unlink(public_path($protocol->meta_img));
            }

            $protocol->delete();

            return redirect()->route('protocols.index')->with('success', 'Protocol deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function protocolsChangeStatus($id): JsonResponse
    {
        $protocol = Protocol::query()->findOrFail($id);
        if ($protocol->status == 1) {
            $protocol->status = 0;
            $protocol->save();
        } else {
            $protocol->status = 1;
            $protocol->save();
        }
        return response()->json(['status' => $protocol->status]);
    }

    public function protocolsChangeIsFeature($id): JsonResponse
    {
        $protocol = Protocol::query()->findOrFail($id);
        if ($protocol->is_feature == 1) {
            $protocol->is_feature = 0;
            $protocol->save();
        } else {
            $protocol->is_feature = 1;
            $protocol->save();
        }
        return response()->json(['is_feature' => $protocol->is_feature]);
    }
}
