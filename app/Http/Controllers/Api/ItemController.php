<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Item;
use App\Models\ItemType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ItemController extends Controller
{
    use ResponseTrait;

    private function getOrderedRelations(): array
    {
        return [
            'galleries',
            'itemType',
            'itineraries' => function ($q) {
                $q->orderBy('id', 'asc');
            },
            'itineraries.places' => function ($q) {
                $q->orderBy('id', 'asc');
            },
            'itineraries.city',
            'routes' => function ($q) {
                $q->orderBy('id', 'asc');
            },
            'prices' => function ($q) {
                $q->orderBy('id', 'asc');
            },
            'excludes' => function ($q) {
                $q->orderBy('id', 'asc');
            }
        ];
    }

    public function getItems(Request $request): JsonResponse
    {

        $ended = $request->get('ended') === '1';
        $today = now()->toDateString();
        $query = Item::query()
            ->when($ended,
                fn($q) => $q->where('start_date', '<', $today),
                fn($q) => $q->where('status', 1)->where(fn($q2) => $q2->whereNull('start_date')->orWhere('start_date', '>=', $today))
            )
            ->with($this->getOrderedRelations());

        if ($request->filled('search')) {
            $keyword = trim($request->get('search'));
            $lowerKeyword = mb_strtolower($keyword, 'UTF-8');
            $gregorianMonths = [
                'january' => '01', 'يناير' => '01',
                'february' => '02', 'فبراير' => '02',
                'march' => '03', 'مارس' => '03',
                'april' => '04', 'ابريل' => '04', 'إبريل' => '04',
                'may' => '05', 'مايو' => '05',
                'june' => '06', 'يونيو' => '06',
                'july' => '07', 'يوليو' => '07',
                'august' => '08', 'اغسطس' => '08', 'أغسطس' => '08',
                'september' => '09', 'سبتمبر' => '09',
                'october' => '10', 'اكتوبر' => '10', 'أكتوبر' => '10',
                'november' => '11', 'نوفمبر' => '11',
                'december' => '12', 'ديسمبر' => '12',
            ];

            $hijriMonths = [
                'muharram' => '01', 'محرم' => '01',
                'safar' => '02', 'صفر' => '02',
                'rabi al-awwal' => '03', 'ربيع الأول' => '03', 'ربيع الاول' => '03',
                'rabi al-thani' => '04', 'ربيع الثاني' => '04', 'ربيع الاخر' => '04',
                'jumada al-awwal' => '05', 'جمادى الأول' => '05', 'جمادى الاولى' => '05',
                'jumada al-thani' => '06', 'جمادى الثاني' => '06', 'جمادى الاخرة' => '06',
                'rajab' => '07', 'رجب' => '07',
                'shaaban' => '08', 'شعبان' => '08',
                'ramadan' => '09', 'رمضان' => '09',
                'shawwal' => '10', 'شوال' => '10',
                'dhu al-qadah' => '11', 'ذو القعدة' => '11',
                'dhu al-hijjah' => '12', 'ذو الحجة' => '12',
            ];

            $matchedGregMonths = [];
            $matchedHijriMonths = [];

            foreach ($gregorianMonths as $name => $num) {
                if (mb_strpos($lowerKeyword, $name) !== false) $matchedGregMonths[] = $num;
            }
            foreach ($hijriMonths as $name => $num) {
                if (mb_strpos($lowerKeyword, $name) !== false) $matchedHijriMonths[] = $num;
            }

            $query->where(function ($q) use ($keyword, $matchedGregMonths, $matchedHijriMonths) {

                $q->where('title_en', 'like', "%{$keyword}%")
                    ->orWhere('title_ar', 'like', "%{$keyword}%")
                    ->orWhere('season', 'like', "%{$keyword}%")
                    ->orWhere('start_date_hijri', 'like', "%{$keyword}%")
                    ->orWhere('end_date_hijri', 'like', "%{$keyword}%")
                    ->orWhere('start_date', 'like', "%{$keyword}%")
                    ->orWhere('end_date', 'like', "%{$keyword}%");

                $q->orWhereHas('itemType', function ($typeQ) use ($keyword) {
                    $typeQ->where('title_ar', 'like', "%{$keyword}%")
                        ->orWhere('title_en', 'like', "%{$keyword}%");
                });

                $q->orWhereHas('itineraries.city', function ($cityQ) use ($keyword) {
                    $cityQ->where('title_ar', 'like', "%{$keyword}%")
                        ->orWhere('title_en', 'like', "%{$keyword}%");
                });

                if (!empty($matchedGregMonths)) {
                    $q->orWhere(function ($monthQ) use ($matchedGregMonths) {
                        foreach ($matchedGregMonths as $monthNum) {
                            $monthQ->orWhereMonth('start_date', $monthNum)
                                ->orWhereMonth('end_date', $monthNum);
                        }
                    });
                }

                if (!empty($matchedHijriMonths)) {
                    $q->orWhere(function ($hijriQ) use ($matchedHijriMonths) {
                        foreach ($matchedHijriMonths as $monthNum) {
                            $hijriQ->orWhere('start_date_hijri', 'like', "%-{$monthNum}-%")
                                ->orWhere('start_date_hijri', 'like', "%/{$monthNum}/%")
                                ->orWhere('end_date_hijri', 'like', "%-{$monthNum}-%")
                                ->orWhere('end_date_hijri', 'like', "%/{$monthNum}/%");
                        }
                    });
                }
            });
        }

        $Items = $query->orderByDesc('id')->paginate(10);

        $data = [
            'items_count' => $Items->total(),
            'items' => $Items,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getItem($slug): JsonResponse
    {

        $Item = Item::query()->with($this->getOrderedRelations())->where(function ($query) use ($slug) {

            $query->where('slug_en', $slug)
                ->orWhere('slug_ar', $slug)
                ->orWhere('slug_fr', $slug)
                ->orWhere('slug_de', $slug);
        })->first();
        if (!$Item)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $Item);
    }

    public function getItemById($id): JsonResponse
    {
        $Item = Item::query()->with($this->getOrderedRelations())->find($id);
        if (!$Item)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $Item);
    }

    public function getItemsByItemType($id): JsonResponse
    {
        $itemType = ItemType::query()->find($id);
        if (!$itemType)
            return $this->responseMessage(404, 'not found');

        $today = now()->toDateString();
        $items = $itemType->items()->where('status', 1)->where(fn($q) => $q->whereNull('start_date')->orWhere('start_date', '>=', $today))->with($this->getOrderedRelations())->orderByDesc('id')->paginate(10);

        $data = [
            'itemType' => $itemType,
            'items_count' => $items->total(),
            'items' => $items,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getItemsFeatures(): JsonResponse
    {
        $itemsFeatures = Item::query()->with($this->getOrderedRelations())->orderByDesc('id')->where('status', 1)->where('is_feature', 1)->get();

        return $this->responseMessage(200, 'success', $itemsFeatures);
    }

}
