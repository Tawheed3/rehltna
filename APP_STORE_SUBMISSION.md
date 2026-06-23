# App Store Submission Guide — رحلتنا (Rehltna)

Complete reference for submitting **رحلتنا** to the Apple App Store via App Store Connect.
Copy/paste the metadata fields directly. Everything in this doc is derived from the actual app
(Flutter, bundle id `rehltna`, API `https://admin.rehltna.com/api/v1`).

> ✅ **Bundle ID set to `com.rehltna.app`** in the Xcode project (app target + `RunnerTests`).
> One follow-up remains: the Firebase iOS app is still registered under the old id `rehltna`,
> so push notifications won't work until you register `com.rehltna.app` in Firebase and replace
> `GoogleService-Info.plist` (see [§9 Pre-Submission Checklist](#9-pre-submission-checklist)).

---

## 1. App Information

| Field | Value |
|---|---|
| **App Name (display)** | رحلتنا |
| **App Name (App Store listing)** | رحلتنا - Rehltna |
| **Subtitle (max 30 chars)** | رحلات ومناسك وعروض السفر |
| **Bundle ID** | `com.rehltna.app` ✅ set in Xcode |
| **SKU** | `rehltna-ios-001` |
| **Primary Category** | Travel |
| **Secondary Category** | Lifestyle |
| **Primary Language** | Arabic (ar) |
| **Additional Languages** | English (en) — if localized |
| **Version** | 1.0.0 |
| **Build** | 1 |
| **Price** | Free |
| **Availability** | Saudi Arabia, Egypt, UAE, Kuwait, Qatar, Bahrain, Oman, Jordan *(adjust to your markets)* |
| **Content Rights** | Does **not** contain, show, or access third-party content |
| **Age Rating** | 4+ |

---

## 2. Description (Arabic — Primary)

**Promotional Text (max 170 chars):**
```
احجز رحلتك القادمة بسهولة. استكشف باقات السفر والعروض الخاصة، حدد اتجاه القبلة، واحسب العملات — كل ما تحتاجه لرحلة مريحة في تطبيق واحد.
```

**Description (max 4000 chars):**
```
رحلتنا هو رفيقك المثالي لتنظيم وحجز رحلاتك بكل سهولة وأمان.

استكشف مجموعة واسعة من باقات السفر والرحلات المنظمة، وتصفّح العروض الخاصة والخصومات الحصرية، واحجز رحلتك المقبلة في خطوات بسيطة.

✦ المميزات الرئيسية:

• تصفّح الرحلات والباقات
استعرض الرحلات حسب التصنيفات والوجهات، وشاهد التفاصيل الكاملة لكل باقة بما في ذلك البرنامج والصور والأسعار.

• العروض الخاصة
لا تفوّت أحدث العروض والخصومات على باقات السفر المختارة.

• البحث الذكي
اعثر على الرحلة المناسبة لك بسرعة من خلال البحث المباشر.

• الحجز والدفع
احجز رحلتك بسهولة واطلع على تفاصيل التحويل البنكي لإتمام عملية الدفع.

• اتجاه القبلة
بوصلة دقيقة لتحديد اتجاه القبلة أينما كنت، باستخدام موقعك ومستشعرات الجهاز.

• البحث عن المساجد
اعثر على أقرب المساجد إليك أثناء سفرك.

• حاسبة العملات
احسب أسعار الصرف بسهولة قبل وأثناء رحلتك.

• رحلاتي السابقة
راجع سجلّ رحلاتك ووثائقها في أي وقت.

• الإشعارات
ابقَ على اطّلاع بآخر العروض وتحديثات الحجوزات عبر الإشعارات الفورية.

• ملفك الشخصي
أنشئ حسابك وأدِر معلوماتك الشخصية بأمان.

حمّل تطبيق رحلتنا الآن وابدأ رحلتك القادمة بثقة وراحة بال.
```

**Keywords (max 100 chars, comma-separated, no spaces):**
```
رحلات,سفر,حجز,عروض,قبلة,مساجد,سياحة,باقات,عمرة,حج,تذاكر,فنادق,وجهات,صرف
```

---

## 3. Description (English — if localized)

**Promotional Text:**
```
Book your next trip with ease. Explore travel packages and special offers, find the Qibla direction, and convert currencies — all in one app.
```

**Description:**
```
Rehltna is your perfect companion for planning and booking trips easily and securely.

Browse a wide range of organized travel packages and trips, explore exclusive special offers and discounts, and book your next journey in a few simple steps.

KEY FEATURES

• Browse Trips & Packages
Explore trips by category and destination, and view full details for each package including itinerary, photos, and pricing.

• Special Offers
Never miss the latest deals and discounts on selected travel packages.

• Smart Search
Quickly find the right trip with instant search.

• Booking & Payment
Book your trip easily and view bank transfer details to complete your payment.

• Qibla Direction
An accurate compass to find the Qibla direction wherever you are, using your location and device sensors.

• Mosque Finder
Find the nearest mosques while traveling.

• Currency Calculator
Easily calculate exchange rates before and during your trip.

• My Past Trips
Review your trip history and documents anytime.

• Notifications
Stay updated with the latest offers and booking updates via push notifications.

• Profile
Create your account and manage your personal information securely.

Download Rehltna now and start your next journey with confidence and peace of mind.
```

**Keywords:**
```
travel,trips,booking,offers,qibla,mosque,tourism,packages,umrah,hajj,flights,hotels,currency
```

---

## 4. What's New (Release Notes — v1.0.0)

**Arabic:**
```
الإصدار الأول من تطبيق رحلتنا 🎉

• تصفّح الرحلات والباقات حسب التصنيفات
• العروض والخصومات الخاصة
• الحجز وتفاصيل الدفع بالتحويل البنكي
• بوصلة اتجاه القبلة والبحث عن المساجد
• حاسبة العملات
• إشعارات فورية بالعروض والحجوزات

نسعد بملاحظاتكم لتحسين التطبيق.
```

**English:**
```
Welcome to the first release of Rehltna 🎉

• Browse trips and packages by category
• Special offers and discounts
• Booking and bank transfer payment details
• Qibla compass and mosque finder
• Currency calculator
• Push notifications for offers and bookings

We'd love your feedback to keep improving.
```

---

## 5. App Privacy ("Nutrition Label") — App Store Connect Questionnaire

Fill this under **App Store Connect → App Privacy**. Answers below reflect the app's actual data flows
(account creation, push tokens, location for Qibla, optional profile photo, contacts).

> Review and confirm each item against your backend before submitting. If a data type is **not**
> actually collected/transmitted, mark it "Not Collected".

### Data Used to Track You
- **None** (assuming no third-party ad/analytics SDK tracks across apps).

### Data Linked to You (tied to user account)
| Data Type | Purpose | Notes |
|---|---|---|
| Name | App Functionality | Account / profile |
| Email Address | App Functionality | Account / login |
| Phone Number | App Functionality | Collected at signup for contact |
| User ID | App Functionality | Account identity |
| Photos | App Functionality | Optional profile picture |
| Purchase History | App Functionality | Trip bookings / orders |

### Data Not Linked to You
| Data Type | Purpose | Notes |
|---|---|---|
| Coarse/Precise Location | App Functionality | Qibla direction & mosque finder — used on-device, not stored to profile |
| Device ID / Push Token | App Functionality | Firebase Cloud Messaging for notifications |
| Crash/Performance Data | Analytics | Only if you ship Firebase Crashlytics/Analytics |

### Contacts
- ⚠️ **`flutter_contacts` is declared in `pubspec.yaml` but is NOT used anywhere in `lib/`**
  (no import, no `Permission.contacts`, no `FlutterContacts` call — verified by code search).
- **Action: remove `flutter_contacts` from `pubspec.yaml`** before submission. Shipping an unused
  contacts-access SDK is a common **Guideline 5.1.1** rejection ("requests data it doesn't use").
- Do **not** declare Contacts in the privacy questionnaire, and do **not** add
  `NSContactsUsageDescription` — neither is needed once the package is removed.

---

## 6. Permission Usage Strings (already in Info.plist)

These purpose strings ship in `ios/Runner/Info.plist`. Confirm each maps to a real feature.

| Key | Current String (AR) | Feature |
|---|---|---|
| `NSCameraUsageDescription` | يحتاج التطبيق إلى الكاميرا لالتقاط صورة الملف الشخصي | Profile photo capture |
| `NSPhotoLibraryUsageDescription` | يحتاج التطبيق إلى مكتبة الصور لاختيار صورة الملف الشخصي | Profile photo selection |
| `NSLocationWhenInUseUsageDescription` | يحتاج التطبيق إلى موقعك لتحديد اتجاه القبلة بدقة | Qibla / mosque finder |
| `NSMotionUsageDescription` | يحتاج التطبيق إلى البوصلة لتحديد اتجاه القبلة | Qibla compass |

> ✅ These four strings cover every permission the app actually uses. **Do not** add
> `NSContactsUsageDescription` — the `flutter_contacts` package is unused and should be removed
> from `pubspec.yaml` (see [§5 Contacts](#contacts)).

---

## 7. App Review Information

| Field | Value |
|---|---|
| **Sign-in required** | Yes |
| **Demo Account — Email** | `reviewer@rehltna.com` *(provide a real working test account)* |
| **Demo Account — Password** | *(working password)* |
| **Contact First Name** | *(your name)* |
| **Contact Last Name** | *(your name)* |
| **Contact Phone** | *(reachable number)* |
| **Contact Email** | mazeneldeeb9@gmail.com |

**Notes for the Reviewer (paste into the Notes box):**
```
رحلتنا is a travel-booking app for browsing and reserving organized trips.

LOGIN: Sign in with the email and password of the demo account we provided.
(Account creation uses email + password; phone number is collected at signup
for contact only. Password reset sends a verification code to the user's email.)

PERMISSIONS:
• Location & Motion are used only for the in-app Qibla compass and mosque finder.
  They are optional — the rest of the app works without granting them.
• Camera & Photo Library are used only to set an optional profile picture.

ACCOUNT DELETION: Users can permanently delete their account from
Settings → "حذف الحساب" (Delete Account).

PAYMENTS: Bookings are paid via offline bank transfer (the app displays the
merchant's bank details). There are NO digital goods or in-app purchases, so
Apple In-App Purchase does not apply (Guideline 3.1.3 / 3.1.5 — physical
services & real-world travel).

The backend API is https://admin.rehltna.com. Please ensure the device has an
internet connection. Thank you for the review.
```

---

## 8. Screenshots & Assets

### Required screenshot sizes (upload PNG/JPG, no alpha)
| Device | Resolution (portrait) | Required? |
|---|---|---|
| 6.9" iPhone (16 Pro Max) | 1320 × 2868 | ✅ Required |
| 6.5" iPhone (11 Pro Max/XS Max) | 1242 × 2688 | ✅ Recommended fallback |
| 13" iPad Pro | 2064 × 2752 | ✅ Required *if* iPad supported |

> Minimum: one set for 6.9" iPhone. Provide iPad screenshots only if the build supports iPad
> (current `UISupportedInterfaceOrientations~ipad` suggests iPad is enabled — confirm or disable).

### Suggested screenshot sequence (5–8 shots)
1. Home — trips & categories
2. Special offers
3. Trip details (itinerary + price)
4. Booking / payment (bank transfer)
5. Qibla compass
6. Mosque finder / map
7. Currency calculator
8. Profile

### Other assets
- **App Icon:** 1024 × 1024 PNG, no transparency, no rounded corners (Apple rounds it).
- **App Preview video (optional):** 15–30s, per device size.

---

## 9. Pre-Submission Checklist

### Blockers (fix before archiving)
- [x] **Bundle ID** set to `com.rehltna.app` in Xcode (app + `RunnerTests`). ✅
- [ ] Register `com.rehltna.app` in **App Store Connect** (create the app record under this id).
- [ ] **Firebase:** add a new iOS app with bundle id `com.rehltna.app` in the Firebase console
      (project `rehltna-392b6`), download the fresh `GoogleService-Info.plist`, and replace
      `ios/Runner/GoogleService-Info.plist`. Re-upload the **APNs auth key** for the new app.
      Without this, push notifications (FCM) will not be delivered.
- [ ] **Remove `flutter_contacts`** from `pubspec.yaml` — it is unused in `lib/` (verified) and triggers Guideline 5.1.1.
- [ ] Production build passes a real **`--dart-define=API_KEY=...`** (per `app_config.dart`, do **not** ship without it).
- [ ] Working **demo account** confirmed for App Review.

### Configuration
- [ ] `version: 1.0.0+1` in `pubspec.yaml` matches App Store Connect version/build.
- [ ] All four (five with contacts) permission strings present and accurate.
- [ ] `UIBackgroundModes` (`fetch`, `remote-notification`) justified — used by Firebase Messaging. ✅
- [ ] APNs key/certificate configured in Firebase + App Store Connect for push notifications.
- [ ] Privacy Policy URL live (required because the app collects account data). e.g. `https://rehltna.com/privacy`
- [ ] Support URL live. e.g. `https://rehltna.com/support`
- [ ] Marketing URL (optional). e.g. `https://rehltna.com`

### Compliance / common rejection points
- [ ] **Guideline 5.1.1** — every requested permission has a clear in-app purpose; no permission requested before it's needed.
- [ ] **Guideline 3.1.1 / 3.1.3** — confirm bank-transfer payments are for real-world travel services (exempt from IAP). Keep this in Review Notes.
- [ ] **Guideline 2.1** — provide demo credentials so reviewer reaches every screen.
- [ ] **Guideline 4.0** — RTL Arabic UI renders correctly on all supported devices.
- [x] **Guideline 5.1.1(v)** — account deletion path exists in-app (Settings → "حذف الحساب" → `deleteAccount()`). ✅ Verified present.
- [ ] No private APIs, no hardcoded secrets in the binary.
- [ ] Tested on a physical device (camera, location, compass, push don't work on Simulator).

### Encryption (ITSAppUsesNonExemptEncryption)
- [ ] App uses only standard HTTPS/TLS → set `ITSAppUsesNonExemptEncryption = NO` in `Info.plist`
      to skip the export-compliance question each upload.

---

## 10. Build & Upload Steps

```bash
# 1. Clean
flutter clean && flutter pub get

# 2. Pods
cd ios && pod install --repo-update && cd ..

# 3. Release build (pass production API key!)
flutter build ipa \
  --release \
  --dart-define=API_BASE_URL=https://admin.rehltna.com/api/v1 \
  --dart-define=API_KEY=YOUR_PRODUCTION_KEY

# 4. Upload the IPA
#    Option A — Xcode: open ios/Runner.xcworkspace → Product > Archive > Distribute App
#    Option B — Transporter app: drag build/ios/ipa/*.ipa
#    Option C — CLI:
xcrun altool --upload-app -f build/ios/ipa/*.ipa -t ios \
  --apiKey YOUR_KEY_ID --apiIssuer YOUR_ISSUER_ID
```

After upload:
1. Wait for the build to finish **processing** in App Store Connect (5–30 min).
2. Attach the build to the version.
3. Complete **App Privacy**, **Age Rating**, **App Review Information**, and screenshots.
4. Answer **Export Compliance** (No, if `ITSAppUsesNonExemptEncryption = NO`).
5. **Submit for Review.**

---

## 11. Required URLs (must be live before submit)

| Field | URL | Required |
|---|---|---|
| Privacy Policy | `https://rehltna.com/privacy` | ✅ Yes (collects account data) |
| Support URL | `https://rehltna.com/support` | ✅ Yes |
| Marketing URL | `https://rehltna.com` | Optional |
| Terms of Use (EULA) | `https://rehltna.com/terms` | Recommended |

---

## 12. Quick Reference

| Item | Value |
|---|---|
| App name | رحلتنا (Rehltna) |
| Platform | iOS (Flutter) |
| Category | Travel |
| Age rating | 4+ |
| Price | Free |
| IAP | None (offline bank transfer) |
| Backend | `https://admin.rehltna.com/api/v1` |
| Push | Firebase Cloud Messaging (APNs) |
| Auth | Email + password (phone collected at signup; email OTP for password reset) |
| Permissions | Camera, Photos, Location (When In Use), Motion |
| Account deletion | ✅ Present (Settings → حذف الحساب) |
| Min iOS | 14.0 (from `ios/Podfile`) |

---

*Generated for the رحلتنا App Store submission. Replace all placeholder values (demo account,
contact info, URLs, bundle id) with real production values before submitting.*
