// models/challenge.dart
import 'package:flutter/material.dart';

enum ChallengeType {
  daily,
  weekly,
  special,
  achievement,
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final int requiredPoints;
  final String environmentalImpact;
  final String rewardTitle;
  final IconData icon;
  final List<Condition> conditions;
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
    icon: Icons.emoji_events,
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
  ];
}

// 도전과제 페이지
class ChallengePage extends StatelessWidget {
  final int savedMoney; // 전달된 절약한 금액

  ChallengePage({required this.savedMoney});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ChallengeData.defaultChallenges.map((challenge) {
        // 절약 금액을 Condition의 currentValue에 업데이트
        challenge.conditions.forEach((condition) {
          if (condition.description.contains("절약하기")) {
            condition.currentValue = savedMoney;
          }
        });
        return ChallengeWidget(challenge: challenge);
      }).toList(),
    );
  }
}

// 도전과제 위젯 (예시)
class ChallengeWidget extends StatelessWidget {
  final Challenge challenge;

  ChallengeWidget({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(challenge.icon),
        title: Text(challenge.title),
        subtitle: Text(
            '${challenge.conditions.first.currentValue}/${challenge.conditions.first.targetValue}'),
      ),
    );
  }
}
