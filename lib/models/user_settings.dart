class UserSettings {
  final DateTime quitDate;
  final String nickname;
  final String cigaretteType;
  final int cigarettesPerDay;
  final int cigarettePrice;
  final String? goal;
  // targetDate 제거

  UserSettings({
    required this.quitDate,
    required this.nickname,
    required this.cigaretteType,
    required this.cigarettesPerDay,
    this.cigarettePrice = 4500,
    this.goal,
  });

  Map<String, dynamic> toJson() => {
    'quitDate': quitDate.toIso8601String(),
    'nickname': nickname,
    'cigaretteType': cigaretteType,
    'cigarettesPerDay': cigarettesPerDay,
    'cigarettePrice': cigarettePrice,
    'goal': goal,
  };

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
    quitDate: DateTime.parse(json['quitDate']),
    nickname: json['nickname'],
    cigaretteType: json['cigaretteType'],
    cigarettesPerDay: json['cigarettesPerDay'],
    cigarettePrice: json['cigarettePrice'] ?? 4500,
    goal: json['goal'],
  );
}