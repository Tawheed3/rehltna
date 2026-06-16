<?php

namespace App\Jobs;

use App\Imports\ItemTypesImport;
use App\Models\ErrorUploaded;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Maatwebsite\Excel\Facades\Excel;

class ImportItemTypesJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public string $filePath;

    public function __construct(string $filePath)
    {
        $this->filePath = public_path($filePath);
    }

    public function handle()
    {
        ErrorUploaded::query()->where('type', 'item_type')->delete();
        Excel::import(new ItemTypesImport, $this->filePath);
        if (file_exists($this->filePath)) {
            unlink($this->filePath);
        }
    }
}
