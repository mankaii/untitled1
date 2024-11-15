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