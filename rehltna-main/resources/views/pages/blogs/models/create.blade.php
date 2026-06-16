<style>
    /* Deluxe AI Generation Modal Styling */
    .modal-ai-gen-deluxe {
        border: none;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(99, 102, 241, 0.2);
    }

    .modal-ai-gen-deluxe .modal-header {
        background: #f8faff;
        border-bottom: 1px solid #eef2ff;
        padding: 25px 30px;
    }

    .modal-ai-gen-deluxe .modal-title {
        font-weight: 800;
        color: #1e1b4b;
        letter-spacing: -0.5px;
    }

    /* Input & Select Perfection */
    .modal-ai-gen-deluxe .form-control,
    .modal-ai-gen-deluxe .form-select {
        border-radius: 14px;
        padding: 12px 18px !important;
        border: 2px solid #f1f5f9;
        background: #f8fafc;
        transition: all 0.3s ease;
        font-weight: 600;
        color: #1e293b;
        line-height: 1.6 !important;
        height: auto !important;
        vertical-align: middle !important;
    }

    .modal-ai-gen-deluxe .form-control:focus,
    .modal-ai-gen-deluxe .form-select:focus {
        border-color: #6366f1;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
        outline: none;
    }

    /* Fix for Select dropdown arrow and text clipping */
    .modal-ai-gen-deluxe select.form-control {
        appearance: auto !important;
        background-image: none !important;
    }

    .modal-ai-gen-deluxe .modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 20px 30px 30px;
        gap: 12px;
    }

    /* Magic Generate Button */
    .btn-generate-ai {
        background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%) !important;
        color: white !important;
        border: none !important;
        border-radius: 14px !important;
        padding: 12px 35px !important;
        font-weight: 700 !important;
        transition: all 0.4s ease !important;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .btn-generate-ai:hover {
        transform: translateY(-3px) scale(1.02);
        box-shadow: 0 12px 25px rgba(168, 85, 247, 0.3);
    }

    .btn-generate-ai i {
        animation: spark 1.5s infinite;
    }

    @keyframes spark {
        0%, 100% {
            opacity: 1;
            transform: scale(1);
        }
        50% {
            opacity: 0.7;
            transform: scale(1.2);
        }
    }
</style>

<div class="modal fade" id="AIBlogsCreate" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-ai-gen-deluxe">
            <form action="{{ route('create.blogs.with.ai') }}" method="POST" id="generate-ai-blogs-form">
                @csrf
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div
                            style="background: rgba(99, 102, 241, 0.12); padding: 12px; border-radius: 14px; margin-right: 15px; display: flex; align-items: center; justify-content: center;">
                            <i class="las la-magic" style="color: #6366f1; font-size: 1.6rem;"></i>
                        </div>
                        <h5 class="modal-title mb-0">AI Content Generator</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold text-muted small text-uppercase">Topic / Keyphrase</label>
                        <input type="text" name="title" id="title" class="form-control"
                               placeholder="e.g. Benefits of Laravel for E-commerce" autofocus required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold text-muted small text-uppercase">Articles Count</label>
                            <select name="count" class="form-control" required>
                                <option selected disabled>-- Qty --</option>
                                @for($i=1; $i<= 10 ; $i++)
                                    <option value="{{ $i }}">{{ $i }} Article{{ $i > 1 ? 's' : '' }}</option>
                                @endfor
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold text-muted small text-uppercase">Target Category</label>
                            <select name="category_id" class="form-control" required>
                                <option selected disabled>-- Select --</option>
                                @foreach($categories as $category)
                                    <option value="{{ $category->id }}">
                                        {{ transDB($category, 'name') }}
                                    </option>
                                @endforeach
                            </select>
                        </div>
                    </div>

                    <div class="mb-0">
                        <label class="form-label fw-bold text-muted small text-uppercase">Engine Model</label>
                        <select name="ai_model_id" class="form-control" required>
                            <option selected disabled>-- Choose Brain --</option>
                            @foreach($ais as $ai)
                                <option value="{{ $ai->id }}">{{ $ai->name }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold"
                            style="background: #f1f5f9; color: #64748b; border: none; border-radius: 14px; padding: 12px 25px;"
                            data-bs-dismiss="modal">Discard
                    </button>
                    <button type="submit" id="generate-ai-blogs-btn" class="btn btn-generate-ai shadow-sm">
                        <i class="las la-wand-magic me-2"></i> Start Generation
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
