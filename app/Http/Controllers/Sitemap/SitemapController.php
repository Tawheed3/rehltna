<?php

namespace App\Http\Controllers\Sitemap;

use App\Http\Controllers\Controller;
use App\Models\CustomPage;
use App\Models\SiteMap;
use App\Models\Tenant;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Response;
use App\Models\Blog;
use App\Models\Offer;
use App\Models\Item;
use Illuminate\View\View;
use Symfony\Component\HttpFoundation\BinaryFileResponse;

class SitemapController extends Controller
{

    /**
     * Display a listing of the resource.
     */
    public function index(): view
    {
        $sitemaps = SiteMap::query()->paginate(10);
        return view('pages.sitemaps.index', compact('sitemaps'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            SiteMap::query()->create([
                'name' => $request->get('name'),
            ]);

            return redirect()->route('sitemaps.index')->with('success', 'Sitemap Created Successfully');

        } catch (\Exception $exception) {
            return back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $sitemap = SiteMap::query()->findOrFail($id);
            $sitemap->update([
                'name' => $request->get('name'),
            ]);

            return redirect()->route('sitemaps.index')->with('success', 'Sitemap Updated Successfully');

        } catch (\Exception $exception) {
            return back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        $sitemap = SiteMap::query()->findOrFail($id);
        $sitemap->delete();
        return redirect()->route('sitemaps.index')->with('success', 'Sitemap Deleted Successfully');
    }

    public function generateSitemap(): BinaryFileResponse
    {
        // Base site URL from settings
        $siteUrl = rtrim(getTenantInfo()?->site_url ?? url('/'), '/');

        $basePath = public_path('sitemaps');
        $baseUrl = $siteUrl . '/sitemaps';

        if (!file_exists($basePath)) {
            mkdir($basePath, 0777, true);
        }

        File::cleanDirectory($basePath);

        $sitemapFiles = [];

        // XML entry creator
        $createXmlEntry = function ($url, $lastmod) {
            return "
            <url>
                <loc>{$url}</loc>
                <lastmod>{$lastmod}</lastmod>
                <changefreq>weekly</changefreq>
                <priority>0.8</priority>
            </url>";
        };

        // Generic sitemap generator
        $generateSitemapForModel = function (
            $model,
            $name,
            $prefixUrl,
            $slugEnField,
            $slugArField
        ) use ($basePath, $baseUrl, &$sitemapFiles, $createXmlEntry, $siteUrl) {

            $items = $model::where('status', 1)->get();
            $chunks = $items->chunk(10);

            foreach ($chunks as $i => $chunk) {

                $entries = [];

                foreach ($chunk as $item) {

                    $lastmod = safeParseDate($item->updated_at)->toDateString();

                    // Web URLs only (NO API)
                    foreach ([$slugEnField, $slugArField] as $slugField) {
                        $slug = $item->{$slugField};
                        if ($slug) {
                            $url = "{$siteUrl}/{$prefixUrl}/{$slug}";
                            $entries[] = $createXmlEntry($url, $lastmod);
                        }
                    }
                }

                $xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
                $xml .= "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";
                $xml .= implode("\n", $entries);
                $xml .= "\n</urlset>";

                $fileName = "{$name}-" . ($i + 1) . ".xml";
                File::put("{$basePath}/{$fileName}", $xml);

                $sitemapFiles[] = "{$baseUrl}/{$fileName}";
            }
        };

        // Generate sitemaps
        $generateSitemapForModel(new Blog, 'blogs', 'blog', 'slug_en', 'slug_ar');
        $generateSitemapForModel(new Offer, 'offers', 'offer', 'slug_en', 'slug_ar');
        $generateSitemapForModel(new Item, 'items', 'item', 'slug_en', 'slug_ar');

        $pages = CustomPage::query()->where('status', 1)->get();

        $entries = [];
        foreach ($pages as $page) {
            $slug = $page->slug;
            if ($slug) {
                $url = "{$siteUrl}/{$slug}";
                $entries[] = $createXmlEntry($url, $page->updated_at->toDateString());
            }
        }

        $sitemaps = SiteMap::query()->get();
        foreach ($sitemaps as $sitemap) {
            $slug = $sitemap->name;
            if ($slug) {
                $url = "{$siteUrl}/{$slug}";
                $entries[] = $createXmlEntry($url, $sitemap->updated_at->toDateString());
            }
        }

        if (!empty($entries)) {
            $xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
            $xml .= "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";
            $xml .= implode("\n", $entries);
            $xml .= "\n</urlset>";

            $fileName = "pages-1.xml";
            File::put("{$basePath}/{$fileName}", $xml);
            $sitemapFiles[] = "{$baseUrl}/{$fileName}";
        }

        // Sitemap index
        $indexXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
        $indexXml .= "<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";

        foreach ($sitemapFiles as $file) {
            $indexXml .= "  <sitemap><loc>{$file}</loc></sitemap>\n";
        }

        $indexXml .= "</sitemapindex>";

        File::put(public_path('sitemap.xml'), $indexXml);

        return Response::file(public_path('sitemap.xml'));
    }

    public function generateWebsiteSitemap(): BinaryFileResponse
    {
        // 1. Get Base URL
        $siteUrl = rtrim(url('/'), '/');

        // 2. Setup Paths
        $basePath = public_path('sitemaps');
        $baseUrl = $siteUrl . '/sitemaps';

        if (!file_exists($basePath)) {
            mkdir($basePath, 0777, true);
        }

        File::cleanDirectory($basePath);

        $sitemapFiles = [];

        // 3. Get Active Languages (Dynamic)
        // This fetches ['ar', 'en', 'fr', ...] based on your settings
        $activeLangs = get_active_langs();

        // XML Entry Creator Helper
        $createXmlEntry = function ($url, $lastmod) {
            return "
        <url>
            <loc>{$url}</loc>
            <lastmod>{$lastmod}</lastmod>
            <changefreq>weekly</changefreq>
            <priority>0.8</priority>
        </url>";
        };

        // Generic Sitemap Generator Function
        $generateSitemapForModel = function ($model, $name, $prefixUrl)
        use ($basePath, $baseUrl, &$sitemapFiles, $createXmlEntry, $siteUrl, $activeLangs) {

            $items = $model::where('status', 1)->get();
            $chunks = $items->chunk(100); // Increased chunk size slightly for better IO

            foreach ($chunks as $i => $chunk) {
                $entries = [];

                foreach ($chunk as $item) {
                    $lastmod = safeParseDate($item->updated_at)->toDateString();

                    // Loop through ALL active languages
                    foreach ($activeLangs as $lang) {
                        // Construct column name dynamically: slug_en, slug_ar, slug_fr, etc.
                        $slugField = 'slug_' . $lang;

                        // Check if the item has a slug for this language
                        // We use isset/!empty to ensure the column exists and has value
                        if (!empty($item->{$slugField})) {
                            $slug = $item->{$slugField};

                            // Construct URL: domain.com/{lang}/{prefix}/{slug}
                            // Example: domain.com/ar/blog/post-title
                            $url = "{$siteUrl}/{$prefixUrl}/{$slug}";

                            $entries[] = $createXmlEntry($url, $lastmod);
                        }
                    }
                }

                if (!empty($entries)) {
                    $xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
                    $xml .= "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";
                    $xml .= implode("\n", $entries);
                    $xml .= "\n</urlset>";

                    $fileName = "{$name}-" . ($i + 1) . ".xml";
                    File::put("{$basePath}/{$fileName}", $xml);
                    $sitemapFiles[] = "{$baseUrl}/{$fileName}";
                }
            }
        };

        // ---------------------------------------------------------
        // Generate for Models (Dynamic Languages)
        // ---------------------------------------------------------

        // Blog (Matches slug_en, slug_ar, slug_fr...)
        $generateSitemapForModel(new Blog, 'blogs', 'blogs');

        // Items/Courses
        $generateSitemapForModel(new Item, 'courses', 'courses');


        // ---------------------------------------------------------
        // Custom Pages Logic (Adapted for Multi-lang)
        // ---------------------------------------------------------
        $pages = CustomPage::query()->where('status', 1)->get();
        $pageEntries = [];

        foreach ($pages as $page) {
            $lastmod = $page->updated_at->toDateString();
            // If CustomPage uses slug_ar, slug_en structure:
            $slugField = 'slug';
            // If the model has translated slugs
            if (!empty($page->{$slugField})) {
                $url = "{$siteUrl}/{$page->{$slugField}}";
                $pageEntries[] = $createXmlEntry($url, $lastmod);
            }
            // Fallback: If CustomPage table only has a single 'slug' column
            // but you want to generate it for all languages
            elseif (!empty($page->slug)) {
                $url = "{$siteUrl}/{$page->slug}";
                $pageEntries[] = $createXmlEntry($url, $lastmod);
            }

        }

        // ---------------------------------------------------------
        // Hardcoded SiteMap Table Logic
        // ---------------------------------------------------------
        $staticSitemaps = SiteMap::query()->get();
        foreach ($staticSitemaps as $sitemap) {
            // Assuming 'name' is the path like 'about-us'
            if ($sitemap->name) {
                // For static routes, we usually want to generate for all langs
                $cleanName = ltrim($sitemap->name, '/');
                $url = "{$siteUrl}/{$cleanName}";
                $pageEntries[] = $createXmlEntry($url, $sitemap->updated_at->toDateString());
            }
        }

        // Write Pages XML
        if (!empty($pageEntries)) {
            $xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
            $xml .= "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";
            $xml .= implode("\n", $pageEntries);
            $xml .= "\n</urlset>";

            $fileName = "pages-1.xml";
            File::put("{$basePath}/{$fileName}", $xml);
            $sitemapFiles[] = "{$baseUrl}/{$fileName}";
        }

        // ---------------------------------------------------------
        // Create Index File
        // ---------------------------------------------------------
        $indexXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
        $indexXml .= "<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";

        foreach ($sitemapFiles as $file) {
            $indexXml .= "  <sitemap><loc>{$file}</loc></sitemap>\n";
        }

        $indexXml .= "</sitemapindex>";

        File::put(public_path('sitemap.xml'), $indexXml);

        return Response::file(public_path('sitemap.xml'));
    }
}
