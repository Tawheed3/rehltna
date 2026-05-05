<?php

namespace App\Http\Controllers\Dashboard;

use App\Exports\ItemsErrorUploadedExport;
use App\Exports\ItemsTempExport;
use App\Http\Controllers\Controller;
use App\Jobs\ImportItemsJob;
use App\Jobs\SendPushNotificationJob;
use App\Models\City;
use App\Models\Item;
use App\Models\ItemType;
use App\Models\NotificationTemplate;
use App\Models\ResidencyUser;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class ItemController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): view
    {
        $query = Item::query();
        if (!checkIfAdmin()) {
            $query->where('user_id', auth()->id());
        }
        $items = $query->with('user')->orderByDesc('id')->paginate(10);
        $templates = NotificationTemplate::all();
        return view('pages.items.index', compact('items', 'templates'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): view
    {
        $itemTypes = ItemType::all();
        $cities = City::all();
        $employees = User::query()->whereNot('role', 'admin')->get();
        return view('pages.items.create', compact('itemTypes', 'cities', 'employees'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $activeLangs = get_active_langs();

            $fieldsToExclude = ['meta_img', 'pdf', 'gallery', 'private_gallery', 'itinerary_city_id', 'itinerary_start', 'itinerary_end', 'itinerary_nights', 'itinerary_map', 'route_title_en', 'route_title_ar', 'route_icon', 'route_order', 'price_title_ar', 'price_title_en', 'price_value', 'price_discount', 'price_discount_type', 'exclude_title_en', 'exclude_title_ar', 'exclude_icon', 'exclude_order', 'itinerary_places_en', 'itinerary_places_ar'];

            foreach ($activeLangs as $lang) {
                $fieldsToExclude[] = 'banner_' . $lang;
            }

            $data = $request->except($fieldsToExclude);
            if (checkIfAdmin()) {
                $request->validate(['responsible_user_ids' => 'required|array|min:1']);
                $ids = $request->input('responsible_user_ids');
                $data['responsible_user_ids'] = $ids;
                $data['user_id'] = $ids[0];
            } else {
                $data['user_id'] = auth()->id();
                $data['responsible_user_ids'] = [auth()->id()];
            }


            if ($request->get('is_feature') == 1) {
                $data['featured_at'] = now();
            }

            foreach ($activeLangs as $lang) {
                if ($request->filled('banner_' . $lang)) {
                    $data['banner_' . $lang] = $this->cleanPath($request->input('banner_' . $lang));
                }
            }

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            if ($request->hasFile('pdf')) {
                $data['pdf'] = uploadFile($request->file('pdf'), 'pdfs', 'pdf');
            }

            if ($request->has('price_value') && count($request->price_value) > 0) {
                $data['price'] = $request->price_value[0] ?? 0;
                $data['discount'] = $request->price_discount[0] ?? 0;
                $data['discount_type'] = $request->price_discount_type[0] ?? 'amount';
            }

            $item = Item::query()->create($data);
            $item->setAttribute('order', $request->get('order'));
            $item->save();

            if ($request->has('gallery')) {
                foreach ($request->input('gallery') as $imagePath) {
                    $item->galleries()->create(['image' => $this->cleanPath($imagePath)]);
                }
            }

            if ($request->has('private_gallery')) {
                foreach ($request->input('private_gallery') as $filePath) {
                    $item->privateGalleries()->create([
                        'image' => $this->cleanPath($filePath),
                        'type' => 'private'
                    ]);
                }
            }

            if ($request->has('itinerary_city_id')) {
                if (isset($item)) { $item->itineraries()->delete(); }

                $cityIds = $request->input('itinerary_city_id');
                $starts = $request->input('itinerary_start');
                $ends = $request->input('itinerary_end');
                $nights = $request->input('itinerary_nights');
                $maps = $request->input('itinerary_map');

                $placesEn = $request->input('itinerary_places_en');
                $placesAr = $request->input('itinerary_places_ar');

                foreach ($cityIds as $index => $cityId) {
                    if (!empty($cityId) && !empty($starts[$index])) {
                        $itin = $item->itineraries()->create([
                            'city_id' => $cityId,
                            'start_date' => $starts[$index],
                            'end_date' => $ends[$index],
                            'nights' => $nights[$index] ?? 0,
                            'map' => $maps[$index] ?? null,
                        ]);

                        if (isset($placesEn[$index]) && is_array($placesEn[$index])) {
                            foreach ($placesEn[$index] as $pIndex => $pEn) {
                                $pAr = $placesAr[$index][$pIndex] ?? null;
                                if (!empty($pEn) || !empty($pAr)) {
                                    $itin->places()->create([
                                        'title_en' => $pEn,
                                        'title_ar' => $pAr,
                                    ]);
                                }
                            }
                        }
                    }
                }
            } else {
                if (isset($item)) { $item->itineraries()->delete(); }
            }

            if ($request->has('route_title_en')) {
                if (isset($item)) {
                    $item->routes()->delete();
                }

                $routeEn = $request->input('route_title_en');
                $routeAr = $request->input('route_title_ar');
                $routeIcons = $request->input('route_icon');
                $routeOrders = $request->input('route_order');

                foreach ($routeEn as $index => $titleEn) {
                    if (!empty($titleEn) || !empty($routeAr[$index])) {
                        $item->routes()->create([
                            'title_en' => $titleEn,
                            'title_ar' => $routeAr[$index] ?? null,
                            'order' => $routeOrders[$index] ?? 0,
                            'icon' => isset($routeIcons[$index]) ? $this->cleanPath($routeIcons[$index]) : null,
                        ]);
                    }
                }
            } else {
                if (isset($item)) {
                    $item->routes()->delete();
                }

            }

            if ($request->has('price_value')) {
                if (isset($item)) {
                    $item->prices()->delete();
                }

                $pTitlesAr = $request->input('price_title_ar');
                $pTitlesEn = $request->input('price_title_en');
                $pValues = $request->input('price_value');
                $pDiscounts = $request->input('price_discount');
                $pTypes = $request->input('price_discount_type');

                foreach ($pValues as $index => $val) {
                    if (!empty($val) || $val === '0') {
                        $item->prices()->create([
                            'title_ar' => $pTitlesAr[$index] ?? null,
                            'title_en' => $pTitlesEn[$index] ?? null,
                            'price' => $val,
                            'discount' => $pDiscounts[$index] ?? 0,
                            'discount_type' => $pTypes[$index] ?? 'amount',
                        ]);
                    }
                }
            }

            if ($request->has('exclude_title_en')) {
                if (isset($item)) {
                    $item->excludes()->delete();
                }
                $excludeEn = $request->input('exclude_title_en');
                $excludeAr = $request->input('exclude_title_ar');
                $excludeIcons = $request->input('exclude_icon');
                $excludeOrders = $request->input('exclude_order');

                foreach ($excludeEn as $index => $titleEn) {
                    if (!empty($titleEn) || !empty($excludeAr[$index])) {
                        $item->excludes()->create([
                            'title_en' => $titleEn,
                            'title_ar' => $excludeAr[$index] ?? null,
                            'order' => $excludeOrders[$index] ?? 0,
                            'icon' => isset($excludeIcons[$index]) ? $this->cleanPath($excludeIcons[$index]) : null,
                        ]);
                    }
                }
            } else {
                if (isset($item)) {
                    $item->excludes()->delete();
                }
            }

            try {
                $template = NotificationTemplate::inRandomOrder()->first();
                if ($template) {

                    $isArabic = preg_match('/[\x{0600}-\x{06FF}]/u', $template->title . $template->body);

                    if ($isArabic) {
                        $tripName = $item->title_ar ?? $item->title_en ?? 'Our Trip';
                    } else {
                        $tripName = $item->title_en ?? $item->title_ar ?? 'Our Trip';
                    }

                    $title = str_replace('{trip_name}', $tripName, $template->title);
                    $body = str_replace('{trip_name}', $tripName, $template->body);

                    $tokens = ResidencyUser::whereNotNull('fcm_token')->pluck('fcm_token')->toArray();

                    foreach ($tokens as $token) {
                        SendPushNotificationJob::dispatch(
                            $token,
                            $title,
                            $body,
                            ['type' => 'new_trip', 'trip_id' => (string)$item->id]
                        );
                    }
                }
            } catch (\Exception $e) {
                Log::error("Error sending push notification for new trip: " . $e->getMessage());
            }

            return redirect()->route('items.index')->with('success', 'Item created successfully.');

        } catch (\Exception $e) {
            Log::error($e->getMessage());
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Item $item)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $item = Item::query()->findOrFail(decrypt($id));
        $itemTypes = ItemType::all();
        $cities = City::all();
        $employees = User::query()->whereNot('role', 'admin')->get();
        return view('pages.items.edit', compact('item', 'itemTypes', 'cities', 'employees'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $item = Item::query()->findOrFail($id);

            $activeLangs = get_active_langs();

            $fieldsToExclude = ['meta_img', 'pdf', 'gallery', 'private_gallery', 'itinerary_city_id', 'itinerary_start', 'itinerary_end', 'itinerary_nights', 'itinerary_map', 'route_title_en', 'route_title_ar', 'route_icon', 'route_order', 'price_title_ar', 'price_title_en', 'price_value', 'price_discount', 'price_discount_type', 'exclude_title_en', 'exclude_title_ar', 'exclude_icon', 'exclude_order', 'itinerary_places_en', 'itinerary_places_ar'];

            foreach ($activeLangs as $lang) {
                $fieldsToExclude[] = 'banner_' . $lang;
            }

            $data = $request->except($fieldsToExclude);

            if (checkIfAdmin()) {
                $ids = $request->input('responsible_user_ids', []);
                $data['responsible_user_ids'] = $ids;
                $data['user_id'] = $ids[0] ?? $item->user_id;
            } else {
                unset($data['user_id']);
            }

            if ($request->has('is_feature')) {
                if ($request->get('is_feature') == 1 && $item->is_feature == 0) {
                    $data['featured_at'] = now();
                } elseif ($request->get('is_feature') == 0) {
                    $data['featured_at'] = null;
                }
            }

            foreach ($activeLangs as $lang) {
                if ($request->filled('banner_' . $lang)) {
                    $data['banner_' . $lang] = $this->cleanPath($request->input('banner_' . $lang));
                }
            }

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            if ($request->hasFile('pdf')) {
                if ($item->pdf) deleteFiles([$item->pdf]);
                $data['pdf'] = uploadFile($request->file('pdf'), 'pdfs', 'pdf');
            }

            if ($request->has('gallery')) {
                $item->galleries()->delete();
                foreach ($request->input('gallery') as $imagePath) {
                    $item->galleries()->create(['image' => $this->cleanPath($imagePath)]);
                }
            } elseif ($request->has('gallery_cleared')) {
                $item->galleries()->delete();
            }

            if ($request->has('private_gallery')) {
                $item->privateGalleries()->delete();
                foreach ($request->input('private_gallery') as $filePath) {
                    $item->privateGalleries()->create([
                        'image' => $this->cleanPath($filePath),
                        'type' => 'private'
                    ]);
                }
            } elseif ($request->has('private_gallery_cleared')) {
                $item->privateGalleries()->delete();
            }

            if ($request->has('itinerary_city_id')) {
                if (isset($item)) { $item->itineraries()->delete(); }

                $cityIds = $request->input('itinerary_city_id');
                $starts = $request->input('itinerary_start');
                $ends = $request->input('itinerary_end');
                $nights = $request->input('itinerary_nights');
                $maps = $request->input('itinerary_map');

                $placesEn = $request->input('itinerary_places_en');
                $placesAr = $request->input('itinerary_places_ar');

                foreach ($cityIds as $index => $cityId) {
                    if (!empty($cityId) && !empty($starts[$index])) {
                        $itin = $item->itineraries()->create([
                            'city_id' => $cityId,
                            'start_date' => $starts[$index],
                            'end_date' => $ends[$index],
                            'nights' => $nights[$index] ?? 0,
                            'map' => $maps[$index] ?? null,
                        ]);

                        if (isset($placesEn[$index]) && is_array($placesEn[$index])) {
                            foreach ($placesEn[$index] as $pIndex => $pEn) {
                                $pAr = $placesAr[$index][$pIndex] ?? null;
                                if (!empty($pEn) || !empty($pAr)) {
                                    $itin->places()->create([
                                        'title_en' => $pEn,
                                        'title_ar' => $pAr,
                                    ]);
                                }
                            }
                        }
                    }
                }
            } else {
                if (isset($item)) { $item->itineraries()->delete(); }
            }

            if ($request->has('route_title_en')) {
                if (isset($item)) {
                    $item->routes()->delete();
                }

                $routeEn = $request->input('route_title_en');
                $routeAr = $request->input('route_title_ar');
                $routeIcons = $request->input('route_icon');
                $routeOrders = $request->input('route_order');

                foreach ($routeEn as $index => $titleEn) {
                    if (!empty($titleEn) || !empty($routeAr[$index])) {
                        $item->routes()->create([
                            'title_en' => $titleEn,
                            'title_ar' => $routeAr[$index] ?? null,
                            'order' => $routeOrders[$index] ?? 0,
                            'icon' => isset($routeIcons[$index]) ? $this->cleanPath($routeIcons[$index]) : null,
                        ]);
                    }
                }
            } else {
                if (isset($item)) {
                    $item->routes()->delete();
                }

            }

            if ($request->has('price_value')) {
                if (isset($item)) {
                    $item->prices()->delete();
                }
                $pTitlesAr = $request->input('price_title_ar');
                $pTitlesEn = $request->input('price_title_en');
                $pValues = $request->input('price_value');
                $pDiscounts = $request->input('price_discount');
                $pTypes = $request->input('price_discount_type');

                foreach ($pValues as $index => $val) {
                    if (!empty($val) || $val === '0') {
                        $item->prices()->create([
                            'title_ar' => $pTitlesAr[$index] ?? null,
                            'title_en' => $pTitlesEn[$index] ?? null,
                            'price' => $val,
                            'discount' => $pDiscounts[$index] ?? 0,
                            'discount_type' => $pTypes[$index] ?? 'amount',
                        ]);
                    }
                }
            }

            if ($request->has('exclude_title_en')) {
                if (isset($item)) {
                    $item->excludes()->delete();
                }
                $excludeEn = $request->input('exclude_title_en');
                $excludeAr = $request->input('exclude_title_ar');
                $excludeIcons = $request->input('exclude_icon');
                $excludeOrders = $request->input('exclude_order');

                foreach ($excludeEn as $index => $titleEn) {
                    if (!empty($titleEn) || !empty($excludeAr[$index])) {
                        $item->excludes()->create([
                            'title_en' => $titleEn,
                            'title_ar' => $excludeAr[$index] ?? null,
                            'order' => $excludeOrders[$index] ?? 0,
                            'icon' => isset($excludeIcons[$index]) ? $this->cleanPath($excludeIcons[$index]) : null,
                        ]);
                    }
                }
            } else {
                if (isset($item)) {
                    $item->excludes()->delete();
                }
            }

            if ($request->has('price_value') && count($request->price_value) > 0) {
                $data['price'] = $request->price_value[0] ?? 0;
                $data['discount'] = $request->price_discount[0] ?? 0;
                $data['discount_type'] = $request->price_discount_type[0] ?? 'amount';
            }

            $item->fill($data);
            $item->setAttribute('order', $request->get('order'));
            $item->save();

            return redirect()->route('items.index')->with('success', 'Item updated successfully.');

        } catch (\Exception $e) {
            Log::error("Error update item: " . $e->getMessage());
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        try {
            $item = Item::query()->findOrFail($id);
            $item->galleries()->delete();
            $item->privateGalleries()->delete();
            $item->delete();
            return redirect()->route('items.index')->with('success', 'Item deleted successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    private function cleanPath($path): array|string
    {
        return str_replace(url('/'), '', $path);
    }

    public function itemsChangeStatus($id): JsonResponse
    {
        $item = Item::query()->findOrFail($id);
        if ($item->status == 1) {
            $item->status = 0;
            $item->save();
        } else {
            $item->status = 1;
            $item->save();
        }
        return response()->json(['status' => $item->status]);
    }

    public function itemsChangeIsFeature($id): JsonResponse
    {
        $item = Item::query()->findOrFail($id);

        if ($item->is_feature == 1) {
            $item->is_feature = 0;
            $item->featured_at = null;
        } else {
            $item->is_feature = 1;
            $item->featured_at = now();

            try {

                $tripName = $item->title_en ?? $item->title_ar ?? 'Our Trip';
                $title = "🌟 Special Offer Alert!";
                $body = "Don't miss out! {$tripName} is now on a special offer for the next 7 days.";

                $tokens = ResidencyUser::whereNotNull('fcm_token')->pluck('fcm_token')->toArray();

                foreach ($tokens as $token) {
                    SendPushNotificationJob::dispatch(
                        $token,
                        $title,
                        $body,
                        ['type' => 'special_offer', 'trip_id' => (string)$item->id]
                    );
                }

            } catch (\Exception $e) {
                Log::error("Error sending push notification for special offer: " . $e->getMessage());
            }
        }

        $item->save();

        return response()->json(['is_feature' => $item->is_feature]);
    }

    public function changeOutOfStock($id): JsonResponse
    {
        $item = Item::query()->findOrFail($id);
        $item->out_of_stock = $item->out_of_stock == 1 ? 0 : 1;
        $item->save();
        return response()->json(['out_of_stock' => $item->out_of_stock]);
    }

    public function sendCustomNotification(Request $request, $id): JsonResponse
    {
        try {
            $item = Item::query()->findOrFail($id);
            $template = NotificationTemplate::findOrFail($request->template_id);

            $isArabic = preg_match('/[\x{0600}-\x{06FF}]/u', $template->title . $template->body);

            if ($isArabic) {
                $tripName = $item->title_ar ?? $item->title_en ?? 'Our Trip';
            } else {
                $tripName = $item->title_en ?? $item->title_ar ?? 'Our Trip';
            }

            $title = str_replace('{trip_name}', $tripName, $template->title);
            $body = str_replace('{trip_name}', $tripName, $template->body);

            $tokens = ResidencyUser::whereNotNull('fcm_token')->pluck('fcm_token')->toArray();

            foreach ($tokens as $token) {
                SendPushNotificationJob::dispatch(
                    $token,
                    $title,
                    $body,
                    ['type' => 'custom_alert', 'trip_id' => (string)$item->id]
                );
            }

            return response()->json(['message' => 'Notifications are being sent in the background!']);

        } catch (\Exception $e) {
            return response()->json(['error' => 'Something went wrong: ' . $e->getMessage()], 500);
        }
    }

    public function exportItemsTempExcel(): BinaryFileResponse
    {
        return Excel::download(new ItemsTempExport, 'itemsTemp.xlsx');
    }

    public function showUploadForm()
    {
        return view('pages.items.upload');
    }

    public function import(Request $request)
    {
        $request->validate([
            'file' => 'required|mimes:xlsx,csv,xls,txt'
        ]);

        $path = $request->file('file')->getRealPath();
        $spreadsheet = \PhpOffice\PhpSpreadsheet\IOFactory::load($path);
        $sheet = $spreadsheet->getActiveSheet();
        $rows = $sheet->toArray(null, true, true, true);

        $header = array_map('trim', $rows[1]);

        Log::info('Import started', ['file' => $request->file('file')->getClientOriginalName()]);

        $activeLangs = get_active_langs();

        foreach (array_slice($rows, 1) as $index => $row) {
            if (empty($row['A']) && empty($row['B'])) {
                Log::warning("Row {$index} skipped - empty row", $row);
                continue;
            }

            try {

                $data = [
                    'price' => $row[array_search('Price', $header)] ?? 0,
                    'status' => $row[array_search('Status', $header)] ?? 1,
                    'is_feature' => $row[array_search('Is Feature', $header)] ?? 0,
                    'item_type_id' => $row[array_search('Item Type', $header)] ?? null,
                ];

                foreach ($activeLangs as $lang) {

                    $langSuffix = ucfirst($lang);

                    $data["title_{$lang}"] = $row[array_search("Title {$langSuffix}", $header)] ?? null;
                    $data["short_description_{$lang}"] = $row[array_search("Short Description {$langSuffix}", $header)] ?? null;
                    $data["description_{$lang}"] = $row[array_search("Description {$langSuffix}", $header)] ?? null;
                    $data["meta_title_{$lang}"] = $row[array_search("Meta Title {$langSuffix}", $header)] ?? null;
                    $data["meta_description_{$lang}"] = $row[array_search("Meta Description {$langSuffix}", $header)] ?? null;
                    $data["meta_keywords_{$lang}"] = $row[array_search("Meta Keywords {$langSuffix}", $header)] ?? null;

                    if (!empty($data["title_{$lang}"])) {
                        $data["slug_{$lang}"] = $this->generateSlug("slug_{$lang}", $data["title_{$lang}"]);
                    }
                }

                $imageLink = $row[array_search('Image 1', $header)] ?? null;
                if ($imageLink) {

                    $data['meta_img'] = $this->downloadGoogleImage($imageLink, 'meta', 'meta');

                    foreach ($activeLangs as $lang) {
                        $data["banner_{$lang}"] = $this->downloadGoogleImage($imageLink, 'banners', $lang);
                    }
                }

                $item = Item::create($data);

                $imageLink2 = $row[array_search('Image 2', $header)] ?? null;
                if ($imageLink2) {
                    $path = $this->downloadGoogleImage($imageLink2, 'gallery', 'gallery');
                    if ($path) {
                        $item->galleries()->create(['image' => $path]);
                    }
                }

                Log::info("Row {$index} imported successfully"); // Removed specific title log to avoid errors if title_en is empty

            } catch (\Exception $e) {
                Log::error("Row {$index} failed to import", [
                    'error' => $e->getMessage(),
                    'row' => $row
                ]);
            }
        }

        Log::info('Import finished');

        return back()->with('success', 'Items imported successfully!');
    }

    private function downloadGoogleImage($url, string $dist, string $prefix = null): ?string
    {
        try {
            preg_match('/\/d\/(.*?)\//', $url, $matches);
            if (!isset($matches[1])) {
                return null;
            }

            $fileId = $matches[1];
            $downloadUrl = "https://drive.google.com/uc?export=download&id={$fileId}";

            $response = Http::get($downloadUrl);
            if ($response->successful()) {
                $finfo = finfo_open(FILEINFO_MIME_TYPE);
                $mime = finfo_buffer($finfo, $response->body());
                finfo_close($finfo);

                $extension = match ($mime) {
                    'image/jpeg' => 'jpeg',
                    'image/png' => 'png',
                    'image/webp' => 'webp',
                    'image/jpg' => 'jpg',
                    default => 'jpg',
                };

                $filename = uniqid() . '_' . time() . ($prefix ? "_{$prefix}" : '') . '.' . $extension;
                $path = "uploads/tenant_" . getTenantId() . "/{$dist}/" . $filename;

                if (!file_exists(public_path("uploads/tenant_" . getTenantId() . "/{$dist}"))) {
                    mkdir(public_path("uploads/tenant_" . getTenantId() . "/{$dist}"), 0777, true);
                }

                file_put_contents(public_path($path), $response->body());

                return $path;
            }
        } catch (\Exception $e) {
            return null;
        }

        return null;
    }

    public function generateSlug($slugModel, $title): string
    {
        $slug = Str::slug($title, '-');
        $original = $slug;
        $counter = 1;
        while (Item::where($slugModel, $slug)->exists()) {
            $slug = $original . '-' . $counter;
            $counter++;
        }
        return $slug;
    }

    public function exportItemsErrorUploadedExcel(): BinaryFileResponse
    {
        return Excel::download(new ItemsErrorUploadedExport, 'itemsErrorUploaded.xlsx');
    }

    public function importExcel(Request $request): RedirectResponse
    {
        $request->validate([
            'excel_file' => 'required|mimes:xlsx,xls,csv'
        ]);
        $file = $request->file('excel_file');
        $fileName = uniqid() . '_' . time() . '_' . $file->getClientOriginalName();
        $filePath = public_path('uploads/tenant_' . getTenantId() . '/excels');
        if (!file_exists($filePath)) {
            mkdir($filePath, 0777, true);
        }
        $file->move($filePath, $fileName);
        ImportItemsJob::dispatch("uploads/tenant_" . getTenantId() . "/excels/{$fileName}");

        return back()->with('success', 'File uploaded successfully, import will start in background.');
    }

    public function duplicate($id): RedirectResponse
    {
        try {

            $originalItem = Item::query()->with([
                'galleries', 'privateGalleries', 'itineraries.places',
                'routes', 'prices', 'excludes'
            ])->findOrFail(decrypt($id));

            $newItem = $originalItem->replicate();

            $newItem->status = 0;
            $newItem->is_feature = 0;
            $newItem->featured_at = null;

            $activeLangs = get_active_langs();
            foreach ($activeLangs as $lang) {
                if (!empty($newItem->{"title_$lang"})) {
                    $newItem->{"title_$lang"} = $newItem->{"title_$lang"} . ' (Copy)';
                    $newItem->{"slug_$lang"} = $this->generateSlug("slug_$lang", $newItem->{"title_$lang"});
                }
            }

            $newItem->save();

            foreach ($originalItem->galleries as $gallery) {
                $newItem->galleries()->create($gallery->only(['image', 'type']));
            }

            foreach ($originalItem->privateGalleries as $gallery) {
                $newItem->privateGalleries()->create($gallery->only(['image', 'type']));
            }

            foreach ($originalItem->prices as $price) {
                $newItem->prices()->create($price->except(['id', 'item_id', 'created_at', 'updated_at']));
            }

            foreach ($originalItem->routes as $route) {
                $newItem->routes()->create($route->except(['id', 'item_id', 'created_at', 'updated_at']));
            }

            foreach ($originalItem->excludes as $exclude) {
                $newItem->excludes()->create($exclude->except(['id', 'item_id', 'created_at', 'updated_at']));
            }

            foreach ($originalItem->itineraries as $itin) {
                $newItin = $newItem->itineraries()->create($itin->except(['id', 'item_id', 'created_at', 'updated_at']));
                foreach ($itin->places as $place) {
                    $newItin->places()->create($place->except(['id', 'itinerary_id', 'created_at', 'updated_at']));
                }
            }

            return redirect()->route('items.edit', encrypt($newItem->id))->with('success', 'Trip duplicated successfully! You are now editing the copy.');

        } catch (\Exception $e) {
            Log::error("Error duplicating item: " . $e->getMessage());
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

}
