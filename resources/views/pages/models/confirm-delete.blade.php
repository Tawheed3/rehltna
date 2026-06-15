<style>
    /* Deluxe Delete Modal Styling */
    .modal-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.2);
    }

    .modal-deluxe .modal-header {
        border-bottom: none;
        padding: 25px 30px 10px;
    }

    .modal-deluxe .modal-body {
        padding: 10px 40px 30px;
    }

    .modal-deluxe .modal-footer {
        border-top: none;
        padding: 0 40px 40px;
        gap: 12px;
    }

    /* Warning Animation Icon */
    .delete-icon-wrapper {
        width: 80px;
        height: 80px;
        background: #fef2f2;
        color: #ef4444;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2.5rem;
        margin: 0 auto 20px;
        animation: pulse-red 2s infinite;
    }

    @keyframes pulse-red {
        0% {
            transform: scale(0.95);
            box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.4);
        }
        70% {
            transform: scale(1);
            box-shadow: 0 0 0 15px rgba(239, 68, 68, 0);
        }
        100% {
            transform: scale(0.95);
            box-shadow: 0 0 0 0 rgba(239, 68, 68, 0);
        }
    }

    .btn-confirm-delete {
        background-color: #ef4444 !important;
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 25px !important;
        font-weight: 700 !important;
        transition: all 0.3s ease !important;
    }

    .btn-confirm-delete:hover {
        background-color: #dc2626 !important;
        transform: translateY(-2px);
        box-shadow: 0 8px 15px rgba(239, 68, 68, 0.25);
    }

    .btn-cancel-delete {
        background-color: #f1f5f9 !important;
        color: #475569 !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 25px !important;
        font-weight: 700 !important;
    }
</style>

<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-deluxe">
            <div class="modal-header">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body text-center">
                <div class="delete-icon-wrapper">
                    <i class="las la-exclamation-circle"></i>
                </div>

                <h3 class="fw-bold text-dark mb-2" style="letter-spacing: -0.5px;">Are you sure?</h3>
                <p class="text-muted px-3">
                    You are about to delete this item permanently. <br>
                    <span class="text-danger fw-bold">This action cannot be undone.</span>
                </p>
            </div>

            <div class="modal-footer justify-content-center">
                <button type="button" class="btn btn-cancel-delete px-4" data-bs-dismiss="modal">
                    No, Keep it
                </button>

                <form method="POST" id="deleteForm" class="m-0">
                    @csrf
                    @method('DELETE')
                    {{ method_field('DELETE') }}
                    {{ csrf_field() }}
                    <button type="submit" class="btn btn-confirm-delete px-4 shadow-sm">
                        Yes, Delete Now
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
