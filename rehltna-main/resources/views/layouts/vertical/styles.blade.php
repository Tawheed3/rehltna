<link rel="icon" href="{{asset(getTenantInfo()->image)}}" type="image/x-icon"/>
<link href="{{asset('assets/plugins/icons/icons.css')}}" rel="stylesheet">
<link href="{{asset('assets/plugins/sidebar/sidebar.css')}}" rel="stylesheet">
<link href="{{asset('assets/plugins/perfect-scrollbar/p-scrollbar.css')}}" rel="stylesheet"/>

<link href="{{asset('assets/plugins/bootstrap/css/bootstrap.min.css')}}" rel="stylesheet">
<link rel="stylesheet" href="{{asset('assets/css/sidemenu.css')}}">
<link href="{{asset('assets/css/style.css')}}" rel="stylesheet">
<link href="{{asset('assets/css/boxed.css')}}" rel="stylesheet">
<link href="{{asset('assets/css/skin-modes.css')}}" rel="stylesheet"/>
<link href="{{asset('assets/css/animate.css')}}" rel="stylesheet">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css"/>

<style>
    body, h1, h2, h3, h4, h5, h6, p, a, span, div, input, button, select, textarea, label {
        font-family: 'Cairo', sans-serif !important;
    }

    .form-select {
        border: 1px solid #e0e6ed;
        border-radius: 8px;
        padding: 10px 35px 10px 15px;
        transition: all 0.2s;
        background-color: #fcfcfc;
        min-height: 46px;
        line-height: 1.5;
        appearance: none;
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M2 5l6 6 6-6'/%3e%3c/svg%3e");
        background-repeat: no-repeat;
        background-position: right 15px center;
        background-size: 16px 12px;
    }

    .form-control {
        border: 1px solid #e0e6ed;
        border-radius: 8px;
        padding: 10px 15px;
        transition: all 0.2s;
        background-color: #fcfcfc;
        min-height: 46px;
    }
</style>


@yield('styles')
