<?php

namespace App\Exports;

use App\Models\Subscribe;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class SubscribersExport implements FromCollection, WithHeadings
{
    public function collection(): Collection
    {
        return Subscribe::query()->select('email', 'created_at')
            ->get()
            ->map(function ($item) {
                return [
                    'email' => $item->email,
                    'subscribed_at' => $item->created_at->format('Y-m-d H:i A'),
                ];
            });
    }

    public function headings(): array
    {
        return ['Email', 'Subscribed At'];
    }
}

