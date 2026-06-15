<style>
    /* Deluxe Reply Modal Styling */
    .modal-reply-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(20, 184, 166, 0.2);
    }

    .modal-reply-deluxe .modal-header {
        background: #f0fdfa;
        border-bottom: 1px solid #ccfbf1;
        padding: 25px 30px;
    }

    .modal-reply-deluxe .modal-title {
        font-weight: 800;
        color: #0f766e;
        letter-spacing: -0.5px;
    }

    /* Textarea Perfection - No Clipping */
    .modal-reply-deluxe .form-control {
        border-radius: 16px;
        padding: 15px 20px !important;
        border: 2px solid #f1f5f9;
        background: #f8fafc;
        transition: all 0.3s ease;
        font-weight: 600;
        color: #1e293b;
        line-height: 1.6 !important;
        resize: none;
    }

    .modal-reply-deluxe .form-control:focus {
        border-color: #14b8a6;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(20, 184, 166, 0.1);
        outline: none;
    }

    .btn-send-reply {
        background: #14b8a6 !important;
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 35px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-send-reply:hover {
        background: #0d9488 !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(20, 184, 166, 0.2);
    }
</style>

<div class="modal fade" id="replyModel" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-reply-deluxe">
            <form method="POST" id="replyForm">
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div
                            style="background: rgba(20, 184, 166, 0.12); padding: 12px; border-radius: 14px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-comment-dots" style="color: #14b8a6; font-size: 1.6rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0">Write a Reply</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="mb-0">
                        <label for="reply-input" class="form-label fw-bold text-muted small text-uppercase mb-2">Message
                            Content</label>
                        <textarea name="reply" id="reply-input" class="form-control shadow-sm"
                                  rows="4" placeholder="Type your message to the applicant here..." required></textarea>
                    </div>
                    <div class="mt-3 p-3 rounded-3 bg-light border border-dashed">
                        <p class="small text-muted mb-0">
                            <i class="las la-info-circle me-1"></i> This message will be saved and displayed to the user
                            in their record.
                        </p>
                    </div>
                </div>

                <div class="modal-footer border-0 p-4 pt-0">
                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold"
                            style="background: #f1f5f9; color: #64748b; border: none; border-radius: 14px; padding: 12px 25px;"
                            data-bs-dismiss="modal">Discard
                    </button>
                    <button type="submit" class="btn btn-send-reply shadow-sm">
                        <i class="las la-paper-plane me-2"></i> Send Message
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
