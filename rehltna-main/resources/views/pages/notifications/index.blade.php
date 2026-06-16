@extends('layouts.app')

@section('styles')
    <style>
        .notification-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            background: #fff;
        }
        .form-control-deluxe {
            border-radius: 12px;
            border: 2px solid #f1f5f9;
            padding: 12px 15px;
            font-weight: 500;
            background: #fcfcfc;
            transition: 0.3s;
        }
        .form-control-deluxe:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
            background: #fff;
        }

        /* تصميم الراديو الأساسي */
        .target-option {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 15px;
            cursor: pointer;
            transition: 0.3s;
        }
        .target-option:hover {
            border-color: #cbd5e1;
            background: #f8fafc;
        }
        .form-check-input:checked + .target-option {
            border-color: #4f46e5;
            background: #e0e7ff;
        }
        .target-section {
            display: none;
            animation: fadeIn 0.4s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* تصميم قائمة التشيك بوكس الجديدة */
        .checkbox-list-container {
            max-height: 250px;
            overflow-y: auto;
            border: 2px solid #f1f5f9;
            border-radius: 12px;
            padding: 15px;
            background: #fcfcfc;
        }
        /* تجميل السكرول بار للقائمة */
        .checkbox-list-container::-webkit-scrollbar {
            width: 6px;
        }
        .checkbox-list-container::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 10px;
        }
        /* لون التشيك بوكس لما تدوس عليه */
        .form-check-input:checked {
            background-color: #4f46e5;
            border-color: #4f46e5;
        }
    </style>
@endsection

@section('content')
    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold text-dark">Push Notifications</h4>
            <p class="text-muted mb-0 small fw-medium">Marketing / <span class="text-primary">Send Notification</span></p>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card notification-card">
                <div class="card-header bg-white border-bottom p-4 rounded-top">
                    <h5 class="fw-bold mb-0"><i class="las la-bell text-warning fs-3 me-2"></i> Compose Notification</h5>
                </div>
                <div class="card-body p-4">
                    <form action="{{ route('notifications.send') }}" method="POST" id="notificationForm">
                        @csrf

                        <div class="mb-4">
                            <label class="fw-bold mb-2">Notification Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control form-control-deluxe" placeholder="e.g. Special Offer!" required>
                        </div>

                        <div class="mb-4">
                            <label class="fw-bold mb-2">Notification Body <span class="text-danger">*</span></label>
                            <textarea name="body" class="form-control form-control-deluxe" rows="4" placeholder="Type your message here..." required></textarea>
                        </div>

                        <hr class="my-4 border-light">

                        <h6 class="fw-bold mb-3">Target Audience <span class="text-danger">*</span></h6>

                        <div class="row mb-4">
                            <div class="col-md-4 mb-2">
                                <input class="form-check-input d-none target-radio" type="radio" name="target_type" id="targetAll" value="all" checked>
                                <label class="target-option w-100 text-center" for="targetAll">
                                    <i class="las la-users fs-2 d-block text-primary mb-1"></i>
                                    <span class="fw-bold">All Users</span>
                                </label>
                            </div>
                            <div class="col-md-4 mb-2">
                                <input class="form-check-input d-none target-radio" type="radio" name="target_type" id="targetUsers" value="users">
                                <label class="target-option w-100 text-center" for="targetUsers">
                                    <i class="las la-user-check fs-2 d-block text-success mb-1"></i>
                                    <span class="fw-bold">Specific Users</span>
                                </label>
                            </div>
                            <div class="col-md-4 mb-2">
                                <input class="form-check-input d-none target-radio" type="radio" name="target_type" id="targetPackages" value="packages">
                                <label class="target-option w-100 text-center" for="targetPackages">
                                    <i class="las la-box fs-2 d-block text-warning mb-1"></i>
                                    <span class="fw-bold">By Packages</span>
                                </label>
                            </div>
                        </div>

                        <div class="target-section mb-4" id="section-users">
                            <label class="fw-bold mb-2">Select Users <span class="text-danger">*</span></label>
                            <div class="checkbox-list-container shadow-sm">
                                <div class="form-check mb-3 pb-2 border-bottom">
                                    <input class="form-check-input" type="checkbox" id="selectAllUsers">
                                    <label class="form-check-label fw-bold text-primary" style="cursor: pointer;" for="selectAllUsers">
                                        Select All Users
                                    </label>
                                </div>
                                <div class="row">
                                    @foreach($users as $user)
                                        <div class="col-md-6 col-lg-4 mb-2">
                                            <div class="form-check">
                                                <input class="form-check-input user-checkbox" type="checkbox" name="user_ids[]" value="{{ $user->id }}" id="user_{{ $user->id }}">
                                                <label class="form-check-label" style="cursor: pointer; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: block;" title="{{ $user->name }} ({{ $user->phone }})" for="user_{{ $user->id }}">
                                                    <span class="fw-bold">{{ $user->name }}</span> <span class="text-muted small">({{ $user->phone }})</span>
                                                </label>
                                            </div>
                                        </div>
                                    @endforeach
                                </div>
                            </div>
                        </div>

                        <div class="target-section mb-4" id="section-packages">
                            <label class="fw-bold mb-2">Select Packages <span class="text-danger">*</span></label>
                            <div class="checkbox-list-container shadow-sm">
                                <div class="form-check mb-3 pb-2 border-bottom">
                                    <input class="form-check-input" type="checkbox" id="selectAllPackages">
                                    <label class="form-check-label fw-bold text-primary" style="cursor: pointer;" for="selectAllPackages">
                                        Select All Packages
                                    </label>
                                </div>
                                <div class="row">
                                    @foreach($packages as $pkg)
                                        <div class="col-md-6 col-lg-3 mb-2">
                                            <div class="form-check">
                                                <input class="form-check-input pkg-checkbox" type="checkbox" name="package_ids[]" value="{{ $pkg->id }}" id="pkg_{{ $pkg->id }}">
                                                <label class="form-check-label fw-bold" style="cursor: pointer;" for="pkg_{{ $pkg->id }}">
                                                    {{ $pkg->name_en }}
                                                </label>
                                            </div>
                                        </div>
                                    @endforeach
                                </div>
                            </div>
                        </div>
                        <hr class="my-4 border-light">

                        <div class="mb-4">
                            <label class="fw-bold mb-2">
                                <i class="las la-clock me-1 text-primary"></i>
                                Schedule (Optional)
                                <span class="text-muted fw-normal small ms-2">— Leave empty to send immediately</span>
                            </label>
                            <input type="datetime-local" name="scheduled_at"
                                   class="form-control form-control-deluxe"
                                   min="{{ now('Asia/Riyadh')->addMinutes(5)->format('Y-m-d\TH:i') }}">
                            <div class="form-text text-muted mt-1">
                                <i class="las la-map-marker me-1"></i> Saudi Arabia Time (UTC+3)
                            </div>
                        </div>

                        <div class="text-end mt-4">
                            <button type="submit" class="btn btn-primary rounded-pill px-5 py-2 fw-bold shadow-sm">
                                <i class="las la-paper-plane me-2"></i> Send Notification
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('scripts')
    <script>
        $(document).ready(function() {
            // إظهار وإخفاء الأقسام بناءً على الراديو
            $('.target-radio').change(function() {
                $('.target-section').hide();

                if ($(this).val() === 'users') {
                    $('#section-users').fadeIn();
                } else if ($(this).val() === 'packages') {
                    $('#section-packages').fadeIn();
                }
            });

            // لوجيك "تحديد كل المستخدمين"
            $('#selectAllUsers').change(function() {
                $('.user-checkbox').prop('checked', $(this).prop('checked'));
            });

            // لوجيك "تحديد كل الباقات"
            $('#selectAllPackages').change(function() {
                $('.pkg-checkbox').prop('checked', $(this).prop('checked'));
            });

            // التأكد قبل الإرسال إن اليوزر اختار حاجة (عشان الـ Checkbox ملوش required زي الـ Select)
            $('#notificationForm').submit(function(e) {
                let targetType = $('input[name="target_type"]:checked').val();

                if (targetType === 'users') {
                    if ($('.user-checkbox:checked').length === 0) {
                        e.preventDefault();
                        alert('Please select at least one user before sending.');
                    }
                } else if (targetType === 'packages') {
                    if ($('.pkg-checkbox:checked').length === 0) {
                        e.preventDefault();
                        alert('Please select at least one package before sending.');
                    }
                }
            });
        });
    </script>
@endsection
