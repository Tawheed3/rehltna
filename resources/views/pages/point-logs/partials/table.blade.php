<div class="table-responsive">
    <table class="table">
        <thead>
        <tr>
            <th>Customer</th>
            <th>Contact</th>
            <th class="text-center">Available Points</th>
            <th class="text-center">Total Logs</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        @forelse($users as $user)
        <tr>
            <td>
                <h6 class="mb-0 fw-bold text-dark">{{ $user->name }}</h6>
                <span class="text-muted small">{{ $user->email }}</span>
            </td>
            <td>
                <span class="fw-bold" style="color:#4f46e5;">
                    <i class="las la-phone me-1"></i>{{ $user->phone }}
                </span>
            </td>
            <td class="text-center">
                <span class="points-badge">
                    <i class="las la-star me-1"></i>{{ number_format($user->available_points, 0) }}
                </span>
            </td>
            <td class="text-center">
                <span class="badge bg-light text-dark border fw-bold">
                    {{ $user->point_logs_count }}
                </span>
            </td>
            <td class="text-center">
                <div class="d-flex justify-content-center gap-2">
                    <a href="{{ route('point-logs.view-pdf', $user->id) }}" target="_blank"
                       class="btn-action btn-view shadow-sm" title="View PDF">
                        <i class="las la-eye fs-18"></i>
                    </a>
                    <a href="{{ route('point-logs.pdf', $user->id) }}"
                       class="btn-action btn-dl shadow-sm" title="Download PDF">
                        <i class="las la-download fs-18"></i>
                    </a>
                </div>
            </td>
        </tr>
        @empty
        <tr>
            <td colspan="5" class="text-center text-muted py-5 fw-bold">No users found.</td>
        </tr>
        @endforelse
        </tbody>
    </table>
</div>
