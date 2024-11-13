class UserSettings {
  final DateTime quitDate;
  final String nickname;
  final String cigaretteType;
  final int cigarettesPerDay;
  final int cigarettePrice;
  final String? goal;
  final DateTime? targetDate;

  UserSettings({
    required this.quitDate,
    required this.nickname,
    required this.cigaretteType,
    required this.cigarettesPerDay,
    this.cigarettePrice = 4500,
    this.goal,
    this.targetDate,
  });

  Map<String, dynamic> toJson() => {
    'quitDate': quitDate.toIso8601String(),
    'nickname': nickname,
    'cigaretteType': cigaretteType,
    'cigarettesPerDay': cigarettesPerDay,
    'cigarettePrice': cigarettePrice,
    'goal': goal,
    'targetDate': targetDate?.toIso8601String(),
  };

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
    quitDate: DateTime.parse(json['quitDate']),
    nickname: json['nickname'],
    cigaretteType: json['cigaretteType'],
    cigarettesPerDay: json['cigarettesPerDay'],
    cigarettePrice: json['cigarettePrice'] ?? 4500,
    goal: json['goal'],
    targetDate: json['targetDate'] != null
        ? DateTime.parse(json['targetDate'])
        : null,
  );

  UserSettings copyWith({
    DateTime? quitDate,
    String? nickname,
    String? cigaretteType,
    int? cigarettesPerDay,
    int? cigarettePrice,
    String? goal,
    DateTime? targetDate,
  }) {
    return UserSettings(
      quitDate: quitDate ?? this.quitDate,
      nickname: nickname ?? this.nickname,
      cigaretteType: cigaretteType ?? this.cigaretteType,
      cigarettesPerDay: cigarettesPerDay ?? this.cigarettesPerDay,
      cigarettePrice: cigarettePrice ?? this.cigarettePrice,
      goal: goal ?? this.goal,
      targetDate: targetDate ?? this.targetDate,
    );
  }
}