# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Rehltna** is a multi-tenant Laravel 12 admin dashboard. It manages content (blogs, news, events, galleries), e-commerce (items, orders, packages, coupons), job listings, medical/healthcare modules, lead capture, and marketing pixel injection (Facebook, TikTok, Google Analytics, GTM, Snapchat, Twitter, Pinterest). It includes AI-powered blog generation via Google Gemini and push notifications via Firebase FCM.

## Commands

```bash
# Start all dev services (server + queue + logs + Vite) concurrently
composer dev

# Run tests (SQLite in-memory)
composer test

# Format PHP code
php artisan pint

# Run migrations
php artisan migrate

# Generate API key
php artisan api-key:generate

# Frontend
npm run dev        # watch mode
npm run build      # production build

# Docker (Sail)
./vendor/bin/sail up -d   # MySQL on :3307, app on :80, Vite on :5173
```

## Architecture

### Multi-Tenancy (Spatie Multitenancy v4)

This is the most important architectural concept. There are two databases:

- **Landlord DB** (`DB_DATABASE=seo_dashboard`): stores `tenants`, admin users, global settings.
- **Tenant DBs**: one database per tenant, connection details stored in the `tenants` table (`db_host`, `db_port`, `db_name`, `db_username`, `db_password`).

**Activation flow:**
1. Admin logs in → `LoginController` calls `TenantController::activate()`.
2. `SetTenantConnection` middleware reads tenant from session and switches the active DB connection via `SwitchTenantDatabaseTask`.
3. All subsequent Eloquent queries hit the tenant database.

Most routes require an active tenant session. When debugging model-not-found issues, check whether the tenant is activated.

### Routing

Routes are split across four files:

| File | Purpose |
|---|---|
| `routes/web.php` | Redirects root to `/admin` |
| `routes/admin.php` | 50+ resource routes for the dashboard UI |
| `routes/api.php` | REST API under `/api/v1/` (protected by `ApiKeyMiddleware`) |
| `routes/console.php` | Artisan commands |

API routes require the `X-API-KEY` header and use `IdentifyTenant` middleware (not the session-based activation). Responses are forced to JSON via `ForceJsonResponseMiddleware`.

### Queue Jobs

The queue driver is database-backed. The following jobs run asynchronously — **a queue worker must be running** (`php artisan queue:work` or included via `composer dev`):

- `ImportItemsJob` / `ImportItemTypesJob` — Excel bulk imports via Maatwebsite
- `SendContactReplyJob` / `SendRegisterUserReplyJob` — email replies
- `GenerateBlogsFromAI` — Gemini AI content generation
- `SendPushNotificationJob` — Firebase FCM push notifications

Failed jobs are stored in `failed_jobs` with retry support.

### Key Services

- `app/Services/AIService.php` — wraps Google Gemini API (requires `GEMINI_API_KEY` in `.env`)
- `app/Services/FcmService.php` — wraps Firebase Cloud Messaging (requires Firebase credentials)
- `app/Http/Helpers.php` — global helper functions including `get_setting()` used throughout Blade views for pixel/feature flags

### Pixel Injection

Blade layouts conditionally inject tracking pixels based on `get_setting('facebook_pixel_enabled')` (and equivalent keys for each platform). Pixel IDs and enable/disable flags are stored in the tenant's settings table and managed via `/admin/settings`.

### Frontend

- **Vite** bundler with Tailwind CSS v4 (`@tailwindcss/vite`)
- Vanilla JS + Axios; Toastify for toast notifications
- Entry: `resources/js/app.js`, `resources/css/app.css`
- 60+ Blade templates in `resources/views/pages/`

## Key Environment Variables

| Variable | Purpose |
|---|---|
| `DB_DATABASE` | Landlord database name |
| `APP_TENANTS_SETTING` | Tenant feature flags |
| `APP_LANG` | `en`, `ar`, or `both` |
| `API_KEY` | Default API key for external access |
| `WEBSITE_URL` | Public-facing website URL |
| `GEMINI_API_KEY` | Google Gemini AI key |

## Deployment

`deploy.sh` uses `rsync` to push to `premium54.web-hosting.com` (user `rehltwoz`, path `~/admin.rehltna.com`, SSH port 21098), excluding `node_modules`, `vendor`, `.git`, logs, and uploads. Post-deploy it clears config, route, and view caches.
