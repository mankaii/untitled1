import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_settings.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _nicknameController = TextEditingController();
  final _smokingAmountController = TextEditingController();
  final _goalController = TextEditingController();

  DateTime? _quitDate;
  String _nickname = '';
  String _cigaretteType = '연초';
  int _cigarettesPerDay = 0;
  String? _goal;
  DateTime? _targetDate;
  int _currentPage = 0;

  final List<CigaretteType> _cigaretteTypes = [
    CigaretteType(
      name: '연초',
      description: '일반 담배',
      icon: Icons.smoking_rooms,
    ),
    CigaretteType(
      name: '궐련형 전자담배',
      description: '아이코스, 릴 등',
      icon: Icons.battery_charging_full,
    ),
    CigaretteType(
      name: '액상형 전자담배',
      description: '쥴, 릴베이퍼 등',
      icon: Icons.waves,
    ),
    CigaretteType(
      name: '기타',
      description: '파이프 등',
      icon: Icons.more_horiz,
    ),
  ];

  int _currentTypeIndex = 0;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() {
      setState(() {
        _nickname = _nicknameController.text;
      });
    });

    _smokingAmountController.addListener(() {
      if (_smokingAmountController.text.isNotEmpty) {
        setState(() {
          _cigarettesPerDay = int.parse(_smokingAmountController.text);
        });
      }
    });

    _goalController.addListener(() {
      setState(() {
        _goal = _goalController.text;
      });
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _smokingAmountController.dispose();
    _goalController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildNicknamePage(),
              _buildCigaretteTypePage(),
              _buildSmokingAmountPage(),
              _buildQuitDatePage(),
              _buildGoalPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildNicknamePage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '반갑습니다!',
            style: Theme
                .of(context)
                .textTheme
                .headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '금연을 결심하신 것을 축하드립니다.',
            style: Theme
                .of(context)
                .textTheme
                .bodyLarge,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: '닉네임',
              hintText: '사용하실 닉네임을 입력해주세요',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '닉네임을 입력해주세요';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCigaretteTypePage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '어떤 담배를 피우시나요?',
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall,
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: _cigaretteTypes.length,
              controller: PageController(viewportFraction: 0.8),
              onPageChanged: (int index) {
                setState(() {
                  _currentTypeIndex = index;
                  _cigaretteType = _cigaretteTypes[index].name;
                });
              },
              itemBuilder: (_, i) => _buildCigaretteTypeItem(i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCigaretteTypeItem(int index) {
    return Transform.scale(
      scale: index == _currentTypeIndex ? 1 : 0.9,
      child: Card(
        elevation: index == _currentTypeIndex ? 8 : 2,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _cigaretteTypes[index].icon,
                size: 64,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                _cigaretteTypes[index].name,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _cigaretteTypes[index].description,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmokingAmountPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '하루에 몇 개비를 피우시나요?',
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _smokingAmountController,
            decoration: const InputDecoration(
              labelText: '하루 흡연량',
              suffixText: '개비',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '하루 흡연량을 입력해주세요';
              }
              final number = int.tryParse(value);
              if (number == null || number <= 0 || number > 99) {
                return '1~99 사이의 숫자를 입력해주세요';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuitDatePage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '언제부터 시작하시나요?',
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall,
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() {
                  _quitDate = picked;
                });
              }
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(
              _quitDate == null
                  ? '날짜 선택하기'
                  : DateFormat('yyyy년 MM월 dd일').format(_quitDate!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '금연 목표를 설정해주세요',
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _goalController,
            decoration: const InputDecoration(
              labelText: '목표',
              hintText: '예: 가족들과 건강하게 지내기',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              );
              if (picked != null) {
                setState(() {
                  _targetDate = picked;
                });
              }
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(
              _targetDate == null
                  ? '목표 날짜 선택하기'
                  : DateFormat('yyyy년 MM월 dd일').format(_targetDate!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    bool canProceed = false;

    switch (_currentPage) {
      case 0:
        canProceed = _nicknameController.text.isNotEmpty;
        break;
      case 1:
        canProceed = true; // 담배 종류는 기본값이 있음
        break;
      case 2:
        canProceed = _smokingAmountController.text.isNotEmpty;
        break;
      case 3:
        canProceed = _quitDate != null;
        break;
      case 4:
        canProceed = _goalController.text.isNotEmpty && _targetDate != null;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('이전'),
            )
          else
            const SizedBox(width: 80),
          Text('${_currentPage + 1}/5'),
          TextButton(
            onPressed: canProceed
                ? _currentPage == 4
                ? _submitForm
                : () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
                : null,
            child: Text(_currentPage == 4 ? '시작하기' : '다음'),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_quitDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('금연 시작일을 선택해주세요')),
        );
        return;
      }

      if (_goalController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('금연 목표를 입력해주세요')),
        );
        return;
      }

      if (_smokingAmountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('하루 흡연량을 입력해주세요')),
        );
        return;
      }

      final settings = UserSettings(
          quitDate: _quitDate!,
          nickname: _nicknameController.text.trim(),
          cigaretteType: _cigaretteType,
          cigarettesPerDay: int.parse(_smokingAmountController.text),
          cigarettePrice: 4500,
          goal: _goalController.text.trim()
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userSettings', jsonEncode(settings.toJson()));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(settings: settings),
        ),
      );
    }
  }
}

class CigaretteType {
  final String name;
  final String description;
  final IconData icon;

  CigaretteType({
    required this.name,
    required this.description,
    required this.icon,
  });
}