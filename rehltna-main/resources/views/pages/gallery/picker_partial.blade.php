<style>
    /* Toolbar Styles */
    .picker-toolbar { background: #fff; padding: 10px 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 100; }
    .picker-actions .btn { font-size: 12px; font-weight: 600; }

    /* Upload & Create Sections */
    .action-section { background: #f8f9fa; padding: 15px; border-bottom: 1px solid #eee; display: none; }
    .action-section.active { display: block; animation: slideDown 0.2s ease-out; }
    @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

    /* Existing Grid Styles */
    .gallery-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(110px, 1fr)); gap: 12px; padding: 15px; }
    .gallery-item { position: relative; background: #fff; border-radius: 8px; overflow: hidden; border: 1px solid #eef0f3; transition: all 0.2s; cursor: pointer; }
    .gallery-item:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.08); border-color: #0d6efd; }
    .gallery-item.selected { border: 2px solid #198754; background-color: #f0fff4; }
    .gallery-item.selected::after { content: '\f00c'; font-family: "Font Awesome 5 Free"; font-weight: 900; position: absolute; top: 5px; right: 5px; background: #198754; color: white; width: 20px; height: 20px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 10px; z-index: 10; }

    .gallery-preview { height: 90px; width: 100%; display: flex; align-items: center; justify-content: center; background: #f8f9fb; overflow: hidden; }
    .gallery-preview img, .gallery-preview video { width: 100%; height: 100%; object-fit: cover; }
    .gallery-name { padding: 6px; font-size: 10px; color: #555; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-align: center; border-top: 1px solid #f0f0f0; }
    .folder-icon { font-size: 2.5rem; color: #ffca28; }
    .back-folder { background: #eef2f7; border: 2px dashed #cbd5e1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #64748b; }

    .gallery-pagination { padding: 10px; display: flex; justify-content: center; }
    .gallery-pagination .page-link { font-size: 12px; padding: 5px 10px; }
</style>

<div class="picker-toolbar">
    <div class="d-flex align-items-center">
        @if(isset($currentFolder))
            <button class="btn btn-light btn-sm me-2 border" onclick="loadPicker('root')" title="Back to Home"><i class="fas fa-arrow-left"></i></button>
            <span class="fw-bold text-dark"><i class="fas fa-folder-open text-warning me-1"></i> {{ $currentFolder->name }}</span>
        @else
            <span class="fw-bold text-dark"><i class="fas fa-home text-primary me-1"></i> Home</span>
        @endif
    </div>
    <div class="picker-actions">
        @if(!isset($currentFolder))
            <button class="btn btn-outline-success btn-sm me-1" onclick="$('#create-folder-section').toggleClass('active'); $('#upload-section').removeClass('active');">
                <i class="fas fa-folder-plus me-1"></i> New Folder
            </button>
        @endif

        <button class="btn btn-primary btn-sm" onclick="$('#upload-section').toggleClass('active'); $('#create-folder-section').removeClass('active');">
            <i class="fas fa-cloud-upload-alt me-1"></i> Upload
        </button>
    </div>
</div>

<div id="create-folder-section" class="action-section">
    <form id="ajax-create-folder-form" class="d-flex gap-2">
        @csrf
        <input type="text" name="name" class="form-control form-control-sm" placeholder="Folder Name (e.g. Courses 2024)" required>
        <button type="submit" class="btn btn-success btn-sm text-nowrap">Create</button>
    </form>
</div>

<div id="upload-section" class="action-section">
    <form id="ajax-upload-form" enctype="multipart/form-data">
        @csrf
        <input type="hidden" name="folder_id" value="{{ isset($currentFolder) ? $currentFolder->id : 'root' }}">
        <div class="input-group">
            <input type="file" name="files[]" class="form-control form-control-sm" multiple required>
            <button type="submit" class="btn btn-primary btn-sm">Start Upload</button>
        </div>
        <div class="progress mt-2 d-none" id="upload-progress" style="height: 5px;">
            <div class="progress-bar" role="progressbar" style="width: 0%"></div>
        </div>
    </form>
</div>

<div class="gallery-grid">
    @foreach($folders as $folder)
        <div class="gallery-item" onclick="loadPicker('{{ $folder->id }}')">
            <div class="gallery-preview"><i class="fas fa-folder folder-icon"></i></div>
            <div class="gallery-name">{{ $folder->name }}</div>
        </div>
    @endforeach

    @foreach($galleries as $file)
        <div class="gallery-item file-item"
             data-url="{{ asset($file->image) }}"
             data-type="{{ $file->type }}"
             onclick="selectFile(this, '{{ asset($file->image) }}', '{{ $file->type }}')">
            <div class="gallery-preview">
                @if(in_array($file->type, ['video']))
                    <video muted style="pointer-events: none;"><source src="{{ asset($file->image) }}"></video>
                    <i class="fas fa-video position-absolute text-white" style="top:5px; left:5px; text-shadow: 0 1px 3px rgba(0,0,0,0.5);"></i>
                @else
                    <img src="{{ asset($file->image) }}" loading="lazy">
                @endif
            </div>
            <div class="gallery-name">{{ basename($file->image) }}</div>
        </div>
    @endforeach
</div>

@if($folders->isEmpty() && $galleries->isEmpty())
    <div class="text-center py-5 text-muted"><i class="fas fa-box-open fa-2x mb-2"></i><br>Empty Folder</div>
@endif

<div class="gallery-pagination">
    {{ $galleries->links('pagination::bootstrap-4') }}
</div>
