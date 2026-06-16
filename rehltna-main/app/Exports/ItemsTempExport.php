<?php

namespace App\Exports;

use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class ItemsTempExport implements FromCollection, WithHeadings
{
    public function collection(): Collection
    {
        return collect([[]]);
    }

    public function headings(): array
    {
        return ['Title En', 'Title Ar', 'Short Description En', 'Short Description Ar', 'Description En', 'Description Ar', 'Image', 'Price', 'Status', 'Is Feature', 'Item Type Id', 'Meta Title En', 'Meta Title Ar', 'Meta Description En', 'Meta Description Ar', 'Meta Keywords En', 'Meta Keywords Ar'];
    }
}

