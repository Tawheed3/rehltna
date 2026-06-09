@php
    $tenantOptions = explode(',', getTenantInfo()?->options ?? '');
@endphp

<div class="app-sidebar__overlay" data-bs-toggle="sidebar"></div>
<aside class="app-sidebar sidebar-scroll" style="overflow-y: auto; max-height: 100vh;">

    <div class="app-sidebar__user clearfix">
        <div class="dropdown user-pro-body">
            <div class="">
                <img alt="user-img" class="avatar avatar-xl brround" src="{{ asset(getTenantInfo()->image) }}">
                <span class="avatar-status profile-status bg-green"></span>
            </div>
            <div class="user-info">
                <h4 class="fw-semibold mt-3 mb-0">{{ getTenantInfo()->name }}</h4>
                <span class="mb-0 text-muted">{{ auth()->user()->email }}</span>
            </div>
        </div>
    </div>

    <ul class="side-menu">

        @if(in_array('home', $tenantOptions))
            <li class="slide">
                <a class="side-menu__item" href="{{ route('dashboard') }}">
                    <i class="side-menu__icon fe fe-home me-2 mb-3"></i>
                    <span class="side-menu__label tx-15 bold">Home</span>
                </a>
            </li>
        @endif

        {{-- Blogs System --}}
        @if(in_array('blogs', $tenantOptions) && auth()->user()->hasPermission('manage_blogs'))
            <li class="slide">
                <a class="side-menu__item d-flex align-items-center justify-content-between" data-bs-toggle="slide"
                   href="#">
                    <div class="d-flex align-items-center">
                        <i class="side-menu__icon fe fe-file-text me-2 mb-3"></i>
                        <span class="side-menu__label tx-15 bold">Blogs System</span>
                    </div>
                    <i class="angle fe fe-chevron-down"></i>
                </a>
                <ul class="slide-menu">
                    <li><a class="slide-item" href="{{ route('categories.index') }}">Categories</a></li>
                    <li><a class="slide-item" href="{{ route('blogs.index') }}">Blogs</a></li>
                </ul>
            </li>
        @endif

        {{-- Trips System --}}
        @if(in_array('items', $tenantOptions) && auth()->user()->hasPermission('manage_trips'))
            <li class="slide">
                <a class="side-menu__item d-flex align-items-center justify-content-between" data-bs-toggle="slide"
                   href="#">
                    <div class="d-flex align-items-center">
                        <i class="side-menu__icon fe fe-layers me-2 mb-3"></i>
                        <span class="side-menu__label tx-15 bold">Trips System</span>
                    </div>
                    <i class="angle fe fe-chevron-down"></i>
                </a>
                <ul class="slide-menu">
                    @if(in_array('items', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('item-types.index') }}"><span>Categories</span></a>
                        </li>
                    @endif
                    @if(in_array('items', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('items.index') }}"><span>Trips</span></a></li>
                    @endif
                    @if(in_array('items', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('trip-documents.index') }}"><span>Trip Documents</span></a></li>
                    @endif
                    @if(in_array('items', $tenantOptions))
                        @php $pendingReviews = \App\Models\Review::where('status','pending')->count(); @endphp
                        <li>
                            <a class="slide-item" href="{{ route('reviews.index') }}">
                                <span>Reviews</span>
                                @if($pendingReviews > 0)
                                    <span style="display:inline-block;background:#ef4444;color:#fff;font-size:10px;font-weight:700;padding:1px 7px;border-radius:20px;margin-left:6px;line-height:1.6;">
                                        {{ $pendingReviews }}
                                    </span>
                                @endif
                            </a>
                        </li>
                    @endif
                </ul>
            </li>
        @endif

        {{-- Travel Tools --}}
        @if(in_array('items', $tenantOptions) && auth()->user()->hasPermission('manage_trips'))
            <li class="slide">
                <a class="side-menu__item" href="{{ route('travel-tools.index') }}">
                    <span class="side-menu__icon me-2 mb-3" style="font-size:18px">🕋</span>
                    <span class="side-menu__label tx-15 bold">أدوات السفر</span>
                </a>
            </li>
        @endif

        {{-- Location System --}}
        @if((in_array('countries', $tenantOptions) || in_array('states', $tenantOptions) || in_array('cities', $tenantOptions) || in_array('events_galleries', $tenantOptions)) && auth()->user()->hasPermission('manage_locations'))
            <li class="slide">
                <a class="side-menu__item d-flex align-items-center justify-content-between" data-bs-toggle="slide"
                   href="#">
                    <div class="d-flex align-items-center">
                        <i class="side-menu__icon fe fe-map me-2 mb-3"></i>
                        <span class="side-menu__label tx-15 bold">Location System</span>
                    </div>
                    <i class="angle fe fe-chevron-down"></i>
                </a>
                <ul class="slide-menu">
                    @if(in_array('countries', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('countries.index') }}">Countries</a></li>
                    @endif
                    @if(in_array('states', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('states.index') }}">States</a></li>
                    @endif
                    @if(in_array('cities', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('cities.index') }}">Cities</a></li>
                    @endif
                    @if(in_array('events_galleries', $tenantOptions))
                        <li><a class="slide-item"
                               href="{{ route('events-galleries.index') }}"><span>Tourist Attractions</span></a></li>
                    @endif
                </ul>
            </li>
        @endif

        {{-- Staff & Roles --}}
        @if((in_array('employees', $tenantOptions) || in_array('role_permissions', $tenantOptions)) && auth()->user()->hasPermission('manage_staff'))
            <li class="slide">
                <a class="side-menu__item d-flex align-items-center justify-content-between" data-bs-toggle="slide"
                   href="#">
                    <div class="d-flex align-items-center">
                        <i class="side-menu__icon fe fe-briefcase me-2 mb-3"></i>
                        <span class="side-menu__label tx-15 bold">Staff & Roles</span>
                    </div>
                    <i class="angle fe fe-chevron-down"></i>
                </a>
                <ul class="slide-menu">
                    @if(in_array('employees', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('employees.index') }}"><span>Employees</span></a></li>
                    @endif
                    @if(in_array('role_permissions', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('roles.index') }}"><span>Roles & Permissions</span></a>
                        </li>
                    @endif
                    @if(in_array('employees', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('etisalaty.index') }}"><span>Etisalaty Contacts</span></a></li>
                    @endif
                    <li><a class="slide-item" href="{{ route('activity-log.index') }}"><span>Activity Log</span></a></li>
                </ul>
            </li>
        @endif

        {{-- Customers --}}
        @php $showCustomers = auth()->user()->hasAnyPermission(['manage_customers','manage_contact_us','manage_subscribers']); @endphp
        @if($showCustomers && (in_array('residency_users', $tenantOptions) || in_array('register_users', $tenantOptions) || in_array('contact', $tenantOptions) || in_array('subscribes', $tenantOptions) || in_array('packages', $tenantOptions)))
            <li class="slide">
                <a class="side-menu__item d-flex align-items-center justify-content-between" data-bs-toggle="slide"
                   href="#">
                    <div class="d-flex align-items-center">
                        <i class="side-menu__icon fe fe-users me-2 mb-3"></i>
                        <span class="side-menu__label tx-15 bold">Customers</span>
                    </div>
                    <i class="angle fe fe-chevron-down"></i>
                </a>
                <ul class="slide-menu">
                    @if(in_array('packages', $tenantOptions) && auth()->user()->hasPermission('manage_customers'))
                        <li><a class="slide-item" href="{{ route('packages.index') }}"><span>Packages</span></a></li>
                    @endif
                    @if(in_array('residency_users', $tenantOptions) && auth()->user()->hasPermission('manage_customers'))
                        <li><a class="slide-item" href="{{ route('residency-users.index') }}"><span>Users</span></a></li>
                        <li><a class="slide-item" href="{{ route('point-logs.index') }}"><span>Points Logs</span></a></li>
                    @endif
                    @if(in_array('register_users', $tenantOptions) && auth()->user()->hasPermission('manage_customers'))
                        <li><a class="slide-item" href="{{ route('register-users.index') }}"><span>Register Users</span></a></li>
                    @endif
                    @if(in_array('contact', $tenantOptions) && auth()->user()->hasPermission('manage_contact_us'))
                        <li><a class="slide-item" href="{{ route('contact-us.index') }}"><span>Contact Us</span></a></li>
                    @endif
                    @if(in_array('subscribes', $tenantOptions) && auth()->user()->hasPermission('manage_subscribers'))
                        <li><a class="slide-item" href="{{ route('subscribes.index') }}"><span>Subscribes</span></a></li>
                    @endif
                </ul>
            </li>
        @endif

        {{-- Notifications --}}
        @if(in_array('notifications', $tenantOptions) && auth()->user()->hasPermission('manage_notifications'))
            <li class="slide">
                <a class="side-menu__item d-flex align-items-center justify-content-between" data-bs-toggle="slide"
                   href="#">
                    <div class="d-flex align-items-center">
                        <i class="side-menu__icon fe fe-navigation me-2 mb-3"></i>
                        <span class="side-menu__label tx-15 bold">Notifications</span>
                    </div>
                    <i class="angle fe fe-chevron-down"></i>
                </a>
                <ul class="slide-menu">
                    @if(in_array('notifications', $tenantOptions))
                        <li><a class="slide-item"
                               href="{{ route('notifications.index') }}"><span>Send Notifications</span></a>
                        </li>
                    @endif
                    @if(in_array('notification_templates', $tenantOptions))
                        <li><a class="slide-item"
                               href="{{ route('notification-templates.index') }}"><span>Templates</span></a>
                        </li>
                    @endif
                </ul>
            </li>
        @endif

        {{-- Payments --}}
        @php $showPayments = auth()->user()->hasAnyPermission(['manage_orders','manage_coupons','manage_payment_methods']); @endphp
        @if($showPayments && (in_array('payment_methods', $tenantOptions) || in_array('coupons', $tenantOptions) || in_array('orders', $tenantOptions) || in_array('payment_links', $tenantOptions)))
            <li class="slide">
                <a class="side-menu__item d-flex align-items-center justify-content-between" data-bs-toggle="slide"
                   href="#">
                    <div class="d-flex align-items-center">
                        <i class="side-menu__icon fe fe-credit-card me-2 mb-3"></i>
                        <span class="side-menu__label tx-15 bold">Payments</span>
                    </div>
                    <i class="angle fe fe-chevron-down"></i>
                </a>
                <ul class="slide-menu">
                    @if(in_array('payment_methods', $tenantOptions) && auth()->user()->hasPermission('manage_payment_methods'))
                        <li><a class="slide-item" href="{{ route('payment-methods.index') }}"><span>Payment Methods</span></a></li>
                        <li><a class="slide-item" href="{{ route('payment-links.index') }}"><span>Payment Links</span></a></li>
                    @endif
                    @if(in_array('coupons', $tenantOptions) && auth()->user()->hasPermission('manage_coupons'))
                        <li><a class="slide-item" href="{{ route('coupons.index') }}"><span>Coupons</span></a></li>
                    @endif
                    @if(in_array('orders', $tenantOptions) && auth()->user()->hasPermission('manage_orders'))
                        @php $reviewingCount = \App\Models\Order::where('payment_status','reviewing')->count(); @endphp
                        <li>
                            <a class="slide-item" href="{{ route('orders.index') }}">
                                <span>Orders</span>
                                @if($reviewingCount > 0)
                                    <span style="display:inline-block;background:#ef4444;color:#fff;font-size:10px;font-weight:700;padding:1px 7px;border-radius:20px;margin-left:6px;line-height:1.6;">
                                        {{ $reviewingCount }}
                                    </span>
                                @endif
                            </a>
                        </li>
                    @endif
                </ul>
            </li>
        @endif

        {{-- Website --}}
        @php $showWebsite = auth()->user()->hasAnyPermission(['manage_sliders','manage_testimonials','manage_custom_pages']); @endphp
        @if($showWebsite && (in_array('sliders', $tenantOptions) || in_array('members', $tenantOptions) || in_array('testimonials', $tenantOptions) || in_array('custom_pages', $tenantOptions)))
            <li class="slide">
                <a class="side-menu__item d-flex align-items-center justify-content-between" data-bs-toggle="slide"
                   href="#">
                    <div class="d-flex align-items-center">
                        <i class="side-menu__icon fe fe-layout me-2 mb-3"></i>
                        <span class="side-menu__label tx-15 bold">Website</span>
                    </div>
                    <i class="angle fe fe-chevron-down"></i>
                </a>
                <ul class="slide-menu">
                    @if(in_array('sliders', $tenantOptions) && auth()->user()->hasPermission('manage_sliders'))
                        <li><a class="slide-item" href="{{ route('sliders.index') }}"><span>Sliders</span></a></li>
                    @endif
                    @if(in_array('members', $tenantOptions) && auth()->user()->hasPermission('manage_sliders'))
                        <li><a class="slide-item" href="{{ route('members.index') }}"><span>Members</span></a></li>
                    @endif
                    @if(in_array('testimonials', $tenantOptions) && auth()->user()->hasPermission('manage_testimonials'))
                        <li><a class="slide-item" href="{{ route('testimonials.index') }}"><span>Testimonials</span></a></li>
                    @endif
                    @if(in_array('custom_pages', $tenantOptions) && auth()->user()->hasPermission('manage_custom_pages'))
                        <li><a class="slide-item" href="{{ route('custom-pages.index') }}"><span>Custom Pages</span></a></li>
                    @endif
                </ul>
            </li>
        @endif

        {{-- Settings --}}
        @if((in_array('settings', $tenantOptions) || in_array('social_integration', $tenantOptions) || in_array('ai_settings', $tenantOptions) || in_array('sitemaps', $tenantOptions) || in_array('failed_jobs', $tenantOptions) || in_array('images_uploader', $tenantOptions)) && auth()->user()->hasPermission('manage_settings'))
            <li class="slide">
                <a class="side-menu__item d-flex align-items-center justify-content-between" data-bs-toggle="slide"
                   href="#">
                    <div class="d-flex align-items-center">
                        <i class="side-menu__icon fe fe-settings me-2 mb-3"></i>
                        <span class="side-menu__label tx-15 bold">Settings</span>
                    </div>
                    <i class="angle fe fe-chevron-down"></i>
                </a>
                <ul class="slide-menu">
                    @if(in_array('settings', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('get.settings') }}"><span>Settings</span></a></li>
                    @endif
                    @if(in_array('images_uploader', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('gallery.index') }}"><span>Images Uploader</span></a>
                        </li>
                    @endif
                    @if(in_array('social_integration', $tenantOptions))
                        <li><a class="slide-item"
                               href="{{ route('social.integration') }}"><span>Social Integration</span></a></li>
                    @endif
                    @if(in_array('ai_settings', $tenantOptions))
                        <li><a class="slide-item"
                               href="{{ route('ai-integration.index') }}"><span>AI Settings</span></a></li>
                    @endif
                    @if(in_array('sitemaps', $tenantOptions))
                        <li><a class="slide-item" href="{{ route('sitemaps.index') }}"><span>SiteMaps</span></a></li>
                    @endif
                    @if(in_array('failed_jobs', $tenantOptions) && checkIfAdmin())
                        <li><a class="slide-item" href="{{ route('blogs.failed.jobs') }}"><span>Failed Jobs</span></a>
                        </li>
                    @endif
                </ul>
            </li>
        @endif

    </ul>
</aside>
{{-- Leads System --}}
@if(in_array('leads', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item d-flex align-items-center justify-content-between" data-bs-toggle="slide"
           href="#">
            <div class="d-flex align-items-center">
                <i class="side-menu__icon fe fe-target me-2 mb-3"></i>
                <span class="side-menu__label tx-15 bold">Leads System</span>
            </div>
            <i class="angle fe fe-chevron-down"></i>
        </a>
        <ul class="slide-menu">
            <li><a class="slide-item" href="{{ route('lead-magnet-types.index') }}">Lead Magnet Types</a></li>
            <li><a class="slide-item" href="{{ route('lead-magnets.index') }}">Lead Magnets</a></li>
            <li><a class="slide-item" href="{{ route('leads.index') }}">Leads</a></li>
        </ul>
    </li>
@endif
@if(in_array('offers', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item" data-bs-toggle="slide" href="#">
            <span class="side-menu__label tx-15 bold">Offers System</span>
            <i class="angle fe fe-chevron-down"></i>
        </a>
        <ul class="slide-menu">
            <li><a class="slide-item" href="{{ route('type-offers.index') }}">Types</a></li>
            <li><a class="slide-item" href="{{ route('offers.index') }}">Offers</a></li>
        </ul>
    </li>
@endif
@if(in_array('jobs', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item" data-bs-toggle="slide" href="#">
            <span class="side-menu__label">Jobs System</span>
            <i class="angle fe fe-chevron-down"></i>
        </a>
        <ul class="slide-menu">
            <li><a class="slide-item" href="{{ route('career-types.index') }}">Types</a></li>
            <li><a class="slide-item" href="{{ route('careers.index') }}">Careers</a></li>
            <li><a class="slide-item" href="{{ route('apply-jobs.index') }}">Applications</a></li>
        </ul>
    </li>
@endif
@if(in_array('portfolios', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item" data-bs-toggle="slide" href="#">
            <span class="side-menu__label">Portfolios System</span>
            <i class="angle fe fe-chevron-down"></i>
        </a>
        <ul class="slide-menu">
            <li><a class="slide-item" href="{{ route('portfolio-categories.index') }}">Categories</a></li>
            <li><a class="slide-item" href="{{ route('portfolios.index') }}">Portfolios</a></li>
        </ul>
    </li>
@endif
@if(in_array('events', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item" href="{{ route('events.index') }}">
            <span class="side-menu__label tx-15 bold">Events</span></a>
    </li>
@endif
@if(in_array('news', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item" href="{{ route('news.index') }}">
            <span class="side-menu__label tx-15 bold">News</span>
        </a>
    </li>
@endif
@if(in_array('disease_types', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item" href="{{ route('disease-types.index') }}">
            <span class="side-menu__label tx-15 bold">Disease Types</span>
        </a>
    </li>
@endif
@if(in_array('patients', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item" href="{{ route('patients.index') }}">
            <span class="side-menu__label tx-15 bold">Patients Educations</span>
        </a>
    </li>
@endif
@if(in_array('residencies', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item" href="{{ route('residencies.index') }}">
            <span class="side-menu__label tx-15 bold">Residencies Programs</span>
        </a>
    </li>
@endif
@if(in_array('protocols', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item" href="{{ route('protocols.index') }}">
            <span class="side-menu__label tx-15 bold">Protocols</span>
        </a>
    </li>
@endif
@if(in_array('clinical_publications', $tenantOptions))
    <li class="slide">
        <a class="side-menu__item" href="{{ route('clinical-publications.index') }}">
            <span class="side-menu__label tx-15 bold">Clinical Publications</span>
        </a>
    </li>
@endif
