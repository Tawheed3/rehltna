import 'item_model.dart';

class SubcategoryItem {
  final int id;
  final String titleAr;
  final String titleEn;
  final String? banner;
  final int? parentId;
  final List<ItemModel> items;
  final List<SubcategoryItem> children;
  int totalItemsRecursive;
  final String? whatsapp;
  final int order; // ✅ حقل الترتيب من الباك إند

  SubcategoryItem({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    this.banner,
    this.parentId,
    this.items = const [],
    this.children = const [],
    this.totalItemsRecursive = 0,
    this.whatsapp,
    this.order = 0, // ✅ قيمة افتراضية
  });

  factory SubcategoryItem.fromJson(Map<String, dynamic> json) {
    final List<ItemModel> itemsList = (json['items'] as List? ?? [])
        .map((item) => ItemModel.fromJson(item))
        .toList();

    final List<SubcategoryItem> childrenList = (json['children'] as List? ?? [])
        .map((child) => SubcategoryItem.fromJson(child))
        .toList();

    int actualTotal = itemsList.length;
    for (var child in childrenList) {
      actualTotal += child.totalItemsRecursive;
    }

    return SubcategoryItem(
      id: json['id'] ?? 0,
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      banner: json['banner_ar'] ?? json['meta_img'],
      parentId: json['parent_id'] != null ? int.tryParse(json['parent_id'].toString()) : null,
      items: itemsList,
      children: childrenList,
      totalItemsRecursive: actualTotal,
      whatsapp: json['whatsapp'],
      order: int.tryParse(json['order']?.toString() ?? '0') ?? 0, // ✅ قراءة order من الباك إند
    );
  }

  String getTitle(String langCode) {
    return langCode == 'ar' ? titleAr : titleEn;
  }

  bool get hasChildren => children.isNotEmpty;

  /// ✅ الحصول على رابط البانر حسب اللغة
  String? getBanner(String langCode) {
    return banner;
  }
}