import 'package:flutter/material.dart';
import 'dart:async';
import '../models/user_settings.dart';
import '../widgets/goal_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/achievement_card.dart';
import 'profile_screen.dart';
import 'challenge_screen.dart';
import 'chat_screen.dart';
//import 'notification_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserSettings settings;

  const HomeScreen({
    Key? key,
    required this.settings,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _points = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _calculatePoints();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _calculatePoints();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculatePoints() {
    final Duration smokeFreeTime = DateTime.now().difference(widget.settings.quitDate);
    setState(() {
      _points = smokeFreeTime.inHours;
    });
  }

  int _calculateSavedMoney() {
    final Duration smokeFreeTime = DateTime.now().difference(widget.settings.quitDate);
    final int savedCigarettes = (smokeFreeTime.inDays * widget.settings.cigarettesPerDay);
    return (savedCigarettes / 20 * widget.settings.cigarettePrice).floor();
  }

  int _calculateSavedCigarettes() {
    final Duration smokeFreeTime = DateTime.now().difference(widget.settings.quitDate);
    return (smokeFreeTime.inDays * widget.settings.cigarettesPerDay).floor();
  }

  @override
  Widget build(BuildContext context) {
    final daysSince = DateTime.now().difference(widget.settings.quitDate).inDays;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.settings.nickname}님의 금연 여정'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    currentPoints: _points,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GoalCard(
            goal: widget.settings.goal,
            targetDate: widget.settings.targetDate,
            quitDate: widget.settings.quitDate,
          ),
          const SizedBox(height: 16),
          StatsCard(
            daysSince: daysSince,
            savedMoney: _calculateSavedMoney(),
            savedCigarettes: _calculateSavedCigarettes(),
          ),
          const SizedBox(height: 16),
          AchievementCard(
            points: _points,
            onProfileTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    currentPoints: _points,
                  ),
                ),
              );
            },
            onChallengeTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeScreen(
                    onPointsEarned: (points) {
                      setState(() {
                        _points += points;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '상담',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '일기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: '도전',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    smokeFreeHours: _points,  // 여기를 수정
                  ),
                ),
              );
              break;
            case 2:
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeScreen(
                    onPointsEarned: (points) {
                      setState(() {
                        _points += points;
                      });
                    },
                  ),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}