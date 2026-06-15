@extends('layouts.app')

@section('styles')
    <style>
        /* Wizard & Layout Styles */
        .wizard-steps {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            position: relative;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .wizard-steps::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: #e9ecef;
            transform: translateY(-50%);
            z-index: 0;
        }

        .step-item {
            position: relative;
            z-index: 1;
            text-align: center;
            width: 100%;
        }

        .step-circle {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: #fff;
            border: 2px solid #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            font-size: 20px;
            color: #6c757d;
            transition: all 0.3s;
        }

        .step-item.active .step-circle {
            background: #0d6efd;
            border-color: #0d6efd;
            color: #fff;
            box-shadow: 0 0 0 5px rgba(13, 110, 253, 0.15);
        }

        .step-item.completed .step-circle {
            background: #198754;
            border-color: #198754;
            color: #fff;
        }

        .step-label {
            font-size: 13px;
            font-weight: 700;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .step-item.active .step-label {
            color: #0d6efd;
        }

        .step-content {
            display: none;
            animation: fadeIn 0.4s ease-in-out;
        }

        .step-content.active {
            display: block;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Form Controls */
        .form-label {
            font-weight: 600;
            font-size: 0.95rem;
            color: #344767;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border: 1px solid #e0e6ed;
            border-radius: 8px;
            padding: 12px 15px;
            transition: all 0.2s;
            background-color: #fcfcfc;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
            background-color: #fff;
        }

        .form-control.is-invalid, .form-select.is-invalid {
            border-color: #dc3545;
            background-image: none;
        }

        .input-group-text {
            background-color: #f1f5f9;
            border: 1px solid #e0e6ed;
            border-right: none;
            border-radius: 8px 0 0 8px;
        }

        .input-group .form-control {
            border-left: none;
        }

        .input-group .form-control:focus {
            border-left: 1px solid #0d6efd;
        }
    </style>
@endsection

@section('content')
    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <div class="d-flex align-items-center">
                <a href="{{ route('dashboard') }}" class="content-title mb-0 my-auto text-dark hover-primary fw-bold">Home</a>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Employees</span>
                <span class="text-muted mt-1 tx-13 ms-2 mb-0">/ Edit Employee</span>
            </div>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-xl-10">

            <div class="wizard-steps">
                <div class="step-item active" data-step="1">
                    <div class="step-circle"><i class="las la-user-tie"></i></div>
                    <div class="step-label">Basic Info</div>
                </div>
                <div class="step-item" data-step="2">
                    <div class="step-circle"><i class="las la-shield-alt"></i></div>
                    <div class="step-label">Security Details</div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-5">
                    <form action="{{ route('employees.update', $employee->id) }}" method="POST" id="editForm">
                        @csrf
                        @method('PUT')

                        <div class="step-content active" id="step-1">
                            <div class="text-center mb-5">
                                <h5 class="text-primary fw-bold">Employee Information</h5>
                                <p class="text-muted">Update the personal details and role for the staff member.</p>
                            </div>

                            <div class="row justify-content-center">
                                <div class="col-md-10">
                                    <div class="row">
                                        <div class="col-md-6 mb-4">
                                            <label class="form-label">Full Name <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" name="name" class="form-control form-control-lg"
                                                   value="{{ $employee->name }}" required>
                                        </div>
                                        <div class="col-md-6 mb-4">
                                            <label class="form-label">Role / Permission <span class="text-danger">*</span></label>
                                            <select name="role_id" class="form-select form-select-lg" required>
                                                <option value="" disabled>-- Select Role --</option>
                                                @foreach($roles as $role)
                                                    <option value="{{ $role->id }}" {{ $employee->role_id == $role->id ? 'selected' : '' }}>
                                                        {{ $role->name }}
                                                    </option>
                                                @endforeach
                                            </select>
                                        </div>
                                        <div class="col-md-6 mb-4">
                                            <label class="form-label">Etisalaty App Role</label>
                                            <select name="etisalaty_role" class="form-select form-select-lg">
                                                <option value="" {{ !$employee->etisalaty_role ? 'selected' : '' }}>-- No Etisalaty Access --</option>
                                                <option value="employee" {{ $employee->etisalaty_role === 'employee' ? 'selected' : '' }}>Employee (Upload only)</option>
                                                <option value="security" {{ $employee->etisalaty_role === 'security' ? 'selected' : '' }}>Security (Upload + Download)</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="step-content" id="step-2">
                            <div class="text-center mb-5">
                                <h5 class="text-primary fw-bold">Account Security</h5>
                                <p class="text-muted">Update login credentials. Leave password blank if you don't want
                                    to change it.</p>
                            </div>

                            <div class="row justify-content-center">
                                <div class="col-md-8">
                                    <div class="mb-4">
                                        <label class="form-label">Email Address <span
                                                class="text-danger">*</span></label>
                                        <div class="input-group input-group-lg">
                                            <span class="input-group-text"><i
                                                    class="las la-envelope fs-4 text-primary"></i></span>
                                            <input type="email" name="email" class="form-control"
                                                   value="{{ $employee->email }}" required>
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <label class="form-label">New Password <small
                                                class="text-muted ms-2">(Optional)</small></label>
                                        <div class="input-group input-group-lg">
                                            <span class="input-group-text"><i class="las la-lock fs-4 text-primary"></i></span>
                                            <input type="password" name="password" class="form-control"
                                                   placeholder="Enter only to change" minlength="6">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between mt-5 pt-4 border-top">
                            <button type="button" class="btn btn-light px-5 py-2 fw-bold" id="prevBtn"
                                    style="display:none;" onclick="nextPrev(-1)">
                                <i class="fas fa-arrow-left me-2"></i> Previous
                            </button>
                            <div class="ms-auto">
                                <button type="button" class="btn btn-primary px-5 py-2 fw-bold" id="nextBtn"
                                        onclick="nextPrev(1)">
                                    Next Step <i class="fas fa-arrow-right ms-2"></i>
                                </button>
                                <button type="submit" class="btn btn-success px-5 py-2 fw-bold" id="submitBtn"
                                        style="display:none;">
                                    <i class="fas fa-save me-2"></i> Update Employee
                                </button>
                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            let currentTab = 0;
            const steps = document.querySelectorAll(".step-content");
            const stepIndicators = document.querySelectorAll(".step-item");

            showTab(currentTab);

            window.nextPrev = function (n) {
                if (n == 1 && !validateForm()) return false;
                currentTab = currentTab + n;
                if (currentTab >= steps.length) return false;
                showTab(currentTab);
                window.scrollTo(0, 0);
            }

            function showTab(n) {
                steps.forEach(s => s.classList.remove('active'));
                steps[n].classList.add('active');

                document.getElementById("prevBtn").style.display = (n == 0) ? "none" : "inline-block";

                if (n == (steps.length - 1)) {
                    document.getElementById("nextBtn").style.display = "none";
                    document.getElementById("submitBtn").style.display = "inline-block";
                } else {
                    document.getElementById("nextBtn").style.display = "inline-block";
                    document.getElementById("submitBtn").style.display = "none";
                }
                updateIndicators(n);
            }

            function validateForm() {
                let valid = true;
                const currentStepDiv = document.getElementsByClassName("step-content")[currentTab];
                const inputs = currentStepDiv.querySelectorAll("input[required], select[required]");

                for (let i = 0; i < inputs.length; i++) {
                    if (inputs[i].value.trim() === "") {
                        inputs[i].classList.add("is-invalid");
                        valid = false;
                    } else {
                        inputs[i].classList.remove("is-invalid");
                    }
                }
                return valid;
            }

            function updateIndicators(n) {
                stepIndicators.forEach((ind, idx) => {
                    ind.classList.remove('active');
                    if (idx < n) ind.classList.add('completed');
                    if (idx === n) {
                        ind.classList.remove('completed');
                        ind.classList.add('active');
                    }
                });
            }

            document.addEventListener('input', function (e) {
                if (e.target.classList.contains('is-invalid')) e.target.classList.remove('is-invalid');
            });
        });
    </script>
@endsection
