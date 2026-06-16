<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\ResidencyUser;
use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    use ResponseTrait;

    public function index(): JsonResponse
    {
        $users = ResidencyUser::query()
            ->select('id', 'name', 'phone', 'package_id')
            ->with(['package' => function ($query) {
                $query->select('id', 'name_en', 'name_ar');
            }])
            ->get();

        $formattedUsers = $users->map(function ($user) {
            return [
                'name' => $user->name,
                'phone' => $user->phone,
                'package' => $user->package ? $user->package->name_en : null,
            ];
        });

        return $this->responseMessage(200, 'success', $formattedUsers);
    }
}
