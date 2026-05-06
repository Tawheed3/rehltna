<?php

use App\Http\Controllers\Sitemap\SitemapController;
use App\Http\Controllers\Api\{ApplyJobController,
    AuthController,
    BlogController,
    CareerController,
    CareerTypeController,
    CategoryController,
    ClinicalPublicationController,
    ContactUsController,
    CountryController,
    CustomPageController,
    DiseaseTypeController,
    EventController,
    EventGalleryController,
    ItemController,
    ItemTypeController,
    LeadController,
    LeadMagnetController,
    MembersController,
    NewsController,
    OfferController,
    OrderController,
    PatientEducationController,
    PaymentMethodController,
    PixelController,
    PortfolioCategoryController,
    PortfolioController,
    ProtocolController,
    ResidencyProgramController,
    SettingController,
    SliderController,
    SubscribeController,
    TenantController,
    TestimonialController,
    TypeOfferController,
    UserController,
    ReviewController
};

use App\Http\Middleware\{ApiKeyMiddleware, ForceJsonResponseMiddleware, IdentifyTenant};
use Illuminate\Support\Facades\Route;

# prefix => url/api/v1/....

Route::middleware([ForceJsonResponseMiddleware::class, ApiKeyMiddleware::class])->group(function () {

    Route::prefix('v1')->group(function () {
        Route::get('/tenants', [TenantController::class, 'index']); #---------- Tenants ----------#
    });

});

Route::middleware([ForceJsonResponseMiddleware::class, ApiKeyMiddleware::class, IdentifyTenant::class])->group(function () {

    Route::prefix('v1')->group(function () {

        #--------------------------- Users Info { Name & Phone } ---------------------------#
        Route::get('/users-info', [UserController::class, 'index']);

        #--------------------------- Auth ---------------------------#
        Route::post('register', [AuthController::class, 'register']);   #--------- Register ---------#
        Route::post('login', [AuthController::class, 'login']);  #--------- Login ---------#
        Route::post('forgot-password', [AuthController::class, 'forgotPassword']);  #--------- Forgot Password ---------#
        Route::post('reset-password', [AuthController::class, 'resetPassword']);   #--------- Reset Password ---------#

        #--------------------------- Pixels ---------------------------#
        Route::get('/pixels-scripts', [PixelController::class, 'getTrackingScripts']); #--------- Get All Pixels Scripts ---------#

        #---------------------------- Blogs ---------------------------#
        Route::get('/categories', [CategoryController::class, 'getCategories']); #--------- Get Categories ---------#
        Route::get('/blogs', [BlogController::class, 'getBlogs']); #--------- Get Blogs ---------#
        Route::get('/blogs-features', [BlogController::class, 'getBlogsFeatures']); #--------- Get Blogs Features ---------#
        Route::get('/blog/{slug}', [BlogController::class, 'getBlog']); #--------- Get Blog By Slug ---------#
        Route::get('/category-blogs/{id}', [BlogController::class, 'getBlogsByCategory']); #--------- Get Blogs By Category Id ---------#

        #---------------------------- Offers ---------------------------#
        Route::get('/offer-types', [TypeOfferController::class, 'getOfferTypes']); #--------- Get Offer Types ---------#
        Route::get('/offers', [OfferController::class, 'getOffers']); #--------- Get Offers ---------#
        Route::get('/offers-features', [OfferController::class, 'getOffersFeatures']); #--------- Get Offers Features ---------#
        Route::get('/offer/{slug}', [OfferController::class, 'getOffer']); #--------- Get Offer By Slug ---------#
        Route::get('/offer-type-offers/{id}', [OfferController::class, 'getOffersByOfferType']); #--------- Get Offers By OfferType Id ---------#

        #---------------------------- Items ---------------------------#
        Route::get('/item-types', [ItemTypeController::class, 'getItemTypes']); #--------- Get Item Types ---------#
        Route::get('/item-types-with-all-items', [ItemTypeController::class, 'getItemTypesWithAllItems']); #--------- Get Item Types With All Items ---------#
        Route::get('/item-types-features', [ItemTypeController::class, 'getItemTypesFeatures']); #--------- Get Item Types Features ---------#
        Route::get('/items', [ItemController::class, 'getItems']); #--------- Get Items ---------#
        Route::get('/items-features', [ItemController::class, 'getItemsFeatures']); #--------- Get Items Features ---------#
        Route::get('/item/{slug}', [ItemController::class, 'getItem']); #--------- Get Item By Slug ---------#
        Route::get('/item-type-items/{id}', [ItemController::class, 'getItemsByItemType']); #--------- Get Items By ItemType Id ---------#

        #---------------------------- ContactUs ---------------------------#
        Route::post('/contact-us', [ContactUsController::class, 'store']); #------------ Create Message ----------#

        #--------------------------- Sliders ---------------------------#
        Route::get('/sliders', [SliderController::class, 'getSliders']); #--------- Get All Sliders ---------#

        #---------------------------- Jobs ---------------------------#
        Route::get('/career-types', [CareerTypeController::class, 'getCareerTypes']); #--------- Get Career Types ---------#
        Route::get('/careers', [CareerController::class, 'getCareers']); #--------- Get Careers ---------#
        Route::get('/career/{slug}', [CareerController::class, 'getCareer']); #--------- Get Career By Slug ---------#
        Route::get('/career-type-careers/{id}', [CareerController::class, 'getCareersByCareerType']); #--------- Get Careers By CareerType Id ---------#
        #---------------------------- Apply Jobs ---------------------------#
        Route::post('/apply-jobs', [ApplyJobController::class, 'store']); #------------ Create Apply Jobs ----------#

        #---------------------------- Subscribes ---------------------------#
        Route::post('/subscribes', [SubscribeController::class, 'store']); #------------ Create Subscribe ----------#

        #---------------------------- Leads ---------------------------#
        Route::post('/leads', [LeadController::class, 'store']); #------------ Create Lead ----------#

        #---------------------------- LeadMagnets ---------------------------#
        Route::get('/lead-magnets', [LeadMagnetController::class, 'index']); #------------ get LeadMagnets ----------#

        #---------------------------- Testimonials ---------------------------#
        Route::get('/testimonials', [TestimonialController::class, 'index']); #------------ get Testimonials ----------#
        Route::post('/testimonials', [TestimonialController::class, 'store']); #------------ Create Testimonials ----------#

        #---------------------------- Custom Pages ---------------------------#
        Route::get('/custom-pages', [CustomPageController::class, 'getCustomPages']); #------------ Get Custom Pages ----------#

        #---------------------------- Portfolio ---------------------------#
        Route::get('/portfolio-categories', [PortfolioCategoryController::class, 'getCategories']); #--------- Get Portfolio Categories ---------#
        Route::get('/portfolios', [PortfolioController::class, 'getPortfolios']); #--------- Get Portfolios ---------#
        Route::get('/portfolio/{slug}', [PortfolioController::class, 'getPortfolio']); #--------- Get Portfolio By Slug ---------#
        Route::get('/category-portfolios/{id}', [PortfolioController::class, 'getPortfoliosByCategory']); #--------- Get Portfolios By Category Id ---------#

        #---------------------------- Settings ---------------------------#
        Route::get('/settings', [SettingController::class, 'index']); #------------ Get Settings ----------#

        #---------------------------- Sitemaps ---------------------------#
        Route::get('/generate-sitemap', [SitemapController::class, 'generateSitemap'])->name('sitemaps'); #----------- Generate Sitemap -----------#

        #---------------------------- Payment Methods ---------------------------#
        Route::get('/payment-methods', [PaymentMethodController::class, 'index']); #------------ Get Payment Methods ----------#

        #---------------------------- Orders & Checkout ---------------------------#
        Route::post('/checkout', [OrderController::class, 'checkout']); #--- Create Order ---#
        Route::post('/check-coupon', [OrderController::class, 'checkCoupon']); #--- Calculate Coupon ---#
        Route::post('/upload-receipt', [OrderController::class, 'uploadReceipt']); #--- Upload InstaPay Receipt ---#
        Route::get('/order/{id}', [OrderController::class, 'getOrderById']); #--- Get Order Info ---#

        #---------------------------- Events ---------------------------#
        Route::get('/events', [EventController::class, 'getEvents']); #--------- Get Events ---------#
        Route::get('/events-features', [EventController::class, 'getEventsFeatures']); #--------- Get Events Features ---------#
        Route::get('/event/{id}', [EventController::class, 'getEvent']); #--------- Get Event By Id ---------#

        #---------------------------- Events Galleries ---------------------------#
        Route::get('/events-galleries', [EventGalleryController::class, 'getEventsGalleries']); #--------- Get Events Galleries ---------#
        Route::get('/events-galleries-features', [EventGalleryController::class, 'getEventsGalleriesFeatures']); #--------- Get Events Galleries Features ---------#
        Route::get('/event-gallery/{id}', [EventGalleryController::class, 'getEventGallery']); #--------- Get Event Gallery By Id ---------#

        #---------------------------- News ---------------------------#
        Route::get('/news', [NewsController::class, 'getNews']); #--------- Get News ---------#
        Route::get('/news-features', [NewsController::class, 'getNewsFeatures']); #--------- Get News Features ---------#
        Route::get('/new/{id}', [NewsController::class, 'getNew']); #--------- Get New By Id ---------#

        #---------------------------- Members ---------------------------#
        Route::get('/members', [MembersController::class, 'getMembers']); #--------- Get Members ---------#
        Route::get('/member/{id}', [MembersController::class, 'getMember']); #--------- Get Member By Id ---------#

        #---------------------------- Protocols ---------------------------#
        Route::get('/protocols', [ProtocolController::class, 'getProtocols']); #--------- Get Protocols ---------#
        Route::get('/protocols-features', [ProtocolController::class, 'getProtocolsFeatures']); #--------- Get Protocols Features ---------#
        Route::get('/protocol/{slug}', [ProtocolController::class, 'getProtocol']); #--------- Get Protocol By Slug ---------#

        #---------------------------- Clinical Publications ---------------------------#
        Route::get('/clinical-publications', [ClinicalPublicationController::class, 'getClinicalPublications']); #--------- Get Clinical Publications ---------#
        Route::get('/clinical-publications-features', [ClinicalPublicationController::class, 'getClinicalPublicationsFeatures']); #--------- Get Clinical Publications Features ---------#
        Route::get('/clinical-publication/{slug}', [ClinicalPublicationController::class, 'getClinicalPublication']); #--------- Get Clinical Publication By Slug ---------#

        #---------------------------- Disease Types ---------------------------#
        Route::get('/disease-types', [DiseaseTypeController::class, 'getDiseaseTypes']); #--------- Get Disease Types  ---------#

        #---------------------------- Patients Educations ---------------------------#
        Route::get('/patients-educations', [PatientEducationController::class, 'getPatientsEducations']); #--------- Get Patients Educations ---------#
        Route::get('/patients-educations-features', [PatientEducationController::class, 'getPatientsEducationsFeatures']); #--------- Get Patients Educations Features ---------#
        Route::get('/patient-education/{slug}', [PatientEducationController::class, 'getPatient']); #--------- Get Patient Education By Slug ---------#
        Route::get('/patients-educations-by-disease-type/{id}', [PatientEducationController::class, 'getPatientsByDiseaseType']); #--------- Get Patients Educations By Disease Type Id ---------#

        #------------------- Countries && States && Cities -------------------#
        Route::controller(CountryController::class)->group(function () {
            Route::get('/countries', 'getCountries'); // Get all active countries
            Route::get('/states/{countryId}', 'getStatesByCountryId'); // Get all active states by country ID
            Route::get('/cities/{stateId}', 'getCitiesByStateId'); // Get all active cities by state ID
        });

        #---------------------------- Reviews ---------------------------#
        Route::get('/items/{id}/reviews', [ReviewController::class, 'index']); #--------- Get Approved Reviews ---------#

        #---------------------------- Auth Routes ---------------------------#
        Route::middleware('auth:sanctum')->group(function () {

            Route::get('/profile', [AuthController::class, 'profile']); #--------- Profile ---------#
            Route::put('/profile', [AuthController::class, 'updateProfile']); #--------- Update Profile ---------#
            Route::post('/logout', [AuthController::class, 'logout']);  #--------- Logout ---------#
            Route::post('/update-fcm-token', [AuthController::class, 'updateFcmToken']);
            Route::post('/reviews', [ReviewController::class, 'store']); #--------- Submit Review ---------#

            #---------------------------- Residencies Programs ---------------------------#
            Route::get('/residencies-programs', [ResidencyProgramController::class, 'getResidenciesPrograms']); #--------- Get Residencies Programs ---------#
            Route::get('/residencies-programs-features', [ResidencyProgramController::class, 'getResidenciesProgramFeatures']); #--------- Get Residencies Programs Features ---------#
            Route::get('/residency-program/{slug}', [ResidencyProgramController::class, 'getResidency']); #--------- Get Residency Program By Slug ---------#
            Route::get('/residencies-programs-by-disease-type/{id}', [ResidencyProgramController::class, 'getResidenciesByDiseaseType']); #--------- Get Residencies Programs By Disease Type Id ---------#

        });

    });

});

Route::middleware(IdentifyTenant::class)->group(function () {
    Route::prefix('v1')->group(function () {
        // Named routes are required for the OrderController redirect logic
        Route::get('/payment/success', [OrderController::class, 'success'])->name('payment.success');
        Route::get('/payment/cancel', [OrderController::class, 'cancel'])->name('payment.cancel');
    });
});

Route::fallback(function () {
    return response()->json([
        'status' => 404,
        'message' => 'Resource not found.',
        'data' => null
    ]);
});
