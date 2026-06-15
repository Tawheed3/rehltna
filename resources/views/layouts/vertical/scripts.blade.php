<!-- Back-to-top -->
<a href="#top" id="back-to-top"><i class="las la-angle-double-up"></i></a>
<!-- Jquery js-->
<script src="{{asset('assets/plugins/jquery/jquery.min.js')}}"></script>
<!-- Bootstrap js-->
<script src="{{asset('assets/plugins/bootstrap/js/popper.min.js')}}"></script>
<!-- Ionicons js-->
<script src="{{asset('assets/plugins/ionicons/ionicons.js')}}"></script>
<!-- Moment js -->
<script src="{{asset('assets/plugins/moment/moment.js')}}"></script>
<!-- Rating js-->
<script src="{{asset('assets/plugins/rating/jquery.rating-stars.js')}}"></script>
<script src="{{asset('assets/plugins/rating/jquery.barrating.js')}}"></script>
<!-- Sticky js -->
<script src="{{asset('assets/js/sticky.js')}}"></script>
<!-- Sidebar js -->
<script src="{{asset('assets/plugins/side-menu/sidemenu.js')}}"></script>
<script src="{{asset('assets/plugins/sidebar/sidebar-custom.js')}}"></script>
<!-- eva-icons js -->
<script src="{{asset('assets/plugins/eva-icons/eva-icons.min.js')}}"></script>

@yield('scripts')
<!-- custom js -->
<script src="{{asset('assets/js/custom.js')}}"></script>

<script src="{{asset('assets/plugins/bootstrap/js/bootstrap.bundle.min.js')}}"></script>
<!-- P-scroll js -->
<script src="{{asset('assets/plugins/perfect-scrollbar/perfect-scrollbar.min.js')}}"></script>
<script src="{{asset('assets/plugins/perfect-scrollbar/p-scroll.js')}}"></script>
<!-- Right-sidebar js -->
<script src="{{asset('assets/plugins/sidebar/sidebar.js')}}"></script>

<!-- Toastr JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script>
    @if(session('success'))
    toastr.success("{{ session('success') }}");
    @endif

    @if(session('error'))
    toastr.error("{{ session('error') }}");
    @endif

    @if(session('warning'))
    toastr.warning("{{ session('warning') }}");
    @endif

    @if(session('info'))
    toastr.info("{{ session('info') }}");
    @endif

    @if($errors->any())
        @foreach($errors->all() as $error)
        toastr.error("{{ $error }}");
        @endforeach
    @endif

</script>

<script> // Show Confirm Delete Form
    function confirmDelete() {
        const deleteBtns = document.querySelectorAll(".delete-btn");
        deleteBtns.forEach(btn => {
            btn.addEventListener("click", () => {
                document.getElementById("deleteForm").action = btn.dataset.route;
            });
        });
    }
</script>
