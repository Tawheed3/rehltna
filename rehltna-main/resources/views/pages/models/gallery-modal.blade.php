<div class="modal fade" id="galleryPickerModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header border-bottom-0 bg-light py-2">
                <h6 class="modal-title text-primary font-weight-bold">
                    <i class="fas fa-photo-video me-2"></i> Media Library
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-0 bg-white" id="gallery-picker-body" style="min-height: 450px;">
                <div class="d-flex flex-column align-items-center justify-content-center h-100 py-5">
                    <div class="spinner-border text-primary" role="status"></div>
                </div>
            </div>

            <div class="modal-footer bg-light border-top-0 justify-content-between py-2" id="multi-select-footer" style="display: none;">
                <span class="text-muted small">Selected: <b id="selected-count" class="text-primary">0</b> items</span>
                <button type="button" class="btn btn-success btn-sm px-4" onclick="confirmMultiSelection()">
                    Insert Selected <i class="fas fa-check ms-1"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {

        window.galleryState = { inputId: null, previewId: null, isMulti: false };
        window.selectedFilesQueue = [];

        window.currentPickerUrl = "{{ route('gallery.picker') }}?folder_id=root";

        // 1. Open Modal
        $(document).on('click', '.open-gallery', function() {
            window.galleryState.inputId = $(this).data('input');
            window.galleryState.previewId = $(this).data('preview');
            window.galleryState.isMulti = $(this).data('multi') || false;
            window.selectedFilesQueue = [];
            updateFooterUI();
            $('#galleryPickerModal').modal('show');
            loadPicker(window.currentPickerUrl);
        });

        // 2. Pagination Click
        $(document).on('click', '#gallery-picker-body .pagination a', function(e) {
            e.preventDefault();
            loadPicker($(this).attr('href'));
        });

        // 3. Load Picker
        window.loadPicker = function(url) {
            if(!url.includes('http')) url = "{{ route('gallery.picker') }}?folder_id=" + url;

            window.currentPickerUrl = url; // Update current URL

            $('#gallery-picker-body').css('opacity', '0.6');
            $.ajax({
                url: url,
                success: function(html) {
                    $('#gallery-picker-body').html(html).css('opacity', '1');
                    restoreSelectionState();
                },
                error: function() {
                    $('#gallery-picker-body').html('<div class="text-center text-danger py-5">Error loading.</div>').css('opacity', '1');
                }
            });
        }

        // --- NEW: Handle Folder Creation ---
        $(document).on('submit', '#ajax-create-folder-form', function(e) {
            e.preventDefault();
            let form = $(this);
            let btn = form.find('button');

            btn.prop('disabled', true).text('Creating...');

            $.ajax({
                url: "{{ route('folders.store') }}",
                method: 'POST',
                data: form.serialize(),
                success: function(response) {
                    // Reload current view
                    loadPicker(window.currentPickerUrl);
                },
                error: function() {
                    alert('Error creating folder');
                    btn.prop('disabled', false).text('Create');
                }
            });
        });

        // --- NEW: Handle File Upload ---
        $(document).on('submit', '#ajax-upload-form', function(e) {
            e.preventDefault();
            let formData = new FormData(this);
            let progressBar = $('#upload-progress');
            let bar = progressBar.find('.progress-bar');
            let btn = $(this).find('button[type="submit"]');

            progressBar.removeClass('d-none');
            btn.prop('disabled', true).text('Uploading...');

            $.ajax({
                url: "{{ route('gallery.store') }}",
                method: 'POST',
                data: formData,
                contentType: false,
                processData: false,
                xhr: function() {
                    let xhr = new window.XMLHttpRequest();
                    xhr.upload.addEventListener("progress", function(evt) {
                        if (evt.lengthComputable) {
                            let percentComplete = (evt.loaded / evt.total) * 100;
                            bar.width(percentComplete + '%');
                        }
                    }, false);
                    return xhr;
                },
                success: function(response) {
                    loadPicker(window.currentPickerUrl); // Refresh
                },
                error: function() {
                    alert('Upload Failed');
                    progressBar.addClass('d-none');
                    bar.width('0%');
                    btn.prop('disabled', false).text('Start Upload');
                }
            });
        });

        // --- Selection Logic (Same as before) ---
        window.selectFile = function(element, url, type) {
            if (window.galleryState.isMulti) {
                let index = window.selectedFilesQueue.findIndex(item => item.url === url);
                if (index === -1) {
                    window.selectedFilesQueue.push({ url: url, type: type });
                    $(element).addClass('selected');
                } else {
                    window.selectedFilesQueue.splice(index, 1);
                    $(element).removeClass('selected');
                }
                updateFooterUI();
            } else {
                setSingleFile(url, type);
                $('#galleryPickerModal').modal('hide');
            }
        }

        function updateFooterUI() {
            if (window.galleryState.isMulti) {
                $('#multi-select-footer').slideDown(100);
                $('#selected-count').text(window.selectedFilesQueue.length);
            } else {
                $('#multi-select-footer').hide();
            }
        }

        function restoreSelectionState() {
            window.selectedFilesQueue.forEach(item => {
                $(`.gallery-item[data-url="${item.url}"]`).addClass('selected');
            });
        }

        window.confirmMultiSelection = function() {
            window.selectedFilesQueue.forEach(item => {
                addMultiFile(item.url, item.type);
            });
            $('#galleryPickerModal').modal('hide');
        }

        function setSingleFile(url, type) {
            $(`#${window.galleryState.inputId}`).val(url);
            let previewHtml = type === 'video'
                ? `<div class="media-preview-card"><video controls class="rounded shadow-sm border" style="max-width: 100%; max-height: 200px;"><source src="${url}"></video></div>`
                : `<div class="media-preview-card"><img src="${url}" class="rounded shadow-sm border" style="max-width: 100%; max-height: 200px;"></div>`;
            $(`#${window.galleryState.previewId}`).html(previewHtml);
        }

        function addMultiFile(url, type) {
            let inputName = window.galleryState.inputId + "[]";
            let previewContent = type === 'video'
                ? `<video class="w-100 h-100 rounded bg-black" style="object-fit:cover;"><source src="${url}"></video><i class="fas fa-play-circle text-white position-absolute top-50 start-50 translate-middle"></i>`
                : `<img src="${url}" class="w-100 h-100 rounded" style="object-fit:cover;">`;

            let itemHtml = `
                <div class="position-relative d-inline-block shadow-sm border rounded bg-white me-2 mb-2" style="width: 80px; height: 80px;">
                    <input type="hidden" name="${inputName}" value="${url}">
                    ${previewContent}
                    <button type="button" class="btn btn-danger btn-sm position-absolute rounded-circle p-0 d-flex justify-content-center align-items-center"
                            style="top:-5px; right:-5px; width:18px; height:18px;"
                            onclick="$(this).parent().remove()">
                        <i class="fas fa-times" style="font-size: 10px;"></i>
                    </button>
                </div>
            `;
            $(`#${window.galleryState.previewId}`).append(itemHtml);
        }
    });
</script>
