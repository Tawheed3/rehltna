class SliderModel {
  final int id;
  final String titleAr;
  final String titleEn;
  final String bannerAr;
  final String bannerEn;
  final String link;
  final String metaImg;

  SliderModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.bannerAr,
    required this.bannerEn,
    required this.link,
    required this.metaImg,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      bannerAr: json['meta_img'] ?? '',
      bannerEn: json['meta_img'] ?? '',
      link: json['link'] ?? '',
      metaImg: json['meta_img'] ?? '',
    );
  }

  // جلب العنوان حسب اللغة
  String getTitle(String langCode) {
    return langCode == 'ar' ? titleAr : titleEn;
  }

  // جلب صورة البانر حسب اللغة
  String getBanner(String langCode) {
    return langCode == 'ar' ? bannerAr : bannerEn;
  }
}