import 'package:flutter/material.dart';

class HealthTimeline {
  final Duration duration;
  final String title;
  final String description;
  final IconData icon;

  HealthTimeline({
    required this.duration,
    required this.title,
    required this.description,
    required this.icon,
  });
}