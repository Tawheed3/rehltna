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

        Route::get('/social-integration', [SettingController::class, 'index'])->name('social.integration');  #------------ Social Integration -------------#
        Route::get('/settings', [SettingController::class, 'getSettings'])->name('get.settings');  #------------ Settings -------------#
        Route::post('/settings', [SettingController::class, 'updateOrCreateSettings'])->name('update.settings');  #------------ Settings -------------#
        Route::post('/social-integration', [SettingController::class, 'updateOrCreate'])->name('social.integration.update');  #------------ Social Integration Update -------------#

        Route::resource('/ai-integration', AiController::class);  #------------ AI => get -> create -> update -> delete -------------#

        Route::resource('/categories', CategoryController::class);  #------------ Categories => get -> create -> update -> delete -------------#

        Route::resource('/blogs', BlogController::class);  #------------ Blogs => get -> create -> update -> delete -------------#
        Route::post('/create-blogs-with-ai', [BlogController::class, 'createBlogsWithAi'])->name('create.blogs.with.ai'); #------- Create Blogs with ai --------#
        Route::post('/blogs-change-status/{id}', [BlogController::class, 'blogsChangeStatus'])->name('blogs.change.status'); #-------- Blogs Change Status ---------#
        Route::post('/blogs-change-is-feature/{id}', [BlogController::class, 'blogsChangeIsFeature'])->name('blogs.change.is_feature'); #-------- Blogs Change Is Feature ---------#

        Route::get('/failed-jobs', [BlogController::class, 'failedJobs'])->name('blogs.failed.jobs')->middleware(AdminOnly::class); #----- Failed Jobs------#
        Route::post('/failed-jobs-retry/{id}', [BlogController::class, 'failedJobsRetry'])->name('blogs.failed.jobs.retry')->middleware(AdminOnly::class); #----- Failed Jobs Retry------#

        Route::resource('/type-offers', TypeOfferController::class);  #------------ TypeOffers => get -> create -> update -> delete -------------#

        Route::resource('/offers', OfferController::class);  #------------ Offers => get -> create -> update -> delete -------------#
        Route::post('/offers-change-status/{id}', [OfferController::class, 'offersChangeStatus'])->name('offers.change.status'); #-------- Offers Change Status ---------#
        Route::post('/offers-change-is-feature/{id}', [OfferController::class, 'offersChangeIsFeature'])->name('offers.change.is_feature'); #-------- Offers Change Is Feature ---------#

        Route::resource('/item-types', ItemTypeController::class);  #------------ ItemType => get -> create -> update -> delete -------------#
        Route::post('/item-types-change-is-feature/{id}', [ItemTypeController::class, 'itemTypesChangeIsFeature'])->name('item.types.change.is_feature'); #-------- Item Types Change Is Feature ---------#
        Route::get('items/{id}/duplicate', [ItemController::class, 'duplicate'])->name('items.duplicate');

        // Lead Magnet Types (CRUD)
        Route::resource('/lead-magnet-types', LeadMagnetTypeController::class);
        // Lead Magnets (CRUD)
        Route::resource('/lead-magnets', LeadMagnetController::class);
        // Lead Magnets (CRUD)
        Route::resource('/leads', LeadController::class);

        // Testimonials CRUD
        Route::resource('/testimonials', TestimonialController::class);
        Route::post('/testimonials/bulk-delete', [TestimonialController::class, 'bulkDelete'])->name('testimonials.bulk-delete');
        Route::post('/testimonials/change-status/{id}', [TestimonialController::class, 'changeStatus'])->name('testimonials.change.status');

        // Change status
        Route::post('/lead-magnets-change-status/{id}', [LeadMagnetController::class, 'changeStatus'])->name('lead-magnets.change.status');

        // from server to upload
        Route::get('/items/upload', [ItemController::class, 'showUploadForm'])->name('items.upload.form');
        Route::post('/items/import', [ItemController::class, 'import'])->name('items.import');

        Route::resource('/items', ItemController::class);  #------------ Items => get -> create -> update -> delete -------------#
        Route::post('/items-change-status/{id}', [ItemController::class, 'itemsChangeStatus'])->name('items.change.status'); #-------- Items Change Status ---------#
        Route::post('/items-change-is-feature/{id}', [ItemController::class, 'itemsChangeIsFeature'])->name('items.change.is_feature'); #-------- Items Change Is Feature ---------#
        Route::post('items/change-out-of-stock/{id}', [ItemController::class, 'changeOutOfStock'])->name('items.change.out_of_stock');
        Route::post('items/{id}/send-notification', [ItemController::class, 'sendCustomNotification'])->name('items.send_notification');

        Route::get('/contact-us', [ContactUsController::class, 'index'])->name('contact-us.index'); #-------- get Contact Us ---------#
        Route::delete('/contact-us/destroy/{id}', [ContactUsController::class, 'destroy'])->name('contact-us.destroy'); #-------- Delete Contact Us ---------#
        Route::post('/contact-us/bulk-delete', [ContactUsController::class, 'bulkDelete'])->name('contact-us.bulk-delete'); #-------- Bulk Delete Contact Us ---------#
        Route::post('/contact-us/reply/{id}', [ContactUsController::class, 'replyMessage'])->name('contact-us.reply'); #-------- Reply Message Contact Us ---------#
        Route::get('/export-contact-us', [ContactUsController::class, 'exportContactUsExcel'])->name('contact-us.export-excel'); #-------- Export Contact Us ---------#

        Route::resource('/sliders', SliderController::class);  #------------ Sliders => get -> create -> update -> delete -------------#
        Route::post('/sliders-change-status/{id}', [SliderController::class, 'SlidersChangeStatus'])->name('sliders.change.status'); #-------- Sliders Change Status ---------#

        Route::resource('/career-types', CareerTypeController::class);  #------------ CareerTypes => get -> create -> update -> delete -------------#
        Route::resource('/careers', CareerController::class);  #------------ Careers => get -> create -> update -> delete -------------#
        Route::post('/careers-change-status/{id}', [CareerController::class, 'CareersChangeStatus'])->name('careers.change.status'); #-------- Careers Change Status ---------#

        Route::resource('/apply-jobs', ApplyJobController::class);  #------------ ApplyJobs => get -> create -> update -> delete -------------#

        Route::resource('/sitemaps', SitemapController::class);  #------------ Sitemaps => get -> create -> update -> delete -------------#
        Route::get('/generate-sitemap', [SitemapController::class, 'generateSitemap'])->name('sitemaps'); #----------- Generate Sitemap -----------#

        Route::resource('/custom-pages', CustomPageController::class);  #------------ Custom pages => get -> create -> update -> delete -------------#
        Route::post('/pages-change-status/{id}', [CustomPageController::class, 'pagesChangeStatus'])->name('pages.change.status'); #-------- Pages Change Status ---------#

        Route::resource('/subscribes', SubscribeController::class);  #------------ Subscribes => get -> delete -------------#
        Route::post('/subscribes/bulk-delete', [SubscribeController::class, 'bulkDelete'])->name('subscribes.bulk-delete'); #-------- Bulk Delete Subscribes ---------#
        Route::get('/export-subscribers', [SubscribeController::class, 'exportSubscribeExcel'])->name('subscribes.export-excel'); #-------- Export Subscribes ---------#

        Route::get('/export-item-types', [ItemTypeController::class, 'exportItemTypesExcel'])->name('item-types.export-excel'); #-------- Export Item Types ---------#
        Route::get('/export-items-temp', [ItemController::class, 'exportItemsTempExcel'])->name('items.export-excel-temp'); #-------- Export Items Temp ---------#
        Route::get('/export-item-types-temp', [ItemTypeController::class, 'exportItemTypesTempExcel'])->name('item-types.export-excel-temp'); #-------- Export Item Types Temp ---------#
        Route::get('/export-item-types-error-uploaded', [ItemTypeController::class, 'exportItemTypesErrorUploadedExcel'])->name('item-types.export-excel-error-uploaded'); #-------- Export Item Types Error Uploaded ---------#
        Route::get('/export-items-error-uploaded', [ItemController::class, 'exportItemsErrorUploadedExcel'])->name('items.export-excel-error-uploaded'); #-------- Export Items Error Uploaded ---------#

        Route::resource('/portfolios', PortfolioController::class);  #------------ Portfolios => get -> create -> update -> delete -------------#
        Route::resource('/portfolio-categories', PortfolioCategoryController::class);  #------------ Portfolio Categories => get -> create -> update -> delete -------------#
        Route::post('/portfolios-change-status/{id}', [PortfolioController::class, 'portfoliosChangeStatus'])->name('portfolios.change.status'); #-------- Portfolios Change Status ---------#

        Route::post('/item-types-import-excel', [ItemTypeController::class, 'importExcel'])->name('item-types.import-excel');#-------- Item Type Import Excel ---------#
        Route::post('/items-import-excel', [ItemController::class, 'importExcel'])->name('items.import-excel');#-------- Items Import Excel ---------#

        Route::resource('/payment-methods', PaymentMethodController::class);  #------------ Payment Methods => get -> update -------------#
        Route::post('/payment-methods-change-status/{id}', [PaymentMethodController::class, 'paymentMethodChangeStatus'])->name('payment.methods.change.status'); #-------- Payment Methods Change Status ---------#

        Route::resource('coupons', CouponController::class); #------------ Coupons => get -> create -> update -> delete -------------#
        Route::post('coupons/change-status/{id}', [CouponController::class, 'changeStatus'])->name('coupons.change.status'); #-------- Coupons Change Status ---------#

        Route::resource('orders', OrderController::class); #------------ Orders => get -> update -> delete -------------#
        Route::post('orders/{id}/status', [OrderController::class, 'updateStatus'])->name('orders.update.status'); #-------- Orders Change Status ---------#

        Route::get('/pages/preview/{id}', [CustomPageController::class, 'preview'])->name('custom-pages.preview'); #-------- Custom Page Preview ---------#

        Route::resource('countries', CountryController::class); #------------ countries => get -> create -> update -> delete -------------#
        Route::post('countries/change-status/{id}', [CountryController::class, 'countryChangeStatus'])->name('countries.change.status'); #-------- countries Change Status ---------#

        Route::resource('states', StateController::class); #------------ states => get -> create -> update -> delete -------------#
        Route::post('states/change-status/{id}', [StateController::class, 'stateChangeStatus'])->name('states.change.status'); #-------- states Change Status ---------#

        Route::resource('cities', CityController::class); #------------ cities => get -> create -> update -> delete -------------#
        Route::post('cities/change-status/{id}', [CityController::class, 'cityChangeStatus'])->name('cities.change.status'); #-------- cities Change Status ---------#

        Route::resource('/events', EventController::class);  #------------ Events => get -> create -> update -> delete -------------#
        Route::post('/events-change-status/{id}', [EventController::class, 'eventsChangeStatus'])->name('events.change.status'); #-------- Events Change Status ---------#
        Route::post('/events-change-is-feature/{id}', [EventController::class, 'eventsChangeIsFeature'])->name('events.change.is_feature'); #-------- Events Change Is Feature ---------#

        Route::resource('/events-galleries', EventGalleryController::class);  #------------ Events Galleries => get -> create -> update -> delete -------------#
        Route::post('/events-galleries-change-status/{id}', [EventGalleryController::class, 'eventGalleryChangeStatus'])->name('events.galleries.change.status'); #-------- Events Galleries Change Status ---------#
        Route::post('/events-galleries-change-is-feature/{id}', [EventGalleryController::class, 'eventGalleryChangeIsFeature'])->name('events.galleries.change.is_feature'); #-------- Events Galleries Change Is Feature ---------#

        Route::resource('/news', NewsController::class);  #------------ News => get -> create -> update -> delete -------------#
        Route::post('/news-change-status/{id}', [NewsController::class, 'newsChangeStatus'])->name('news.change.status'); #-------- News Change Status ---------#
        Route::post('/news-change-is-feature/{id}', [NewsController::class, 'newsChangeIsFeature'])->name('news.change.is_feature'); #-------- News Change Is Feature ---------#

        Route::resource('/members', MembersController::class);  #------------ Members => get -> create -> update -> delete -------------#
        Route::post('/members-change-status/{id}', [MembersController::class, 'membersChangeStatus'])->name('members.change.status'); #-------- Members Change Status ---------#

        Route::resource('/protocols', ProtocolController::class);  #------------ Protocols => get -> create -> update -> delete -------------#
        Route::post('/protocols-change-status/{id}', [ProtocolController::class, 'protocolsChangeStatus'])->name('protocols.change.status'); #-------- Protocols Change Status ---------#
        Route::post('/protocols-change-is-feature/{id}', [ProtocolController::class, 'protocolsChangeIsFeature'])->name('protocols.change.is_feature'); #-------- Protocols Change Is Feature ---------#

        Route::resource('/clinical-publications', ClinicalPublicationController::class);  #------------ Clinical Publications => get -> create -> update -> delete -------------#
        Route::post('/clinical-publications-change-status/{id}', [ClinicalPublicationController::class, 'clinicalPublicationsChangeStatus'])->name('clinical.publications.change.status'); #-------- Clinical Publications Change Status ---------#
        Route::post('/clinical-publications-change-is-feature/{id}', [ClinicalPublicationController::class, 'clinicalPublicationsChangeIsFeature'])->name('clinical.publications.change.is_feature'); #-------- Clinical Publications Change Is Feature ---------#

        Route::resource('/disease-types', DiseaseTypeController::class);  #------------ Disease Types => get -> create -> update -> delete -------------#

        Route::resource('/patients', PatientEducationController::class);  #------------ Patients Educations => get -> create -> update -> delete -------------#
        Route::post('/patients-change-status/{id}', [PatientEducationController::class, 'patientsChangeStatus'])->name('patients.change.status'); #-------- Patients Educations Change Status ---------#
        Route::post('/patients-change-is-feature/{id}', [PatientEducationController::class, 'patientsChangeIsFeature'])->name('patients.change.is_feature'); #-------- Patients Educations Change Is Feature ---------#

        Route::resource('/residencies', ResidencyProgramController::class);  #------------ Residencies Programs => get -> create -> update -> delete -------------#
        Route::post('/residencies-change-status/{id}', [ResidencyProgramController::class, 'residenciesChangeStatus'])->name('residencies.change.status'); #-------- Residencies Programs Change Status ---------#
        Route::post('/residencies-change-is-feature/{id}', [ResidencyProgramController::class, 'residenciesChangeIsFeature'])->name('residencies.change.is_feature'); #-------- Residencies Programs Change Is Feature ---------#

        Route::get('/register-users', [RegisterUsersController::class, 'index'])->name('register-users.index'); #-------- get Register Users ---------#
        Route::delete('/register-users/destroy/{id}', [RegisterUsersController::class, 'destroy'])->name('register-users.destroy'); #-------- Delete Register Users ---------#
        Route::post('/register-users/bulk-delete', [RegisterUsersController::class, 'bulkDelete'])->name('register-users.bulk-delete'); #-------- Bulk Delete Register Users ---------#
        Route::post('/register-users/reply/{id}', [RegisterUsersController::class, 'replyMessage'])->name('register-users.reply'); #-------- Reply Message Register Users ---------#

        Route::resource('/payment-links', PaymentLinkController::class);  #------------ Payment Links => get -> create -> update -> delete -------------#

        Route::get('/residency-users', [ResidencyUsersController::class, 'index'])->name('residency-users.index'); #-------- get Residency Users ---------#
        Route::delete('/residency-users/destroy/{id}', [ResidencyUsersController::class, 'destroy'])->name('residency-users.destroy'); #-------- Delete Residency Users ---------#
        Route::post('/residency-users/bulk-delete', [ResidencyUsersController::class, 'bulkDelete'])->name('residency-users.bulk-delete'); #-------- Bulk Delete Residency Users ---------#
        Route::post('residency-users/{id}/change-package', [ResidencyUsersController::class, 'changePackage'])->name('residency-users.change-package');
        Route::post('residency-users/{id}/update-points', [ResidencyUsersController::class, 'updatePoints'])->name('residency-users.update-points');

        Route::get('/point-logs', [PointLogsController::class, 'index'])->name('point-logs.index');
        Route::get('/point-logs/{id}/view-pdf', [PointLogsController::class, 'viewPdf'])->name('point-logs.view-pdf');
        Route::get('/point-logs/{id}/pdf', [PointLogsController::class, 'downloadPdf'])->name('point-logs.pdf');

        Route::post('payment-links/create-from-user/{id}', [PaymentLinkController::class, 'storeFromRegisterUser'])->name('payment-links.storeFromRegister');

        Route::get('/notifications', [NotificationController::class, 'index'])->name('notifications.index');
        Route::post('/notifications/send', [NotificationController::class, 'send'])->name('notifications.send');

        Route::resource('packages', PackageController::class);

        Route::get('/notification-templates', [NotificationTemplateController::class, 'index'])->name('notification-templates.index');
        Route::post('/notification-templates', [NotificationTemplateController::class, 'store'])->name('notification-templates.store');
        Route::delete('/notification-templates/{id}', [NotificationTemplateController::class, 'destroy'])->name('notification-templates.destroy');
        Route::put('/notification-templates/{id}', [NotificationTemplateController::class, 'update'])->name('notification-templates.update');

        Route::resource('employees', EmployeeController::class);
        Route::resource('roles', RoleController::class);

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
