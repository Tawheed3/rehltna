class CustomPageModel {
  final int id;
  final String titleAr;
  final String titleEn;
  final String slug;
  final String contentAr;
  final String contentEn;

  CustomPageModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.slug,
    required this.contentAr,
    required this.contentEn,
  });

  factory CustomPageModel.fromJson(Map<String, dynamic> json) {
    return CustomPageModel(
      id: json['id'] ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      slug: json['slug'] ?? '',
      contentAr: json['content_ar'] ?? '',
      contentEn: json['content_en'] ?? '',
    );
  }

  String getTitle(String langCode) => langCode == 'ar' ? titleAr : titleEn;
  String getContent(String langCode) => langCode == 'ar' ? contentAr : contentEn;
}