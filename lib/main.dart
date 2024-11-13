import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'screens/profile_screen.dart';
import 'models/profile_item.dart';
import 'screens/health_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/diary_screen.dart';
import 'screens/diary_stats_screen.dart';
import 'screens/UserSettingPage.dart'; // UserSettingPage import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '금연 도우미',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: UserSettingsPage(), // 처음에 유저 세팅 페이지로 이동
    );
  }
}

// 메인 홈 화면
class HomeScreen extends StatefulWidget {
  final UserSettings settings;

  HomeScreen({required this.settings});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _points = 0;
  String _mood = '';
  Timer? _timer;

  // 금연 시간에 따른 포인트 계산
  void calculatePoints() {
    final Duration smokeFreeTime = DateTime.now().difference(widget.settings.quitDate);
    setState(() {
      _points = smokeFreeTime.inHours; // 1시간당 1포인트
    });
  }

  int calculateSavedCigarettes() {
    final Duration smokeFreeTime = DateTime.now().difference(widget.settings.quitDate);
    return (smokeFreeTime.inDays * widget.settings.cigarettesPerDay).round();
  }

  @override
  void initState() {
    super.initState();
    calculatePoints();
    // 주기적으로 포인트 업데이트 (1분마다)
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      calculatePoints();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Timer 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('금연 시작일: ${DateFormat('yyyy-MM-dd').format(widget.settings.quitDate)}'),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stars, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        '보유 포인트: $_points P',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('절약한 담배: ${calculateSavedCigarettes()} 개비'),
                ],
              ),
            ),
          ),

          // 프로필 꾸미기 버튼
          Card(
            child: ListTile(
              leading: Icon(Icons.palette),
              title: Text('프로필 꾸미기'),
              subtitle: Text('포인트로 프로필을 꾸며보세요'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
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
          ),

          // 건강 상태 버튼
          Card(
            child: ListTile(
              leading: Icon(Icons.health_and_safety),
              title: Text('건강 상태'),
              subtitle: Text('금연으로 인한 건강 변화를 확인하세요'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthScreen(
                      quitDate: widget.settings.quitDate,
                      cigarettesPerDay: widget.settings.cigarettesPerDay,
                    ),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.emoji_events),
              title: Text('도전 과제'),
              subtitle: Text('재미있는 챌린지에 도전하고 포인트를 얻으세요'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChallengeScreen(
                      onPointsEarned: (int points) {
                        setState(() {
                          _points += points;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.book),
              title: Text('금연 일기'),
              subtitle: Text('오늘의 이야기를 기록해보세요'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryScreen(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('오늘의 기분을 기록해주세요'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      EmojiButton('😊', '행복해요'),
                      EmojiButton('😔', '우울해요'),
                      EmojiButton('😤', '짜증나요'),
                      EmojiButton('😌', '평온해요'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotScreen()),
              );
            },
            child: Text('AI 상담사와 대화하기'),
          ),
        ],
      ),
    );
  }
}

// 감정 버튼 위젯
class EmojiButton extends StatelessWidget {
  final String emoji;
  final String label;

  EmojiButton(this.emoji, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            final today = DateTime.now().toIso8601String().split('T')[0];
            await prefs.setString('mood_$today', label);
          },
          child: Text(emoji, style: TextStyle(fontSize: 30)),
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

// AI 챗봇 화면
class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) {
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      // 여기에 실제 AI 챗봇 응답 로직을 구현해야 합니다
      _messages.add({
        'role': 'bot',
        'content': '금연 성공을 위한 조언: 스트레스 관리가 중요합니다. 운동이나 취미 활동을 통해 스트레스를 해소해보세요.'
      });
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI 상담사')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  leading: message['role'] == 'user'
                      ? Icon(Icons.person)
                      : Icon(Icons.android),
                  title: Text(message['content']!),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _sendMessage(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}