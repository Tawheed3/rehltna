class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final int toursCount;
  final bool isSpecial; // للعروض الخاصة

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.toursCount,
    this.isSpecial = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      toursCount: json['toursCount'],
      isSpecial: json['isSpecial'] ?? false,
    );
  }
}