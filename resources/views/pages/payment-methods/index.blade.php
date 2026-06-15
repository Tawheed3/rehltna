@extends('layouts.app')

@section('styles')
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f3f4f6;
        }

        /* Card Master Styling */
        .payment-card {
            background: #ffffff;
            border: none;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            position: relative;
        }

        .payment-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 4px;
            background: linear-gradient(90deg, #3b82f6, #8b5cf6);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .payment-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        .payment-card:hover::before {
            opacity: 1;
        }

        /* Image Area */
        .payment-img-wrapper {
            height: 140px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-bottom: 1px solid #f1f5f9;
            padding: 25px;
            position: relative;
            overflow: hidden;
        }

        .payment-img-wrapper::after {
            content: '';
            position: absolute;
            width: 150px; height: 150px;
            background: radial-gradient(circle, rgba(255,255,255,0.8) 0%, rgba(255,255,255,0) 70%);
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            pointer-events: none;
        }

        .payment-img {
            max-height: 70px;
            max-width: 75%;
            object-fit: contain;
            filter: drop-shadow(0 8px 12px rgba(0, 0, 0, 0.08));
            transition: transform 0.3s ease;
            position: relative;
            z-index: 1;
        }

        .payment-card:hover .payment-img {
            transform: scale(1.05);
        }

        /* Typography & Header */
        .card-title {
            font-size: 1.1rem;
            color: #1e293b;
            letter-spacing: -0.025em;
        }

        .section-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: #64748b;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            display: flex;
            align-items: center;
        }

        .section-label i {
            margin-right: 6px;
            color: #94a3b8;
            font-size: 0.85rem;
        }

        /* Form Inputs Modernization */
        .input-group {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .input-group:focus-within {
            background: #ffffff;
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        .input-group-text {
            background: transparent;
            border: none;
            color: #94a3b8;
            padding: 0.75rem 1rem;
            transition: color 0.3s ease;
        }

        .input-group:focus-within .input-group-text {
            color: #3b82f6;
        }

        .form-control, .form-select {
            background: transparent;
            border: none;
            color: #334155;
            font-size: 0.9rem;
            padding: 0.75rem 1rem 0.75rem 0;
            font-weight: 500;
        }

        .form-control:focus, .form-select:focus {
            box-shadow: none;
            background: transparent;
        }

        .form-control::placeholder {
            color: #cbd5e1;
            font-weight: 400;
        }

        textarea.form-control {
            padding-top: 0.75rem;
            min-height: 80px;
        }

        /* Save Button */
        .btn-save {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            border: none;
            color: #ffffff !important;
            border-radius: 12px;
            font-weight: 600;
            letter-spacing: 0.025em;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(59, 130, 246, 0.4);
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: #ffffff !important;
        }

        .btn-save i, .btn-save span {
            color: #ffffff !important;
            transition: transform 0.3s ease;
        }

        .btn-save:hover i {
            transform: translateX(3px);
        }

        /* Config Boxes (Tamara & Moyasar) */
        .config-box {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }

        .config-box::before {
            content: '';
            position: absolute;
            left: 0; top: 0; bottom: 0; width: 4px;
        }

        .config-box.test-box::before { background: #f59e0b; }
        .config-box.live-box::before { background: #10b981; }

        .config-box h6 {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        /* Specific Settings Cards */
        .settings-card {
            background: #ffffff;
            border: none;
            border-radius: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            padding: 25px;
            position: relative;
            overflow: hidden;
        }

        .settings-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 5px;
            background: linear-gradient(90deg, #10b981, #3b82f6);
        }

        /* Custom Toggle Switch (Optional overriding if main-toggle is default) */
        .main-toggle {
            transform: scale(0.9);
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 align-items-center">
        <div>
            <h2 class="main-content-title tx-24 mg-b-5 font-weight-bold text-dark">Payment Hub</h2>
            <p class="mg-b-0 text-muted">Manage your payment gateways and manual transfer methods seamlessly.</p>
        </div>
    </div>

    <div class="row">

        <div class="col-xl-6 col-md-12 mb-4">
            <div class="settings-card h-100 d-flex flex-column">
                <div class="mb-4 d-flex align-items-center">
                    <div class="bg-primary-transparent p-3 rounded-circle me-3">
                        <i class="fas fa-globe tx-24 text-primary"></i>
                    </div>
                    <div>
                        <h5 class="mb-1 fw-bold text-dark">Frontend Callbacks</h5>
                        <p class="text-muted tx-13 mb-0">Web endpoints for redirect flows.</p>
                    </div>
                </div>

                <div class="card-body p-0 flex-grow-1">
                    <form action="{{ route('update.settings') }}" method="POST" class="h-100 d-flex flex-column">
                        @csrf
                        <div class="flex-grow-1">
                            <div class="mb-3">
                                <label class="section-label"><i class="fas fa-check-circle text-success"></i> Success URL</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-link"></i></span>
                                    <input type="url" name="payment_success_url" class="form-control" placeholder="https://..." value="{{ get_setting('payment_success_url') }}">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="section-label"><i class="fas fa-times-circle text-danger"></i> Failed URL</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-unlink"></i></span>
                                    <input type="url" name="payment_failed_url" class="form-control" placeholder="https://..." value="{{ get_setting('payment_failed_url') }}">
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="section-label"><i class="fas fa-undo text-warning"></i> Cancel URL</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-arrow-left"></i></span>
                                    <input type="url" name="payment_cancel_url" class="form-control" placeholder="https://..." value="{{ get_setting('payment_cancel_url') }}">
                                </div>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-save w-100" style="height: 50px;">
                            <i class="fas fa-cloud-upload-alt me-2"></i> Update Web URLs
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-xl-6 col-md-12 mb-4">
            <div class="settings-card h-100 d-flex flex-column" style="before { background: linear-gradient(90deg, #8b5cf6, #ec4899); }">
                <div class="mb-4 d-flex align-items-center">
                    <div class="bg-purple-transparent p-3 rounded-circle me-3" style="background: rgba(139, 92, 246, 0.1);">
                        <i class="fas fa-mobile-alt tx-24" style="color: #8b5cf6;"></i>
                    </div>
                    <div>
                        <h5 class="mb-1 fw-bold text-dark">Mobile App Callbacks</h5>
                        <p class="text-muted tx-13 mb-0">Deep links for application flows.</p>
                    </div>
                </div>

                <div class="card-body p-0 flex-grow-1">
                    <form action="{{ route('update.settings') }}" method="POST" class="h-100 d-flex flex-column">
                        @csrf
                        <div class="flex-grow-1">
                            <div class="mb-3">
                                <label class="section-label"><i class="fas fa-check-circle text-success"></i> Success URL</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-link"></i></span>
                                    <input type="url" name="payment_success_url_app" class="form-control" placeholder="app://..." value="{{ get_setting('payment_success_url_app') }}">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="section-label"><i class="fas fa-times-circle text-danger"></i> Failed URL</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-unlink"></i></span>
                                    <input type="url" name="payment_failed_url_app" class="form-control" placeholder="app://..." value="{{ get_setting('payment_failed_url_app') }}">
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="section-label"><i class="fas fa-undo text-warning"></i> Cancel URL</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-arrow-left"></i></span>
                                    <input type="url" name="payment_cancel_url_app" class="form-control" placeholder="app://..." value="{{ get_setting('payment_cancel_url_app') }}">
                                </div>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-save w-100" style="height: 50px;">
                            <i class="fas fa-cloud-upload-alt me-2"></i> Update App URLs
                        </button>
                    </form>
                </div>
            </div>
        </div>

        @foreach($paymentMethods as $method)
            <div class="col-xl-6 col-lg-6 col-md-6 mb-4">
                <div class="payment-card h-100 d-flex flex-column">
                    <div class="payment-img-wrapper">
                        <img src="{{ asset($method->banner_en) }}" alt="{{ $method->title_en }}" class="payment-img">
                    </div>

                    <div class="card-body d-flex flex-column flex-grow-1 p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom border-light">
                            <h5 class="card-title mb-0 fw-bold">{{ $method->title_en }}</h5>
                            <div class="main-toggle {{ $method->status ? 'main-toggle-success on' : 'main-toggle-danger off' }} toggle-status-btn shadow-sm" data-id="{{ $method->id }}">
                                <span></span>
                            </div>
                        </div>

                        <form action="{{ route('payment-methods.update', $method->id) }}" method="POST" class="d-flex flex-column flex-grow-1">
                            @csrf
                            @method('PUT')

                            <div class="flex-grow-1">

                                {{-- Bank Transfers --}}
                                @if(str_contains($method->code, 'bank_transfer'))
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-university"></i> Bank Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-building"></i></span>
                                            <input type="text" name="config[bank_name]" class="form-control fw-bold" value="{{ $method->config['bank_name'] ?? '' }}">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-user-tie"></i> Account Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-signature"></i></span>
                                            <input type="text" name="config[account_name]" class="form-control" value="{{ $method->config['account_name'] ?? '' }}">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-hashtag"></i> Account Number</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-th"></i></span>
                                            <input type="text" name="config[account_number]" class="form-control fw-bold text-primary" value="{{ $method->config['account_number'] ?? '' }}">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-money-check"></i> IBAN</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                                            <input type="text" name="config[iban]" class="form-control" style="font-family: monospace;" value="{{ $method->config['iban'] ?? '' }}">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-info-circle"></i> Instructions</label>
                                        <div class="input-group">
                                            <span class="input-group-text align-items-start pt-3"><i class="fas fa-align-left"></i></span>
                                            <textarea name="config[instructions]" class="form-control">{{ $method->config['instructions'] ?? '' }}</textarea>
                                        </div>
                                    </div>

                                    {{-- E-Wallets --}}
                                @elseif(str_contains($method->code, 'wallet_'))
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-mobile-alt"></i> Wallet Number</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-phone-alt"></i></span>
                                            <input type="text" name="config[wallet_number]" class="form-control fw-bold text-primary" value="{{ $method->config['wallet_number'] ?? '' }}" placeholder="010XXXXXXXX">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-user"></i> Account Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-signature"></i></span>
                                            <input type="text" name="config[account_name]" class="form-control" value="{{ $method->config['account_name'] ?? '' }}">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-info-circle"></i> Instructions</label>
                                        <div class="input-group">
                                            <span class="input-group-text align-items-start pt-3"><i class="fas fa-align-left"></i></span>
                                            <textarea name="config[instructions]" class="form-control">{{ $method->config['instructions'] ?? '' }}</textarea>
                                        </div>
                                    </div>

                                    {{-- InstaPay --}}
                                @elseif($method->code === 'instapay')
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-at"></i> Payment Address (IPA)</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-bolt text-warning"></i></span>
                                            <input type="text" name="config[instapay_address]" class="form-control fw-bold text-primary" value="{{ $method->config['instapay_address'] ?? '' }}" placeholder="name@instapay">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-mobile-alt"></i> Mobile Number</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                            <input type="text" name="config[mobile_number]" class="form-control" value="{{ $method->config['mobile_number'] ?? '' }}">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-user-tie"></i> Account Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-signature"></i></span>
                                            <input type="text" name="config[account_name]" class="form-control" value="{{ $method->config['account_name'] ?? '' }}">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="section-label"><i class="fas fa-info-circle"></i> Instructions</label>
                                        <div class="input-group">
                                            <span class="input-group-text align-items-start pt-3"><i class="fas fa-align-left"></i></span>
                                            <textarea name="config[instructions]" class="form-control">{{ $method->config['instructions'] ?? '' }}</textarea>
                                        </div>
                                    </div>

                                    {{-- Gateways (Tamara & Moyasar) --}}
                                @elseif($method->code === 'tamara' || $method->code === 'moyasar')
                                    <div class="mb-4">
                                        <label class="section-label"><i class="fas fa-toggle-on"></i> Environment Mode</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-server"></i></span>
                                            <select name="config[mode]" class="form-control form-select fw-bold">
                                                <option value="test" {{ ($method->config['mode'] ?? '') == 'test' ? 'selected' : '' }}>Test / Sandbox</option>
                                                <option value="live" {{ ($method->config['mode'] ?? '') == 'live' ? 'selected' : '' }}>Live / Production</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="config-box test-box shadow-sm">
                                        <h6 class="text-warning fw-bold"><i class="fas fa-vial"></i> Test Configuration</h6>
                                        @if($method->code === 'tamara')
                                            <div class="mb-3">
                                                <label class="section-label">Base URL</label>
                                                <div class="input-group"><input type="url" name="config[test][base_url]" class="form-control" value="{{ $method->config['test']['base_url'] ?? '' }}"></div>
                                            </div>
                                            <div class="mb-3">
                                                <label class="section-label">Public Key</label>
                                                <div class="input-group"><input type="text" name="config[test][public_key]" class="form-control" value="{{ $method->config['test']['public_key'] ?? '' }}"></div>
                                            </div>
                                        @else
                                            <div class="mb-3">
                                                <label class="section-label">Publishable Key</label>
                                                <div class="input-group"><input type="text" name="config[test][publishable_key]" class="form-control" value="{{ $method->config['test']['publishable_key'] ?? '' }}"></div>
                                            </div>
                                        @endif
                                        <div class="mb-0">
                                            <label class="section-label">Secret Key</label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="fas fa-key"></i></span>
                                                <input type="text" name="config[test][secret_key]" class="form-control" value="{{ $method->config['test']['secret_key'] ?? '' }}">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="config-box live-box shadow-sm">
                                        <h6 class="text-success fw-bold"><i class="fas fa-rocket"></i> Live Configuration</h6>
                                        @if($method->code === 'tamara')
                                            <div class="mb-3">
                                                <label class="section-label">Base URL</label>
                                                <div class="input-group"><input type="url" name="config[live][base_url]" class="form-control" value="{{ $method->config['live']['base_url'] ?? '' }}"></div>
                                            </div>
                                            <div class="mb-3">
                                                <label class="section-label">Public Key</label>
                                                <div class="input-group"><input type="text" name="config[live][public_key]" class="form-control" value="{{ $method->config['live']['public_key'] ?? '' }}"></div>
                                            </div>
                                        @else
                                            <div class="mb-3">
                                                <label class="section-label">Publishable Key</label>
                                                <div class="input-group"><input type="text" name="config[live][publishable_key]" class="form-control" value="{{ $method->config['live']['publishable_key'] ?? '' }}"></div>
                                            </div>
                                        @endif
                                        <div class="mb-0">
                                            <label class="section-label">Secret Key</label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                                <input type="password" name="config[live][secret_key]" class="form-control" value="{{ $method->config['live']['secret_key'] ?? '' }}">
                                            </div>
                                        </div>
                                    </div>

                                @else
                                    <div class="d-flex align-items-center justify-content-center h-100 p-4 text-center" style="background: #f8fafc; border-radius: 16px; border: 1px dashed #cbd5e1;">
                                        <div>
                                            <div class="bg-white p-3 rounded-circle d-inline-block shadow-sm mb-3">
                                                <i class="fas fa-cog tx-24 text-primary"></i>
                                            </div>
                                            <p class="text-muted fw-medium mb-0">Plug & Play setup.<br>No extra config needed.</p>
                                        </div>
                                    </div>
                                @endif
                            </div>

                            <div class="mt-4 pt-3 border-top border-light">
                                <button type="submit" class="btn btn-save w-100" style="height: 50px;">
                                    <span>Save Configuration</span>
                                    <i class="fas fa-arrow-right ms-2 tx-12"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        @endforeach

    </div>

@endsection

@section('scripts')
    <script>
        $(document).on('click', '.toggle-status-btn', function () {
            let button = $(this);
            let paymentId = button.data('id');

            if (button.hasClass('disabled')) return;

            button.addClass('disabled');

            $.ajax({
                url: "{{ route('payment.methods.change.status', ['id' => ':id']) }}".replace(':id', paymentId),
                type: 'POST',
                data: {
                    _token: '{{ csrf_token() }}'
                },
                success: function (response) {
                    toastr.success("Status updated successfully");
                    if (response.status == 1) {
                        button.removeClass('main-toggle-danger off').addClass('main-toggle-success on');
                    } else {
                        button.removeClass('main-toggle-success on').addClass('main-toggle-danger off');
                    }
                    button.removeClass('disabled');
                },
                error: function () {
                    toastr.error("Something went wrong");
                    button.removeClass('disabled');
                }
            });
        });
    </script>
@endsection
