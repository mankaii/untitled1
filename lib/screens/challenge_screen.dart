import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../models/challenge.dart';

class ChallengeScreen extends StatefulWidget {
  final Function(int) onPointsEarned;

  const ChallengeScreen({
    Key? key,
    required this.onPointsEarned,
  }) : super(key: key);

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Challenge> _dailyChallenges = [];
  List<Challenge> _weeklyChallenges = [];
  List<Challenge> _specialChallenges = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadChallenges();
  }

  void _loadChallenges() {
    // 일일 챌린지
    _dailyChallenges = [
      Challenge(
        id: 'daily_1',
        title: '물 마시기',
        description: '오늘 물 8잔 마시기',
        points: 50,
        type: 'daily',
        icon: Icons.water_drop,
      ),
      Challenge(
        id: 'daily_2',
        title: '산책하기',
        description: '10분 이상 산책하기',
        points: 50,
        type: 'daily',
        icon: Icons.directions_walk,
      ),
      Challenge(
        id: 'daily_3',
        title: '심호흡',
        description: '심호흡 10번 하기',
        points: 30,
        type: 'daily',
        icon: Icons.air,
      ),
      Challenge(
        id: 'daily_4',
        title: '과일 섭취',
        description: '과일 한 개 먹기',
        points: 30,
        type: 'daily',
        icon: Icons.apple,
      ),
    ];

    // 주간 챌린지
    _weeklyChallenges = [
      Challenge(
        id: 'weekly_1',
        title: '운동 하기',
        description: '이번 주 운동 3회 하기',
        points: 200,
        type: 'weekly',
        icon: Icons.fitness_center,
        deadline: DateTime.now().add(Duration(days: 7)),
      ),
      Challenge(
        id: 'weekly_2',
        title: '스트레스 관리',
        description: '스트레스 관리 일지 5회 작성',
        points: 150,
        type: 'weekly',
        icon: Icons.book,
        deadline: DateTime.now().add(Duration(days: 7)),
      ),
    ];

    // 특별 챌린지
    _specialChallenges = [
      Challenge(
        id: 'special_1',
        title: '첫 24시간',
        description: '금연 첫 24시간 달성',
        points: 500,
        type: 'special',
        icon: Icons.timer,
      ),
      Challenge(
        id: 'special_2',
        title: '일주일 달성',
        description: '금연 7일 연속 달성',
        points: 1000,
        type: 'special',
        icon: Icons.workspace_premium,
      ),
    ];
  }

  Future<void> _completeChallenge(Challenge challenge) async {
    if (!challenge.isCompleted) {
      setState(() {
        challenge.isCompleted = true;
      });

      // 포인트 적립
      widget.onPointsEarned(challenge.points);

      // 축하 다이얼로그 표시
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('챌린지 달성!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration, size: 50, color: Colors.amber),
              SizedBox(height: 16),
              Text('축하합니다!\n${challenge.points}포인트를 획득했습니다!'),
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
  }

  Widget _buildChallengeCard(Challenge challenge) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            challenge.icon,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          challenge.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: challenge.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge.description),
            if (challenge.deadline != null)
              Text(
                '마감: ${DateFormat('yyyy-MM-dd').format(challenge.deadline!)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
          ],
        ),
        trailing: challenge.isCompleted
            ? Icon(Icons.check_circle, color: Colors.green)
            : Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '+${challenge.points}P',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () => _completeChallenge(challenge),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도전 과제'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '일일'),
            Tab(text: '주간'),
            Tab(text: '특별'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 일일 챌린지 목록
          ListView.builder(
            itemCount: _dailyChallenges.length,
            itemBuilder: (context, index) => _buildChallengeCard(_dailyChallenges[index]),
          ),
          // 주간 챌린지 목록
          ListView.builder(
            itemCount: _weeklyChallenges.length,
            itemBuilder: (context, index) => _buildChallengeCard(_weeklyChallenges[index]),
          ),
          // 특별 챌린지 목록
          ListView.builder(
            itemCount: _specialChallenges.length,
            itemBuilder: (context, index) => _buildChallengeCard(_specialChallenges[index]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}