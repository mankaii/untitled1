// models/challenge.dart
import 'package:flutter/material.dart';

enum ChallengeType {
  daily,    // 일일 도전과제
  weekly,   // 주간 도전과제
  special,  // 특별 도전과제
  achievement  // 업적
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final int requiredPoints;
  final String environmentalImpact; // 환경 영향력 설명
  final String rewardTitle; // 달성 시 얻는 칭호
  final IconData icon;
  final List<Condition> conditions; // 달성 조건들
  bool isCompleted;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.requiredPoints,
    required this.environmentalImpact,
    required this.rewardTitle,
    required this.icon,
    required this.conditions,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type.toString(),
    'requiredPoints': requiredPoints,
    'environmentalImpact': environmentalImpact,
    'rewardTitle': rewardTitle,
    'isCompleted': isCompleted,
    'conditions': conditions.map((c) => c.toJson()).toList(),
  };

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    type: ChallengeType.values.firstWhere(
          (e) => e.toString() == json['type'],
    ),
    requiredPoints: json['requiredPoints'],
    environmentalImpact: json['environmentalImpact'],
    rewardTitle: json['rewardTitle'],
    icon: Icons.emoji_events, // 기본 아이콘
    conditions: (json['conditions'] as List)
        .map((c) => Condition.fromJson(c))
        .toList(),
    isCompleted: json['isCompleted'] ?? false,
  );
}

class Condition {
  final String description;
  final int targetValue;
  final bool requiresConsecutive;
  int currentValue;
  DateTime? lastUpdateTime;

  Condition({
    required this.description,
    required this.targetValue,
    this.requiresConsecutive = false,
    this.currentValue = 0,
    this.lastUpdateTime,
  });

  bool get isCompleted => currentValue >= targetValue;

  Map<String, dynamic> toJson() => {
    'description': description,
    'targetValue': targetValue,
    'requiresConsecutive': requiresConsecutive,
    'currentValue': currentValue,
    'lastUpdateTime': lastUpdateTime?.toIso8601String(),
  };

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
    description: json['description'],
    targetValue: json['targetValue'],
    requiresConsecutive: json['requiresConsecutive'] ?? false,
    currentValue: json['currentValue'] ?? 0,
    lastUpdateTime: json['lastUpdateTime'] != null
        ? DateTime.parse(json['lastUpdateTime'])
        : null,
  );
}

// 도전과제 데이터
class ChallengeData {
  static List<Challenge> get defaultChallenges => [
    // 금연 재테크 관련 도전과제
    Challenge(
      id: 'finance_1',
      title: '금연 재테크 입문자',
      description: '금연으로 10만원 절약하기',
      type: ChallengeType.achievement,
      requiredPoints: 100,
      environmentalImpact: '절약한 비용으로 나무 한 그루를 심을 수 있어요',
      rewardTitle: '알뜰한 금연인',
      icon: Icons.savings,
      conditions: [
        Condition(
          description: '10만원 절약하기',
          targetValue: 100000,
        ),
      ],
    ),
    Challenge(
      id: 'finance_2',
      title: '금연 재테크 전문가',
      description: '금연으로 50만원 절약하기',
      type: ChallengeType.achievement,
      requiredPoints: 500,
      environmentalImpact: '절약한 비용으로 작은 숲을 만들 수 있어요',
      rewardTitle: '금연 재테크의 달인',
      icon: Icons.account_balance,
      conditions: [
        Condition(
          description: '50만원 절약하기',
          targetValue: 500000,
        ),
      ],
    ),

    // 환경 보호 관련 도전과제
    Challenge(
      id: 'environment_1',
      title: '지구를 지키는 금연인',
      description: '100개비의 담배로부터 지구 지키기',
      type: ChallengeType.achievement,
      requiredPoints: 200,
      environmentalImpact: '담배 100개비는 약 20L의 깨끗한 물을 오염시킬 수 있어요',
      rewardTitle: '지구 수호자',
      icon: Icons.eco,
      conditions: [
        Condition(
          description: '100개비 참기',
          targetValue: 100,
        ),
      ],
    ),
    Challenge(
      id: 'environment_2',
      title: '숲을 만드는 금연인',
      description: '1000개비의 담배로부터 지구 지키기',
      type: ChallengeType.achievement,
      requiredPoints: 1000,
      environmentalImpact: '1년 동안 버려지는 담배꽁초로 인한 환경오염을 줄였어요',
      rewardTitle: '숲의 수호자',
      icon: Icons.forest,
      conditions: [
        Condition(
          description: '1000개비 참기',
          targetValue: 1000,
        ),
      ],
    ),

    // 건강 관련 도전과제
    Challenge(
      id: 'health_1',
      title: '건강한 첫걸음',
      description: '7일 연속 금연 성공',
      type: ChallengeType.special,
      requiredPoints: 150,
      environmentalImpact: '당신의 폐가 회복되기 시작했어요',
      rewardTitle: '새싹 금연인',
      icon: Icons.favorite,
      conditions: [
        Condition(
          description: '7일 연속 금연',
          targetValue: 7,
          requiresConsecutive: true,
        ),
      ],
    ),
    Challenge(
      id: 'health_2',
      title: '건강 마스터',
      description: '30일 연속 금연 성공',
      type: ChallengeType.special,
      requiredPoints: 500,
      environmentalImpact: '당신의 건강이 크게 개선되었어요',
      rewardTitle: '건강 달인',
      icon: Icons.workspace_premium,
      conditions: [
        Condition(
          description: '30일 연속 금연',
          targetValue: 30,
          requiresConsecutive: true,
        ),
      ],
    ),
  ];
}