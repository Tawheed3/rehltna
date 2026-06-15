<?php

namespace App\Jobs;

use App\Imports\ItemsImport;
use App\Models\ErrorUploaded;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Maatwebsite\Excel\Facades\Excel;

class ImportItemsJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public string $filePath;

    public function __construct(string $filePath)
    {
        $this->filePath = public_path($filePath);
    }

    public function handle()
    {
        ErrorUploaded::query()->where('type', 'item')->delete();
        Excel::import(new ItemsImport, $this->filePath);
        if (file_exists($this->filePath)) {
            unlink($this->filePath);
        }
    }
}
