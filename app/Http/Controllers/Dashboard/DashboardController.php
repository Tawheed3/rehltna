<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Blog;
use App\Models\Career;
use App\Models\ContactUs;
use App\Models\Coupon;
use App\Models\CustomPage;
use App\Models\Item;
use App\Models\Lead;
use App\Models\Offer;
use App\Models\Order;
use App\Models\Portfolio;
use App\Models\RegisterUsers;
use App\Models\ResidencyUser;
use App\Models\Review;
use App\Models\Slider;
use App\Models\Subscribe;
use App\Models\Testimonial;
use Illuminate\Contracts\View\View;

class DashboardController extends Controller
{
    public function index(): View
    {
        // ===== Blogs =====
        $blogsRaw = Blog::query()
            ->where('status', 1)
            ->whereYear('created_at', now()->year)
            ->selectRaw('MONTH(created_at) as month, COUNT(*) as total')
            ->groupBy('month')
            ->pluck('total', 'month')
            ->toArray();

        $blogsPerMonth = array_fill(1, 12, 0);
        foreach ($blogsRaw as $month => $count) {
            $blogsPerMonth[$month] = $count;
        }
        $blogsPerMonth = array_values($blogsPerMonth);

        // ===== Offers =====
        $offersRaw = Offer::query()
            ->where('status', 1)
            ->whereYear('created_at', now()->year)
            ->selectRaw('MONTH(created_at) as month, COUNT(*) as total')
            ->groupBy('month')
            ->pluck('total', 'month')
            ->toArray();

        $offersPerMonth = array_fill(1, 12, 0);
        foreach ($offersRaw as $month => $count) {
            $offersPerMonth[$month] = $count;
        }
        $offersPerMonth = array_values($offersPerMonth);

        // ===== Items =====
        $itemsRaw = Item::query()->when(!checkIfAdmin(), fn($query) => $query->where('user_id', auth()->id()))
            ->where('status', 1)
            ->whereYear('created_at', now()->year)
            ->selectRaw('MONTH(created_at) as month, COUNT(*) as total')
            ->groupBy('month')
            ->pluck('total', 'month')
            ->toArray();

        $itemsPerMonth = array_fill(1, 12, 0);
        foreach ($itemsRaw as $month => $count) {
            $itemsPerMonth[$month] = $count;
        }
        $itemsPerMonth = array_values($itemsPerMonth);

        // ===== Orders =====
        $ordersRaw = Order::query()
            ->whereYear('created_at', now()->year)
            ->selectRaw('MONTH(created_at) as month, COUNT(*) as total')
            ->groupBy('month')
            ->pluck('total', 'month')
            ->toArray();

        $ordersPerMonth = array_fill(1, 12, 0);
        foreach ($ordersRaw as $month => $count) {
            $ordersPerMonth[$month] = $count;
        }
        $ordersPerMonth = array_values($ordersPerMonth);


        // ===== Stats =====
        $stats = [
            'blogs' => ['count' => Blog::query()->count()],
            'offers' => ['count' => Offer::query()->count()],
            'items' => [
                'count' => Item::query()
                    ->when(!checkIfAdmin(), fn($query) => $query->where('user_id', auth()->id()))
                    ->count()
            ],
            'jobs' => ['count' => Career::query()->count()],
            'leads' => ['count' => Lead::query()->count()],
            'subscribes' => ['count' => Subscribe::query()->count()],
            'sliders' => ['count' => Slider::query()->count()],
            'portfolios' => ['count' => Portfolio::query()->count()],
            'testimonials' => ['count' => Testimonial::query()->count()],
            'custom_pages' => ['count' => CustomPage::query()->count()],
            'contact' => ['count' => ContactUs::query()->count()],
            'orders' => ['count' => Order::query()->count()],
            'register_users' => ['count' => RegisterUsers::query()->count()],
            'residency_users' => ['count' => ResidencyUser::query()->count()],
            'coupons' => ['count' => Coupon::query()->count()],
        ];

        $user = auth()->user();
        $pendingOrders  = $user->hasPermission('manage_orders')  ? Order::query()->where('payment_status', 'reviewing')->count()  : null;
        $pendingReviews = $user->hasPermission('manage_trips')    ? Review::query()->where('status', 'pending')->count()           : null;

        return view('pages.dashboard', [
            'stats' => $stats,
            'latestBlogs' => Blog::query()->where('status', 1)->latest()->take(3)->get(),
            'latestOffers' => Offer::query()->where('status', 1)->latest()->take(3)->get(),
            'latestItems' => Item::query()->where('status', 1)->latest()->take(3)->get(),
            'months' => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            'blogsPerMonth' => $blogsPerMonth,
            'offersPerMonth' => $offersPerMonth,
            'itemsPerMonth' => $itemsPerMonth,
            'ordersPerMonth' => $ordersPerMonth,
            'pendingOrders'  => $pendingOrders,
            'pendingReviews' => $pendingReviews,
        ]);
    }
}
