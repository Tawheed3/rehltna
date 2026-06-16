<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ChunkUploadController extends Controller
{
    public function uploadChunk(Request $request): JsonResponse
    {
        $request->validate([
            'chunk'       => 'required|file',
            'chunkIndex'  => 'required|integer|min:0',
            'totalChunks' => 'required|integer|min:1',
            'uploadId'    => 'required|string|max:64',
        ]);

        $uploadId    = preg_replace('/[^a-zA-Z0-9\-]/', '', $request->uploadId);
        $chunkIndex  = (int) $request->chunkIndex;
        $totalChunks = (int) $request->totalChunks;
        $chunkDir    = "chunks/{$uploadId}";

        $request->file('chunk')->storeAs($chunkDir, (string) $chunkIndex, 'local');

        $received = count(Storage::disk('local')->files($chunkDir));

        if ($received < $totalChunks) {
            return response()->json(['status' => 'partial', 'received' => $received, 'total' => $totalChunks]);
        }

        // All chunks received — merge them
        $finalName = Str::uuid() . '.pdf';
        $finalPath = 'trip-documents/' . $finalName;
        $outputPath = Storage::disk('public')->path($finalPath);

        @mkdir(dirname($outputPath), 0755, true);
        $out = fopen($outputPath, 'wb');

        for ($i = 0; $i < $totalChunks; $i++) {
            $chunkPath = Storage::disk('local')->path("{$chunkDir}/{$i}");
            $in = fopen($chunkPath, 'rb');
            while (!feof($in)) {
                fwrite($out, fread($in, 1024 * 1024));
            }
            fclose($in);
        }

        fclose($out);
        Storage::disk('local')->deleteDirectory($chunkDir);

        return response()->json(['status' => 'done', 'path' => $finalPath]);
    }
}
