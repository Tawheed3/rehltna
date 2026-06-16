@extends('layouts.app')

@section('styles')

@endsection

@section('content')

    <!-- breadcrumb -->
    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Protocols</span>
            </div>
        </div>
    </div>
    <!-- breadcrumb -->

    <!-- row -->
    <div class="row row-sm">
        <div class="col-xl-12">
            <div class="card">
                <div class="card-header pb-0">
                    <div class="d-flex justify-content-between">
                        <div class="col-sm-4 col-md-2 col-xl-2">
                            <a class="btn btn-outline-primary btn-block"
                               data-bs-effect="effect-scale"
                               href="{{ route('protocols.create') }}">Add Protocol</a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table text-md-nowrap" id="table">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    @if(hasEnglish())
                                        <th>Title EN</th>
                                    @endif
                                    @if(hasArabic())
                                        <th>Title AR</th>
                                    @endif
                                    <th>Order</th>
                                    <th>Link</th>
                                    <th>Feature</th>
                                    <th>Status</th>
                                    <th>Options</th>
                                </tr>
                                </thead>
                                <tbody>
                                @foreach($protocols as $protocol)
                                    <tr>
                                        <td>{{ $loop->iteration }}</td>
                                        @if(hasEnglish())
                                            <td>{{ $protocol->title_en }}</td>
                                        @endif
                                        @if(hasArabic())
                                            <td>{{ $protocol->title_ar }}</td>
                                        @endif
                                        <td>{{ $protocol->order ?? 0}}</td>
                                        <td>{{ $protocol->link }}</td>
                                        <td>
                                            <div
                                                class="toggle-is-feature-btn main-toggle {{ $protocol->is_feature == 1 ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                                                data-id="{{ $protocol->id }}"
                                                data-is_feature="{{ $protocol->is_feature }}">
                                                <span></span>
                                            </div>
                                        </td>
                                        <td>
                                            <div
                                                class="toggle-status-btn main-toggle {{ $protocol->status == 1 ? 'main-toggle-success on' : 'main-toggle-danger of' }}"
                                                data-id="{{ $protocol->id }}"
                                                data-status="{{ $protocol->status }}">
                                                <span></span>
                                            </div>
                                        </td>
                                        <td>
                                            <a class="btn btn-sm btn-outline-info"
                                               data-bs-effect="effect-scale"
                                               href="{{ route('protocols.edit',encrypt($protocol->id)) }}"><i
                                                    class="las la-pen"></i></a>
                                            <a class="modal-effect btn btn-sm btn-outline-danger delete-btn"
                                               data-bs-effect="effect-scale"
                                               data-route="{{ route('protocols.destroy',$protocol->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"><i
                                                    class="las la-trash"></i></a>
                                        </td>
                                    </tr>
                                @endforeach
                                </tbody>
                            </table>
                            {{ $protocols->links() }}
                        </div>
                    </div>
                </div>
            </div>
            <!--/div-->

            @include('pages.models.confirm-delete')

        </div>
    </div>
    <!-- row closed -->

@endsection

@section('scripts')
    <script>
        $(document).on('click', '.toggle-status-btn', function () {
            let button = $(this);
            let protocolId = button.data('id');
            $.ajax({
                url: "{{ route('protocols.change.status', ['id' => ':id']) }}".replace(':id', protocolId),
                type: 'POST',
                data: {
                    _token: '{{ csrf_token() }}'
                },
                success: function (response) {
                    toastr.success("Status changed successfully");
                    if (response.status == 1) {
                        button.removeClass('main-toggle-danger of').addClass('main-toggle-success on');
                    } else {
                        button.removeClass('main-toggle-success on').addClass('main-toggle-danger of');
                    }
                },
                error: function () {
                    toastr.error("Something went wrong");
                }
            });
        });

        $(document).on('click', '.toggle-is-feature-btn', function () {
            let button = $(this);
            let protocolId = button.data('id');
            $.ajax({
                url: "{{ route('protocols.change.is_feature', ['id' => ':id']) }}".replace(':id', protocolId),
                type: 'POST',
                data: {
                    _token: '{{ csrf_token() }}'
                },
                success: function (response) {
                    toastr.success("Feature changed successfully");
                    if (response.is_feature == 1) {
                        button.removeClass('main-toggle-danger of').addClass('main-toggle-success on');
                    } else {
                        button.removeClass('main-toggle-success on').addClass('main-toggle-danger of');
                    }
                },
                error: function () {
                    toastr.error("Something went wrong");
                }
            });
        });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete()
        });
    </script>
@endsection
