<?php

namespace App\Imports;

use App\Models\ErrorUploaded;
use App\Models\ItemType;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class ItemTypesImport implements ToCollection, WithHeadingRow, WithChunkReading
{
    public function collection(Collection $rows)
    {
        $valid = [];
        $errors = [];

        foreach ($rows as $row) {
            $row = $row->toArray();
            $defaults = [
                'meta_image' => null,
                'meta_title_en' => null,
                'meta_title_ar' => null,
                'meta_description_en' => null,
                'meta_description_ar' => null,
                'meta_keywords_en' => null,
                'meta_keywords_ar' => null,
                'title_ar' => null,
                'title_en' => null,
                'short_description_en' => null,
                'short_description_ar' => null,
                'banner_en' => null,
                'banner_ar' => null,
                'is_feature' => 0,
            ];
            $row = array_merge($defaults, $row);

            if (!isset($row['is_feature']) || $row['is_feature'] == null || $row['is_feature'] == '') {
                $row['is_feature'] = 0;
            } else {
                $row['is_feature'] = (int)$row['is_feature'];
            }

            $rowErrors = [];
            if (empty($row['title_en']) || !is_string($row['title_en'])) {
                $rowErrors[] = 'Title En is required and must be a string.';
            }

            if (!empty($row['title_ar']) && !is_string($row['title_ar'])) {
                $rowErrors[] = 'Title Ar must be a string.';
            }

            if (empty($row['short_description_en']) || !is_string($row['short_description_en'])) {
                $rowErrors[] = 'Short Description En is required and must be a string.';
            }

            if (!empty($row['short_description_ar']) && !is_string($row['short_description_ar'])) {
                $rowErrors[] = 'Short Description Ar must be a string.';
            }

            if (!in_array($row['is_feature'], [0, 1])) {
                $rowErrors[] = 'Is Feature must be in (0 , 1).';
            }

            if (empty($row['banner_en']) || !filter_var($row['banner_en'], FILTER_VALIDATE_URL)) {
                $rowErrors[] = 'Banner En is required and must be a valid URL.';
            }

            if (!empty($row['banner_ar']) && !filter_var($row['banner_ar'], FILTER_VALIDATE_URL)) {
                $rowErrors[] = 'Banner Ar must be a valid URL.';
            }

            if (!empty($row['meta_image']) && !filter_var($row['meta_image'], FILTER_VALIDATE_URL)) {
                $rowErrors[] = 'Meta Image must be a valid URL.';
            }

            foreach (['meta_title_en', 'meta_title_ar', 'meta_description_en', 'meta_description_ar', 'meta_keywords_en', 'meta_keywords_ar'] as $field) {
                if (!empty($row[$field]) && !is_string($row[$field])) {
                    $rowErrors[] = "$field must be a string.";
                }
            }

            $exists = ItemType::query()
                ->where('title_en', $row['title_en'])
                ->orWhere('title_ar', $row['title_ar'])
                ->exists();

            if ($exists) {
                $rowErrors[] = 'Title En or Title Ar already exists.';
            }

            if (!empty($rowErrors)) {
                $errors[] = [
                    'title_en' => $row['title_en'],
                    'title_ar' => $row['title_ar'],
                    'short_description_en' => $row['short_description_en'],
                    'short_description_ar' => $row['short_description_ar'],
                    'banner_en' => $row['banner_en'],
                    'banner_ar' => $row['banner_ar'],
                    'is_feature' => $row['is_feature'],
                    'meta_img' => $row['meta_image'],
                    'meta_title_en' => $row['meta_title_en'],
                    'meta_title_ar' => $row['meta_title_ar'],
                    'meta_description_en' => $row['meta_description_en'],
                    'meta_description_ar' => $row['meta_description_ar'],
                    'meta_keywords_en' => $row['meta_keywords_en'],
                    'meta_keywords_ar' => $row['meta_keywords_ar'],
                    'errors' => implode(' | ', $rowErrors),
                    'type' => 'item_type',
                    'created_at' => now(),
                    'updated_at' => now(),
                ];
            } else {
                $bannerEn = $row['banner_en'] ? downloadAndSaveImage($row['banner_en'], 'banners', 'en') : null;
                $bannerAr = $row['banner_ar'] ? downloadAndSaveImage($row['banner_ar'], 'banners', 'ar') : null;
                $metaImg = $row['meta_image'] ? downloadAndSaveImage($row['meta_image'], 'meta', 'meta') : null;

                $valid[] = [
                    'title_en' => $row['title_en'],
                    'title_ar' => $row['title_ar'],
                    'short_description_en' => $row['short_description_en'],
                    'short_description_ar' => $row['short_description_ar'],
                    'banner_en' => $bannerEn,
                    'banner_ar' => $bannerAr,
                    'is_feature' => $row['is_feature'],
                    'meta_img' => $metaImg,
                    'meta_title_en' => $row['meta_title_en'],
                    'meta_title_ar' => $row['meta_title_ar'],
                    'meta_description_en' => $row['meta_description_en'],
                    'meta_description_ar' => $row['meta_description_ar'],
                    'meta_keywords_en' => $row['meta_keywords_en'],
                    'meta_keywords_ar' => $row['meta_keywords_ar'],
                    'created_at' => now(),
                    'updated_at' => now(),
                ];
            }
        }

        if (!empty($valid)) {
            ItemType::query()->insert($valid);
        }

        if (!empty($errors)) {
            ErrorUploaded::query()->insert($errors);
        }
    }

    public function chunkSize(): int
    {
        return 100;
    }
}
