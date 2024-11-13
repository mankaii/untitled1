// models/challenge.dart
import 'package:flutter/material.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final int points;
  final String type; // 'daily', 'weekly', 'special'
  final IconData icon;
  final DateTime? deadline;
  bool isCompleted;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.type,
    required this.icon,
    this.deadline,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'points': points,
    'type': type,
    'deadline': deadline?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    points: json['points'],
    type: json['type'],
    icon: Icons.star, // 기본 아이콘
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    isCompleted: json['isCompleted'] ?? false,
  );
}