@extends('layouts.app')

@section('styles')
    <style>
        /* Global Background */
        body {
            background-color: #f8fafc;
        }

        /* Deluxe Central Card */
        .upload-card {
            border: none;
            border-radius: 30px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.05);
            background: #fff;
            overflow: hidden;
            max-width: 800px;
            margin: 0 auto;
        }

        /* Hero Header Section */
        .hero-section {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            border-radius: 24px;
            padding: 45px 35px;
            margin-bottom: 35px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 20px 30px rgba(0, 0, 0, 0.12);
        }

        /* Dropzone Styling */
        .custom-dropzone {
            border: 3px dashed #e2e8f0;
            border-radius: 20px;
            padding: 50px 30px;
            text-align: center;
            background: #f8fafc;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
        }

        .custom-dropzone:hover {
            border-color: #4f46e5;
            background: #f5f3ff;
        }

        /* Form Control Fix - No Text Clipping */
        .form-control-deluxe {
            border-radius: 14px;
            padding: 12px 18px !important;
            border: 2px solid #f1f5f9;
            line-height: 1.6 !important;
            height: auto !important;
            font-weight: 600;
        }

        /* Stat Glass Card */
        .stat-glass-card {
            background: rgba(255, 255, 255, 0.1) !important;
            backdrop-filter: blur(12px) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            padding: 15px 25px;
            border-radius: 20px;
            min-width: 140px;
            text-align: center;
        }

        .btn-upload-now {
            background: #4f46e5 !important;
            color: white !important;
            border-radius: 15px !important;
            padding: 15px 40px !important;
            font-weight: 700 !important;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-upload-now:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(79, 70, 229, 0.3);
        }
    </style>
@endsection

@section('content')

    <div class="breadcrumb-header justify-content-between mb-4 mt-3">
        <div class="my-auto">
            <h4 class="content-title mb-0 fw-bold" style="color: #1e293b; letter-spacing: -0.8px; font-size: 1.7rem;">
                Course Bulk Upload
            </h4>
            <p class="text-muted mb-0 small fw-medium">Courses / <span class="text-primary">Data Import</span></p>
        </div>
    </div>

    <div class="hero-section">
        <div>
            <h3 class="mb-2 fw-bold" style="letter-spacing: -0.5px;">Knowledge Importer</h3>
            <p class="mb-0 opacity-75 fw-medium">Rapidly populate your course library by uploading your structured Excel
                or CSV files.</p>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <div class="stat-glass-card">
                <span
                    style="display: block; font-size: 0.7rem; text-transform: uppercase; letter-spacing: 1.2px; color: rgba(255, 255, 255, 0.8); margin-bottom: 4px; font-weight: 800;">System Ready</span>
                <div class="d-flex align-items-center justify-content-center gap-2">
                    <h4 class="mb-0 fw-bold text-white">Active</h4>
                    <i class="las la-check-circle text-success fs-4"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid">
        <div class="upload-card">
            <div class="p-5">
                {{-- Flash Messages --}}
                @if(session('success'))
                    <div class="alert alert-success border-0 shadow-sm rounded-4 p-3 mb-4">
                        <i class="las la-check-double me-2"></i> {{ session('success') }}
                    </div>
                @endif
                @if(session('error'))
                    <div class="alert alert-danger border-0 shadow-sm rounded-4 p-3 mb-4">
                        <i class="las la-exclamation-triangle me-2"></i> {{ session('error') }}
                    </div>
                @endif

                <form action="{{ route('items.import') }}" method="POST" enctype="multipart/form-data"
                      class="text-center">
                    @csrf

                    <div class="custom-dropzone mb-4" onclick="document.getElementById('fileInput').click();">
                        <div
                            style="background: rgba(79, 70, 229, 0.1); width: 80px; height: 80px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <i class="las la-cloud-upload-alt fs-1" style="color: #4f46e5;"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-2">Select Course Spreadsheet</h4>
                        <p class="text-muted mb-4">Click to browse or drag and drop your file here</p>

                        <input type="file" name="file" id="fileInput" class="form-control form-control-deluxe" required
                               style="max-width: 400px; margin: 0 auto;">
                    </div>

                    <div class="bg-light rounded-4 p-4 mb-4 text-start">
                        <h6 class="fw-bold text-dark"><i class="las la-info-circle me-2 text-primary"></i> Upload
                            Instructions:</h6>
                        <ul class="small text-muted mb-0 mt-2">
                            <li>Supported formats: <strong>.xlsx, .xls, .csv</strong></li>
                            <li>Ensure that "Course Title" and "Category" columns are not empty.</li>
                            <li>Maximum file size allowed is <strong>10MB</strong>.</li>
                        </ul>
                    </div>

                    <button type="submit" class="btn btn-upload-now shadow-lg">
                        <i class="las la-file-import me-2"></i> Process and Create Courses
                    </button>
                </form>
            </div>
        </div>
    </div>

@endsection

@section('scripts')
    <script>
        // Optional: Update text when file is selected
        document.getElementById('fileInput').addEventListener('change', function (e) {
            let fileName = e.target.files[0].name;
            if (fileName) {
                toastr.info("File selected: " + fileName);
            }
        });
    </script>
@endsection
