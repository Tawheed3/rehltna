<?php

namespace App\Imports;

use App\Models\ErrorUploaded;
use App\Models\Item;
use App\Models\ItemType;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class ItemsImport implements ToCollection, WithHeadingRow, WithChunkReading
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
                'description_en' => null,
                'description_ar' => null,
                'price' => null,
                'item_type_id' => null,
                'image' => null,
                'is_feature' => 0,
                'status' => 0,
            ];
            $row = array_merge($defaults, $row);

            if (!isset($row['is_feature']) || $row['is_feature'] == null || $row['is_feature'] == '') {
                $row['is_feature'] = 0;
            } else {
                $row['is_feature'] = (int)$row['is_feature'];
            }

            if (!isset($row['status']) || $row['status'] == null || $row['status'] == '') {
                $row['status'] = 0;
            } else {
                $row['status'] = (int)$row['status'];
            }

            $rowErrors = [];

            if (empty($row['price']) || !is_double($row['price'])) {
                $rowErrors[] = 'Price is required and must be a double.';
            }

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

            if (empty($row['item_type_id']) || !ItemType::query()->where('id', $row['item_type_id'])->exists()) {
                $rowErrors[] = 'Item Type is required and must be in item types.';
            }

            if (empty($row['description_en']) || !is_string($row['description_en'])) {
                $rowErrors[] = 'Description En is required and must be a string.';
            }

            if (!empty($row['description_ar']) && !is_string($row['description_ar'])) {
                $rowErrors[] = 'Description Ar must be a string.';
            }

            if (!in_array($row['status'], [0, 1])) {
                $rowErrors[] = 'Status must be in (0 , 1).';
            }

            if (!in_array($row['is_feature'], [0, 1])) {
                $rowErrors[] = 'Is Feature must be in (0 , 1).';
            }

            if (empty($row['image']) || !filter_var($row['image'], FILTER_VALIDATE_URL)) {
                $rowErrors[] = 'Image is required and must be a valid URL.';
            }

            if (!empty($row['meta_image']) && !filter_var($row['meta_image'], FILTER_VALIDATE_URL)) {
                $rowErrors[] = 'Meta Image must be a valid URL.';
            }

            foreach (['meta_title_en', 'meta_title_ar', 'meta_description_en', 'meta_description_ar', 'meta_keywords_en', 'meta_keywords_ar'] as $field) {
                if (!empty($row[$field]) && !is_string($row[$field])) {
                    $rowErrors[] = "$field must be a string.";
                }
            }

            $exists = Item::query()
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
                    'description_en' => $row['description_en'],
                    'description_ar' => $row['description_ar'],
                    'item_type_id' => $row['item_type_id'],
                    'image' => $row['image'],
                    'status' => $row['status'],
                    'price' => $row['price'],
                    'is_feature' => $row['is_feature'],
                    'meta_img' => $row['meta_image'],
                    'meta_title_en' => $row['meta_title_en'],
                    'meta_title_ar' => $row['meta_title_ar'],
                    'meta_description_en' => $row['meta_description_en'],
                    'meta_description_ar' => $row['meta_description_ar'],
                    'meta_keywords_en' => $row['meta_keywords_en'],
                    'meta_keywords_ar' => $row['meta_keywords_ar'],
                    'errors' => implode(' | ', $rowErrors),
                    'type' => 'item',
                    'created_at' => now(),
                    'updated_at' => now(),
                ];
            } else {
                $image = $row['image'];
                $metaImg = $row['meta_image'] ? downloadAndSaveImage($row['meta_image'], 'meta', 'meta') : null;

                $valid[] = [
                    'title_en' => $row['title_en'],
                    'title_ar' => $row['title_ar'],
                    'short_description_en' => $row['short_description_en'],
                    'short_description_ar' => $row['short_description_ar'],
                    'banner_en' => $image,
                    'banner_ar' => $image,
                    'description_en' => $row['description_en'],
                    'description_ar' => $row['description_ar'],
                    'item_type_id' => $row['item_type_id'],
                    'status' => $row['status'],
                    'price' => $row['price'],
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
            Item::query()->insert($valid);
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
