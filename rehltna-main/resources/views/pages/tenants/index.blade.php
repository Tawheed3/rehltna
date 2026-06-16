<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tenants | {{ env('APP_NAME') }} Panel</title>
    <link rel="icon" href="{{ asset('assets/img/seo-img.png') }}" type="image/x-icon"/>
    <link href="{{ asset('assets/css/style.css') }}" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>

    <style>
        .tenant-avatar {
            transition: all 0.3s ease-in-out;
            border: 3px solid transparent;
        }

        .tenant-avatar:hover {
            transform: scale(1.1);
            border-color: #28a745;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .centered-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }
    </style>
</head>
<body>
<!-- Loader -->
<div id="global-loader">
    <img src="{{ asset('assets/img/loader.svg') }}" class="loader-img" alt="Loader">
</div>
<!-- /Loader -->

<div class="container centered-container">
    @if($tenants->count() > 0)
        <h3 class="mb-4 text-center">Select A Tenant To Activate And Continue</h3>
    @else
        @if(env('APP_TENANTS_SETTING') == 'on')
            <h3 class="mb-4 text-center text-success">Add First Tenants To Continue</h3>
        @else
            <h3 class="mb-4 text-center text-danger">Please contact the administrator to add tenants</h3>
        @endif
    @endif

    @if(env('APP_TENANTS_SETTING') == 'on')
        <div class="mb-4 text-end w-100">
            <a href="{{ route('tenants.create') }}" class="btn btn-success">
                <i class="fa fa-plus"></i> New Tenant
            </a>
        </div>
    @endif

    <div class="row justify-content-center">
        @foreach($tenants as $tenant)
            <div class="col-md-4 col-4 mb-4 text-center">
                <form action="{{ route('tenants.activate', $tenant->id) }}" method="GET">
                    <button type="submit" class="border-0 bg-transparent p-0">
                        <img src="{{ asset($tenant->image) }}"
                             class="tenant-avatar img-fluid rounded-circle shadow-sm"
                             alt="{{ $tenant->name }}"
                             style="width: 120px; height: 120px; object-fit: cover;">
                        <p class="mt-2 fw-semibold">{{ $tenant->name }}</p>
                    </button>
                </form>
                @if(env('APP_TENANTS_SETTING') == 'on')
                    <a href="{{ route('tenants.edit', encrypt($tenant->id)) }}"
                       class="btn btn-sm btn-outline-primary mt-1">
                        <i class="fa fa-edit"></i>
                    </a>
                    <button type="button"
                            class="btn btn-sm btn-outline-danger mt-1"
                            data-bs-toggle="modal"
                            data-bs-target="#deleteTenantModal"
                            data-id="{{ encrypt($tenant->id) }}">
                        <i class="fa fa-trash"></i>
                    </button>

                @endif
            </div>
        @endforeach
    </div>
</div>
<div class="modal fade" id="deleteTenantModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-danger">
                    <i class="fa fa-triangle-exclamation"></i> Confirm Delete
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body text-center">
                <p class="mb-0">
                    Are you sure you want to delete this tenant?<br>
                    <strong class="text-danger">This action cannot be undone.</strong>
                </p>
            </div>

            <div class="modal-footer justify-content-center">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                    Cancel
                </button>

                <form id="deleteTenantForm" method="POST">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-outline-danger">
                        Yes, Delete
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="{{ asset('assets/plugins/jquery/jquery.min.js') }}"></script>
<script src="{{ asset('assets/js/custom.js') }}"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script>
    const deleteModal = document.getElementById('deleteTenantModal');

    deleteModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const tenantId = button.getAttribute('data-id');

        const form = document.getElementById('deleteTenantForm');

        form.action = "{{ route('tenants.destroy', ':id') }}".replace(':id', tenantId);
    });
</script>

<script>
    @if(session('success'))
    toastr.success("{{ session('success') }}");
    @endif

    @if(session('error'))
    toastr.error("{{ session('error') }}");
    @endif

    @if(session('warning'))
    toastr.warning("{{ session('warning') }}");
    @endif

    @if(session('info'))
    toastr.info("{{ session('info') }}");
    @endif
</script>

</body>
</html>
