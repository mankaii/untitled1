// models/profile_item.dart
import 'package:flutter/material.dart';

class ProfileItem {
  final String id;
  final String name;
  final String description;
  final int requiredPoints;
  final String category;
  final String imageAsset;
  final int tier;
  final String unlockMessage;
  bool isLocked;

  ProfileItem({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredPoints,
    required this.category,
    required this.imageAsset,
    required this.tier,
    required this.unlockMessage,
    this.isLocked = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'requiredPoints': requiredPoints,
    'category': category,
    'imageAsset': imageAsset,
    'tier': tier,
    'unlockMessage': unlockMessage,
    'isLocked': isLocked,
  };

  factory ProfileItem.fromJson(Map<String, dynamic> json) => ProfileItem(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    requiredPoints: json['requiredPoints'],
    category: json['category'],
    imageAsset: json['imageAsset'],
    tier: json['tier'],
    unlockMessage: json['unlockMessage'],
    isLocked: json['isLocked'],
  );

  ProfileItem copyWith({bool? isLocked}) {
    return ProfileItem(
      id: id,
      name: name,
      description: description,
      requiredPoints: requiredPoints,
      category: category,
      imageAsset: imageAsset,
      tier: tier,
      unlockMessage: unlockMessage,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}