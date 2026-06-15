<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use Illuminate\Http\JsonResponse;


class PixelController extends Controller
{
    use ResponseTrait;

    public function getTrackingScripts(): JsonResponse
    {
        $scripts = [];
        // Facebook Pixel
        if (get_setting('facebook_pixel') == 1) {
            $id = get_setting('facebook_pixel_id');
            $scripts['facebook_pixel'] = <<<HTML
            <script>
                !function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod ?
                n.callMethod.apply(n,arguments) : n.queue.push(arguments)};
                if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
                n.queue=[];t=b.createElement(e);t.async=!0;
                t.src=v;s=b.getElementsByTagName(e)[0];
                s.parentNode.insertBefore(t,s)}(window, document,'script',
                'https://connect.facebook.net/en_US/fbevents.js');
                fbq('init', '$id');
                fbq('track', 'PageView');
            </script>
            <noscript><img height="1" width="1" style="display:none"
                src="https://www.facebook.com/tr?id=$id&ev=PageView&noscript=1"
            /></noscript>
            HTML;
        }

        // TikTok Pixel
        if (get_setting('tiktok_analytics') == 1) {
            $id = get_setting('tiktok_analytics_id');
            $scripts['tiktok_pixel'] = <<<HTML
            <script>
                !function(w,d,t){w.TiktokAnalyticsObject=t;var ttq=w[t]=w[t]||[];
                ttq.methods=["page","track","identify","instances","debug","on","off","once","ready","alias","group","enableCookie","disableCookie","holdConsent","revokeConsent","grantConsent"],
                ttq.setAndDefer=function(t,e){t[e]=function(){t.push([e].concat(Array.prototype.slice.call(arguments,0)))}};
                for(var i=0;i<ttq.methods.length;i++)ttq.setAndDefer(ttq,ttq.methods[i]);
                ttq.load=function(e,n){var r="https://analytics.tiktok.com/i18n/pixel/events.js";
                var o=n&&n.partner;ttq._i=ttq._i||{},ttq._i[e]=[],ttq._i[e]._u=r,ttq._t=ttq._t||{},ttq._t[e]=+new Date,
                ttq._o=ttq._o||{},ttq._o[e]=n||{};n=document.createElement("script");
                n.type="text/javascript",n.async=!0,n.src=r+"?sdkid="+e+"&lib="+t;
                e=document.getElementsByTagName("script")[0];e.parentNode.insertBefore(n,e)};
                ttq.load('$id'); ttq.page();
            </script>
            HTML;
        }

        // Google Analytics
        if (get_setting('google_analytics') == 1) {
            $id = get_setting('google_analytics_id');
            $scripts['google_analytics'] = <<<HTML
            <script async src="https://www.googletagmanager.com/gtag/js?id=$id"></script>
            <script>
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                gtag('js', new Date());
                gtag('config', '$id');
            </script>
            HTML;
        }

        // Google Tag Manager
        if (get_setting('google_manager') == 1) {
            $id = get_setting('google_manager_id');
            $scripts['google_tag_manager'] = <<<HTML
            <script>
                (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
                new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
                j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;
                j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;
                f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer', '$id');
            </script>
            HTML;
        }

        // Snapchat Pixel
        if (get_setting('snapchat_pixel') == 1) {
            $id = get_setting('snapchat_pixel_id');
            $scripts['snapchat_pixel'] = <<<HTML
            <script type='text/javascript'>
                (function(e,t,n){if(e.snaptr)return;var a=e.snaptr=function(){
                a.handleRequest?a.handleRequest.apply(a,arguments):a.queue.push(arguments)};
                a.queue=[];var s='script';r=t.createElement(s);r.async=!0;r.src=n;
                var u=t.getElementsByTagName(s)[0];u.parentNode.insertBefore(r,u);
                })(window,document,'https://sc-static.net/scevent.min.js');
                snaptr('init', '$id');
                snaptr('track', 'PAGE_VIEW');
            </script>
            HTML;
        }

        // Twitter Pixel
        if (get_setting('twitter_pixel') == 1) {
            $id = get_setting('twitter_pixel_id');
            $scripts['twitter_pixel'] = <<<HTML
            <script>
                !function(e,t,n,s,u,a){e.twq||(s=e.twq=function(){
                s.exe?s.exe.apply(s,arguments):s.queue.push(arguments)},
                s.version='1.1',s.queue=[],u=t.createElement(n),u.async=!0,
                u.src='https://static.ads-twitter.com/uwt.js',
                a=t.getElementsByTagName(n)[0],a.parentNode.insertBefore(u,a))}(window,document,'script');
                twq('init', '$id');
                twq('track', 'PageView');
            </script>
            HTML;
        }

        // Pinterest Tag
        if (get_setting('pinterest_tag') == 1) {
            $id = get_setting('pinterest_tag_id');
            $scripts['pinterest_tag'] = <<<HTML
            <script>
                !function(e){if(!window.pintrk){window.pintrk=function(){
                window.pintrk.queue.push(Array.prototype.slice.call(arguments))};
                var n=window.pintrk;n.queue=[],n.version="3.0";
                var t=document.createElement("script");
                t.async=!0,t.src=e;
                var r=document.getElementsByTagName("script")[0];
                r.parentNode.insertBefore(t,r)}}("https://s.pinimg.com/ct/core.js");
                pintrk('load', '$id');
                pintrk('page');
            </script>
            HTML;
        }

        return $this->responseMessage(200, 'success', $scripts);

    }

}
