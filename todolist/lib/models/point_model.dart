import 'package:cloud_firestore/cloud_firestore.dart';

class PointModel {
  String id;
  String name;
  bool isCompleted;
  DateTime? createdAt;
  DateTime? completedAt;

  PointModel({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'createdAt': createdAt != null ? FieldValue.serverTimestamp() : null,
      'completedAt': completedAt != null ? FieldValue.serverTimestamp() : null,
    };
  }

  factory PointModel.fromMap(String id, Map<String, dynamic> map) {
    return PointModel(
      id: id,
      name: map['name'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
    );
  }
}