// screens/challenge_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/challenge.dart';
import 'dart:convert';

class ChallengeScreen extends StatefulWidget {
  final Function(int) onPointsEarned;
  final int savedMoney;
  final int savedCigarettes;
  final int consecutiveDays;

  const ChallengeScreen({
    Key? key,
    required this.onPointsEarned,
    required this.savedMoney,
    required this.savedCigarettes,
    required this.consecutiveDays,
  }) : super(key: key);

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Challenge> _challenges = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadChallenges();
    _checkChallengeProgress();
  }

  Future<void> _loadChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final savedChallenges = prefs.getString('challenges');

    if (savedChallenges != null) {
      final List<dynamic> decodedChallenges = jsonDecode(savedChallenges);
      setState(() {
        _challenges = decodedChallenges
            .map((c) => Challenge.fromJson(c))
            .toList();
      });
    } else {
      setState(() {
        _challenges = ChallengeData.defaultChallenges;
      });
    }
  }

  void _checkChallengeProgress() {
    for (var challenge in _challenges) {
      // 금연 재테크 도전과제 체크
      if (challenge.id.startsWith('finance_')) {
        challenge.conditions[0].currentValue = widget.savedMoney;
      }

      // 환경 보호 도전과제 체크
      if (challenge.id.startsWith('environment_')) {
        challenge.conditions[0].currentValue = widget.savedCigarettes;
      }

      // 건강 관련 도전과제 체크
      if (challenge.id.startsWith('health_')) {
        challenge.conditions[0].currentValue = widget.consecutiveDays;
      }

      // 도전과제 완료 체크
      if (!challenge.isCompleted &&
          challenge.conditions.every((c) => c.isCompleted)) {
        _completeChallenge(challenge);
      }
    }
    _saveChallenges();
  }

  Future<void> _saveChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final challengesJson = jsonEncode(
      _challenges.map((c) => c.toJson()).toList(),
    );
    await prefs.setString('challenges', challengesJson);
  }

  void _completeChallenge(Challenge challenge) {
    setState(() {
      challenge.isCompleted = true;
    });

    widget.onPointsEarned(challenge.requiredPoints);

    _showCompletionDialog(challenge);
  }

  void _showCompletionDialog(Challenge challenge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber),
            SizedBox(width: 8),
            Text('도전과제 달성!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('축하합니다!'),
            SizedBox(height: 8),
            Text('획득한 칭호: ${challenge.rewardTitle}'),
            SizedBox(height: 8),
            Text('환경 영향: ${challenge.environmentalImpact}'),
            SizedBox(height: 8),
            Text('보상: ${challenge.requiredPoints} 포인트'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final achievements = _challenges.where((c) => c.type == ChallengeType.achievement).toList();
    final specialChallenges = _challenges.where((c) => c.type == ChallengeType.special).toList();
    final dailyChallenges = _challenges.where((c) => c.type == ChallengeType.daily).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('도전과제'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '업적'),
            Tab(text: '특별'),
            Tab(text: '일일'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChallengeList(achievements),
          _buildChallengeList(specialChallenges),
          _buildChallengeList(dailyChallenges),
        ],
      ),
    );
  }

  Widget _buildChallengeList(List<Challenge> challenges) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return Card(
          child: ListTile(
            leading: Icon(
              challenge.icon,
              color: challenge.isCompleted ? Colors.amber : Colors.grey,
              size: 32,
            ),
            title: Text(
              challenge.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: challenge.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(challenge.description),
                SizedBox(height: 4),
                ...challenge.conditions.map((condition) {
                  final progress = condition.currentValue / condition.targetValue;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${condition.description}: ${condition.currentValue}/${condition.targetValue}',
                        style: TextStyle(fontSize: 12),
                      ),
                      LinearProgressIndicator(
                        value: progress.clamp(0, 1),
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress >= 1 ? Colors.green : Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            trailing: challenge.isCompleted
                ? Tooltip(
              message: challenge.rewardTitle,
              child: Icon(Icons.workspace_premium, color: Colors.amber),
            )
                : Text('${challenge.requiredPoints}P'),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
