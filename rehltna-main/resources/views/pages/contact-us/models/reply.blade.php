<style>
    /* Deluxe Contact Reply Modal Styling */
    .modal-contact-reply-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(79, 70, 229, 0.2);
    }

    .modal-contact-reply-deluxe .modal-header {
        background: #f5f3ff;
        border-bottom: 1px solid #ddd6fe;
        padding: 25px 30px;
    }

    .modal-contact-reply-deluxe .modal-title {
        font-weight: 800;
        color: #4338ca;
        letter-spacing: -0.5px;
    }

    /* Textarea Fix - No Text Clipping */
    .modal-contact-reply-deluxe .form-control {
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

    .modal-contact-reply-deluxe .form-control:focus {
        border-color: #4f46e5;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        outline: none;
    }

    /* Send Button Deluxe */
    .btn-send-contact {
        background: #4f46e5 !important;
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 35px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-send-contact:hover {
        background: #4338ca !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(79, 70, 229, 0.2);
    }
</style>

<div class="modal fade" id="replyModel" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-contact-reply-deluxe">
            <form method="POST" id="replyForm">
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div
                            style="background: rgba(79, 70, 229, 0.12); padding: 12px; border-radius: 14px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-envelope-open-text" style="color: #4f46e5; font-size: 1.6rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0">Reply to Inquiry</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="mb-0">
                        <label for="reply-input" class="form-label fw-bold text-muted small text-uppercase mb-2">Message
                            Body</label>
                        <textarea name="reply" id="reply-input" class="form-control shadow-sm"
                                  rows="4" placeholder="Write your response here..." required></textarea>
                    </div>
                    <div class="mt-3 p-3 rounded-3 bg-light border border-dashed text-center">
                        <p class="small text-muted mb-0">
                            <i class="las la-shield-alt me-1"></i> This response will be officially recorded in the
                            contact center log.
                        </p>
                    </div>
                </div>

                <div class="modal-footer border-0 p-4 pt-0">
                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold"
                            style="background: #f1f5f9; color: #64748b; border: none; border-radius: 14px; padding: 12px 25px;"
                            data-bs-dismiss="modal">Discard
                    </button>
                    <button type="submit" class="btn btn-send-contact shadow-sm">
                        <i class="las la-paper-plane me-2"></i> Send Reply
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
