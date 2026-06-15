<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\CustomPage;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CustomPageController extends Controller
{
    use ResponseTrait;

    public function getCustomPages(): JsonResponse
    {
        $customPages = CustomPage::query()->where('status', 1)->get();
        return $this->responseMessage(200, 'success', $customPages);
    }
}
