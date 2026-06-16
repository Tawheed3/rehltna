<?php

namespace App\Http\Controllers;

use Google\Exception;
use Illuminate\Support\Facades\Storage;
use Google\Client;
use Google\Service\Drive;

class GoogleDriveController extends Controller
{
    protected $driveService;


    public function __construct()
    {
        $client = new Client();
        $client->setAuthConfig(storage_path('app/google/google.json'));
        $client->addScope(Drive::DRIVE_READONLY);
        $this->driveService = new Drive($client);
    }

    public function downloadFolderImages()
    {
        $folderLink = 'https://drive.google.com/drive/folders/14yjswLcNvzvx8P60fHfRMGUV04HBL7pt?usp=drive_link';
        $folderId = $this->extractFolderId($folderLink);

        $files = $this->driveService->files->listFiles([
            'q' => "'{$folderId}' in parents and mimeType contains 'image/'",
            'fields' => 'files(id, name, mimeType, size)',
        ])->files;
        $newFileNames = [];

        foreach ($files as $file) {
            $content = $this->driveService->files->get($file->id, ['alt' => 'media']);
            $extension = pathinfo($file->name, PATHINFO_EXTENSION);
            $newFileName = uniqid() . '.' . $extension;
            // Define storage path
            $path = 'uploads/all/' . $newFileName;

// Save file locally (like store('uploads/all', 'local'))
            Storage::disk('local')->put($path, $content->getBody()->getContents());

// Get file size
            $size = Storage::disk('local')->size($path);

            $newFileNames[] = $newFileName;
        }

dd($newFileNames);

    }

    private function extractFolderId($link)
    {
        preg_match('/[-\w]{25,}/', $link, $matches);
        return $matches[0] ?? null;
    }


}
