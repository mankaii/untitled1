import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  late DateTime _startDate;
  String _nickname = '';
  String _selectedTobaccoType = '연초(궐련형)';
  int _dailySmoking = 1;
  String _addictionLevel = '보통';

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

  final List<String> _addictionLevels = ['매우심함', '심함', '보통', '참을 수 있음', '참기 쉬움'];

  static const String KEY_NICKNAME = 'nickname';
  static const String KEY_START_DATE = 'start_date';
  static const String KEY_TOBACCO_TYPE = 'tobacco_type';
  static const String KEY_DAILY_SMOKING = 'daily_smoking';
  static const String KEY_ADDICTION_LEVEL = 'addiction_level';
  static const String KEY_IS_FIRST_TIME = 'is_first_time';

  int _currentTypeIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    bool isFirstTime = _prefs.getBool(KEY_IS_FIRST_TIME) ?? true;

    if (!isFirstTime) {
      setState(() {
        _nickname = _prefs.getString(KEY_NICKNAME) ?? '';
        _startDate = DateTime.fromMillisecondsSinceEpoch(
            _prefs.getInt(KEY_START_DATE) ?? DateTime.now().millisecondsSinceEpoch
        );
        _selectedTobaccoType = _prefs.getString(KEY_TOBACCO_TYPE) ?? '연초(궐련형)';
        _dailySmoking = _prefs.getInt(KEY_DAILY_SMOKING) ?? 1;
        _addictionLevel = _prefs.getString(KEY_ADDICTION_LEVEL) ?? '보통';
        _navigateToHome();
      });
    } else {
      setState(() {
        _startDate = DateTime.now();
      });
    }

    setState(() {
      _isInitialized = true;
    });
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '금연 여정을',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Text(
          '시작해볼까요?',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
      ],
    );
  }

  Widget _buildNicknameSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '닉네임',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _nickname,
            onChanged: (value) {
              setState(() {
                _nickname = value;
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: '사용하실 닉네임을 입력해주세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[400]!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '금연 시작일',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _startDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.blue[400]!,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  _startDate = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_startDate.year}년 ${_startDate.month}월 ${_startDate.day}일',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                  Icon(Icons.calendar_today, color: Colors.blue[400]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCigaretteTypesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '담배 종류',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            child: PageView.builder(
              itemCount: _cigaretteTypes.length,
              controller: PageController(viewportFraction: 0.8),
              onPageChanged: (int index) {
                setState(() {
                  _currentTypeIndex = index;
                  _selectedTobaccoType = _cigaretteTypes[index].name;
                });
              },
              itemBuilder: (_, i) {
                return Transform.scale(
                  scale: i == _currentTypeIndex ? 1 : 0.9,
                  child: Card(
                    elevation: i == _currentTypeIndex ? 8 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: i == _currentTypeIndex
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _cigaretteTypes[i].icon,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(height: 8),
                          Text(
                            _cigaretteTypes[i].name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _cigaretteTypes[i].description,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmokingDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '흡연 정보',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: '하루 평균 흡연량',
            value: _dailySmoking,
            items: List.generate(30, (index) => index + 1).map((value) {
              return DropdownMenuItem(value: value, child: Text('$value 개비'));
            }).toList(),
            onChanged: (int? value) {
              setState(() {
                _dailySmoking = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: '흡연 충동 정도',
            value: _addictionLevel,
            items: _addictionLevels.map((level) {
              return DropdownMenuItem(value: level, child: Text(level));
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _addictionLevel = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[400]!),
              ),
            ),
            dropdownColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: ElevatedButton(
        onPressed: _savePreferences,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          '금연 시작하기',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _savePreferences() async {
    await _prefs.setString(KEY_NICKNAME, _nickname);
    await _prefs.setInt(KEY_START_DATE, _startDate.millisecondsSinceEpoch);
    await _prefs.setString(KEY_TOBACCO_TYPE, _selectedTobaccoType);
    await _prefs.setInt(KEY_DAILY_SMOKING, _dailySmoking);
    await _prefs.setString(KEY_ADDICTION_LEVEL, _addictionLevel);
    await _prefs.setBool(KEY_IS_FIRST_TIME, false);

    _navigateToHome(); // 추가
  }

  void _navigateToHome() {
    final settings = UserSettings(
      quitDate: _startDate,
      nickname: _nickname,
      cigaretteType: _selectedTobaccoType,
      cigarettesPerDay: _dailySmoking,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(settings: settings),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        body: SafeArea(
        child: Stack(
        children: [
        ListView(
        padding: const EdgeInsets.all(24.0),
    children: [
    const SizedBox(height: 20),
    _buildHeader(),
    const SizedBox(height: 40),
    _buildNicknameSection(),
    const SizedBox(height: 24),
      _buildDateSection(),
      const SizedBox(height: 24),
      _buildCigaretteTypesSection(),
      const SizedBox(height: 24),
      _buildSmokingDetailsSection(),
      const SizedBox(height: 100),
    ],
        ),
          _buildSaveButton(),
        ],
        ),
        ),
    );
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
class UserSettings {
  final DateTime quitDate;
  final String nickname;
  final String cigaretteType;
  final int cigarettesPerDay;
  UserSettings({
    required this.quitDate,
    required this.nickname,
    required this.cigaretteType,
    required this.cigarettesPerDay,
  });
  Map<String, dynamic> toJson() {
    return {
      'quitDate': quitDate.toIso8601String(),
      'nickname': nickname,
      'cigaretteType': cigaretteType,
      'cigarettesPerDay': cigarettesPerDay,
    };
  }
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      quitDate: DateTime.parse(json['quitDate']),
      nickname: json['nickname'],
      cigaretteType: json['cigaretteType'],
      cigarettesPerDay: json['cigarettesPerDay'],
    );
  }
}
