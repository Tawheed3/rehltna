<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\PaymentMethod;
use Illuminate\Http\JsonResponse;

class PaymentMethodController extends Controller
{
    use ResponseTrait;

    public function index(): JsonResponse
    {
        $dbPaymentMethods = PaymentMethod::query()->where('status', 1)->get();

        $finalPaymentMethods = [];

        foreach ($dbPaymentMethods as $method) {

            if ($method->code === 'moyasar') {

                $config = $method->config ?? [];
                $mode = $config['mode'] ?? 'live';
                $publishableKey = $config[$mode]['publishable_key'] ?? '';

                $finalPaymentMethods[] = [
                    'id' => (string)$method->id,
                    'title_ar' => $method->title_ar,
                    'title_en' => $method->title_en,
                    'code' => $method->code,
                    'banner' => asset($method->banner_en),
                    'config' => [
                        'publishable_key' => $publishableKey
                    ],
                    'mode' => $mode,
                ];

                $finalPaymentMethods[] = [
                    'id' => $method->id . '_visa',
                    'title_ar' => 'فيزا / ماستركارد',
                    'title_en' => 'Visa / MasterCard',
                    'code' => 'moyasar',
                    'banner' => asset('payment-methods/visa_mastercard.png'),
                    'config' => [],
                    'mode' => $mode,
                ];

                $finalPaymentMethods[] = [
                    'id' => $method->id . '_mada',
                    'title_ar' => 'بطاقة مدى',
                    'title_en' => 'Mada Card',
                    'code' => 'moyasar',
                    'banner' => asset('payment-methods/mada.png'),
                    'config' => [],
                    'mode' => $mode,
                ];

                $finalPaymentMethods[] = [
                    'id' => $method->id . '_stcpay',
                    'title_ar' => 'إس تي سي باي',
                    'title_en' => 'STC Pay',
                    'code' => 'moyasar',
                    'banner' => asset('payment-methods/stcpay.png'),
                    'config' => [],
                    'mode' => $mode,
                ];

                $finalPaymentMethods[] = [
                    'id' => $method->id . '_applepay',
                    'title_ar' => 'أبل باي',
                    'title_en' => 'Apple Pay',
                    'code' => 'apple_pay',
                    'banner' => asset('payment-methods/applepay.png'),
                    'config' => [
                        'publishable_key' => $publishableKey
                    ],
                    'mode' => $mode,
                ];

            } else {

                $config = $method->config ?? [];
                $mode = $config['mode'] ?? 'live';

                if ($method->code === 'tamara') {
                    $config = [
                        'public_key' => $config[$mode]['public_key'] ?? '',
                    ];
                }

                $finalPaymentMethods[] = [
                    'id' => (string)$method->id,
                    'title_ar' => $method->title_ar,
                    'title_en' => $method->title_en,
                    'code' => $method->code,
                    'banner' => asset($method->banner_en),
                    'config' => $config,
                    'mode' => $mode,
                ];
            }
        }

        return $this->responseMessage(200, 'Payment Methods', $finalPaymentMethods);
    }
}
