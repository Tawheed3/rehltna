<div class="table-responsive">
    <table class="table" id="table">
        <thead>
        <tr>
            <th class="text-center" width="60"><input type="checkbox" onclick="toggle(this)"></th>
            <th>Client</th>
            <th>Review Content</th>
            <th class="text-center">Status</th>
            <th class="text-center px-4">Actions</th>
        </tr>
        </thead>
        <tbody>
        @foreach($testimonials as $testimonial)
            <tr>
                <td class="text-center"><input type="checkbox" name="ids[]" value="{{ $testimonial->id }}"></td>
                <td>
                    <div class="d-flex align-items-center gap-3">
                        @if($testimonial->image)
                            <img src="{{ asset($testimonial->image) }}" class="client-avatar img-preview"
                                 data-bs-toggle="modal" data-bs-target="#imageModal"
                                 data-src="{{ asset($testimonial->image) }}">
                        @else
                            <div class="client-avatar bg-light d-flex align-items-center justify-content-center border">
                                <i class="las la-user text-muted fs-4"></i>
                            </div>
                        @endif
                        <div>
                            <h6 class="mb-0 fw-bold text-dark">{{ $testimonial->name }}</h6>
                            <span class="text-muted small fw-medium d-block">{{ $testimonial->email }}</span>

                            <div class="text-warning mt-1" style="font-size: 12px;">
                                @php $stars = $testimonial->stars ?? 5; @endphp
                                @for($i = 1; $i <= 5; $i++)
                                    <i class="{{ $i <= $stars ? 'fas' : 'far' }} fa-star"></i>
                                @endfor
                            </div>

                        </div>
                    </div>
                </td>
                <td>
                    <div class="testimonial-text">
                        {!! \Illuminate\Support\Str::limit(strip_tags($testimonial->testimonial), 120) !!}
                    </div>
                </td>
                <td class="text-center">
                    <div
                        class="toggle-status-btn main-toggle mx-auto {{ $testimonial->status ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                        data-id="{{ $testimonial->id }}">
                        <span></span>
                    </div>
                </td>
                <td class="text-center px-4">
                    <div class="d-flex justify-content-center gap-2">
                        <a class="btn-action btn-edit-action"
                           href="{{ route('testimonials.edit', encrypt($testimonial->id)) }}">
                            <i class="las la-pen fs-18"></i>
                        </a>
                        <a class="btn-action btn-delete-action delete-btn"
                           data-route="{{ route('testimonials.destroy', $testimonial->id) }}"
                           data-bs-toggle="modal" href="#" data-bs-target="#deleteModal">
                            <i class="las la-trash fs-18"></i>
                        </a>
                    </div>
                </td>
            </tr>
        @endforeach
        </tbody>
    </table>
</div>
