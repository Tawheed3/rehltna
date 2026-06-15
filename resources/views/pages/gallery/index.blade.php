@extends('layouts.app')

@section('styles')
    <style>
        /* --- General Layout --- */
        .media-manager-container {
            background-color: #f9fbfd;
            border-radius: 12px;
            padding: 20px;
            min-height: 600px;
        }

        /* --- Card Design --- */
        .media-card {
            position: relative;
            background: #fff;
            border: 1px solid #eef0f3;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            cursor: pointer;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .media-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.05);
            border-color: #dce1e7;
        }

        /* --- Drag & Drop Visual Feedback --- */
        .media-card.drag-over, .breadcrumb-drop-zone.drag-over {
            border: 2px dashed #0d6efd !important;
            background-color: #e9f2ff !important;
            transform: scale(1.02);
            transition: all 0.2s;
        }

        /* --- Media Preview Area (Thumbnail) --- */
        .media-preview {
            height: 140px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            position: relative;
            overflow: hidden;
        }

        .media-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }

        .media-card:hover .media-preview img {
            transform: scale(1.05);
        }

        /* Folder Icon */
        .folder-icon-wrapper {
            font-size: 4rem;
            color: #0d6efd;
            text-shadow: 0 2px 5px rgba(255, 193, 7, 0.2);
        }

        /* --- Card Footer (Name) --- */
        .media-details {
            padding: 12px;
            border-top: 1px solid #f0f0f0;
            background: #fff;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .media-name {
            font-size: 0.9rem;
            font-weight: 600;
            color: #333;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 0;
            text-align: center;
        }

        /* --- Hover Actions (Delete/Edit Buttons) --- */
        .media-actions {
            position: absolute;
            top: 10px;
            right: 10px;
            opacity: 0;
            transition: opacity 0.2s ease-in-out;
            z-index: 10;
            display: flex;
            gap: 5px; /* Space between buttons */
        }

        .media-card:hover .media-actions {
            opacity: 1;
        }

        .action-btn {
            background: rgba(255, 255, 255, 0.9);
            border: none;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: all 0.2s;
        }

        .action-btn-danger {
            color: #dc3545;
        }
        .action-btn-danger:hover {
            background: #dc3545;
            color: #fff;
        }

        .action-btn-primary {
            color: #0d6efd;
        }
        .action-btn-primary:hover {
            background: #0d6efd;
            color: #fff;
        }

        /* --- Video Specific --- */
        .video-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: rgba(255, 255, 255, 0.8);
            font-size: 2.5rem;
            pointer-events: none;
        }

        /* --- Upload Modal Zone --- */
        .upload-drop-zone {
            border: 2px dashed #dbe0e6;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            transition: border-color 0.3s;
            background-color: #fafbfc;
        }

        .upload-drop-zone:hover {
            border-color: #0d6efd;
            background-color: #f0f7ff;
        }

        /* --- Preview Modal --- */
        #previewImage {
            max-height: 85vh;
            width: auto;
            max-width: 100%;
            border-radius: 8px;
            box-shadow: 0 5px 30px rgba(0, 0, 0, 0.5);
        }

        /* Breadcrumb Drop Zone (Active Home) */
        .breadcrumb-drop-zone {
            cursor: default;
            padding: 2px 8px;
            border-radius: 4px;
            border: 2px solid transparent;
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 align-items-center">
        <div>
            <h4 class="content-title mb-2">Media Gallery</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 bg-transparent p-0">
                    <li class="breadcrumb-item breadcrumb-drop-zone"
                        data-folder-id="root"
                        ondrop="drop(event)"
                        ondragover="allowDrop(event)"
                        ondragleave="leaveDrop(event)">
                        <a href="{{ route('gallery.index') }}" class="text-primary">
                            <i class="fas fa-home me-1"></i> Home
                        </a>
                    </li>
                    @if(isset($currentFolder))
                        <li class="breadcrumb-item active" aria-current="page">{{ $currentFolder->name }}</li>
                    @endif
                </ol>
            </nav>
        </div>
        <div class="d-flex gap-2">
            @if(!isset($currentFolder))
                <button type="button" class="btn btn-success shadow-sm" data-bs-toggle="modal"
                        data-bs-target="#createFolderModal">
                    <i class="fas fa-folder-plus me-1"></i> New Folder
                </button>
            @endif
            <button type="button" class="btn btn-primary shadow-sm" data-bs-toggle="modal"
                    data-bs-target="#uploadModal">
                <i class="fas fa-cloud-upload-alt me-1"></i> Upload
            </button>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm border-0">
                <div class="card-body media-manager-container">

                    <div class="row g-3">
                        @if(isset($currentFolder))
                            <div class="col-xl-2 col-lg-3 col-md-4 col-6">
                                <div class="media-card"
                                     onclick="window.location.href='{{ route('gallery.index') }}'"
                                     ondrop="drop(event)"
                                     ondragover="allowDrop(event)"
                                     ondragleave="leaveDrop(event)"
                                     data-folder-id="root"
                                     style="background-color: #f8f9fa; border-style: dashed;">
                                    <div class="media-preview bg-transparent">
                                        <i class="fas fa-level-up-alt text-secondary" style="font-size: 3rem;"></i>
                                    </div>
                                    <div class="media-details bg-transparent border-top-0">
                                        <span class="media-name text-muted">Back to Home</span>
                                    </div>
                                </div>
                            </div>
                        @endif
                        @foreach($folders as $folder)

                            <div class="col-xl-2 col-lg-3 col-md-4 col-6">
                                <div class="media-card"
                                     onclick="window.location.href='{{ route('gallery.index', ['folder_id' => $folder->id]) }}'"
                                     ondrop="drop(event)"
                                     ondragover="allowDrop(event)"
                                     ondragleave="leaveDrop(event)"
                                     data-folder-id="{{ $folder->id }}">

                                    <div class="media-actions" onclick="event.stopPropagation()">
                                        <button class="action-btn action-btn-primary"
                                                onclick="editFolder(event, '{{ route('folders.update', $folder->id) }}', '{{ $folder->name }}')"
                                                title="Edit Folder Name">
                                            <i class="fas fa-pen"></i>
                                        </button>

                                        <button class="action-btn action-btn-danger delete-btn"
                                                data-route="{{ route('folders.destroy', $folder->id) }}"
                                                data-bs-toggle="modal"
                                                data-bs-target="#deleteModal"
                                                title="Delete Folder">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>

                                    <div class="media-preview">
                                        <i class="fas fa-folder folder-icon-wrapper"></i>
                                    </div>
                                    <div class="media-details">
                                        <span class="media-name">{{ $folder->name }}</span>
                                    </div>
                                </div>
                            </div>
                        @endforeach

                        @foreach($galleries as $file)
                            <div class="col-xl-2 col-lg-3 col-md-4 col-6">
                                <div class="media-card"
                                     draggable="true"
                                     ondragstart="drag(event)"
                                     data-file-id="{{ $file->id }}"
                                     onclick="openPreview('{{ asset($file->image) }}', '{{ $file->type }}')">

                                    <div class="media-actions">
                                        <button class="action-btn action-btn-danger delete-btn"
                                                data-route="{{ route('gallery.destroy', $file->id) }}"
                                                data-bs-toggle="modal"
                                                data-bs-target="#deleteModal"
                                                onclick="event.stopPropagation()"
                                                title="Delete File">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>

                                    <div class="media-preview">
                                        @if(in_array($file->type, ['video']))
                                            <video class="w-100 h-100 object-fit-cover"
                                                   src="{{ asset($file->image) }}"></video>
                                            <div class="video-overlay"><i class="fas fa-play-circle"></i></div>
                                        @else
                                            <img src="{{ asset($file->image) }}" alt="img" draggable="false"
                                                 class="user-select-none">
                                        @endif
                                    </div>
                                    <div class="media-details">
                                        <span class="media-name" title="{{ basename($file->image) }}">
                                            {{ basename($file->image) }}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        @endforeach

                        @if($folders->isEmpty() && $galleries->isEmpty())
                            <div class="col-12 text-center mt-5">
                                <div class="text-muted opacity-50 mb-3">
                                    <i class="fas fa-box-open fa-4x"></i>
                                </div>
                                <h5 class="text-muted">No media files found</h5>
                                <p class="text-muted small">Upload files or create a folder to get started.</p>
                            </div>
                        @endif
                    </div>

                    <div class="mt-4 d-flex justify-content-center">
                        {{ $galleries->links() }}
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="createFolderModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <form action="{{ route('folders.store') }}" method="POST">
                    @csrf
                    <div class="modal-header border-bottom-0">
                        <h5 class="modal-title">Create New Folder</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="form-label text-muted">Folder Name</label>
                            <input type="text" name="name" class="form-control form-control-lg" required
                                   placeholder="e.g. Products 2024">
                        </div>
                    </div>
                    <div class="modal-footer border-top-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success px-4">Create</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editFolderModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <form id="editFolderForm" method="POST">
                    @csrf
                    @method('PUT')
                    <div class="modal-header border-bottom-0">
                        <h5 class="modal-title">Edit Folder</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="form-label text-muted">Folder Name</label>
                            <input type="text" id="editFolderName" name="name" class="form-control form-control-lg" required>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4">Update</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="uploadModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <form action="{{ route('gallery.store') }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    <input type="hidden" name="folder_id" value="{{ request('folder_id') }}">

                    <div class="modal-header border-bottom-0">
                        <h5 class="modal-title">Upload Media</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="upload-drop-zone">
                            <i class="fas fa-cloud-upload-alt fa-3x text-primary mb-3"></i>
                            <h5 class="mb-2">Drag & Drop files here</h5>
                            <p class="text-muted small mb-4">or click to browse your computer</p>

                            <label for="files" class="btn btn-outline-primary px-4 rounded-pill">Browse Files</label>
                            <input type="file" name="files[]" id="files" class="d-none" multiple
                                   onchange="showFileCount(this)">

                            <div class="mt-3">
                                <span id="file_count" class="badge bg-soft-primary text-primary fs-6 fw-normal"></span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4">Upload Files</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    @include('pages.models.confirm-delete')

    <div class="modal fade" id="previewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl">
            <div class="modal-content bg-transparent border-0 shadow-none">
                <div class="modal-header border-0 p-0 mb-2">
                    <button type="button" class="btn-close btn-close-white ms-auto" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                <div class="modal-body text-center p-0">
                    <img src="" id="previewImage" class="img-fluid" alt="Preview">
                    <video controls id="previewVideo" class="img-fluid d-none" style="max-height: 85vh;"></video>
                </div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')
    <script>
        // --- 1. Helper Functions ---
        function showFileCount(input) {
            const count = input.files.length;
            const text = count > 0 ? count + ' file(s) selected' : '';
            document.getElementById('file_count').innerText = text;
        }

        function confirmDelete() {
            const deleteBtns = document.querySelectorAll('.delete-btn');
            const deleteForm = document.getElementById('deleteForm');

            deleteBtns.forEach(btn => {
                btn.addEventListener('click', function () {
                    const route = this.getAttribute('data-route');
                    deleteForm.setAttribute('action', route);
                });
            });
        }

        // --- 2. Edit Folder Logic ---
        function editFolder(event, url, name) {
            // Stop propagation to prevent entering the folder
            event.stopPropagation();
            const modal = new bootstrap.Modal(document.getElementById('editFolderModal'));
            const form = document.getElementById('editFolderForm');
            const nameInput = document.getElementById('editFolderName');
            nameInput.value = name;
            form.setAttribute('action', url);
            modal.show();
        }

        // --- 3. Preview Logic ---
        function openPreview(url, type) {
            const modal = new bootstrap.Modal(document.getElementById('previewModal'));
            const img = document.getElementById('previewImage');
            const vid = document.getElementById('previewVideo');

            if (type === 'video') {
                img.classList.add('d-none');
                vid.classList.remove('d-none');
                vid.src = url;
            } else {
                vid.classList.add('d-none');
                img.classList.remove('d-none');
                img.src = url;
            }
            modal.show();
        }

        // --- 4. Drag & Drop Logic ---

        // Start Dragging
        function drag(ev) {
            const card = ev.target.closest('.media-card');
            if (card) {
                ev.dataTransfer.setData("file_id", card.getAttribute('data-file-id'));
            }
        }

        // Allow Dropping
        function allowDrop(ev) {
            ev.preventDefault();
            const target = ev.target.closest('.media-card') || ev.target.closest('.breadcrumb-drop-zone');

            if (target && target.hasAttribute('data-folder-id')) {
                target.classList.add('drag-over');
            }
        }

        // Leave Drop Zone
        function leaveDrop(ev) {
            const target = ev.target.closest('.media-card') || ev.target.closest('.breadcrumb-drop-zone');
            if (target) {
                target.classList.remove('drag-over');
            }
        }

        // Drop Action
        function drop(ev) {
            ev.preventDefault();

            const target = ev.target.closest('.media-card') || ev.target.closest('.breadcrumb-drop-zone');

            if (target && target.hasAttribute('data-folder-id')) {
                target.classList.remove('drag-over');

                var file_id = ev.dataTransfer.getData("file_id");
                var folder_id = target.getAttribute('data-folder-id');

                if (!file_id) return;

                fetch("{{ route('gallery.move') }}", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-CSRF-TOKEN": "{{ csrf_token() }}"
                    },
                    body: JSON.stringify({
                        file_id: file_id,
                        folder_id: folder_id === 'root' ? null : folder_id
                    })
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        } else {
                            alert('Error moving file');
                        }
                    })
                    .catch(error => console.error('Error:', error));
            }
        }

        // --- 5. Initialization ---
        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete();
        });
    </script>
@endsection
