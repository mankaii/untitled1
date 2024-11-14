// models/daily_survey.dart
import 'package:flutter/material.dart';
import 'dart:convert';

class DailySurvey {
  final DateTime date;
  final bool isSmokeFree;
  final int? cigarettesSmoked;  // 실패했을 경우 피운 개비 수
  final int stressLevel;        // 1-5 스트레스 수준
  final String? stressReason;   // 스트레스 원인
  final int urgencyLevel;       // 1-5 흡연 충동 정도
  final String? note;           // 추가 메모

  DailySurvey({
    required this.date,
    required this.isSmokeFree,
    this.cigarettesSmoked,
    required this.stressLevel,
    this.stressReason,
    required this.urgencyLevel,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'isSmokeFree': isSmokeFree,
    'cigarettesSmoked': cigarettesSmoked,
    'stressLevel': stressLevel,
    'stressReason': stressReason,
    'urgencyLevel': urgencyLevel,
    'note': note,
  };

  factory DailySurvey.fromJson(Map<String, dynamic> json) => DailySurvey(
    date: DateTime.parse(json['date']),
    isSmokeFree: json['isSmokeFree'],
    cigarettesSmoked: json['cigarettesSmoked'],
    stressLevel: json['stressLevel'],
    stressReason: json['stressReason'],
    urgencyLevel: json['urgencyLevel'],
    note: json['note'],
  );
}