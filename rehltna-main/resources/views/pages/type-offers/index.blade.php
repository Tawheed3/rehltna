@extends('layouts.app')

@section('styles')

@endsection

@section('content')

    <!-- breadcrumb -->
    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Type Offers</span>
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
                               href="{{ route('type-offers.create') }}">Add Type</a>
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
                                    <th>Offers</th>
                                    <th>Options</th>
                                </tr>
                                </thead>
                                <tbody>
                                @foreach($typeOffers as $typeOffer)
                                    <tr>
                                        <td>{{ $loop->iteration }}</td>
                                        @if(hasEnglish())
                                            <td>{{ $typeOffer->title_en }}</td>
                                        @endif
                                        @if(hasArabic())
                                            <td>{{ $typeOffer->title_ar }}</td>
                                        @endif
                                        <td>{{ $typeOffer->offers_count }}</td>
                                        <td>
                                            <a class="btn btn-sm btn-outline-info"
                                               data-bs-effect="effect-scale"
                                               href="{{ route('type-offers.edit',encrypt($typeOffer->id)) }}"><i
                                                    class="las la-pen"></i></a>
                                            <a class="modal-effect btn btn-sm btn-outline-danger delete-btn"
                                               data-bs-effect="effect-scale"
                                               data-route="{{ route('type-offers.destroy',$typeOffer->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"><i
                                                    class="las la-trash"></i></a>
                                        </td>
                                    </tr>
                                @endforeach
                                </tbody>
                            </table>
                            {{ $typeOffers->links() }}
                        </div>
                    </div>
                </div>
            </div>
            <!--/div-->
        </div>
    </div>
    <!-- row closed -->

    @include('pages.models.confirm-delete')

@endsection

@section('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            confirmDelete()
        });
    </script>
@endsection
