// models/health_status.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/models/daily_survey.dart';

class HealthStatus {
  final int smokeFreeHours;
  final double lungCapacityImprovement; // 폐활량 개선도 (%)
  final double bloodCirculationImprovement; // 혈액순환 개선도 (%)
  final double nicotineLevel; // 니코틴 수치 (%)
  final List<String> improvements; // 개선된 건강 지표들
  final List<DailySurvey> recentSurveys; // 최근 설문 데이터
  final String aiAnalysis; // AI 분석 결과

  HealthStatus({
    required this.smokeFreeHours,
    required this.lungCapacityImprovement,
    required this.bloodCirculationImprovement,
    required this.nicotineLevel,
    required this.improvements,
    required this.recentSurveys,
    required this.aiAnalysis,
  });

  // 금연 시간에 따른 건강 개선도 계산
  static double calculateLungCapacity(int hours) {
    // 의학적 데이터 기반 계산
    return (hours / 720) * 30; // 30일 기준 최대 30% 개선
  }

  static double calculateBloodCirculation(int hours) {
    return (hours / 168) * 100; // 7일 기준 100% 개선
  }

  static double calculateNicotineLevel(int hours) {
    return 100 - ((hours / 72) * 100).clamp(0, 100); // 3일 기준 100% 감소
  }
}