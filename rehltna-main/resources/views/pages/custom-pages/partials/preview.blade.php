<style>
    .preview-card {
        background: #f9f9f9;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
    }

    .preview-title {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 10px;
        color: #333;
    }

    .preview-content {
        font-size: 15px;
        color: #555;
        line-height: 1.7;
    }

    .preview-label {
        font-size: 14px;
        font-weight: bold;
        color: #6c757d;
        margin-bottom: 10px;
        text-transform: uppercase;
        letter-spacing: 1px;
    }
</style>

<div class="row">
    @foreach(get_active_langs() as $lang)
        <div class="{{ colClass() }}">
            <div class="preview-card {{ $lang == 'ar' ? 'text-end' : '' }}" {{ $lang == 'ar' ? 'dir=rtl' : '' }}>
                <div class="preview-label">{{ strtoupper($lang) }} Content</div>
                <div class="preview-title">{{ $page->{'title_'.$lang} }}</div>
                <div class="preview-content">{!! $page->{'content_'.$lang} !!}</div>
            </div>
        </div>
    @endforeach
</div>
