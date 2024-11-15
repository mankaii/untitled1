import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../models/challenge.dart';
import '../models/user_settings.dart';

class ChallengeScreen extends StatefulWidget {
  final UserSettings userSettings;
  final Function(int) onPointsEarned;
  final int savedMoney;
  final int savedCigarettes;
  final int consecutiveDays;

  ChallengeScreen({
    required this.userSettings,
    required this.onPointsEarned,
    required this.savedMoney,
    required this.savedCigarettes,
    required this.consecutiveDays,
  });

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> with SingleTickerProviderStateMixin {
  List<Challenge> challenges = [];
  String? unlockedChallengeTitle;
  bool showUnlockedAnimation = false;
  late SharedPreferences prefs;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // 챌린지 트리 레벨 정의
  final List<List<String>> challengeLevels = [
    ['health_1'], // Level 1
    ['finance_1', 'clean_air_1'], // Level 2
    ['health_2'], // Level 3
    ['finance_2', 'clean_air_2'], // Level 4
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    initPrefs();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    challenges = getChallenges();
    loadUnlockedStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateChallenges();
    });
  }

  void loadUnlockedStatus() {
    for (var challenge in challenges) {
      challenge.isUnlocked = prefs.getBool(challenge.id) ?? false;
      challenge.isNotified = challenge.isUnlocked;
    }
  }

  void updateChallenges() {
    bool newUnlock = false;

    setState(() {
      for (var challenge in challenges) {
        challenge.updateProgress(
          widget.userSettings.cigarettePrice,
          widget.userSettings.cigarettesPerDay,
          widget.userSettings.quitDate,
        );

        if (challenge.isCompleted && !challenge.isUnlocked) {
          challenge.isUnlocked = true;
          prefs.setBool(challenge.id, true);

          if (!challenge.isNotified) {
            newUnlock = true;
            unlockedChallengeTitle = challenge.title;
            challenge.isNotified = true;
            widget.onPointsEarned(challenge.pointsReward);
          }
        }
      }
    });

    if (newUnlock) {
      showUnlockAnimation();
    }
  }

  void showUnlockAnimation() {
    setState(() {
      showUnlockedAnimation = true;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        showUnlockedAnimation = false;
        unlockedChallengeTitle = null;
      });
    });
  }

  Widget _buildChallengeBranch(Challenge challenge, bool isLeft) {
    final isUnlocked = challenge.isUnlocked;
    final progress = challenge.isCompleted ? 1.0 : 0.0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          CustomPaint(
            size: Size(2, 60),
            painter: BranchPainter(
              progress: progress,
              isLeft: isLeft,
              color: isUnlocked ? Colors.deepPurpleAccent : Colors.grey,
            ),
          ),
          _buildChallengeCard(challenge),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    final isUnlocked = challenge.isUnlocked;

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          // Show challenge details
          _showChallengeDetails(challenge);
        }
      },
      child: Container(
        width: 150,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isUnlocked
                ? [Colors.purple[300]!, Colors.deepPurpleAccent]
                : [Colors.grey[300]!, Colors.grey[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              challenge.icon,
              color: isUnlocked ? Colors.white : Colors.grey[800],
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              challenge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (isUnlocked)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  '+${challenge.pointsReward}P',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showChallengeDetails(Challenge challenge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(challenge.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge.description),
            SizedBox(height: 8),
            Text(
              '환경 영향:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(challenge.environmentalImpact),
            SizedBox(height: 8),
            Text(
              '획득 칭호: ${challenge.rewardTitle}',
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('닫기'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  List<Challenge> getChallenges() {
    return [
      Challenge(
        id: 'health_1',
        title: '건강한 첫걸음',
        description: '금연을 시작한지 3일이 지났습니다. 폐가 회복되기 시작했어요!',
        type: ChallengeType.achievement,
        requiredPoints: 0,
        requiredSavings: 0,
        requiredCigarettes: 0,
        requiredDays: 3,
        icon: Icons.favorite,
        environmentalImpact: '담배 연기가 없는 깨끗한 공기로 3일을 보냈습니다.',
        rewardTitle: '건강 수호자',
        pointsReward: 100,
      ),
      Challenge(
        id: 'finance_1',
        title: '현명한 소비',
        description: '금연으로 5만원을 절약했어요!',
        type: ChallengeType.achievement,
        requiredPoints: 0,
        requiredSavings: 50000,
        requiredCigarettes: 0,
        requiredDays: 0,
        icon: Icons.savings,
        environmentalImpact: '담배 구매 대신 더 가치있는 곳에 투자했습니다.',
        rewardTitle: '절약 달인',
        pointsReward: 150,
      ),
      Challenge(
        id: 'clean_air_1',
        title: '맑은 공기',
        description: '100개의 담배를 피우지 않았어요!',
        type: ChallengeType.achievement,
        requiredPoints: 0,
        requiredSavings: 0,
        requiredCigarettes: 100,
        requiredDays: 0,
        icon: Icons.air,
        environmentalImpact: '100개의 담배 연기가 공기를 오염시키지 않았습니다.',
        rewardTitle: '공기 지킴이',
        pointsReward: 150,
      ),
      Challenge(
        id: 'health_2',
        title: '건강 달성',
        description: '금연 2주를 달성했어요! 폐 기능이 크게 개선되었습니다.',
        type: ChallengeType.achievement,
        requiredPoints: 0,
        requiredSavings: 0,
        requiredCigarettes: 0,
        requiredDays: 14,
        icon: Icons.healing,
        environmentalImpact: '2주 동안 담배 연기 없는 깨끗한 환경을 만들었습니다.',
        rewardTitle: '건강 마스터',
        pointsReward: 200,
      ),
      Challenge(
        id: 'finance_2',
        title: '재정 성공',
        description: '금연으로 10만원을 절약했어요!',
        type: ChallengeType.achievement,
        requiredPoints: 0,
        requiredSavings: 100000,
        requiredCigarettes: 0,
        requiredDays: 0,
        icon: Icons.account_balance,
        environmentalImpact: '절약한 비용으로 환경 보호에 기여할 수 있습니다.',
        rewardTitle: '재정 전문가',
        pointsReward: 250,
      ),
      Challenge(
        id: 'clean_air_2',
        title: '환경 보호',
        description: '500개의 담배를 피우지 않았어요!',
        type: ChallengeType.achievement,
        requiredPoints: 0,
        requiredSavings: 0,
        requiredCigarettes: 500,
        requiredDays: 0,
        icon: Icons.eco,
        environmentalImpact: '500개의 담배꽁초가 환경을 오염시키지 않았습니다.',
        rewardTitle: '환경 수호자',
        pointsReward: 250,
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "도전과제",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 5,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.grey[100]!],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: challengeLevels.asMap().entries.map((entry) {
                  final levelIndex = entry.key;
                  final levelChallenges = entry.value;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: levelChallenges.length > 1
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.center,
                        children: levelChallenges.asMap().entries.map((challengeEntry) {
                          final challenge = challenges.firstWhere(
                                (c) => c.id == challengeEntry.value,
                          );
                          return _buildChallengeBranch(
                            challenge,
                            challengeEntry.key.isEven,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          if (showUnlockedAnimation && unlockedChallengeTitle != null)
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "$unlockedChallengeTitle 해금되었습니다!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BranchPainter extends CustomPainter {
  final double progress;
  final bool isLeft;
  final Color color;

  BranchPainter({
    required this.progress,
    required this.isLeft,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isLeft) {
      path.moveTo(size.width / 2, 0);
      path.quadraticBezierTo(
        -20,
        size.height / 2,
        size.width / 2,
        size.height,
      );
    } else {
      path.moveTo(size.width / 2, 0);
      path.quadraticBezierTo(
        size.width + 20,
        size.height / 2,
        size.width / 2,
        size.height,
      );
    }

    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(
      0.0,
      pathMetrics.length * progress,
    );

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(BranchPainter oldDelegate) =>
      progress != oldDelegate.progress ||
          isLeft != oldDelegate.isLeft ||
          color != oldDelegate.color;
}