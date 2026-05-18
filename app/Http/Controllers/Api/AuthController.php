<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Package;
use App\Models\PasswordResetCode;
use App\Models\ResidencyUser;
use App\Models\TripDocument;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\Rule;

class AuthController extends Controller
{
    use ResponseTrait;

    public function register(Request $request): JsonResponse
    {
        if (!empty($request->extra_key)) {
            return $this->responseMessage(403, 'Spam detected.');
        }

        $trashedUser = ResidencyUser::onlyTrashed()->where('email', $request->email)->first();

        $rules = [
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:255',
            'password' => 'required|string|confirmed|min:8',
            'email' => ['required', 'email'],
        ];

        if (!$trashedUser) {
            $rules['email'][] = Rule::unique(ResidencyUser::class, 'email');
        }

        $data = $request->validate($rules);

        $silverPackage = Package::where('name_en', 'Silver')->first();
        $packageId = $silverPackage ? $silverPackage->id : null;

        if ($trashedUser) {
            $trashedUser->restore();
            $trashedUser->update([
                'name' => $data['name'],
                'phone' => $data['phone'],
                'password' => Hash::make($data['password']),
                'package_id' => $packageId,
            ]);
            $user = $trashedUser;
        } else {
            $user = ResidencyUser::query()->create([
                'name' => $data['name'],
                'phone' => $data['phone'],
                'email' => $data['email'],
                'password' => Hash::make($data['password']),
                'package_id' => $packageId,
            ]);
        }

        $token = $user->createToken('api-token')->plainTextToken;

        $data = $user->load('package')->toArray();
        $data['acssess_token'] = $token;
        $data['access_token']  = $token;
        $data['token_type']    = 'Bearer';

        return $this->responseMessage(201, 'Registered successfully', $data);
    }

    public function login(Request $request): JsonResponse
    {
        $data = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        $user = ResidencyUser::query()->where('email', $data['email'])->first();

        if (!$user || !Hash::check($data['password'], $user->password)) {
            return $this->responseMessage(400, 'The provided credentials are incorrect.');
        }

        $token = $user->createToken('api-token')->plainTextToken;

        $data = $user->load('package')->toArray();
        $data['acssess_token'] = $token;
        $data['access_token']  = $token;
        $data['token_type']    = 'Bearer';

        return $this->responseMessage(200, 'Logged Successfully', $data);

    }

    public function forgotPassword(Request $request): JsonResponse
    {
        $request->validate(['email' => 'required|email']);

        $user = ResidencyUser::query()->where('email', $request->get('email'))->first();
        if (!$user) {
            return $this->responseMessage(422, 'Invalid email');
        }

        $code = rand(100000, 999999);

        PasswordResetCode::query()->where('email', $request->get('email'))->delete();
        PasswordResetCode::query()->create([
            'email' => $request->get('email'),
            'code' => $code,
            'created_at' => Carbon::now(),
        ]);

        Mail::raw("Your reset code is: $code", function ($message) use ($request) {
            $message->to($request->get('email'))
                ->subject('Password Reset Code');
        });

        return $this->responseMessage(201, 'Check your email for password reset code');

    }
    public function resetPassword(Request $request): JsonResponse
    {
        $request->validate([
            'email' => 'required|email',
            'code' => 'required|string',
            'password' => 'required|string|confirmed|min:8',
        ]);

        $user = ResidencyUser::query()->where('email', $request->get('email'))->first();
        if (!$user) {
            return $this->responseMessage(422, 'Invalid email');
        }

        $record = PasswordResetCode::query()->where('email', $request->get('email'))
            ->where('code', $request->get('code'))
            ->first();

        if (!$record) {
            return $this->responseMessage(422, 'Invalid code');
        }

        if (Carbon::parse($record->created_at)->addMinutes(15)->isPast()) {
            return $this->responseMessage(422, 'Reset code has expired');
        }

        $user->password = Hash::make($request->get('password'));
        $user->save();
        PasswordResetCode::query()->where('email', $request->get('email'))->delete();
        $user->tokens()->delete();

        return $this->responseMessage(201, 'Password reset successful');

    }
    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()?->delete();
        return $this->responseMessage(200, 'Logged out');
    }
    public function profile(): JsonResponse
    {
        $user = auth()->user();
        return $this->responseMessage(200, 'Profile', $user->load('package', 'orders', 'items.privateGalleries'));
    }
    public function updateProfile(Request $request): JsonResponse
    {
        $request->validate([
            'name'  => 'required|string|max:255',
            'phone' => 'required|string|max:20',
        ]);

        $user = $request->user();
        $user->update([
            'name'  => $request->name,
            'phone' => $request->phone,
        ]);

        return $this->responseMessage(200, 'Profile updated successfully.', $user->fresh()->load('package'));
    }

    public function updateFcmToken(Request $request): JsonResponse
    {
        $request->validate([
            'fcm_token' => 'required|string',
        ]);

        $user = $request->user();
        $user->update([
            'fcm_token' => $request->get('fcm_token'),
        ]);

        return $this->responseMessage(200, 'FCM Token updated successfully');
    }

    public function myTripDocuments(): JsonResponse
    {
        $user = auth()->user();

        $documents = $user->tripDocuments()
            ->with(['item:id,title_ar,title_en,slug_ar,slug_en'])
            ->get()
            ->map(function (TripDocument $doc) {
                return [
                    'id'      => $doc->id,
                    'trip'    => [
                        'id'       => $doc->item?->id,
                        'title_ar' => $doc->item?->title_ar,
                        'title_en' => $doc->item?->title_en,
                        'slug_ar'  => $doc->item?->slug_ar,
                        'slug_en'  => $doc->item?->slug_en,
                    ],
                    'pdf_url' => $doc->pdf_path ? asset(Storage::url($doc->pdf_path)) : null,
                    'details' => $doc->details ?? [],
                ];
            });

        return $this->responseMessage(200, 'success', $documents);
    }

}
