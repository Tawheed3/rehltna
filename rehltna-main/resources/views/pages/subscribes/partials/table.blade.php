<div class="table-responsive">
    <table class="table" id="table">
        <thead>
        <tr>
            <th class="text-center" width="60"><input id="loopId" type="checkbox" class="form-check-input shadow-none"
                                                      onclick="toggle(this)"></th>
            <th>Subscriber Email</th>
            <th>Joined Date</th>
            <th class="text-center px-4">Actions</th>
        </tr>
        </thead>
        <tbody>
        @foreach($subscribes as $subscribe)
            <tr>
                <td class="text-center">
                    <div class="d-flex flex-column align-items-center">
                        <input type="checkbox" name="ids[]" value="{{ $subscribe->id }}"
                               class="form-check-input mb-1 shadow-none">
                    </div>
                </td>
                <td>
                    <div class="d-flex align-items-center gap-3">
                        <div class="d-flex align-items-center justify-content-center"
                             style="width: 40px;
                                height: 40px;
                                background-color: #f5f3ff !important;
                                border-radius: 12px;
                                border: 1px solid #4f46e530;">
                            <i class="las la-envelope" style="color: #4f46e5 !important; font-size: 1.3rem;"></i>
                        </div>
                        <span class="fw-bold text-dark" style="font-size: 0.95rem;">{{ $subscribe->email }}</span>
                    </div>
                </td>
                <td>
                    <span class="text-muted small fw-bold"><i class="far fa-calendar-alt me-1"></i>{{ $subscribe->created_at->format('Y-m-d') }}</span>
                </td>
                <td class="text-center px-4">
                    <div class="d-flex justify-content-center">
                        <a class="btn-action btn-delete-action delete-btn shadow-sm"
                           data-route="{{ route('subscribes.destroy',$subscribe->id) }}"
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
