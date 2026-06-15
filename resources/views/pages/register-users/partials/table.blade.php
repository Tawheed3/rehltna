<div class="table-responsive">
    <table class="table" id="table">
        <thead>
        <tr>
            <th class="text-center" width="60">
                <input id="loopId" type="checkbox" class="form-check-input shadow-none" onclick="toggle(this)">
            </th>
            <th>Applicant Info</th>
            <th>Contact Details</th>
            <th>Location</th>
            <th>Target Item</th>
            <th class="text-center">Admin Reply</th>
            <th class="text-center px-4">Actions</th>
        </tr>
        </thead>
        <tbody>
        @foreach($registerUsers as $registerUser)
            <tr>
                <td class="text-center">
                    <div class="d-flex flex-column align-items-center">
                        <input type="checkbox" name="ids[]" value="{{ $registerUser->id }}"
                               class="form-check-input mb-1 shadow-none">
                    </div>
                </td>
                <td>
                    <h6 class="mb-0 fw-bold text-dark">{{ $registerUser->name }}</h6>
                    <span class="text-muted small fw-medium">{{ $registerUser->email }}</span>
                </td>
                <td>
                    <div class="fw-bold" style="color: #4f46e5;"><i
                            class="las la-phone me-1"></i>{{ $registerUser->phone }}</div>
                    <small class="text-info fw-bold">{{ $registerUser->specialty }}</small>
                </td>
                <td>
                    <span class="badge"
                          style="background: #f8fafc; color: #64748b; border: 1px solid #e2e8f0; padding: 6px 12px; border-radius: 8px;">
                        <i class="las la-globe me-1"></i>{{ $registerUser->country }}
                    </span>
                </td>
                <td>
                    <span class="badge"
                          style="background-color: #f5f3ff !important;
                 color: #4f46e5 !important;
                 border: 1px solid #4f46e540 !important;
                 padding: 8px 14px;
                 border-radius: 10px;
                 font-weight: 800;
                 font-size: 11px;
                 display: inline-block;
                 white-space: nowrap;">
                        <i class="las la-tag me-1"></i> {{ $registerUser->item->title_en }}
                    </span>
                </td>
                <td class="text-center">
                    @if($registerUser->reply)
                        <div class="reply-badge" title="{{ $registerUser->reply }}">
                            {{ \Illuminate\Support\Str::limit($registerUser->reply, 20) }}
                        </div>
                    @else
                        <span class="text-muted opacity-50">-</span>
                    @endif
                </td>
                <td class="text-center px-4">
                    <div class="d-flex justify-content-center gap-2">
                        {{-- Create Link --}}
                        <button type="button" class="btn-action btn-link-action create-link-btn"
                                data-url="{{ route('payment-links.storeFromRegister', $registerUser->id) }}"
                                title="Create Payment Link">
                            <i class="las la-link fs-18"></i>
                        </button>
                        {{-- Reply --}}
                        <a class="btn-action btn-reply-action reply-btn"
                           data-reply="{{ $registerUser->reply }}"
                           data-route="{{ route('register-users.reply',$registerUser->id) }}"
                           data-bs-toggle="modal" href="#" data-bs-target="#replyModel" title="Reply">
                            <i class="las la-reply fs-18"></i>
                        </a>
                        {{-- Delete --}}
                        <a class="btn-action btn-delete-action delete-btn"
                           data-route="{{ route('register-users.destroy',$registerUser->id) }}"
                           data-bs-toggle="modal" href="#" data-bs-target="#deleteModal" title="Delete">
                            <i class="las la-trash fs-18"></i>
                        </a>
                    </div>
                </td>
            </tr>
        @endforeach
        </tbody>
    </table>
</div>
