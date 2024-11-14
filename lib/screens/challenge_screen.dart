import 'package:flutter/material.dart';
import 'dart:async';
import '../models/challenge.dart';
import '../models/user_settings.dart';

class ChallengeScreen extends StatefulWidget {
  final UserSettings userSettings;
  final Function(int) onPointsEarned;
  final int savedMoney;
  final int savedCigarettes;
  final int consecutiveDays; // consecutiveDays 매개변수 추가

  ChallengeScreen({
    required this.userSettings,
    required this.onPointsEarned,
    required this.savedMoney,
    required this.savedCigarettes,
    required this.consecutiveDays, // required 추가
  });

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  List<Challenge> challenges = [];
  String? unlockedChallengeTitle;
  bool showUnlockedAnimation = false;

  @override
  void initState() {
    super.initState();
    challenges = getChallenges();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateChallenges();
    });
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
          if (!challenge.isNotified) {
            newUnlock = true;
            unlockedChallengeTitle = challenge.title;
            challenge.isNotified = true;
          }
        }
      }
      challenges.sort((a, b) => (b.isUnlocked ? 1 : 0).compareTo(a.isUnlocked ? 1 : 0));
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

  List<Challenge> getChallenges() {
    return [
      Challenge(
        id: 'finance_1',
        title: '금연 재테크 입문자',
        description: '금연으로 10만원 절약하기',
        type: ChallengeType.achievement,
        requiredPoints: 100,
        requiredSavings: 100000,
        requiredCigarettes: 0,
        requiredDays: 0,
        environmentalImpact: '절약한 비용으로 나무 한 그루를 심을 수 있어요',
        rewardTitle: '알뜰한 금연인',
        icon: Icons.savings,
      ),
      Challenge(
        id: 'finance_2',
        title: '금연 재테크 마스터',
        description: '금연으로 50만원 절약하기',
        type: ChallengeType.achievement,
        requiredPoints: 500,
        requiredSavings: 500000,
        requiredCigarettes: 0,
        requiredDays: 0,
        environmentalImpact: '절약한 비용으로 작은 숲을 만들 수 있어요',
        rewardTitle: '금연 재테크의 달인',
        icon: Icons.account_balance_wallet,
      ),
      Challenge(
        id: 'clean_air_1',
        title: '깨끗한 공기 지킴이',
        description: '100개비의 담배로부터 지구 지키기',
        type: ChallengeType.achievement,
        requiredPoints: 200,
        requiredSavings: 0,
        requiredCigarettes: 100,
        requiredDays: 0,
        environmentalImpact: '담배 100개비는 약 20L의 깨끗한 물을 오염시킬 수 있어요',
        rewardTitle: '지구 수호자',
        icon: Icons.eco,
      ),
      Challenge(
        id: 'clean_air_2',
        title: '미세먼지 해결사',
        description: '500개비의 담배로부터 공기 보호하기',
        type: ChallengeType.achievement,
        requiredPoints: 800,
        requiredSavings: 0,
        requiredCigarettes: 500,
        requiredDays: 0,
        environmentalImpact: '500개비의 담배는 공기와 환경을 오염시킬 수 있어요',
        rewardTitle: '미세먼지 해결사',
        icon: Icons.filter_hdr,
      ),
      Challenge(
        id: 'health_1',
        title: '꾸준한 첫걸음',
        description: '금연 시작 후 7일 경과',
        type: ChallengeType.special,
        requiredPoints: 150,
        requiredSavings: 0,
        requiredCigarettes: 0,
        requiredDays: 7,
        environmentalImpact: '당신의 폐가 회복되기 시작했어요',
        rewardTitle: '새싹 금연인',
        icon: Icons.favorite,
      ),
      Challenge(
        id: 'health_2',
        title: '건강한 금연 마스터',
        description: '금연 시작 후 30일 경과',
        type: ChallengeType.special,
        requiredPoints: 600,
        requiredSavings: 0,
        requiredCigarettes: 0,
        requiredDays: 30,
        environmentalImpact: '30일 금연으로 건강이 크게 개선되었어요',
        rewardTitle: '건강 달인',
        icon: Icons.star,
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                final isUnlocked = challenge.isUnlocked;
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: isUnlocked
                        ? LinearGradient(
                      colors: [Colors.purple[300]!, Colors.deepPurpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : LinearGradient(
                      colors: [Colors.grey[300]!, Colors.grey[500]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(
                      challenge.icon,
                      color: isUnlocked ? Colors.white : Colors.grey[800],
                      size: 32,
                    ),
                    title: Text(
                      challenge.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      challenge.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    trailing: isUnlocked && challenge.isCompleted
                        ? Icon(Icons.check_circle, color: Colors.greenAccent, size: 30)
                        : Icon(Icons.lock, color: Colors.white70, size: 30),
                  ),
                );
              },
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
