<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Tenant | {{ env('APP_NAME') }} Panel</title>
    <link rel="icon" href="{{ asset('assets/img/seo-img.png') }}" type="image/x-icon"/>
    <link href="{{ asset('assets/css/style.css') }}" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>

    <style>
        .form-check-input:checked + .form-check-label {
            color: #28a745;
            font-weight: 600;
        }
    </style>
</head>
<body>

<!-- Loader -->
<div id="global-loader">
    <img src="{{ asset('assets/img/loader.svg') }}" class="loader-img" alt="Loader">
</div>

<!-- Create Tenant Form -->
<div class="container py-5">
    <h3 class="mb-4 text-center">Add New Tenant</h3>

    <form action="{{ route('tenants.store') }}" method="POST" enctype="multipart/form-data" class="card p-4 shadow-sm">
        @csrf
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Tenant Name</label>
                <input type="text" name="name" class="form-control" placeholder="Enter tenant name"
                       value="{{ old('name') }}" required>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Site URL</label>
                <input type="text" name="site_url" class="form-control" placeholder="Enter site url"
                       value="{{ old('site_url') }}" required>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">DB Host</label>
                <input type="text" name="db_host" value="127.0.0.1" class="form-control" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">DB Port</label>
                <input type="text" name="db_port" value="3306" class="form-control" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">DB Name</label>
            <input type="text" name="db_name" class="form-control" value="{{ old('db_name') }}"
                   placeholder="Database name" required>
        </div>

        <div class="mb-3">
            <label class="form-label">DB Username</label>
            <input type="text" name="db_username" class="form-control" value="{{ old('db_username') }}"
                   placeholder="Database username" required>
        </div>

        <div class="mb-3">
            <label class="form-label">DB Password</label>
            <input type="text" name="db_password" class="form-control" value="{{ old('db_password') }}"
                   placeholder="Database password">
        </div>

        <div class="mb-3">
            <label class="form-label">User Email</label>
            <input type="email" name="email" class="form-control" placeholder="User Email" value="{{ old('email') }}"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">User Password</label>
            <input type="text" name="password" class="form-control" placeholder="User password"
                   value="{{ old('password') }}" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Tenant Image</label>
            <input type="file" name="image" class="form-control" required>
        </div>

        <h5 class="form-label">Enable Options</h5>
        <div class="row mb-3">
            @foreach([
                'home' => 'Home',
                'social_integration' => 'Social Integration',
                'blogs' => 'Blogs System',
                'offers' => 'Offers System',
                'ai_settings' => 'AI Settings',
                'sitemaps' => 'SiteMaps',
                'items' => 'Items System',
                'jobs' => 'Jobs System',
                'contact' => 'Contact Us',
                'payment_methods' => 'Payment Methods',
                'coupons' => 'Coupons',
                'orders' => 'Orders',
                'subscribes' => 'Subscribes',
                'sliders' => 'Sliders',
                'events' => 'Events',
                'events_galleries' => 'Events Galleries',
                'news' => 'News',
                'members' => 'Members',
                'disease_types' => 'Disease Types',
                'patients' => 'Patients',
                'residencies' => 'Residencies',
                'residency_users' => 'Residency Users',
                'register_users' => 'Register Users',
                'protocols' => 'Protocols',
                'payment_links' => 'Payment Links',
                'clinical_publications' => 'Clinical Publications',
                'portfolios' => 'Portfolios System',
                'custom_pages' => 'Custom Pages',
                'testimonials' => 'Testimonials',
                'leads' => 'Leads System',
                'images_uploader' => 'Images Uploader',
                'settings' => 'Settings',
                'countries' => 'Countries',
                'states' => 'States',
                'cities' => 'Cities',
                'packages' => 'Packages',
                'employees' => 'Employees',
                'role_permissions' => 'Role & Permissions',
                'notifications' => 'Notifications',
                'notification_templates' => 'Templates',
                'failed_jobs' => 'Failed Jobs',
            ] as $value => $label)
                <div class="col-md-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="options[]" value="{{ $value }}"
                               id="{{ $value }}" checked>
                        <label class="form-check-label" for="{{ $value }}">{{ $label }}</label>
                    </div>
                </div>
            @endforeach
        </div>

        <div class="text-end">
            <button class="btn btn-primary">
                <i class="fas fa-plus-circle me-1"></i> Add Tenant
            </button>
        </div>

    </form>
</div>

<!-- Scripts -->
<script src="{{ asset('assets/plugins/jquery/jquery.min.js') }}"></script>
<script src="{{ asset('assets/js/custom.js') }}"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<script>
    @if(session('success')) toastr.success("{{ session('success') }}");
    @endif
    @if(session('error')) toastr.error("{{ session('error') }}");
    @endif
    @if(session('warning')) toastr.warning("{{ session('warning') }}");
    @endif
    @if(session('info')) toastr.info("{{ session('info') }}"); @endif
</script>
<script>
    @if ($errors->any())
    @foreach ($errors->all() as $error)
    toastr.error("{{ $error }}");
    @endforeach
    @endif
</script>

</body>
</html>
