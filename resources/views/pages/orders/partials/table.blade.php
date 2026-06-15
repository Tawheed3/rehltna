<div class="table-responsive">
    <table class="table" id="table">
        <thead>
        <tr>
            <th class="text-center" width="60">#</th>
            <th>Customer Info</th>
            <th>Trip Name</th>
            <th>Total Bill</th>
            <th class="text-center">Method</th>
            <th class="text-center">Proof</th>
            <th class="text-center">Status</th>
            <th>Date</th>
            <th class="text-center px-4">Actions</th>
        </tr>
        </thead>
        <tbody>
        @foreach($orders as $order)
            <tr>
                <td class="text-center fw-bold text-muted">{{ $loop->iteration }}</td>
                <td>
                    <h6 class="mb-0 fw-bold text-dark">{{ $order->name }}</h6>
                    <span class="text-muted small fw-medium"><i class="las la-phone me-1"></i>{{ $order->phone }}</span>
                </td>
                <td>
                    @php
                        $tripItem = $order->items->first()?->item;
                        $tripName = $tripItem?->title_ar ?? $tripItem?->title_en ?? '-';
                    @endphp
                    <span class="fw-bold text-dark small">{{ $tripName }}</span>
                </td>
                <td><span class="fw-extrabold text-primary">{{ $order->total_amount }} SAR</span></td>
                <td class="text-center">
                    @php
                        $methodStyles = [
                            'tamara'    => ['bg' => 'rgba(79, 70, 229, 0.1)',  'color' => '#4f46e5', 'icon' => 'fa-credit-card'],
                            'moyasar'   => ['bg' => 'rgba(16, 185, 129, 0.1)', 'color' => '#10b981', 'icon' => 'fa-credit-card'],
                            'apple_pay' => ['bg' => 'rgba(0, 0, 0, 0.1)',      'color' => '#000000', 'icon' => 'fab fa-apple'],
                            'instapay'  => ['bg' => 'rgba(236, 72, 153, 0.1)', 'color' => '#ec4899', 'icon' => 'fa-bolt'],
                            'wallet_vodafone' => ['bg' => 'rgba(239, 68, 68, 0.1)', 'color' => '#ef4444', 'icon' => 'fa-mobile-alt'],
                            'wallet_etisalat' => ['bg' => 'rgba(16, 185, 129, 0.1)', 'color' => '#10b981', 'icon' => 'fa-mobile-alt'],
                            'wallet_orange' => ['bg' => 'rgba(249, 115, 22, 0.1)', 'color' => '#f97316', 'icon' => 'fa-mobile-alt'],
                            'wallet_we' => ['bg' => 'rgba(139, 92, 246, 0.1)', 'color' => '#8b5cf6', 'icon' => 'fa-mobile-alt'],
                            'bank_transfer_alrajhi' => ['bg' => 'rgba(147, 51, 234, 0.1)', 'color' => '#9333ea', 'icon' => 'fa-university'],
                            'bank_transfer_alahli' => ['bg' => 'rgba(100, 116, 139, 0.1)', 'color' => '#64748b', 'icon' => 'fa-university'],
                            'cash_on_delivery' => ['bg' => 'rgba(245, 158, 11, 0.1)', 'color' => '#f59e0b', 'icon' => 'fa-money-bill-wave'],
                        ];

                        // Fallback for any unknown wallet
                        if (!isset($methodStyles[$order->payment_method]) && str_contains($order->payment_method, 'wallet')) {
                            $mStyle = ['bg' => 'rgba(59, 130, 246, 0.1)', 'color' => '#3b82f6', 'icon' => 'fa-mobile-alt'];
                        } else {
                            $mStyle = $methodStyles[$order->payment_method] ?? ['bg' => '#f1f5f9', 'color' => '#1e293b', 'icon' => 'fa-wallet'];
                        }

                        $methodName = str_replace('_', ' ', $order->payment_method);
                    @endphp
                    <span class="badge" style="background: {{ $mStyle['bg'] }}; color: {{ $mStyle['color'] }}; border: 1px solid {{ $mStyle['color'] }}40; padding: 8px 14px; border-radius: 10px; font-weight: 800; font-size: 11px;">
                                            <i class="{{ str_contains($mStyle['icon'], 'fab') ? '' : 'fas' }} {{ $mStyle['icon'] }} me-1"></i> {{ strtoupper($methodName) }}
                                        </span>
                </td>
                <td class="text-center">
                    @if($order->payment_proof)
                        <a href="javascript:void(0);" class="btn btn-sm btn-outline-success view-proof-btn p-2 rounded-3 border-2" data-bs-toggle="modal" data-bs-target="#receiptModal" data-image="{{ asset($order->payment_proof) }}">
                            <i class="fas fa-image fs-16"></i>
                        </a>
                    @else
                        <span class="text-muted opacity-50">-</span>
                    @endif
                </td>
                <td class="text-center">
                    @php
                        $statusStyles = [
                            'paid'      => ['bg' => 'rgba(16, 185, 129, 0.1)', 'color' => '#10b981'],
                            'pending'   => ['bg' => 'rgba(245, 158, 11, 0.1)', 'color' => '#f59e0b'],
                            'reviewing' => ['bg' => 'rgba(99, 102, 241, 0.1)', 'color' => '#6366f1'],
                            'rejected'  => ['bg' => 'rgba(239, 68, 68, 0.1)',  'color' => '#ef4444'],
                            'canceled'  => ['bg' => 'rgba(100, 116, 139, 0.1)', 'color' => '#64748b'],
                        ];
                        $sStyle = $statusStyles[$order->payment_status] ?? ['bg' => '#f1f5f9', 'color' => '#1e293b'];
                    @endphp
                    <span class="badge" style="background: {{ $sStyle['bg'] }}; color: {{ $sStyle['color'] }}; border: 1px solid {{ $sStyle['color'] }}40; padding: 8px 14px; border-radius: 10px; font-weight: 800; min-width: 90px; text-transform: uppercase; font-size: 11px;">
                                            {{ $order->payment_status }}
                                        </span>
                </td>
                <td class="text-muted small fw-bold">{{ $order->created_at->format('Y-m-d H:i') }}</td>
                <td class="text-center px-4">
                    <div class="d-flex justify-content-center gap-2">
                        <a class="btn-action" href="{{ route('orders.show', encrypt($order->id)) }}" title="View Details">
                            <i class="las la-eye fs-20"></i>
                        </a>
                    </div>
                </td>
            </tr>
        @endforeach
        </tbody>
    </table>
    <div class="card-footer bg-transparent border-0 p-4">
        <div class="d-flex justify-content-between align-items-center">
            <p class="text-muted small mb-0 fw-bold">Showing {{ $orders->count() }} orders</p>
            {!! $orders->appends(request()->all())->links() !!}
        </div>
    </div>
</div>

