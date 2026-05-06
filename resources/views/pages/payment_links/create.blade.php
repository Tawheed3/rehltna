@extends('layouts.app')

@section('content')

    <style>
        .select2-container .select2-selection--single {
            height: 38px !important;
            border: 1px solid #ced4da;
            display: flex;
            align-items: center;
        }
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 36px !important;
        }
        .item-row-box {
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        .item-row-box:hover {
            border-color: #d1d3e2;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #4a5568;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
    </style>

    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex align-items-center">
                <a href="{{ route('dashboard') }}" class="text-dark font-weight-bold" style="font-size: 16px;">Home</a>
                <span class="text-muted mx-2">/</span>
                <span class="text-muted">Create Payment Link</span>
            </div>
        </div>
    </div>

    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card shadow-sm">
                <div class="card-header bg-white pb-0">
                    <h4 class="card-title mb-0">New Payment Link</h4>
                </div>
                <div class="card-body">
                    <form id="createForm" action="{{ route('payment-links.store') }}" method="POST">
                        @csrf
                        <input type="hidden" name="phone" id="full_phone">

                        {{-- Customer Details Section --}}
                        <div class="mb-5">
                            <h5 class="section-title"><i class="fas fa-user-circle me-2"></i> Customer Details</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label font-weight-bold">Full Name <span class="text-danger">*</span></label>
                                    <input type="text" name="name" class="form-control" required value="{{ old('name') }}" placeholder="John Doe">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label font-weight-bold">Email <span class="text-danger">*</span></label>
                                    <input type="email" name="email" class="form-control" required value="{{ old('email') }}" placeholder="client@example.com">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label font-weight-bold">Phone Number <span class="text-danger">*</span></label>
                                    <div class="row g-2">
                                        <div class="col-4 col-sm-3">
                                            <select id="phoneCodeSelect" class="form-control select2">
                                                <option value="" selected disabled>Code</option>
                                            </select>
                                        </div>
                                        <div class="col-8 col-sm-9 pl-0">
                                            <input type="tel" id="phone_number" class="form-control" placeholder="100 123 4567" required value="{{ old('phone_number') }}">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label class="form-label font-weight-bold">Specialty</label>
                                    <input type="text" name="specialty" class="form-control" value="{{ old('specialty') }}" placeholder="e.g. Dermatology">
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label class="form-label font-weight-bold">Country</label>
                                    <select id="countrySelect" name="country" class="form-control select2">
                                        <option value="" selected disabled>Select Country</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        {{-- PAYMENT TYPE SELECTION --}}
                        <div class="mb-4 p-3 bg-light border rounded">
                            <label class="form-label font-weight-bold d-block mb-3">Payment Type:</label>
                            <div class="d-flex gap-4">
                                <div class="form-check me-4">
                                    <input class="form-check-input" type="radio" name="link_type" id="type_items" value="items" checked>
                                    <label class="form-check-label" for="type_items">
                                        <i class="fas fa-shopping-cart me-1"></i> Select Items/Courses
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="link_type" id="type_amount" value="amount">
                                    <label class="form-check-label" for="type_amount">
                                        <i class="fas fa-dollar-sign me-1"></i> Custom Amount
                                    </label>
                                </div>
                            </div>
                        </div>

                        {{-- ITEMS SECTION --}}
                        <div id="section-items">
                            <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">
                                <h5 class="text-primary mb-0 font-weight-bold"><i class="fas fa-shopping-cart me-2"></i> Order Items</h5>
                                <button type="button" class="btn btn-sm btn-info shadow-sm" id="add-item-btn">
                                    <i class="fas fa-plus-circle"></i> Add Item
                                </button>
                            </div>
                            <div id="items-container">
                                @if(old('items'))
                                    @foreach(old('items') as $index => $oldItem)
                                        <div class="item-row item-row-box">
                                            <div class="row align-items-end">
                                                <div class="col-md-7 mb-2 mb-md-0">
                                                    <label class="form-label small text-muted">Select Item</label>
                                                    <select name="items[{{$index}}][item_id]" class="form-control select2-items" required>
                                                        <option value="">Choose Course/Item</option>
                                                        @foreach($items as $item)
                                                            <option value="{{ $item->id }}" {{ $oldItem['item_id'] == $item->id ? 'selected' : '' }}>
                                                                {{ $item->title_ar ?: ($item->title_en ?? $item->name) }}@if($item->season) — {{ $item->season }}@endif ({{ $item->price }} $)
                                                            </option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                                <div class="col-md-4 mb-2 mb-md-0">
                                                    <label class="form-label small text-muted">Attendees Count</label>
                                                    <input type="number" name="items[{{$index}}][attendees]" class="form-control" value="{{ $oldItem['attendees'] }}" min="1" required>
                                                </div>
                                                <div class="col-md-1 text-end">
                                                    <button type="button" class="btn btn-danger btn-sm remove-item-btn"><i class="fas fa-trash"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                    @endforeach
                                @else
                                    <div class="item-row item-row-box">
                                        <div class="row align-items-end">
                                            <div class="col-md-7 mb-2 mb-md-0">
                                                <label class="form-label small text-muted">Select Item</label>
                                                <select name="items[0][item_id]" class="form-control select2-items" required>
                                                    <option value="">Choose Course/Item</option>
                                                    @foreach($items as $item)
                                                        <option value="{{ $item->id }}">{{ $item->title_ar ?: ($item->title_en ?? $item->name) }}@if($item->season) — {{ $item->season }}@endif ({{ $item->price }} $)</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                            <div class="col-md-4 mb-2 mb-md-0">
                                                <label class="form-label small text-muted">Attendees Count</label>
                                                <input type="number" name="items[0][attendees]" class="form-control" value="1" min="1" required>
                                            </div>
                                            <div class="col-md-1 text-end">
                                                <button type="button" class="btn btn-outline-danger btn-sm remove-item-btn"><i class="fas fa-trash"></i></button>
                                            </div>
                                        </div>
                                    </div>
                                @endif
                            </div>
                        </div>

                        {{-- AMOUNT SECTION (Hidden by default) --}}
                        <div id="section-amount" style="display: none;">
                            <h5 class="section-title"><i class="fas fa-money-bill-wave me-2"></i> Payment Amount</h5>
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="form-label font-weight-bold">Amount (USD) <span class="text-danger">*</span></label>
                                    <input type="number" name="amount" id="amount-input" class="form-control form-control-lg" step="0.01" placeholder="0.00">
                                </div>
                                <div class="col-md-8">
                                    <label class="form-label font-weight-bold">Description / Note <span class="text-muted small">(Sent to Payment Gateway)</span></label>
                                    <textarea name="note" id="note-input" class="form-control" rows="3" placeholder="Payment details...">{{ old('note') }}</textarea>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-start mt-4 pt-3 border-top">
                            <button class="btn btn-primary btn-lg px-4 ml-2" type="submit">
                                <i class="fas fa-link mr-1"></i> Generate Link
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('scripts')
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <script>
        $(document).ready(function () {
            $('.select2-items').select2({width: '100%'});
            $('#countrySelect').select2({width: '100%', placeholder: "Select Country"});
            $('#phoneCodeSelect').select2({width: '100%', placeholder: "Code"});

            // --- Toggle Items vs Amount ---
            $('input[name="link_type"]').change(function() {
                if ($(this).val() === 'items') {
                    $('#section-items').slideDown();
                    $('#section-amount').slideUp();
                    $('.select2-items').prop('required', true);
                    $('#amount-input').prop('required', false);
                } else {
                    $('#section-items').slideUp();
                    $('#section-amount').slideDown();
                    $('.select2-items').prop('required', false);
                    $('#amount-input').prop('required', true);
                }
            });

            // Trigger on load (for validation errors)
            if ($('#type_amount').is(':checked')) {
                $('#type_amount').trigger('change');
            }


            // --- Dynamic Items Logic ---
            let itemIndex = {{ old('items') ? count(old('items')) : 1 }};
            $('#add-item-btn').click(function () {
                let newItemRow = `
                    <div class="item-row item-row-box">
                        <div class="row align-items-end">
                            <div class="col-md-7 mb-2 mb-md-0">
                                <label class="form-label small text-muted">Select Item</label>
                                <select name="items[${itemIndex}][item_id]" class="form-control select2-dynamic" required>
                                    <option value="">Choose Course/Item</option>
                                    @foreach($items as $item)
                <option value="{{ $item->id }}">{{ $item->title_ar ?: ($item->title_en ?? $item->name) }}@if($item->season) — {{ $item->season }}@endif ({{ $item->price }} $)</option>
                                    @endforeach
                </select>
            </div>
            <div class="col-md-4 mb-2 mb-md-0">
                <label class="form-label small text-muted">Attendees Count</label>
                <input type="number" name="items[${itemIndex}][attendees]" class="form-control" value="1" min="1" required>
                            </div>
                            <div class="col-md-1 text-end">
                                <button type="button" class="btn btn-danger btn-sm remove-item-btn"><i class="fas fa-trash"></i></button>
                            </div>
                        </div>
                    </div>`;
                $('#items-container').append(newItemRow);
                $('.select2-dynamic').select2({width: '100%'}).removeClass('select2-dynamic');
                itemIndex++;
            });

            $(document).on('click', '.remove-item-btn', function () {
                if ($('.item-row').length > 1) {
                    $(this).closest('.item-row').fadeOut(300, function() { $(this).remove(); });
                } else {
                    alert('At least one item is required.');
                }
            });

            // --- Form Submit & Countries (نفس الكود السابق للدول) ---
            $('#createForm').on('submit', function (e) {
                const code = $('#phoneCodeSelect').val();
                const number = $('#phone_number').val();
                if (!code || !number) {
                    alert('Please enter a valid phone number with code.');
                    e.preventDefault();
                    return;
                }
                $('#full_phone').val(code + number);
            });

            const countriesData = [
                {name: "Afghanistan", code: "+93", flag: "🇦🇫"},
                {name: "Albania", code: "+355", flag: "🇦🇱"},
                {name: "Algeria", code: "+213", flag: "🇩🇿"},
                {name: "Andorra", code: "+376", flag: "🇦🇩"},
                {name: "Angola", code: "+244", flag: "🇦🇴"},
                {name: "Antigua and Barbuda", code: "+1-268", flag: "🇦🇬"},
                {name: "Argentina", code: "+54", flag: "🇦🇷"},
                {name: "Armenia", code: "+374", flag: "🇦🇲"},
                {name: "Australia", code: "+61", flag: "🇦🇺"},
                {name: "Austria", code: "+43", flag: "🇦🇹"},
                {name: "Azerbaijan", code: "+994", flag: "🇦🇿"},
                {name: "Bahamas", code: "+1-242", flag: "🇧🇸"},
                {name: "Bahrain", code: "+973", flag: "🇧🇭"},
                {name: "Bangladesh", code: "+880", flag: "🇧🇩"},
                {name: "Barbados", code: "+1-246", flag: "🇧🇧"},
                {name: "Belarus", code: "+375", flag: "🇧🇾"},
                {name: "Belgium", code: "+32", flag: "🇧🇪"},
                {name: "Belize", code: "+501", flag: "🇧🇿"},
                {name: "Benin", code: "+229", flag: "🇧🇯"},
                {name: "Bhutan", code: "+975", flag: "🇧🇹"},
                {name: "Bolivia", code: "+591", flag: "🇧🇴"},
                {name: "Bosnia and Herzegovina", code: "+387", flag: "🇧🇦"},
                {name: "Botswana", code: "+267", flag: "🇧🇼"},
                {name: "Brazil", code: "+55", flag: "🇧🇷"},
                {name: "Brunei", code: "+673", flag: "🇧🇳"},
                {name: "Bulgaria", code: "+359", flag: "🇧🇬"},
                {name: "Burkina Faso", code: "+226", flag: "🇧🇫"},
                {name: "Burundi", code: "+257", flag: "🇧🇮"},
                {name: "Cambodia", code: "+855", flag: "🇰🇭"},
                {name: "Cameroon", code: "+237", flag: "🇨🇲"},
                {name: "Canada", code: "+1", flag: "🇨🇦"},
                {name: "Cape Verde", code: "+238", flag: "🇨y"},
                {name: "Central African Republic", code: "+236", flag: "🇨🇫"},
                {name: "Chad", code: "+235", flag: "🇹🇩"},
                {name: "Chile", code: "+56", flag: "🇨🇱"},
                {name: "China", code: "+86", flag: "🇨🇳"},
                {name: "Colombia", code: "+57", flag: "🇨🇴"},
                {name: "Comoros", code: "+269", flag: "🇰🇲"},
                {name: "Congo", code: "+242", flag: "🇨🇬"},
                {name: "Costa Rica", code: "+506", flag: "🇨🇷"},
                {name: "Cote d'Ivoire", code: "+225", flag: "🇨🇮"},
                {name: "Croatia", code: "+385", flag: "🇭🇷"},
                {name: "Cuba", code: "+53", flag: "🇨🇺"},
                {name: "Cyprus", code: "+357", flag: "🇨🇾"},
                {name: "Czech Republic", code: "+420", flag: "🇨🇿"},
                {name: "Democratic Republic of the Congo", code: "+243", flag: "🇨🇩"},
                {name: "Denmark", code: "+45", flag: "🇩🇰"},
                {name: "Djibouti", code: "+253", flag: "🇩🇯"},
                {name: "Dominica", code: "+1-767", flag: "🇩🇲"},
                {name: "Dominican Republic", code: "+1-809", flag: "🇩🇴"},
                {name: "Ecuador", code: "+593", flag: "🇪🇨"},
                {name: "Egypt", code: "+20", flag: "🇪🇬"},
                {name: "El Salvador", code: "+503", flag: "🇸🇻"},
                {name: "Equatorial Guinea", code: "+240", flag: "🇬🇶"},
                {name: "Eritrea", code: "+291", flag: "🇪🇷"},
                {name: "Estonia", code: "+372", flag: "🇪🇪"},
                {name: "Eswatini", code: "+268", flag: "🇸🇿"},
                {name: "Ethiopia", code: "+251", flag: "🇪🇹"},
                {name: "Fiji", code: "+679", flag: "🇫🇯"},
                {name: "Finland", code: "+358", flag: "🇫🇮"},
                {name: "France", code: "+33", flag: "🇫🇷"},
                {name: "Gabon", code: "+241", flag: "🇬🇦"},
                {name: "Gambia", code: "+220", flag: "🇬🇲"},
                {name: "Georgia", code: "+995", flag: "🇬🇪"},
                {name: "Germany", code: "+49", flag: "🇩🇪"},
                {name: "Ghana", code: "+233", flag: "🇬🇭"},
                {name: "Greece", code: "+30", flag: "🇬🇷"},
                {name: "Grenada", code: "+1-473", flag: "🇬🇩"},
                {name: "Guatemala", code: "+502", flag: "🇬🇹"},
                {name: "Guinea", code: "+224", flag: "🇬🇳"},
                {name: "Guinea-Bissau", code: "+245", flag: "🇬🇼"},
                {name: "Guyana", code: "+592", flag: "🇬🇾"},
                {name: "Haiti", code: "+509", flag: "🇭🇹"},
                {name: "Honduras", code: "+504", flag: "🇭🇳"},
                {name: "Hungary", code: "+36", flag: "🇭🇺"},
                {name: "Iceland", code: "+354", flag: "🇮🇸"},
                {name: "India", code: "+91", flag: "🇮🇳"},
                {name: "Indonesia", code: "+62", flag: "🇮🇩"},
                {name: "Iran", code: "+98", flag: "🇮🇷"},
                {name: "Iraq", code: "+964", flag: "🇮🇶"},
                {name: "Ireland", code: "+353", flag: "🇮🇪"},
                {name: "Italy", code: "+39", flag: "🇮🇹"},
                {name: "Jamaica", code: "+1-876", flag: "🇯🇲"},
                {name: "Japan", code: "+81", flag: "🇯🇵"},
                {name: "Jordan", code: "+962", flag: "🇯🇴"},
                {name: "Kazakhstan", code: "+7", flag: "🇰🇿"},
                {name: "Kenya", code: "+254", flag: "🇰🇪"},
                {name: "Kiribati", code: "+686", flag: "🇰🇮"},
                {name: "Kuwait", code: "+965", flag: "🇰🇼"},
                {name: "Kyrgyzstan", code: "+996", flag: "🇰🇬"},
                {name: "Laos", code: "+856", flag: "🇱🇦"},
                {name: "Latvia", code: "+371", flag: "🇱🇻"},
                {name: "Lebanon", code: "+961", flag: "🇱🇧"},
                {name: "Lesotho", code: "+266", flag: "🇱🇸"},
                {name: "Liberia", code: "+231", flag: "🇱🇷"},
                {name: "Libya", code: "+218", flag: "🇱🇾"},
                {name: "Liechtenstein", code: "+423", flag: "🇱🇮"},
                {name: "Lithuania", code: "+370", flag: "🇱🇹"},
                {name: "Luxembourg", code: "+352", flag: "🇱🇺"},
                {name: "Madagascar", code: "+261", flag: "🇲🇬"},
                {name: "Malawi", code: "+265", flag: "🇲🇼"},
                {name: "Malaysia", code: "+60", flag: "🇲🇾"},
                {name: "Maldives", code: "+960", flag: "🇲🇻"},
                {name: "Mali", code: "+223", flag: "🇲🇱"},
                {name: "Malta", code: "+356", flag: "🇲🇹"},
                {name: "Marshall Islands", code: "+692", flag: "🇲🇭"},
                {name: "Mauritania", code: "+222", flag: "🇲🇷"},
                {name: "Mauritius", code: "+230", flag: "🇲🇺"},
                {name: "Mexico", code: "+52", flag: "🇲🇽"},
                {name: "Micronesia", code: "+691", flag: "🇫🇲"},
                {name: "Moldova", code: "+373", flag: "🇲🇩"},
                {name: "Monaco", code: "+377", flag: "🇲🇨"},
                {name: "Mongolia", code: "+976", flag: "🇲🇳"},
                {name: "Montenegro", code: "+382", flag: "🇲🇪"},
                {name: "Morocco", code: "+212", flag: "🇲🇦"},
                {name: "Mozambique", code: "+258", flag: "🇲🇿"},
                {name: "Myanmar", code: "+95", flag: "🇲🇲"},
                {name: "Namibia", code: "+264", flag: "🇳🇦"},
                {name: "Nauru", code: "+674", flag: "🇳🇷"},
                {name: "Nepal", code: "+977", flag: "🇳🇵"},
                {name: "Netherlands", code: "+31", flag: "🇳🇱"},
                {name: "New Zealand", code: "+64", flag: "🇳🇿"},
                {name: "Nicaragua", code: "+505", flag: "🇳🇮"},
                {name: "Niger", code: "+227", flag: "🇳🇪"},
                {name: "Nigeria", code: "+234", flag: "🇳🇬"},
                {name: "North Korea", code: "+850", flag: "🇰🇵"},
                {name: "North Macedonia", code: "+389", flag: "🇲🇰"},
                {name: "Norway", code: "+47", flag: "🇳🇴"},
                {name: "Oman", code: "+968", flag: "🇴🇲"},
                {name: "Pakistan", code: "+92", flag: "🇵🇰"},
                {name: "Palau", code: "+680", flag: "🇵🇼"},
                {name: "Palestine", code: "+970", flag: "🇵🇸"},
                {name: "Panama", code: "+507", flag: "🇵🇦"},
                {name: "Papua New Guinea", code: "+675", flag: "🇵🇬"},
                {name: "Paraguay", code: "+595", flag: "🇵🇾"},
                {name: "Peru", code: "+51", flag: "🇵🇪"},
                {name: "Philippines", code: "+63", flag: "🇵🇭"},
                {name: "Poland", code: "+48", flag: "🇵🇱"},
                {name: "Portugal", code: "+351", flag: "🇵🇹"},
                {name: "Qatar", code: "+974", flag: "🇶🇦"},
                {name: "Romania", code: "+40", flag: "🇷🇴"},
                {name: "Russia", code: "+7", flag: "🇷🇺"},
                {name: "Rwanda", code: "+250", flag: "🇷🇼"},
                {name: "Saint Kitts and Nevis", code: "+1-869", flag: "🇰🇳"},
                {name: "Saint Lucia", code: "+1-758", flag: "🇱🇨"},
                {name: "Saint Vincent and the Grenadines", code: "+1-784", flag: "🇻🇨"},
                {name: "Samoa", code: "+685", flag: "🇼🇸"},
                {name: "San Marino", code: "+378", flag: "🇸🇲"},
                {name: "Sao Tome and Principe", code: "+239", flag: "🇸🇹"},
                {name: "Saudi Arabia", code: "+966", flag: "🇸🇦"},
                {name: "Senegal", code: "+221", flag: "🇸🇳"},
                {name: "Serbia", code: "+381", flag: "🇷🇸"},
                {name: "Seychelles", code: "+248", flag: "🇸🇨"},
                {name: "Sierra Leone", code: "+232", flag: "🇸🇱"},
                {name: "Singapore", code: "+65", flag: "🇸🇬"},
                {name: "Slovakia", code: "+421", flag: "🇸🇰"},
                {name: "Slovenia", code: "+386", flag: "🇸🇮"},
                {name: "Solomon Islands", code: "+677", flag: "🇸🇧"},
                {name: "Somalia", code: "+252", flag: "🇸🇴"},
                {name: "South Africa", code: "+27", flag: "🇿🇦"},
                {name: "South Korea", code: "+82", flag: "🇰🇷"},
                {name: "South Sudan", code: "+211", flag: "🇸🇸"},
                {name: "Spain", code: "+34", flag: "🇪🇸"},
                {name: "Sri Lanka", code: "+94", flag: "🇱🇰"},
                {name: "Sudan", code: "+249", flag: "🇸🇩"},
                {name: "Suriname", code: "+597", flag: "🇸🇷"},
                {name: "Sweden", code: "+46", flag: "🇸🇪"},
                {name: "Switzerland", code: "+41", flag: "🇨🇭"},
                {name: "Syria", code: "+963", flag: "🇸🇾"},
                {name: "Taiwan", code: "+886", flag: "🇹🇼"},
                {name: "Tajikistan", code: "+992", flag: "🇹🇯"},
                {name: "Tanzania", code: "+255", flag: "🇹🇿"},
                {name: "Thailand", code: "+66", flag: "🇹🇭"},
                {name: "Timor-Leste", code: "+670", flag: "🇹🇱"},
                {name: "Togo", code: "+228", flag: "🇹🇬"},
                {name: "Tonga", code: "+676", flag: "🇹🇴"},
                {name: "Trinidad and Tobago", code: "+1-868", flag: "🇹🇹"},
                {name: "Tunisia", code: "+216", flag: "🇹🇳"},
                {name: "Turkey", code: "+90", flag: "🇹🇷"},
                {name: "Turkmenistan", code: "+993", flag: "🇹🇲"},
                {name: "Tuvalu", code: "+688", flag: "🇹🇻"},
                {name: "Uganda", code: "+256", flag: "🇺🇬"},
                {name: "Ukraine", code: "+380", flag: "🇺🇦"},
                {name: "United Arab Emirates", code: "+971", flag: "🇦🇪"},
                {name: "United Kingdom", code: "+44", flag: "🇬🇧"},
                {name: "United States", code: "+1", flag: "🇺🇸"},
                {name: "Uruguay", code: "+598", flag: "🇺🇾"},
                {name: "Uzbekistan", code: "+998", flag: "🇺🇿"},
                {name: "Vanuatu", code: "+678", flag: "🇻🇺"},
                {name: "Vatican City", code: "+379", flag: "🇻🇦"},
                {name: "Venezuela", code: "+58", flag: "🇻🇪"},
                {name: "Vietnam", code: "+84", flag: "🇻🇳"},
                {name: "Yemen", code: "+967", flag: "🇾🇪"},
                {name: "Zambia", code: "+260", flag: "🇿🇲"},
                {name: "Zimbabwe", code: "+263", flag: "🇿🇼"}
            ];


            countriesData.forEach(country => {
                $('#countrySelect').append(new Option(`${country.flag} ${country.name}`, country.name, false, false));
                $('#phoneCodeSelect').append(new Option(`${country.flag} ${country.code}`, country.code, false, false));
            });

            $('#phoneCodeSelect').val('+20').trigger('change');
        });
    </script>
@endsection
