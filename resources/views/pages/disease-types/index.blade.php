@extends('layouts.app')

@section('styles')

@endsection

@section('content')

    <!-- breadcrumb -->
    <div class="breadcrumb-header justify-content-between mb-4">
        <div class="my-auto">
            <div class="d-flex">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Disease Types</span>
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
                            <a class="modal-effect btn btn-outline-primary btn-block"
                               data-bs-effect="effect-scale" data-bs-toggle="modal"
                               href="#DiseaseTypeCreate">Add Disease Type</a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table text-md-nowrap" id="table">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    @if(hasEnglish())
                                        <th>Name EN</th>
                                    @endif
                                    @if(hasArabic())
                                        <th>Name AR</th>
                                    @endif
                                    <th>Patient Education Count</th>
                                    <th>Residency Program Count</th>
                                    <th>Options</th>
                                </tr>
                                </thead>
                                <tbody>
                                @foreach($diseaseTypes as $diseaseType)
                                    <tr>
                                        <td>{{ $loop->iteration }}</td>
                                        @if(hasEnglish())
                                            <td>{{ $diseaseType->name_en }}</td>
                                        @endif
                                        @if(hasArabic())
                                            <td>{{ $diseaseType->name_ar }}</td>
                                        @endif
                                        <td>{{ $diseaseType->patientsEducation()->count() }}</td>
                                        <td>{{ $diseaseType->residenciesProgram()->count() }}</td>
                                        <td>
                                            <a class="modal-effect btn btn-sm btn-outline-info edit-btn"
                                               data-bs-effect="effect-scale"
                                               data-name_en="{{ $diseaseType->name_en }}"
                                               data-name_ar="{{ $diseaseType->name_ar }}"
                                               data-route="{{ route('disease-types.update',$diseaseType->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#editModel"><i
                                                    class="las la-pen"></i></a>

                                            <a class="modal-effect btn btn-sm btn-outline-danger delete-btn"
                                               data-bs-effect="effect-scale"
                                               data-route="{{ route('disease-types.destroy',$diseaseType->id) }}"
                                               data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"><i
                                                    class="las la-trash"></i></a>
                                        </td>
                                    </tr>

                                @endforeach
                                </tbody>
                            </table>
                            {{ $diseaseTypes->links() }}
                        </div>
                    </div>
                </div>
            </div>
            <!--/div-->

            @include('pages.models.confirm-delete')
            @include('pages.disease-types.models.create')
            @include('pages.disease-types.models.edit')

        </div>
    </div>
    <!-- row closed -->

@endsection

@section('scripts')
    <script>
        function attachEditBtns() {
            const editBtns = document.querySelectorAll(".edit-btn");
            editBtns.forEach(btn => {
                btn.addEventListener("click", () => {
                    const nameEnInput = document.getElementById("edit-name_en");
                    if (nameEnInput) {
                        nameEnInput.value = btn.dataset.name_en;
                    }
                    const nameArInput = document.getElementById("edit-name_ar");
                    if (nameArInput) {
                        nameArInput.value = btn.dataset.name_ar;
                    }
                    document.getElementById("editForm").action = btn.dataset.route;
                });
            });
        }

        document.addEventListener('DOMContentLoaded', function () {
            attachEditBtns()
            confirmDelete()
        });
    </script>
@endsection
