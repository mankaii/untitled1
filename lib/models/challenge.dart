import 'package:flutter/material.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final int points;
  final String type; // 'daily', 'weekly', 'special'
  final IconData icon;
  bool isCompleted;
  final DateTime? deadline;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.type,
    required this.icon,
    this.isCompleted = false,
    this.deadline,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'points': points,
    'type': type,
    'isCompleted': isCompleted,
    'deadline': deadline?.toIso8601String(),
  };

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    points: json['points'],
    type: json['type'],
    icon: Icons.star, // 아이콘은 기본값으로 설정
    isCompleted: json['isCompleted'],
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
  );
}