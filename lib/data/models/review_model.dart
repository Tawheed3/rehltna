class ReviewModel {
  final int id;
  final int itemId;
  final String reviewerName;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final ItemReviewInfo? item;

  ReviewModel({
    required this.id,
    required this.itemId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.item,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] != null ? _parseInt(json['id']) : 0,
      itemId: json['item_id'] != null ? _parseInt(json['item_id']) : 0,
      reviewerName: json['reviewer_name']?.toString() ?? 'مستخدم',
      rating: _parseInt(json['rating']),  // ✅ هنا المشكلة - rating جاي String
      comment: json['comment']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      item: json['item'] != null ? ItemReviewInfo.fromJson(json['item']) : null,
    );
  }

  // ✅ دالة مساعدة لتحويل أي نوع لـ int بأمان
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // عرض النجوم بشكل نصي
  String get starsDisplay => '⭐' * rating;

  // عرض النجوم على شكل قائمة
  List<bool> get starsList => List.generate(5, (index) => index < rating);
}

class ItemReviewInfo {
  final int id;
  final String titleAr;
  final String titleEn;

  ItemReviewInfo({
    required this.id,
    required this.titleAr,
    required this.titleEn,
  });

  factory ItemReviewInfo.fromJson(Map<String, dynamic> json) {
    return ItemReviewInfo(
      id: json['id'] != null ? _parseInt(json['id']) : 0,
      titleAr: json['title_ar']?.toString() ?? '',
      titleEn: json['title_en']?.toString() ?? '',
    );
  }

  String getTitle(String langCode) => langCode == 'ar' ? titleAr : titleEn;

  // ✅ دالة مساعدة
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}