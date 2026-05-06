import 'dart:convert';

class SettingsModel {
  final List<String> activeLangs;
  final List<String> siteAddressAr;
  final List<String> siteAddressEn;
  final List<String> facebook;
  final List<String> instagram;
  final List<String> twitter;
  final List<String> whatsapp;
  final List<String> youtube;
  final String siteNameAr;
  final String siteNameEn;
  final String siteEmail;
  final String sitePhone;
  final String mainLogoLight;
  final String mainLogoDark;
  final String favicon;
  final String paymentSuccessUrl;
  final String paymentFailedUrl;
  final String paymentCancelUrl;

  SettingsModel({
    required this.activeLangs,
    required this.siteAddressAr,
    required this.siteAddressEn,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.whatsapp,
    required this.youtube,
    required this.siteNameAr,
    required this.siteNameEn,
    required this.siteEmail,
    required this.sitePhone,
    required this.mainLogoLight,
    required this.mainLogoDark,
    required this.favicon,
    this.paymentSuccessUrl = '',
    this.paymentFailedUrl = '',
    this.paymentCancelUrl = '',
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    List<String> parseJsonList(String? jsonString) {
      if (jsonString == null || jsonString.isEmpty || jsonString == '[]') return [];
      try {
        final list = List<String>.from(jsonDecode(jsonString));
        return list;
      } catch (e) {
        return [];
      }
    }

    // ✅ whatsapp ممكن ييجي كـ URL أو رقم
    List<String> parseWhatsapp(dynamic value) {
      if (value == null) return [];
      if (value is List) return List<String>.from(value);
      return [value.toString()];
    }

    // ✅ linkedin و youtube ممكن ييجوا كـ JSON string
    List<String> parseJsonOrList(dynamic value) {
      if (value == null) return [];
      if (value is List) return List<String>.from(value);
      if (value is String) {
        try {
          final decoded = jsonDecode(value);
          if (decoded is List) return List<String>.from(decoded);
        } catch (e) {
          return [value];
        }
      }
      return [value.toString()];
    }

    return SettingsModel(
      activeLangs: parseJsonList(json['active_langs']),
      siteAddressAr: json['site_address_ar'] is List
          ? List<String>.from(json['site_address_ar'])
          : [],
      siteAddressEn: json['site_address_en'] is List
          ? List<String>.from(json['site_address_en'])
          : [],
      facebook: json['facebook'] is List
          ? List<String>.from(json['facebook'])
          : [],
      instagram: json['instagram'] is List
          ? List<String>.from(json['instagram'])
          : [],
      twitter: json['twitter'] is List
          ? List<String>.from(json['twitter'])
          : [],
      whatsapp: parseWhatsapp(json['whatsapp']),
      youtube: parseJsonOrList(json['youtube']),
      siteNameAr: json['site_name_ar'] ?? 'رحلتنا',
      siteNameEn: json['site_name_en'] ?? 'Rehltna',
      siteEmail: json['site_email'] ?? '',
      sitePhone: json['site_phone'] ?? '',
      mainLogoLight: json['main_logo_light'] ?? '',
      mainLogoDark: json['main_logo_dark'] ?? '',
      favicon: json['favicon'] ?? '',
      paymentSuccessUrl: json['payment_success_url'] ?? '',
      paymentFailedUrl: json['payment_failed_url'] ?? '',
      paymentCancelUrl: json['payment_cancel_url'] ?? '',
    );
  }

  String getSiteName(String langCode) {
    return langCode == 'ar' ? siteNameAr : siteNameEn;
  }

  String getAddress(String langCode) {
    final addresses = langCode == 'ar' ? siteAddressAr : siteAddressEn;
    return addresses.isNotEmpty ? addresses.first : '';
  }

  String getLogo(bool isDarkMode) {
    if (isDarkMode && mainLogoDark.isNotEmpty) return mainLogoDark;
    if (!isDarkMode && mainLogoLight.isNotEmpty) return mainLogoLight;
    return mainLogoLight.isNotEmpty ? mainLogoLight : mainLogoDark;
  }

  /// ✅ استخراج رقم الواتساب من الرابط
  String get whatsappNumber {
    if (whatsapp.isEmpty) return '';
    final first = whatsapp.first;
    // لو رابط: https://wa.me/966551933635
    final uri = Uri.tryParse(first);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    // لو رقم مباشر
    return first.replaceAll(RegExp(r'[^\d+]'), '');
  }

  /// ✅ استخراج رابط الواتساب
  String get whatsappUrl {
    if (whatsapp.isEmpty) return '';
    final first = whatsapp.first;
    if (first.startsWith('http')) return first;
    return 'https://wa.me/${whatsappNumber}';
  }
}