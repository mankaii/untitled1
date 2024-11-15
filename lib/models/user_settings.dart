class UserSettings {
  final DateTime quitDate;
  final String nickname;
  final String cigaretteType;
  final int cigarettesPerDay;
  final int cigarettePrice;
  final String? goal;
  final DateTime? targetDate; // 목표일자 추가

  UserSettings({
    required this.quitDate,
    required this.nickname,
    required this.cigaretteType,
    required this.cigarettesPerDay,
    required this.cigarettePrice,
    this.goal,
    this.targetDate, // 필드 초기화
  });

  Map<String, dynamic> toJson() => {
    'quitDate': quitDate.toIso8601String(),
    'nickname': nickname,
    'cigaretteType': cigaretteType,
    'cigarettesPerDay': cigarettesPerDay,
    'cigarettePrice': cigarettePrice,
    'goal': goal,
    'targetDate': targetDate?.toIso8601String(), // JSON 변환
  };

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
    quitDate: DateTime.parse(json['quitDate']),
    nickname: json['nickname'],
    cigaretteType: json['cigaretteType'],
    cigarettesPerDay: json['cigarettesPerDay'],
    cigarettePrice: json['cigarettePrice'],
    goal: json['goal'],
    targetDate: json['targetDate'] != null
        ? DateTime.parse(json['targetDate'])
        : null, // JSON 읽기
  );
}
