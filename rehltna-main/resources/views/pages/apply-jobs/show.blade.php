@extends('layouts.app')

@section('content')

    <!-- breadcrumb -->
    <div class="breadcrumb-header mb-4">
        <div class="d-flex align-items-center">
            <a href="{{ route('dashboard') }}" class="text-dark fw-bold">
                <i class="fas fa-home me-1"></i> Home
            </a>
            <span class="text-muted mx-2">/</span>
            <span class="text-muted">CV Details</span>
        </div>
    </div>

    <!-- Main Content -->
    <div class="row">
        <div class="col-xl-10 mx-auto">
            <div class="card shadow border-0">
                <div class="card-header bg-white border-bottom">
                    <h5 class="mb-0"><i class="fas fa-id-card me-2 text-primary"></i>Applicant Info</h5>
                </div>
                <div class="card-body">

                    <!-- Info Grid -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="border rounded p-3 h-100 bg-light">
                                <div class="text-muted mb-1">
                                    <i class="fas fa-user me-1 text-primary"></i> Name
                                </div>
                                <div class="fw-bold fs-5 text-dark">{{ $applyJob->name }}</div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="border rounded p-3 h-100 bg-light position-relative">
                                <div class="text-muted mb-1 d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-envelope me-1 text-primary"></i> Email</span>
                                    <button onclick="copyToClipboard('{{ $applyJob->email }}')" class="btn btn-sm btn-light" title="Copy Email">
                                        <i class="fas fa-copy"></i>
                                    </button>
                                </div>
                                <div class="fw-bold fs-6 text-dark">{{ $applyJob->email }}</div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="border rounded p-3 h-100 bg-light position-relative">
                                <div class="text-muted mb-1 d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-phone me-1 text-primary"></i> Phone</span>
                                    <button onclick="copyToClipboard('{{ $applyJob->phone }}')" class="btn btn-sm btn-light" title="Copy Phone">
                                        <i class="fas fa-copy"></i>
                                    </button>
                                </div>
                                <div class="fw-bold fs-6 text-dark">{{ $applyJob->phone }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Status + Download -->
                    <div class="mb-4">
                        <h6 class="text-muted mb-3">
                            <i class="fas fa-clipboard-check me-1"></i>Application Status & CV
                        </h6>
                        <div class="d-flex flex-wrap align-items-center gap-3">
                            <form action="{{ route('apply-jobs.update', $applyJob->id) }}" method="POST" class="d-flex flex-wrap align-items-center gap-3">
                                @csrf
                                @method('PUT')
                                <select name="status" class="form-select w-auto">
                                    <option value="accepted" {{ $applyJob->status == 'accepted' ? 'selected' : '' }}>Accepted</option>
                                    <option value="rejected" {{ $applyJob->status == 'rejected' ? 'selected' : '' }}>Rejected</option>
                                </select>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-check-circle me-1"></i> Update
                                </button>
                            </form>

                            @if($applyJob->cv)
                                <a href="{{ asset($applyJob->cv) }}" class="btn btn-success" download>
                                    <i class="fas fa-download me-1"></i> Download CV
                                </a>
                            @else
                                <span class="badge bg-danger">No CV uploaded</span>
                            @endif
                        </div>
                    </div>

                    <!-- CV Preview -->
                    @if(Str::endsWith($applyJob->cv, '.pdf'))
                        <div class="mt-5">
                            <h6 class="text-muted mb-3"><i class="fas fa-eye me-1"></i>CV Preview</h6>
                            <div class="ratio ratio-4x3 border rounded shadow-sm">
                                <iframe src="{{ asset($applyJob->cv) }}" style="border: none;"></iframe>
                            </div>
                        </div>
                    @endif

                    <!-- Back Button -->
                    <div class="mt-5 text-start">
                        <a href="{{ route('apply-jobs.index') }}" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-1"></i> Back to List
                        </a>
                    </div>

                </div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')
    <script>
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(function () {
                toastr.success("Copied: " + text);
            }, function () {
                toastr.error("Failed to copy");
            });
        }
    </script>
@endsection
