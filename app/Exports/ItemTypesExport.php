<?php

namespace App\Exports;

use App\Models\ItemType;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class ItemTypesExport implements FromCollection, WithHeadings
{
    public function collection(): Collection
    {
        return ItemType::query()
            ->select('title_en', 'title_ar', 'short_description_en', 'short_description_ar', 'banner_en', 'banner_ar', 'is_feature', 'meta_img', 'meta_title_en', 'meta_title_ar', 'meta_description_en', 'meta_description_ar', 'meta_keywords_en', 'meta_keywords_ar')
            ->get()
            ->map(function ($itemType) {
                return [
                    'title_en' => $itemType->title_en,
                    'title_ar' => $itemType->title_ar,
                    'short_description_en' => $itemType->short_description_en,
                    'short_description_ar' => $itemType->short_description_ar,
                    'banner_en' => $itemType->banner_en,
                    'banner_ar' => $itemType->banner_ar,
                    'is_feature' => $itemType->is_feature,
                    'meta_img' => $itemType->meta_img,
                    'meta_title_en' => $itemType->meta_title_en,
                    'meta_title_ar' => $itemType->meta_title_ar,
                    'meta_description_en' => $itemType->meta_description_en,
                    'meta_description_ar' => $itemType->meta_description_ar,
                    'meta_keywords_en' => $itemType->meta_keywords_en,
                    'meta_keywords_ar' => $itemType->meta_keywords_ar,
                ];
            });
    }

    public function headings(): array
    {
        return ['Title En', 'Title Ar', 'Short Description En', 'Short Description Ar', 'Banner En', 'Banner Ar', 'Is Feature', 'Meta Image', 'Meta Title En', 'Meta Title Ar', 'Meta Description En', 'Meta Description Ar', 'Meta Keywords En', 'Meta Keywords Ar'];
    }
}

