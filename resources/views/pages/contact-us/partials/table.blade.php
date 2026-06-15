<div class="table-responsive">
    <table class="table" id="table">
        <thead>
        <tr>
            <th class="text-center" width="60"><input id="loopId" type="checkbox" class="form-check-input shadow-none" onclick="toggle(this)"></th>
            <th>Sender Info</th>
            <th>Contact</th>
            <th class="text-center">Status</th>
            <th>Message Content</th>
            <th class="text-center">Reply</th>
            <th class="text-center px-4">Actions</th>
        </tr>
        </thead>
        <tbody>
        @foreach($contacts as $contact)
            <tr>
                <td class="text-center fw-bold text-muted">
                    <div class="d-flex flex-column align-items-center">
                        <input type="checkbox" name="ids[]" value="{{ $contact->id }}" class="form-check-input mb-1 shadow-none">
                    </div>
                </td>
                <td>
                    <h6 class="mb-0 fw-bold text-dark">{{ $contact->name }}</h6>
                    <span class="text-muted small fw-medium">{{ $contact->email }}</span>
                </td>
                <td>
                    <span class="fw-bold" style="color: #4f46e5;"><i class="las la-phone me-1"></i>{{ $contact->phone }}</span>
                </td>
                <td class="text-center">
                    @if($contact->status == 'read')
                        <span class="badge" style="background-color: #f0fdf4 !important; color: #10b981 !important; border: 1px solid #10b98140 !important; padding: 8px 14px; border-radius: 10px; font-weight: 800; font-size: 11px;">READ</span>
                    @else
                        <span class="badge" style="background-color: #fef2f2 !important; color: #ef4444 !important; border: 1px solid #ef444440 !important; padding: 8px 14px; border-radius: 10px; font-weight: 800; font-size: 11px;">UNREAD</span>
                    @endif
                </td>
                <td>
                    <div class="text-muted" style="max-width: 250px; white-space: normal; line-height: 1.5; font-size: 0.9rem;">
                        {{ \Illuminate\Support\Str::limit($contact->message, 80) }}
                    </div>
                </td>
                <td class="text-center">
                    @if($contact->reply)
                        <span class="badge" style="background-color: #eff6ff !important; color: #3b82f6 !important; border: 1px solid #3b82f640 !important; padding: 8px 14px; border-radius: 10px; font-weight: 800; font-size: 11px;">Replied</span>
                    @else
                        <span class="text-muted small fw-bold">No Reply</span>
                    @endif
                </td>
                <td class="text-center px-4">
                    <div class="d-flex justify-content-center gap-2">
                        @if($contact->status !== 'read')
                            <a class="btn-action btn-reply-action reply-btn"
                               data-reply="{{ $contact->reply }}"
                               data-route="{{ route('contact-us.reply',$contact->id) }}"
                               data-bs-toggle="modal" href="#" data-bs-target="#replyModel" title="Reply">
                                <i class="las la-reply fs-18"></i>
                            </a>
                        @endif
                        <a class="btn-action btn-delete-action delete-btn"
                           data-route="{{ route('contact-us.destroy',$contact->id) }}"
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
