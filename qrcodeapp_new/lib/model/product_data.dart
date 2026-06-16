// lib/models/product_data.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'product_model.dart';

class JsonProduct {
  final String id;
  final String name;
  final double price;

  JsonProduct({
    required this.id,
    required this.name,
    required this.price,
  });

  factory JsonProduct.fromJson(Map<String, dynamic> json) {
    return JsonProduct(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }

  // تحويل إلى Product للتخزين في قاعدة البيانات
  Product toProduct({int quantity = 0, String expiryDate = ''}) {
    return Product(
      productId: id,
      name: name,
      price: price,
      quantity: quantity,
      expiryDate: expiryDate.isEmpty ? _getDefaultExpiryDate() : expiryDate,
      storedAt: DateTime.now(),
      barcodeImagePath: null,
    );
  }

  // تاريخ صلاحية افتراضي (بعد سنة من الآن)
  String _getDefaultExpiryDate() {
    DateTime now = DateTime.now();
    DateTime expiry = DateTime(now.year + 1, now.month, now.day);
    return '${expiry.year}-${expiry.month.toString().padLeft(2, '0')}';
  }
}

class ProductDataLoader {
  static List<JsonProduct> _allProducts = [];

  // تحميل المنتجات من ملف JSON
  static Future<List<JsonProduct>> loadProducts() async {
    try {
      final String response = await rootBundle.loadString('assets/products.json');
      final Map<String, dynamic> data = await json.decode(response);

      _allProducts = (data['products'] as List)
          .map((product) => JsonProduct.fromJson(product))
          .toList();

      print('✅ تم تحميل ${_allProducts.length} منتج من JSON');
      return _allProducts;
    } catch (e) {
      print('❌ خطأ في تحميل المنتجات: $e');
      return [];
    }
  }

  // جلب كل المنتجات
  static List<JsonProduct> getAllProducts() => _allProducts;

  // جلب منتج بواسطة ID
  static JsonProduct? getProductById(String id) {
    try {
      return _allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // البحث في المنتجات
  static List<JsonProduct> searchProducts(String query) {
    if (query.isEmpty) return _allProducts;

    return _allProducts.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.id.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // تحويل JsonProduct إلى Product مع إضافة الكمية وتاريخ الصلاحية
  static Product convertToStorableProduct(JsonProduct jsonProduct, {
    required int quantity,
    required String expiryDate,
  }) {
    return Product(
      productId: jsonProduct.id,
      name: jsonProduct.name,
      price: jsonProduct.price,
      quantity: quantity,
      expiryDate: expiryDate,
      storedAt: DateTime.now(),
      barcodeImagePath: null,
    );
  }

  // الحصول على منتجات مقترحة (أول 10)
  static List<JsonProduct> getSuggestedProducts() {
    return _allProducts.take(10).toList();
  }

  // تحديث أسعار المنتجات (لو عايز تعمل تحديث جماعي)
  static void updateProductPrice(String id, double newPrice) {
    try {
      final index = _allProducts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _allProducts[index] = JsonProduct(
          id: _allProducts[index].id,
          name: _allProducts[index].name,
          price: newPrice,
        );
      }
    } catch (e) {
      print('❌ خطأ في تحديث السعر: $e');
    }
  }
}