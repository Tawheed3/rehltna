<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Members;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MembersController extends Controller
{
    use ResponseTrait;

    public function getMembers(Request $request): JsonResponse
    {
        $query = Members::query()->where('status', 1);
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('name_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('name_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $members = $query->orderByDesc('id')->paginate(10);
        $total = $members->total();
        $data = [
            'members_count' => $total,
            'members' => $members,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getMember($id): JsonResponse
    {
        $member = Members::query()->find($id);
        if (!$member)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $member);
    }
}
