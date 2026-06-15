<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\PaymentMethod;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class PaymentMethodController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $paymentMethods = PaymentMethod::all();
        return view('pages.payment-methods.index', compact('paymentMethods'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(PaymentMethod $paymentMethod)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        $method = PaymentMethod::query()->findOrFail($id);
        $currentConfig = $method->config ?? [];
        $newConfig = array_replace_recursive($currentConfig, $request->input('config'));
        $method->update([
            'config' => $newConfig
        ]);
        return back()->with('success', 'Configuration updated successfully!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(PaymentMethod $paymentMethod)
    {
        //
    }

    public function paymentMethodChangeStatus($id): JsonResponse
    {
        $paymentMethod = PaymentMethod::query()->findOrFail($id);
        if ($paymentMethod->status == 1) {
            $paymentMethod->status = 0;
            $paymentMethod->save();
        } else {
            $paymentMethod->status = 1;
            $paymentMethod->save();
        }
        return response()->json(['status' => $paymentMethod->status]);
    }
}
