import 'dart:convert';

class ItemModel {
  final int id;
  final int itemTypeId;
  final String titleAr;
  final String titleEn;
  final String bannerAr;
  final String bannerEn;
  final String shortDescriptionAr;
  final String shortDescriptionEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final double discount;
  final String discountType;
  final String startDate;
  final String endDate;
  final String startDateHijri; // ✅ تاريخ البداية هجري
  final String endDateHijri;   // ✅ تاريخ النهاية هجري
  final String season;
  final String whatsapp;
  final String contactUs;
  final int earnedPoints;
  final List<String> galleries;
  final ItemTypeModel itemType;
  final List<ItineraryModel> itineraries;
  final List<PriceModel> prices;
  final List<RouteModel> routes;
  final List<ExcludeModel> excludes;
  final String? map;

  final int? featureId;
  final int? itemId;

  ItemModel({
    required this.id,
    required this.itemTypeId,
    required this.titleAr,
    required this.titleEn,
    required this.bannerAr,
    required this.bannerEn,
    required this.shortDescriptionAr,
    required this.shortDescriptionEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    this.discount = 0,
    this.discountType = 'amount',
    required this.startDate,
    required this.endDate,
    this.startDateHijri = '', // ✅ قيمة افتراضية
    this.endDateHijri = '',   // ✅ قيمة افتراضية
    required this.season,
    required this.whatsapp,
    required this.contactUs,
    required this.earnedPoints,
    required this.galleries,
    required this.itemType,
    required this.itineraries,
    required this.prices,
    this.routes = const [],
    this.excludes = const [],
    this.map,
    this.featureId,
    this.itemId,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    List<String> galleryImages = [];
    if (json['galleries'] != null) {
      galleryImages = List.from(json['galleries'].map((g) => g['image']));
    }

    List<PriceModel> pricesList = [];
    if (json['prices'] != null && json['prices'] is List) {
      pricesList = (json['prices'] as List)
          .map((p) => PriceModel.fromJson(p))
          .toList();
    }

    List<RouteModel> routesList = [];
    if (json['routes'] != null && json['routes'] is List) {
      routesList = (json['routes'] as List)
          .map((r) => RouteModel.fromJson(r))
          .toList();
    }

    List<ExcludeModel> excludesList = [];
    if (json['excludes'] != null && json['excludes'] is List) {
      excludesList = (json['excludes'] as List)
          .map((e) => ExcludeModel.fromJson(e))
          .toList();
    }

    return ItemModel(
      id: json['id'] ?? 0,
      itemTypeId: int.tryParse(json['item_type_id']?.toString() ?? '0') ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      bannerAr: json['banner_ar'] ?? '',
      bannerEn: json['banner_en'] ?? '',
      shortDescriptionAr: json['short_description_ar'] ?? '',
      shortDescriptionEn: json['short_description_en'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0,
      discountType: json['discount_type'] ?? 'amount',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      startDateHijri: json['start_date_hijri'] ?? '', // ✅ قراءة التاريخ الهجري
      endDateHijri: json['end_date_hijri'] ?? '',     // ✅ قراءة التاريخ الهجري
      season: json['season'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      contactUs: json['contact_us'] ?? json['quick_contact'] ?? '',
      earnedPoints: int.tryParse(json['earned_points']?.toString() ?? '0') ?? 0,
      galleries: galleryImages,
      itemType: ItemTypeModel.fromJson(json['item_type'] ?? {}),
      itineraries: (json['itineraries'] as List? ?? [])
          .map((i) => ItineraryModel.fromJson(i))
          .toList(),
      prices: pricesList,
      routes: routesList,
      excludes: excludesList,
      map: json['map'],
      featureId: json['feature_id'],
      itemId: int.tryParse(json['item_id']?.toString() ?? '0'),
    );
  }

  // ✅ نفس الشيء في fromFeatureJson
  factory ItemModel.fromFeatureJson(Map<String, dynamic> json) {
    // ... نفس الكود السابق مع إضافة startDateHijri و endDateHijri
    List<String> galleryImages = [];
    if (json['galleries'] != null) {
      galleryImages = List.from(json['galleries'].map((g) => g['image']));
    }

    List<PriceModel> pricesList = [];
    if (json['prices'] != null && json['prices'] is List) {
      pricesList = (json['prices'] as List)
          .map((p) => PriceModel.fromJson(p))
          .toList();
    }

    List<RouteModel> routesList = [];
    if (json['routes'] != null && json['routes'] is List) {
      routesList = (json['routes'] as List)
          .map((r) => RouteModel.fromJson(r))
          .toList();
    }

    List<ExcludeModel> excludesList = [];
    if (json['excludes'] != null && json['excludes'] is List) {
      excludesList = (json['excludes'] as List)
          .map((e) => ExcludeModel.fromJson(e))
          .toList();
    }

    return ItemModel(
      id: json['id'] ?? 0,
      itemTypeId: int.tryParse(json['item_type_id']?.toString() ?? '0') ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      bannerAr: json['banner_ar'] ?? '',
      bannerEn: json['banner_en'] ?? '',
      shortDescriptionAr: json['short_description_ar'] ?? '',
      shortDescriptionEn: json['short_description_en'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0,
      discountType: json['discount_type'] ?? 'amount',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      startDateHijri: json['start_date_hijri'] ?? '', // ✅ إضافة
      endDateHijri: json['end_date_hijri'] ?? '',     // ✅ إضافة
      season: json['season'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      contactUs: json['contact_us'] ?? json['quick_contact'] ?? '',
      earnedPoints: int.tryParse(json['earned_points']?.toString() ?? '0') ?? 0,
      galleries: galleryImages,
      itemType: ItemTypeModel.fromJson(json['item_type'] ?? {}),
      itineraries: (json['itineraries'] as List? ?? [])
          .map((i) => ItineraryModel.fromJson(i))
          .toList(),
      prices: pricesList,
      routes: routesList,
      excludes: excludesList,
      map: json['map'],
      featureId: json['id'],
      itemId: int.tryParse(json['item_id']?.toString() ?? '0'),
    );
  }

  double get priceAfterDiscount {
    if (discount <= 0) return price;
    if (discountType == 'amount') {
      return price - discount;
    } else if (discountType == 'percentage') {
      return price * (1 - discount / 100);
    }
    return price;
  }

  int get discountPercent {
    if (discount <= 0) return 0;
    if (discountType == 'amount') {
      return ((discount / price) * 100).round();
    } else {
      return discount.round();
    }
  }

  bool get hasItemDiscount => discount > 0;

  String getTitle(String langCode) => langCode == 'ar' ? titleAr : titleEn;
  String getShortDescription(String langCode) => langCode == 'ar' ? shortDescriptionAr : shortDescriptionEn;
  String getDescription(String langCode) => langCode == 'ar' ? descriptionAr : descriptionEn;
  String getBanner(String langCode) => langCode == 'ar' ? bannerAr : bannerEn;

  int get totalNights {
    try {
      if (startDate.isEmpty || endDate.isEmpty) return 1;
      DateTime? start, end;
      try { start = DateTime.parse(startDate); } catch (e) {
        if (startDate.contains('T')) start = DateTime.tryParse(startDate.split('T').first);
        if (start == null) {
          final parts = startDate.split('-');
          if (parts.length == 3) start = DateTime.tryParse('${parts[0]}-${parts[1].padLeft(2, '0')}-${parts[2].padLeft(2, '0')}');
        }
      }
      try { end = DateTime.parse(endDate); } catch (e) {
        if (endDate.contains('T')) end = DateTime.tryParse(endDate.split('T').first);
        if (end == null) {
          final parts = endDate.split('-');
          if (parts.length == 3) end = DateTime.tryParse('${parts[0]}-${parts[1].padLeft(2, '0')}-${parts[2].padLeft(2, '0')}');
        }
      }
      if (start == null || end == null) return 1;
      final difference = end.difference(start).inDays;
      return difference > 0 ? difference : 1;
    } catch (e) { return 1; }
  }

  bool get isExpired {
    if (endDate.isEmpty) return false;
    try {
      DateTime? end;
      try { end = DateTime.parse(endDate); } catch (_) {
        if (endDate.contains('T')) end = DateTime.tryParse(endDate.split('T').first);
        if (end == null) {
          final parts = endDate.split('-');
          if (parts.length == 3) end = DateTime.tryParse('${parts[0]}-${parts[1].padLeft(2, '0')}-${parts[2].padLeft(2, '0')}');
        }
      }
      if (end == null) return false;
      return DateTime.now().isAfter(end);
    } catch (_) { return false; }
  }

  double get minPrice {
    if (prices.isEmpty) return priceAfterDiscount;
    return prices.map((p) => p.effectivePrice).reduce((a, b) => a < b ? a : b);
  }

  double get maxPrice {
    if (prices.isEmpty) return priceAfterDiscount;
    return prices.map((p) => p.effectivePrice).reduce((a, b) => a > b ? a : b);
  }

  bool get hasMultiplePrices => prices.length > 1;

  String getPriceDisplay(String langCode) {
    if (prices.isEmpty) return '${priceAfterDiscount.toStringAsFixed(0)} ريال';
    final minP = minPrice;
    final maxP = maxPrice;
    if (minP == maxP) return '${minP.toStringAsFixed(0)} ريال';
    return '${minP.toStringAsFixed(0)} - ${maxP.toStringAsFixed(0)} ريال';
  }

  PriceModel? getPriceById(int priceId) {
    try { return prices.firstWhere((p) => p.id == priceId); } catch (e) { return null; }
  }
}

// ==================== PriceModel ====================
class PriceModel {
  final int id;
  final int itemId;
  final String titleAr;
  final String titleEn;
  final double price;
  final double discount;
  final String discountType;
  final int? minAttendees;
  final int? maxAttendees;
  final int? maxRooms;
  final String? descriptionAr;
  final String? descriptionEn;

  PriceModel({
    required this.id,
    this.itemId = 0,
    required this.titleAr,
    required this.titleEn,
    required this.price,
    this.discount = 0,
    this.discountType = 'amount',
    this.minAttendees,
    this.maxAttendees,
    this.maxRooms,
    this.descriptionAr,
    this.descriptionEn,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      id: json['id'] ?? 0,
      itemId: int.tryParse(json['item_id']?.toString() ?? '0') ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0,
      discountType: json['discount_type'] ?? 'amount',
      minAttendees: json['min_attendees'] != null ? int.tryParse(json['min_attendees'].toString()) : null,
      maxAttendees: json['max_attendees'] != null ? int.tryParse(json['max_attendees'].toString()) : 50,
      maxRooms: json['max_rooms'] != null ? int.tryParse(json['max_rooms'].toString()) : 50,
      descriptionAr: json['description_ar'],
      descriptionEn: json['description_en'],
    );
  }

  String getTitle(String langCode) => langCode == 'ar' ? titleAr : titleEn;
  String getDescription(String langCode) => langCode == 'ar' ? (descriptionAr ?? '') : (descriptionEn ?? '');

  double get effectivePrice {
    if (discount <= 0) return price;
    if (discountType == 'amount') {
      final afterDiscount = price - discount;
      return afterDiscount > 0 ? afterDiscount : 0;
    } else if (discountType == 'percentage') {
      final afterDiscount = price * (1 - discount / 100);
      return afterDiscount > 0 ? afterDiscount : 0;
    }
    return price;
  }

  bool get hasDiscount => discount > 0;

  double get discountAmount {
    if (!hasDiscount) return 0;
    if (discountType == 'amount') return discount;
    return price * (discount / 100);
  }

  int get discountPercentage {
    if (!hasDiscount) return 0;
    if (discountType == 'amount') return ((discount / price) * 100).round();
    return discount.round();
  }
}

// ==================== RouteModel ====================
class RouteModel {
  final int id;
  final int itemId;
  final String titleAr;
  final String titleEn;
  final String icon;
  final int order;

  RouteModel({
    required this.id,
    required this.itemId,
    required this.titleAr,
    required this.titleEn,
    required this.icon,
    required this.order,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] ?? 0,
      itemId: int.tryParse(json['item_id']?.toString() ?? '0') ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      icon: json['icon'] ?? '',
      order: int.tryParse(json['order']?.toString() ?? '0') ?? 0,
    );
  }

  String getTitle(String langCode) => langCode == 'ar' ? titleAr : titleEn;
}

// ==================== ExcludeModel ====================
class ExcludeModel {
  final int id;
  final int itemId;
  final String titleAr;
  final String titleEn;
  final String icon;
  final int order;

  ExcludeModel({
    required this.id,
    required this.itemId,
    required this.titleAr,
    required this.titleEn,
    required this.icon,
    required this.order,
  });

  factory ExcludeModel.fromJson(Map<String, dynamic> json) {
    return ExcludeModel(
      id: json['id'] ?? 0,
      itemId: int.tryParse(json['item_id']?.toString() ?? '0') ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      icon: json['icon'] ?? '',
      order: int.tryParse(json['order']?.toString() ?? '0') ?? 0,
    );
  }

  String getTitle(String langCode) => langCode == 'ar' ? titleAr : titleEn;
}

// ==================== PlaceModel ====================
class PlaceModel {
  final int id;
  final int itineraryId;
  final String titleAr;
  final String titleEn;

  PlaceModel({
    required this.id,
    required this.itineraryId,
    required this.titleAr,
    required this.titleEn,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] ?? 0,
      itineraryId: int.tryParse(json['itinerary_id']?.toString() ?? '0') ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
    );
  }

  String getTitle(String langCode) => langCode == 'ar' ? titleAr : titleEn;
}

// ==================== ItineraryModel ====================
class ItineraryModel {
  final int id;
  final int cityId;
  final String startDate;
  final String endDate;
  final int nights;
  final CityModel city;
  final List<PlaceModel> places;
  final String? map;

  ItineraryModel({
    required this.id,
    required this.cityId,
    required this.startDate,
    required this.endDate,
    required this.nights,
    required this.city,
    this.places = const [],
    this.map,
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    List<PlaceModel> placesList = [];
    if (json['places'] != null && json['places'] is List) {
      placesList = (json['places'] as List).map((p) => PlaceModel.fromJson(p)).toList();
    }

    return ItineraryModel(
      id: json['id'] ?? 0,
      cityId: int.tryParse(json['city_id']?.toString() ?? '0') ?? 0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      nights: int.tryParse(json['nights']?.toString() ?? '0') ?? 0,
      city: CityModel.fromJson(json['city'] ?? {}),
      places: placesList,
      map: json['map'],
    );
  }
}

class ItemTypeModel {
  final int id;
  final String titleAr;
  final String titleEn;
  final String? bannerAr;
  final String? bannerEn;

  ItemTypeModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    this.bannerAr,
    this.bannerEn,
  });

  factory ItemTypeModel.fromJson(Map<String, dynamic> json) {
    return ItemTypeModel(
      id: json['id'] ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      bannerAr: json['banner_ar'],
      bannerEn: json['banner_en'],
    );
  }

  String getTitle(String langCode) => langCode == 'ar' ? titleAr : titleEn;
  String? getBanner(String langCode) => langCode == 'ar' ? bannerAr : bannerEn;
}

// ==================== CityModel ====================
class CityModel {
  final int id;
  final String titleAr;
  final String titleEn;

  CityModel({required this.id, required this.titleAr, required this.titleEn});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
    );
  }

  String getTitle(String langCode) => langCode == 'ar' ? titleAr : titleEn;
}