import 'package:flutter/material.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? package;
  final double earnedPoints;
  final double availablePoints;
  final double usedPoints;
  final List<dynamic> orders;
  final String? fcmToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.isVerified = false,
    required this.createdAt,
    this.updatedAt,
    this.package,
    this.earnedPoints = 0,
    this.availablePoints = 0,
    this.usedPoints = 0,
    this.orders = const [],
    this.fcmToken,
  });

  /// ✅ تحويل آمن من JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? 'مستخدم',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      avatarUrl: json['avatar_url']?.toString() ?? json['avatar']?.toString(),
      isVerified: json['email_verified_at'] != null,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseNullableDate(json['updated_at']),
      package: _parsePackage(json['package']),
      earnedPoints: _parseDouble(json['earned_points']),
      availablePoints: _parseDouble(json['available_points']),
      usedPoints: _parseDouble(json['used_points']),
      orders: json['orders'] ?? [],
      fcmToken: json['fcm_token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'package': package,
      'earned_points': earnedPoints,
      'available_points': availablePoints,
      'used_points': usedPoints,
      'orders': orders,
      'fcm_token': fcmToken,
    };
  }

  String get initials {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length > 1) return (parts[0][0] + parts[1][0]).toUpperCase();
    return name[0].toUpperCase();
  }

  Color get packageColor {
    switch (package?.toLowerCase()) {
      case 'silver': return const Color(0xFFC0C0C0);
      case 'gold': return const Color(0xFFFFD700);
      case 'diamond': return const Color(0xFFB9F2FF);
      default: return Colors.grey;
    }
  }

  IconData get packageIcon {
    switch (package?.toLowerCase()) {
      case 'silver': return Icons.emoji_events_outlined;
      case 'gold': return Icons.emoji_events;
      case 'diamond': return Icons.diamond;
      default: return Icons.card_membership;
    }
  }

  String get packageName {
    switch (package?.toLowerCase()) {
      case 'silver': return 'فضي';
      case 'gold': return 'ذهبي';
      case 'diamond': return 'ألماسي';
      default: return package ?? 'عادي';
    }
  }

  // ==================== دوال مساعدة آمنة ====================

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  static DateTime? _parseNullableDate(dynamic date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return null;
    }
  }

  static String? _parsePackage(dynamic package) {
    if (package == null) return null;
    if (package is Map) return package['name']?.toString();
    return package.toString();
  }
}