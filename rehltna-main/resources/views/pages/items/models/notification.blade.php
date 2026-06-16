{{-- Notification Modal --}}
<div class="modal fade" id="notificationModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg"> <div class="modal-content border-0 shadow" style="border-radius: 20px;">
            <div class="modal-header border-bottom-0 bg-light" style="border-radius: 20px 20px 0 0;">
                <h5 class="modal-title fw-bold text-dark">
                    <i class="las la-bell text-warning me-2"></i> Send Notification
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <p class="text-muted mb-4">Select a template to send for: <strong id="notify_item_title" class="text-primary"></strong></p>

                <input type="hidden" id="notify_item_id">
                <input type="hidden" id="selected_template_id">

                <div class="template-list-container pe-2" style="max-height: 400px; overflow-y: auto;">
                    @if(isset($templates) && $templates->count() > 0)
                        @foreach($templates as $template)
                            <div class="template-card mb-3 p-3 border rounded cursor-pointer" data-id="{{ $template->id }}">
                                <div class="original-title d-none">{{ $template->title }}</div>
                                <div class="original-body d-none">{{ $template->body }}</div>

                                <h6 class="template-display-title fw-bold text-dark mb-2"></h6>
                                <p class="template-display-body text-muted small mb-0"></p>
                            </div>
                        @endforeach
                    @else
                        <div class="text-center text-muted p-4">
                            <i class="las la-inbox fs-1 mb-2"></i>
                            <p>No templates available.</p>
                        </div>
                    @endif
                </div>
            </div>
            <div class="modal-footer border-top-0 pt-0 pb-4 px-4">
                <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-warning rounded-pill px-4 fw-bold text-dark" id="sendNotificationBtn" disabled>
                    <i class="fas fa-paper-plane me-1"></i> Send Now
                </button>
            </div>
        </div>
    </div>
</div>
