<?php

namespace App\Exports;

use App\Models\ErrorUploaded;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class ItemsErrorUploadedExport implements FromCollection, WithHeadings
{
    public function collection(): Collection
    {
        return ErrorUploaded::query()->where('type', 'item')
            ->select('title_en', 'title_ar', 'short_description_en', 'short_description_ar', 'description_en', 'description_ar', 'image', 'price', 'status', 'is_feature', 'item_type_id', 'meta_img', 'meta_title_en', 'meta_title_ar', 'meta_description_en', 'meta_description_ar', 'meta_keywords_en', 'meta_keywords_ar', 'errors')
            ->get()
            ->map(function ($ErrorUploaded) {
                return [
                    'title_en' => $ErrorUploaded->title_en,
                    'title_ar' => $ErrorUploaded->title_ar,
                    'short_description_en' => $ErrorUploaded->short_description_en,
                    'short_description_ar' => $ErrorUploaded->short_description_ar,
                    'description_en' => $ErrorUploaded->description_en,
                    'description_ar' => $ErrorUploaded->description_ar,
                    'image' => $ErrorUploaded->imege,
                    'price' => $ErrorUploaded->price,
                    'status' => $ErrorUploaded->status,
                    'is_feature' => $ErrorUploaded->is_feature,
                    'item_type_id' => $ErrorUploaded->item_type_id,
                    'meta_img' => $ErrorUploaded->meta_img,
                    'meta_title_en' => $ErrorUploaded->meta_title_en,
                    'meta_title_ar' => $ErrorUploaded->meta_title_ar,
                    'meta_description_en' => $ErrorUploaded->meta_description_en,
                    'meta_description_ar' => $ErrorUploaded->meta_description_ar,
                    'meta_keywords_en' => $ErrorUploaded->meta_keywords_en,
                    'meta_keywords_ar' => $ErrorUploaded->meta_keywords_ar,
                    'errors' => $ErrorUploaded->errors,
                ];
            });
    }

    public function headings(): array
    {
        return ['Title En', 'Title Ar', 'Short Description En', 'Short Description Ar', 'Description En', 'Description Ar', 'Image', 'Price', 'Status', 'Is Feature', 'Item Type Id', 'Meta Image', 'Meta Title En', 'Meta Title Ar', 'Meta Description En', 'Meta Description Ar', 'Meta Keywords En', 'Meta Keywords Ar', 'Errors'];
    }
}

