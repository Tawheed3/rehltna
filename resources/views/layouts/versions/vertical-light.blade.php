<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="UTF-8">
    <meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=0'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="X-UA-Compatible" content="IE=9"/>

    <title> {{ env('APP_NAME') }} Panel </title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    @include('layouts.vertical.styles')
<style>
    /* =======================
   Premium Global Loader
   ======================= */
    #global-loader {
        position: fixed;
        z-index: 999999;
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: opacity 0.6s ease, visibility 0.6s ease;
    }

    .loader-content {
        position: relative;
        width: 130px;
        height: 130px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .loader-logo {
        max-width: 65px;
        max-height: 65px;
        z-index: 2;
        animation: pulse-logo 1.5s infinite ease-in-out;
        object-fit: contain;
    }

    .loader-ring {
        position: absolute;
        width: 100%;
        height: 100%;
        border-radius: 50%;
        border: 3px solid transparent;
        border-top-color: #5c9f86;
        border-bottom-color: #5c9f86;
        animation: spin-ring 2s linear infinite;
        z-index: 1;
        box-shadow: 0 0 20px rgba(92, 159, 134, 0.15);
    }

    .loader-ring::before {
        content: '';
        position: absolute;
        top: 10px;
        left: 10px;
        right: 10px;
        bottom: 10px;
        border-radius: 50%;
        border: 3px solid transparent;
        border-left-color: #f59e0b;
        border-right-color: #f59e0b;
        animation: spin-ring 1.5s linear infinite reverse;
    }

    @keyframes pulse-logo {
        0% { transform: scale(0.85); opacity: 0.7; }
        50% { transform: scale(1.1); opacity: 1; }
        100% { transform: scale(0.85); opacity: 0.7; }
    }

    @keyframes spin-ring {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    .loader-hidden {
        opacity: 0 !important;
        visibility: hidden !important;
    }

    @media (max-width: 767px) {
        body.app {
            overflow: visible !important;
            -webkit-overflow-scrolling: touch;
        }
        .page {
            overflow-x: hidden;
        }
    }
</style>
</head>

<body class="main-body app sidebar-mini">

<div id="global-loader">
    <div class="loader-content">
        <img src="{{ asset(getTenantInfo()->image ?? 'rehltna.jpeg') }}" class="loader-logo" alt="Brand Logo">

        <div class="loader-ring"></div>
    </div>
</div>
<div class="page">

    @include('layouts.vertical.app-sidebar')

    <div class='main-content app-content'>

        @include('layouts.vertical.main-header')

        <div class="container-fluid">

            @yield('content')

        </div>
    </div>
    @include('layouts.footer')

    @yield('modal')

</div>
@include('layouts.vertical.scripts')

</body>
</html>
