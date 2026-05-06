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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'مستخدم',
      email: json['email'] ?? '',
      phone: json['phone']?.toString(),
      avatarUrl: json['avatar_url'] ?? json['avatar'],
      isVerified: json['email_verified_at'] != null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
      package: json['package'] is Map ? json['package']['name'] : json['package'],
      earnedPoints: double.tryParse(json['earned_points']?.toString() ?? '0') ?? 0,
      availablePoints: double.tryParse(json['available_points']?.toString() ?? '0') ?? 0,
      usedPoints: double.tryParse(json['used_points']?.toString() ?? '0') ?? 0,
      orders: json['orders'] ?? [],
      fcmToken: json['fcm_token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'name': name, 'email': email, 'phone': phone,
      'avatar_url': avatarUrl, 'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
      'package': package, 'earned_points': earnedPoints,
      'available_points': availablePoints, 'used_points': usedPoints,
      'orders': orders, 'fcm_token': fcmToken,
    };
  }

  String get initials {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length > 1) return (parts[0][0] + parts[1][0]).toUpperCase();
    return name[0].toUpperCase();
  }

  // ✅ Getters للباقة
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
}