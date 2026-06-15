@extends('layouts.app')

@section('styles')
@endsection

@section('content')

    <!-- breadcrumb -->
    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Applications</span>
            </div>
        </div>
    </div>
    <!-- breadcrumb -->

    <!-- row -->
    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-header pb-0">
                    <div class="d-flex justify-content-end gap-2">
                        <div class="col-auto">
                            <select id="status-filter" class="form-select">
                                <option value="">All Status</option>
                                <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                                <option value="accepted" {{ request('status') == 'accepted' ? 'selected' : '' }}>Accepted</option>
                                <option value="rejected" {{ request('status') == 'rejected' ? 'selected' : '' }}>Rejected</option>
                            </select>
                        </div>
                        <div class="col-sm-4 col-md-4 col-xl-3">
                            <input type="text" id="search" class="form-control" placeholder="Search..." autofocus
                                   value="{{ request('search') }}">
                        </div>
                    </div>
                </div>


                <div class="card-body" id="apply-jobs-table">
                    @include('pages.apply-jobs.partials.table', ['applyJobs' => $applyJobs])
                </div>

            </div>
        </div>
    </div>
    <!-- row closed -->

    @include('pages.models.confirm-delete')

@endsection

@section('scripts')
    <script>
        $(document).ready(function () {
            function fetchData() {
                let search = $('#search').val();
                let status = $('#status-filter').val();

                $.ajax({
                    url: "{{ route('apply-jobs.index') }}",
                    data: {
                        search: search,
                        status: status
                    },
                    success: function (data) {
                        $('#apply-jobs-table').html(data);
                        confirmDelete();
                    }
                });
            }

            $('#search').on('keyup', function () {
                fetchData();
            });

            $('#status-filter').on('change', function () {
                fetchData();
            });

            confirmDelete();
        });
    </script>
@endsection

