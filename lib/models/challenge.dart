import 'package:flutter/material.dart';

enum ChallengeType { daily, weekly, special, achievement }

class Challenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final int requiredPoints;
  final int requiredSavings;
  final int requiredCigarettes;
  final int requiredDays;
  final String environmentalImpact;
  final String rewardTitle;
  final IconData icon;
  final int pointsReward;

  int currentSavings = 0;
  int currentCigarettes = 0;
  int daysSinceQuit = 0;
  bool isUnlocked = false;
  bool isNotified = false; // 알림이 한 번만 표시되도록 제어하는 속성 추가

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.requiredPoints,
    required this.requiredSavings,
    required this.requiredCigarettes,
    required this.requiredDays,
    required this.environmentalImpact,
    required this.rewardTitle,
    required this.icon,
    required this.pointsReward,
  });

  // 절약 금액과 개비 수 및 경과 날짜 계산
  void updateProgress(int cigarettePrice, int cigarettesPerDay, DateTime quitDate) {
    daysSinceQuit = DateTime.now().difference(quitDate).inDays;
    currentCigarettes = daysSinceQuit * cigarettesPerDay;
    currentSavings = (currentCigarettes ~/ 20) * cigarettePrice;
  }

  // 도전 과제의 완료 여부
  bool get isCompleted {
    if (requiredDays > 0) {
      return daysSinceQuit >= requiredDays;
    } else if (requiredCigarettes > 0) {
      return currentCigarettes >= requiredCigarettes;
    } else {
      return currentSavings >= requiredSavings;
    }
  }

  String get formattedSavings => '₩$currentSavings / ₩$requiredSavings';
  String get formattedCigarettes => '$currentCigarettes / $requiredCigarettes 개비';
  String get formattedDays => '$daysSinceQuit / $requiredDays 일';
}
