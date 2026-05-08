<?php

use App\Http\Controllers\Dashboard\{AiController,
    ApplyJobController,
    BlogController,
    CareerController,
    CareerTypeController,
    CategoryController,
    CityController,
    ClinicalPublicationController,
    ContactUsController,
    CountryController,
    CouponController,
    CustomPageController,
    DashboardController,
    DiseaseTypeController,
    EmployeeController,
    EventController,
    EventGalleryController,
    GalleryController,
    PointLogsController,
    ItemController,
    ItemTypeController,
    LeadController,
    LeadMagnetController,
    LeadMagnetTypeController,
    LoginController,
    MembersController,
    NewsController,
    NotificationController,
    NotificationTemplateController,
    OfferController,
    OrderController,
    PackageController,
    PatientEducationController,
    PaymentLinkController,
    PaymentMethodController,
    PortfolioCategoryController,
    PortfolioController,
    ProtocolController,
    RegisterUsersController,
    ResidencyProgramController,
    ResidencyUsersController,
    RoleController,
    SettingController,
    SliderController,
    StateController,
    SubscribeController,
    TenantController,
    TestimonialController,
    TypeOfferController};

use App\Http\Controllers\Sitemap\SitemapController;
use App\Http\Middleware\AdminOnly;
use App\Http\Middleware\SetTenantConnection;
use Illuminate\Support\Facades\Route;

Route::group([
    'prefix' => 'admin',
    'middleware' => 'web'
], function () {
#------------------- login Guest Users-------------------#
    Route::group([
        'controller' => LoginController::class,
        'middleware' => 'guest'
    ], function () {
        Route::get('/', 'loginForm')->name('admin.login.form');
        Route::post('/login', 'loginSubmit')->name('admin.login.submit');
    });

    Route::middleware(['auth'])->group(function () {

        Route::get('/tenants/activate/{id}', [TenantController::class, 'activate'])->name('tenants.activate'); #-------- Tenants Activation ---------#
        Route::resource('/tenants', TenantController::class)->middleware(AdminOnly::class);  #------------ Tenants => get -> create -> update -> delete -------------#
    });

#------------------------- Routes Auth Users Dashboard -----------------------#
    Route::middleware(['auth', SetTenantConnection::class])->group(function () {

        Route::post('/logout', [LoginController::class, 'logOut'])->name('admin.logout');  #------------ Logout -------------#
        Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');  #------------ Dashboard -------------#

        #--- Admin only ---#
        Route::get('/failed-jobs', [BlogController::class, 'failedJobs'])->name('blogs.failed.jobs')->middleware(AdminOnly::class);
        Route::post('/failed-jobs-retry/{id}', [BlogController::class, 'failedJobsRetry'])->name('blogs.failed.jobs.retry')->middleware(AdminOnly::class);

        #--- City quick-create (utility used from trip form, no extra permission needed) ---#
        Route::post('cities/quick-create', [CityController::class, 'quickCreate'])->name('cities.quick-create');

        #--- Healthcare sections (tenant-specific, no role gate) ---#
        Route::resource('/protocols', ProtocolController::class);
        Route::post('/protocols-change-status/{id}', [ProtocolController::class, 'protocolsChangeStatus'])->name('protocols.change.status');
        Route::post('/protocols-change-is-feature/{id}', [ProtocolController::class, 'protocolsChangeIsFeature'])->name('protocols.change.is_feature');
        Route::resource('/clinical-publications', ClinicalPublicationController::class);
        Route::post('/clinical-publications-change-status/{id}', [ClinicalPublicationController::class, 'clinicalPublicationsChangeStatus'])->name('clinical.publications.change.status');
        Route::post('/clinical-publications-change-is-feature/{id}', [ClinicalPublicationController::class, 'clinicalPublicationsChangeIsFeature'])->name('clinical.publications.change.is_feature');
        Route::resource('/disease-types', DiseaseTypeController::class);
        Route::resource('/patients', PatientEducationController::class);
        Route::post('/patients-change-status/{id}', [PatientEducationController::class, 'patientsChangeStatus'])->name('patients.change.status');
        Route::post('/patients-change-is-feature/{id}', [PatientEducationController::class, 'patientsChangeIsFeature'])->name('patients.change.is_feature');
        Route::resource('/residencies', ResidencyProgramController::class);
        Route::post('/residencies-change-status/{id}', [ResidencyProgramController::class, 'residenciesChangeStatus'])->name('residencies.change.status');
        Route::post('/residencies-change-is-feature/{id}', [ResidencyProgramController::class, 'residenciesChangeIsFeature'])->name('residencies.change.is_feature');

        #--- Blogs ---#
        Route::middleware('permission:manage_blogs')->group(function () {
            Route::resource('/categories', CategoryController::class);
            Route::resource('/blogs', BlogController::class);
            Route::post('/create-blogs-with-ai', [BlogController::class, 'createBlogsWithAi'])->name('create.blogs.with.ai');
            Route::post('/blogs-change-status/{id}', [BlogController::class, 'blogsChangeStatus'])->name('blogs.change.status');
            Route::post('/blogs-change-is-feature/{id}', [BlogController::class, 'blogsChangeIsFeature'])->name('blogs.change.is_feature');
        });

        #--- Offers ---#
        Route::middleware('permission:manage_offers')->group(function () {
            Route::resource('/type-offers', TypeOfferController::class);
            Route::resource('/offers', OfferController::class);
            Route::post('/offers-change-status/{id}', [OfferController::class, 'offersChangeStatus'])->name('offers.change.status');
            Route::post('/offers-change-is-feature/{id}', [OfferController::class, 'offersChangeIsFeature'])->name('offers.change.is_feature');
        });

        #--- Trips ---#
        Route::middleware('permission:manage_trips')->group(function () {
            Route::resource('/item-types', ItemTypeController::class);
            Route::post('/item-types-change-is-feature/{id}', [ItemTypeController::class, 'itemTypesChangeIsFeature'])->name('item.types.change.is_feature');
            Route::get('items/{id}/duplicate', [ItemController::class, 'duplicate'])->name('items.duplicate');
            Route::get('/items/upload', [ItemController::class, 'showUploadForm'])->name('items.upload.form');
            Route::post('/items/import', [ItemController::class, 'import'])->name('items.import');
            Route::resource('/items', ItemController::class);
            Route::post('/items-change-status/{id}', [ItemController::class, 'itemsChangeStatus'])->name('items.change.status');
            Route::post('/items-change-is-feature/{id}', [ItemController::class, 'itemsChangeIsFeature'])->name('items.change.is_feature');
            Route::post('items/change-out-of-stock/{id}', [ItemController::class, 'changeOutOfStock'])->name('items.change.out_of_stock');
            Route::post('items/{id}/send-notification', [ItemController::class, 'sendCustomNotification'])->name('items.send_notification');
            Route::post('/item-types-import-excel', [ItemTypeController::class, 'importExcel'])->name('item-types.import-excel');
            Route::post('/items-import-excel', [ItemController::class, 'importExcel'])->name('items.import-excel');
            Route::get('/export-item-types', [ItemTypeController::class, 'exportItemTypesExcel'])->name('item-types.export-excel');
            Route::get('/export-items-temp', [ItemController::class, 'exportItemsTempExcel'])->name('items.export-excel-temp');
            Route::get('/export-item-types-temp', [ItemTypeController::class, 'exportItemTypesTempExcel'])->name('item-types.export-excel-temp');
            Route::get('/export-item-types-error-uploaded', [ItemTypeController::class, 'exportItemTypesErrorUploadedExcel'])->name('item-types.export-excel-error-uploaded');
            Route::get('/export-items-error-uploaded', [ItemController::class, 'exportItemsErrorUploadedExcel'])->name('items.export-excel-error-uploaded');
        });

        #--- Testimonials & Reviews ---#
        Route::middleware('permission:manage_testimonials')->group(function () {
            Route::resource('/testimonials', TestimonialController::class);
            Route::post('/testimonials/bulk-delete', [TestimonialController::class, 'bulkDelete'])->name('testimonials.bulk-delete');
            Route::post('/testimonials/change-status/{id}', [TestimonialController::class, 'changeStatus'])->name('testimonials.change.status');
            Route::get('/reviews', [\App\Http\Controllers\Dashboard\ReviewController::class, 'index'])->name('reviews.index');
            Route::post('/reviews', [\App\Http\Controllers\Dashboard\ReviewController::class, 'store'])->name('reviews.store');
            Route::put('/reviews/{id}', [\App\Http\Controllers\Dashboard\ReviewController::class, 'update'])->name('reviews.update');
            Route::patch('/reviews/{id}/approve', [\App\Http\Controllers\Dashboard\ReviewController::class, 'approve'])->name('reviews.approve');
            Route::patch('/reviews/{id}/reject', [\App\Http\Controllers\Dashboard\ReviewController::class, 'reject'])->name('reviews.reject');
            Route::delete('/reviews/{id}', [\App\Http\Controllers\Dashboard\ReviewController::class, 'destroy'])->name('reviews.destroy');
        });

        #--- Leads ---#
        Route::middleware('permission:manage_leads')->group(function () {
            Route::resource('/lead-magnet-types', LeadMagnetTypeController::class);
            Route::resource('/lead-magnets', LeadMagnetController::class);
            Route::resource('/leads', LeadController::class);
            Route::post('/lead-magnets-change-status/{id}', [LeadMagnetController::class, 'changeStatus'])->name('lead-magnets.change.status');
        });

        #--- Contact Us ---#
        Route::middleware('permission:manage_contact_us')->group(function () {
            Route::get('/contact-us', [ContactUsController::class, 'index'])->name('contact-us.index');
            Route::delete('/contact-us/destroy/{id}', [ContactUsController::class, 'destroy'])->name('contact-us.destroy');
            Route::post('/contact-us/bulk-delete', [ContactUsController::class, 'bulkDelete'])->name('contact-us.bulk-delete');
            Route::post('/contact-us/reply/{id}', [ContactUsController::class, 'replyMessage'])->name('contact-us.reply');
            Route::get('/export-contact-us', [ContactUsController::class, 'exportContactUsExcel'])->name('contact-us.export-excel');
        });

        #--- Sliders & Members ---#
        Route::middleware('permission:manage_sliders')->group(function () {
            Route::resource('/sliders', SliderController::class);
            Route::post('/sliders-change-status/{id}', [SliderController::class, 'SlidersChangeStatus'])->name('sliders.change.status');
            Route::resource('/members', MembersController::class);
            Route::post('/members-change-status/{id}', [MembersController::class, 'membersChangeStatus'])->name('members.change.status');
        });

        #--- Careers ---#
        Route::middleware('permission:manage_careers')->group(function () {
            Route::resource('/career-types', CareerTypeController::class);
            Route::resource('/careers', CareerController::class);
            Route::post('/careers-change-status/{id}', [CareerController::class, 'CareersChangeStatus'])->name('careers.change.status');
            Route::resource('/apply-jobs', ApplyJobController::class);
        });

        #--- Custom Pages ---#
        Route::middleware('permission:manage_custom_pages')->group(function () {
            Route::resource('/sitemaps', SitemapController::class);
            Route::get('/generate-sitemap', [SitemapController::class, 'generateSitemap'])->name('sitemaps');
            Route::resource('/custom-pages', CustomPageController::class);
            Route::post('/pages-change-status/{id}', [CustomPageController::class, 'pagesChangeStatus'])->name('pages.change.status');
            Route::get('/pages/preview/{id}', [CustomPageController::class, 'preview'])->name('custom-pages.preview');
            Route::resource('/portfolios', PortfolioController::class);
            Route::resource('/portfolio-categories', PortfolioCategoryController::class);
            Route::post('/portfolios-change-status/{id}', [PortfolioController::class, 'portfoliosChangeStatus'])->name('portfolios.change.status');
        });

        #--- Subscribers ---#
        Route::middleware('permission:manage_subscribers')->group(function () {
            Route::resource('/subscribes', SubscribeController::class);
            Route::post('/subscribes/bulk-delete', [SubscribeController::class, 'bulkDelete'])->name('subscribes.bulk-delete');
            Route::get('/export-subscribers', [SubscribeController::class, 'exportSubscribeExcel'])->name('subscribes.export-excel');
        });

        #--- Payment Methods ---#
        Route::middleware('permission:manage_payment_methods')->group(function () {
            Route::resource('/payment-methods', PaymentMethodController::class);
            Route::post('/payment-methods-change-status/{id}', [PaymentMethodController::class, 'paymentMethodChangeStatus'])->name('payment.methods.change.status');
            Route::resource('/payment-links', PaymentLinkController::class);
            Route::post('payment-links/create-from-user/{id}', [PaymentLinkController::class, 'storeFromRegisterUser'])->name('payment-links.storeFromRegister');
        });

        #--- Coupons ---#
        Route::middleware('permission:manage_coupons')->group(function () {
            Route::resource('coupons', CouponController::class);
            Route::post('coupons/change-status/{id}', [CouponController::class, 'changeStatus'])->name('coupons.change.status');
        });

        #--- Orders ---#
        Route::middleware('permission:manage_orders')->group(function () {
            Route::resource('orders', OrderController::class);
            Route::post('orders/{id}/status', [OrderController::class, 'updateStatus'])->name('orders.update.status');
        });

        #--- Locations ---#
        Route::middleware('permission:manage_locations')->group(function () {
            Route::resource('countries', CountryController::class);
            Route::post('countries/change-status/{id}', [CountryController::class, 'countryChangeStatus'])->name('countries.change.status');
            Route::resource('states', StateController::class);
            Route::post('states/change-status/{id}', [StateController::class, 'stateChangeStatus'])->name('states.change.status');
            Route::resource('cities', CityController::class);
            Route::post('cities/change-status/{id}', [CityController::class, 'cityChangeStatus'])->name('cities.change.status');
        });

        #--- Events & Tourist Attractions ---#
        Route::middleware('permission:manage_events')->group(function () {
            Route::resource('/events', EventController::class);
            Route::post('/events-change-status/{id}', [EventController::class, 'eventsChangeStatus'])->name('events.change.status');
            Route::post('/events-change-is-feature/{id}', [EventController::class, 'eventsChangeIsFeature'])->name('events.change.is_feature');
            Route::resource('/events-galleries', EventGalleryController::class);
            Route::post('/events-galleries-change-status/{id}', [EventGalleryController::class, 'eventGalleryChangeStatus'])->name('events.galleries.change.status');
            Route::post('/events-galleries-change-is-feature/{id}', [EventGalleryController::class, 'eventGalleryChangeIsFeature'])->name('events.galleries.change.is_feature');
        });

        #--- News ---#
        Route::middleware('permission:manage_news')->group(function () {
            Route::resource('/news', NewsController::class);
            Route::post('/news-change-status/{id}', [NewsController::class, 'newsChangeStatus'])->name('news.change.status');
            Route::post('/news-change-is-feature/{id}', [NewsController::class, 'newsChangeIsFeature'])->name('news.change.is_feature');
        });

        #--- Customers & Users ---#
        Route::middleware('permission:manage_customers')->group(function () {
            Route::get('/register-users', [RegisterUsersController::class, 'index'])->name('register-users.index');
            Route::delete('/register-users/destroy/{id}', [RegisterUsersController::class, 'destroy'])->name('register-users.destroy');
            Route::post('/register-users/bulk-delete', [RegisterUsersController::class, 'bulkDelete'])->name('register-users.bulk-delete');
            Route::post('/register-users/reply/{id}', [RegisterUsersController::class, 'replyMessage'])->name('register-users.reply');
            Route::get('/residency-users', [ResidencyUsersController::class, 'index'])->name('residency-users.index');
            Route::delete('/residency-users/destroy/{id}', [ResidencyUsersController::class, 'destroy'])->name('residency-users.destroy');
            Route::post('/residency-users/bulk-delete', [ResidencyUsersController::class, 'bulkDelete'])->name('residency-users.bulk-delete');
            Route::post('residency-users/{id}/change-package', [ResidencyUsersController::class, 'changePackage'])->name('residency-users.change-package');
            Route::post('residency-users/{id}/update-points', [ResidencyUsersController::class, 'updatePoints'])->name('residency-users.update-points');
            Route::get('/point-logs', [PointLogsController::class, 'index'])->name('point-logs.index');
            Route::get('/point-logs/{id}/view-pdf', [PointLogsController::class, 'viewPdf'])->name('point-logs.view-pdf');
            Route::get('/point-logs/{id}/pdf', [PointLogsController::class, 'downloadPdf'])->name('point-logs.pdf');
            Route::resource('packages', PackageController::class);
        });

        #--- Notifications ---#
        Route::middleware('permission:manage_notifications')->group(function () {
            Route::get('/notifications', [NotificationController::class, 'index'])->name('notifications.index');
            Route::post('/notifications/send', [NotificationController::class, 'send'])->name('notifications.send');
            Route::get('/notification-templates', [NotificationTemplateController::class, 'index'])->name('notification-templates.index');
            Route::post('/notification-templates', [NotificationTemplateController::class, 'store'])->name('notification-templates.store');
            Route::delete('/notification-templates/{id}', [NotificationTemplateController::class, 'destroy'])->name('notification-templates.destroy');
            Route::put('/notification-templates/{id}', [NotificationTemplateController::class, 'update'])->name('notification-templates.update');
        });

        #--- Staff & Roles ---#
        Route::middleware('permission:manage_staff')->group(function () {
            Route::resource('employees', EmployeeController::class);
            Route::resource('roles', RoleController::class);
        });

        #--- Settings ---#
        Route::middleware('permission:manage_settings')->group(function () {
            Route::get('/social-integration', [SettingController::class, 'index'])->name('social.integration');
            Route::get('/settings', [SettingController::class, 'getSettings'])->name('get.settings');
            Route::post('/settings', [SettingController::class, 'updateOrCreateSettings'])->name('update.settings');
            Route::post('/social-integration', [SettingController::class, 'updateOrCreate'])->name('social.integration.update');
            Route::resource('/ai-integration', AiController::class);
        });

        #--- Etisalaty ---#
        Route::middleware('permission:manage_etisalaty')->group(function () {
            Route::get('/etisalaty', [\App\Http\Controllers\Dashboard\EtisalatyController::class, 'index'])->name('etisalaty.index');
            Route::delete('/etisalaty/{id}', [\App\Http\Controllers\Dashboard\EtisalatyController::class, 'destroy'])->name('etisalaty.destroy');
            Route::delete('/etisalaty/employee/{employeeId}/contacts', [\App\Http\Controllers\Dashboard\EtisalatyController::class, 'destroyByEmployee'])->name('etisalaty.destroy-by-employee');
        });

        Route::group(['prefix' => 'gallery', 'as' => 'gallery.'], function () {
            Route::get('/', [GalleryController::class, 'index'])->name('index');
            Route::post('/upload', [GalleryController::class, 'storeGallery'])->name('store');
            Route::delete('/{id}', [GalleryController::class, 'destroy'])->name('destroy');
        });

        Route::post('/gallery/move', [GalleryController::class, 'moveFile'])->name('gallery.move');
        Route::post('/folders/create', [GalleryController::class, 'storeFolder'])->name('folders.store');
        Route::delete('/folders/{id}', [GalleryController::class, 'destroyFolder'])->name('folders.destroy');
        Route::put('/gallery/folders/{id}', [GalleryController::class, 'updateFolder'])->name('folders.update');
        Route::get('/gallery/picker', [GalleryController::class, 'picker'])->name('gallery.picker');

    });
});
//Route::get('test-ai',function(){
//    $ai = new \App\Services\AIService();
//    return $ai->geminiAiModel('cars',2,'AIzaSyBLNwORmTKsg9xocGla7i3OCxGtYRAk2YY');
//});
Route::get('/download-images', function () {
    return app(\App\Http\Controllers\GoogleDriveController::class)->downloadFolderImages();
});
