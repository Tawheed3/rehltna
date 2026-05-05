<div class="table-responsive">
    <table class="table" id="table">
        <thead>
        <tr>
            <th class="text-center" width="60">
                <input id="loopId" type="checkbox" class="form-check-input" onclick="toggle(this)">
            </th>
            <th>Name & Details</th>
            <th>Contact & Package</th>
            <th class="text-center">Trips</th>
            <th class="text-center">Orders</th>
            <th class="text-center">Points</th>
            <th class="text-center px-4">Actions</th>
        </tr>
        </thead>
        <tbody>
        @foreach($residencyUsers as $residencyUser)
            <tr>
                <td class="text-center fw-bold">
                    <div class="d-flex flex-column align-items-center">
                        <input type="checkbox" name="ids[]" value="{{ $residencyUser->id }}"
                               class="form-check-input mb-1">
                    </div>
                </td>
                <td>
                    <h6 class="mb-0 fw-bold text-dark">{{ $residencyUser->name }}</h6>
                    <span class="text-muted small fw-medium">{{ $residencyUser->email }}</span>
                </td>
                <td>
                    <span class="fw-bold d-block mb-1" style="color: #4f46e5;"><i class="las la-phone me-1"></i>{{ $residencyUser->phone }}</span>
                    @if($residencyUser->package)
                        <span class="badge bg-light text-dark border"><i
                                class="{{ $residencyUser->package->icon }} text-warning me-1"></i> {{ $residencyUser->package->name_en }}</span>
                    @else
                        <span class="badge bg-light text-muted border">No Package</span>
                    @endif
                </td>
                <td class="text-center">
                    <span class="count-badge" style="background: #f0fdf4; color: #10b981; border-color: #10b98130;">
                        {{ $residencyUser->items_count ?? 0 }}
                    </span>
                </td>
                <td class="text-center">
                    <span class="count-badge">
                        {{ $residencyUser->orders_count ?? 0 }}
                    </span>
                </td>
                <td class="text-center">
                    <span class="fw-bold d-block" style="color: #f59e0b; font-size: 13px;">
                        <i class="las la-star me-1"></i>{{ number_format($residencyUser->available_points, 0) }}
                    </span>
                    <span class="text-muted" style="font-size: 11px;">available</span>
                </td>
                <td class="text-center px-4">
                    <div class="d-flex justify-content-center gap-2">
                        <button type="button" class="btn-action shadow-sm edit-points-btn"
                                style="color: #f59e0b;"
                                data-bs-toggle="modal"
                                data-bs-target="#editPointsModal"
                                data-userid="{{ $residencyUser->id }}"
                                data-username="{{ $residencyUser->name }}"
                                data-points="{{ $residencyUser->available_points }}"
                                data-earned="{{ $residencyUser->earned_points }}">
                            <i class="las la-star fs-18"></i>
                        </button>
                        <button type="button" class="btn-action shadow-sm edit-pkg-btn"
                                style="color: #10b981;"
                                data-bs-toggle="modal"
                                data-bs-target="#changePackageModal"
                                data-userid="{{ $residencyUser->id }}"
                                data-username="{{ $residencyUser->name }}"
                                data-pkgid="{{ $residencyUser->package_id }}">
                            <i class="las la-exchange-alt fs-18"></i>
                        </button>

                        <a class="btn-action btn-delete-action delete-btn shadow-sm"
                           data-route="{{ route('residency-users.destroy',$residencyUser->id) }}"
                           data-bs-toggle="modal" href="#" data-bs-target="#deleteModal">
                            <i class="las la-trash fs-18"></i>
                        </a>
                    </div>
                </td>
            </tr>
        @endforeach
        </tbody>
    </table>
</div>
