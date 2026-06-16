<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | {{ env('APP_NAME', 'Rehltna') }}</title>

    <link rel="icon" href="{{asset('assets/img/seo-img.png')}}" type="image/x-icon"/>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>

    <style>
        :root {
            --primary: #00768b;
            --primary-hover: #005f70;
            --secondary: #f4b223;
            --text-dark: #111827;
            --text-muted: #6b7280;
            --bg-light: #ffffff;
            --border-color: #e5e7eb;
            --input-focus-ring: rgba(0, 118, 139, 0.15);
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--bg-light);
            color: var(--text-dark);
            height: 100vh;
            overflow: hidden;
        }

        /* --- Split Layout --- */
        .auth-container {
            display: flex;
            height: 100vh;
        }

        /* Left Side: Form */
        .auth-form-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            position: relative;
            background-color: #ffffff;
            animation: fadeIn 0.8s ease-out;
            z-index: 10;
            box-shadow: 20px 0 50px rgba(0, 0, 0, 0.05);
        }

        .form-wrapper {
            width: 100%;
            max-width: 400px;
        }

        /* Right Side: The Masterpiece Background */
        .auth-brand-section {
            flex: 1.3;
            display: none;
            background: linear-gradient(135deg, #042f3d 0%, #005f70 100%);
            position: relative;
            overflow: hidden;
        }

        @media (min-width: 992px) {
            .auth-brand-section {
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 4rem;
                color: white;
            }
        }

        /* --- Magic Overlapping Shapes (Leaves/Waves) --- */
        .shape-petal {
            position: absolute;
            border-radius: 50% 0 50% 50%;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
            opacity: 0.9;
        }

        /* Top Right Waves */
        .petal-1 {
            width: 700px;
            height: 700px;
            background: linear-gradient(135deg, #004d5e, #003644);
            top: -250px;
            right: -150px;
            --rot: 15deg;
            animation: floatPetal 12s infinite ease-in-out;
            z-index: 1;
        }

        .petal-2 {
            width: 550px;
            height: 550px;
            background: linear-gradient(135deg, #0098b3, #00768b);
            top: -150px;
            right: 50px;
            --rot: 45deg;
            animation: floatPetal 14s infinite ease-in-out reverse;
            z-index: 2;
        }

        /* Bottom Left Waves */
        .petal-3 {
            width: 800px;
            height: 800px;
            background: linear-gradient(135deg, #00222b, #003d4c);
            bottom: -350px;
            left: -250px;
            border-radius: 50% 50% 50% 0; /* مقلوبة */
            --rot: -20deg;
            animation: floatPetal 15s infinite ease-in-out;
            z-index: 1;
        }

        .petal-4 {
            width: 500px;
            height: 500px;
            background: linear-gradient(135deg, #008e9d, #005f70);
            bottom: -150px;
            left: -50px;
            border-radius: 50% 50% 0 50%;
            --rot: -5deg;
            animation: floatPetal 10s infinite ease-in-out reverse;
            z-index: 2;
        }

        @keyframes floatPetal {
            0% {
                transform: translateY(0) rotate(var(--rot));
            }
            50% {
                transform: translateY(-25px) rotate(calc(var(--rot) + 8deg));
            }
            100% {
                transform: translateY(0) rotate(var(--rot));
            }
        }

        /* --- Line Art Overlay (Travel Theme) --- */
        .line-art-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 3;
            pointer-events: none;
            opacity: 0.45;
        }

        /* --- Typography & Elements --- */
        .auth-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }

        .auth-subtitle {
            color: var(--text-muted);
            font-size: 0.95rem;
            margin-bottom: 2rem;
        }

        .form-label {
            font-weight: 500;
            font-size: 0.875rem;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        /* Pro Inputs */
        .form-control {
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            color: var(--text-dark);
            background-color: #f9fafb;
            transition: all 0.2s ease-in-out;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05) inset;
        }

        .form-control:focus {
            background-color: #ffffff;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px var(--input-focus-ring);
            outline: none;
        }

        .form-control::placeholder {
            color: #9ca3af;
        }

        .field-icon {
            position: absolute;
            right: 15px;
            top: 42px;
            cursor: pointer;
            color: #9ca3af;
            font-size: 0.9rem;
            transition: color 0.2s;
        }

        .field-icon:hover {
            color: var(--primary);
        }

        /* Pro Button - Super Del3 */
        .btn-primary {
            position: relative;
            background: linear-gradient(135deg, var(--primary) 0%, #005f70 100%);
            color: white;
            font-weight: 600;
            font-size: 1.05rem;
            padding: 0.85rem 1.5rem;
            border-radius: 12px;
            border: none;
            width: 100%;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            box-shadow: 0 4px 15px rgba(0, 118, 139, 0.3);
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }

        /* Shine Effect */
        .btn-primary::after {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 50%;
            height: 100%;
            background: linear-gradient(to right, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.3) 50%, rgba(255, 255, 255, 0) 100%);
            transform: skewX(-25deg);
            animation: shine 4s infinite;
        }

        @keyframes shine {
            0% {
                left: -100%;
            }
            20% {
                left: 200%;
            }
            100% {
                left: 200%;
            }
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #005f70 0%, var(--primary) 100%);
            transform: translateY(-2px) scale(1.01);
            box-shadow: 0 10px 20px rgba(0, 118, 139, 0.4);
        }

        .btn-primary:active {
            transform: translateY(1px) scale(0.98);
            box-shadow: 0 2px 10px rgba(0, 118, 139, 0.3);
        }

        /* Icon Animation on Hover */
        .btn-primary i {
            transition: transform 0.3s ease;
        }

        .btn-primary:hover i {
            transform: translateX(5px);
        }

        .text-danger {
            font-size: 0.8rem;
            font-weight: 500;
            margin-top: 0.4rem;
            color: #ef4444 !important;
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

        /* Brand content styling */
        .brand-content {
            z-index: 10;
            text-align: center;
            background: rgba(0, 47, 61, 0.4);
            padding: 40px;
            border-radius: 20px;
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            max-width: 550px;
        }

        .brand-content h1 {
            font-weight: 700;
            font-size: 3.8rem;
            letter-spacing: -1px;
            margin-bottom: 1rem;
            text-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        }

        .brand-content p {
            font-size: 1.15rem;
            opacity: 0.9;
            margin: 0 auto;
            line-height: 1.7;
            font-weight: 300;
        }

        /* Logo Styling */
        .brand-logo {
            width: 200px;
            height: auto;
            margin-bottom: 1.5rem;
            animation: popIn 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
            opacity: 0;
            transform: scale(0.8);
        }

        @keyframes popIn {
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
    </style>
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
    </style>
</head>
<body>
<div id="global-loader">
    <div class="loader-content">
        <img src="{{ asset('rehltna.jpeg') }}" class="loader-logo" alt="Brand Logo">

        <div class="loader-ring"></div>
    </div>
</div>
<div class="auth-container">

    <div class="auth-form-section">
        <div class="form-wrapper">
            <div class="text-center">
                <img src="{{ asset('rehltna.jpeg') }}" alt="Rehltna Logo" class="brand-logo">
                <h2 class="auth-title">Welcome back</h2>
                <p class="auth-subtitle">Please enter your details to access the admin panel.</p>
            </div>

            <form action="{{ route('admin.login.submit') }}" method="POST">
                @csrf
                <div class="mb-4">
                    <label class="form-label" for="email">Email address</label>
                    <input type="email" name="email" id="email"
                           class="form-control @error('email') is-invalid @enderror"
                           value="{{ old('email') }}" placeholder="admin@rehltna.com" required autofocus>
                    @error('email')
                    <div class="text-danger"><i class="fas fa-info-circle me-1"></i>{{ $message }}</div>
                    @enderror
                </div>

                <div class="mb-4 position-relative">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" name="password" id="password"
                           class="form-control @error('password') is-invalid @enderror"
                           placeholder="••••••••" required>
                    <span toggle="#password" class="fas fa-eye field-icon toggle-password mt-2"></span>
                    @error('password')
                    <div class="text-danger"><i class="fas fa-info-circle me-1"></i>{{ $message }}</div>
                    @enderror
                </div>

                <div class="d-grid mt-5">
                    <button type="submit" class="btn btn-primary">
                        <span>Sign in</span>
                        <i class="fas fa-arrow-right"></i>
                    </button>
                </div>
            </form>

            <div class="mt-5 text-center" style="font-size: 0.85rem; color: #9ca3af;">
                &copy; {{ date('Y') }} {{ env('APP_NAME', 'Rehltna') }}. All rights reserved.
            </div>
        </div>
    </div>

    <div class="auth-brand-section">

        <div class="shape-petal petal-1"></div>
        <div class="shape-petal petal-2"></div>
        <div class="shape-petal petal-3"></div>
        <div class="shape-petal petal-4"></div>

        <svg class="line-art-overlay" viewBox="0 0 1000 1000" preserveAspectRatio="xMidYMid slice">
            <g transform="translate(150, 250) scale(0.8)" stroke="#ffffff" stroke-width="2" fill="none" opacity="0.6">
                <circle cx="0" cy="0" r="60" stroke-dasharray="4 4"/>
                <circle cx="0" cy="0" r="45" opacity="0.3"/>
                <path d="M0,-80 L0,80 M-80,0 L80,0"/>
                <path d="M0,-90 L15,-20 L90,0 L15,20 L0,90 L-15,20 L-90,0 L-15,-20 Z" fill="rgba(255,255,255,0.15)"/>
            </g>

            <path d="M 150,700 Q 400,300 600,600 T 950,250" fill="none" stroke="#ffffff" stroke-width="2"
                  stroke-dasharray="8 8" opacity="0.7"/>

            <g transform="translate(150, 700) scale(0.08) translate(-256, -512)" fill="#ffffff" opacity="0.9">
                <path
                    d="M256,0C153.755,0,70.573,83.182,70.573,185.426c0,126.888,165.939,313.167,173.004,321.035c6.636,7.391,18.222,7.378,24.846,0c7.065-7.868,173.004-194.147,173.004-321.035C441.425,83.182,358.244,0,256,0z M256,278.719 c-51.442,0-93.292-41.851-93.292-93.293S204.559,92.134,256,92.134s93.291,41.851,93.291,93.293S307.441,278.719,256,278.719z"/>
            </g>

            <g transform="translate(930, 230) rotate(50) scale(0.1)" fill="#ffffff" opacity="0.9">
                <path
                    d="M510,255c0-20.4-16.5-36.9-36.9-36.9H286.9L205.6,41.5C202,30.5,191.8,23,180.2,23h-34.6c-11.4,0-17.7,13.2-10.6,22.1l111.8,173H108.2l-38.4-57.5c-4.4-6.5-11.7-10.5-19.5-10.5H19c-10.4,0-16.7,11.5-11,20.5l45.4,70.9l-45.4,70.9c-5.7,9,0.6,20.5,11,20.5h31.3c7.8,0,15.1-4,19.5-10.5l38.4-57.5h138.6L96.2,466.8c-7,8.9-0.7,22.1,10.6,22.1h34.6c11.5,0,21.8-7.5,25.4-18.5l81.3-176.6h186.2C493.5,291.9,510,275.4,510,255z"/>
            </g>

            <g transform="translate(600, 580) scale(1.5)" stroke="#ffffff" fill="none" stroke-width="2" opacity="0.6">
                <path d="M0,40 L0,15 C0,0 20,-10 30,0 L30,40 Z"/>
                <path d="M30,40 L30,20 C30,10 45,5 50,20 L50,40 Z"/>
                <circle cx="15" cy="-10" r="2" fill="#ffffff"/>
                <line x1="0" y1="40" x2="50" y2="40"/>
            </g>
        </svg>

        <div class="brand-content">
            <h1>{{ env('APP_NAME', 'Rehltna') }}</h1>
            <p>Your comprehensive dashboard to manage content, track performance, and control your digital journey
                efficiently.</p>
        </div>
    </div>

</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<script>
    // Password Toggle
    $(".toggle-password").click(function () {
        const input = $($(this).attr("toggle"));
        const type = input.attr("type") === "password" ? "text" : "password";
        input.attr("type", type);
        $(this).toggleClass("fa-eye fa-eye-slash");
    });

    // Toastr Notifications
    toastr.options = {
        "closeButton": true,
        "progressBar": true,
        "positionClass": "toast-top-right",
        "timeOut": "4000",
    };

    @if(session('success')) toastr.success("{{ session('success') }}");
    @endif
    @if(session('error')) toastr.error("{{ session('error') }}");
    @endif
    @if(session('warning')) toastr.warning("{{ session('warning') }}");
    @endif
    @if(session('info')) toastr.info("{{ session('info') }}"); @endif


    $(window).on("load", function() {
        $("#global-loader").addClass("loader-hidden");
    });

</script>

</body>
</html>
