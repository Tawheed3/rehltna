<?php

namespace App\Exports;

use App\Models\ContactUs;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class ContactUsExport implements FromCollection, WithHeadings
{
    public function collection(): Collection
    {
        return ContactUs::query()
            ->select('name', 'email', 'phone', 'message', 'created_at')
            ->get()
            ->map(function ($item) {
                return [
                    'name'       => $item->name,
                    'email'      => $item->email,
                    'phone'      => $item->phone,
                    'message'    => $item->message,
                    'contact_at' => $item->created_at->format('Y-m-d H:i A'),
                ];
            });
    }

    public function headings(): array
    {
        return ['Name', 'Email', 'Phone', 'Message', 'Contact At'];
    }
}

