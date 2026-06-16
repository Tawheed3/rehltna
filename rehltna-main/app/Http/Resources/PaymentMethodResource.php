<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PaymentMethodResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $config = $this->config ?? [];
        $mode = $config['mode'] ?? 'test';
        return [
            'id' => $this->id,
            'title_ar' => $this->title_ar,
            'title_en' => $this->title_en,
            'code' => $this->code,
            'status' => $this->status,
            'banner_ar' => $this->banner_ar,
            'banner_en' => $this->banner_en,
            'config' => $config,
            'mode' => $mode,
        ];
    }
}
