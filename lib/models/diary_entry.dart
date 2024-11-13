// models/diary_entry.dart
class DiaryEntry {
  final String id;
  final DateTime date;
  final String content;
  final String mood;
  final int smokingDesireLevel; // 흡연 욕구 레벨 (1-5)
  final String copingStrategy; // 흡연 욕구 대처 방법

  DiaryEntry({
    required this.id,
    required this.date,
    required this.content,
    required this.mood,
    required this.smokingDesireLevel,
    required this.copingStrategy,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'content': content,
    'mood': mood,
    'smokingDesireLevel': smokingDesireLevel,
    'copingStrategy': copingStrategy,
  };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
    id: json['id'],
    date: DateTime.parse(json['date']),
    content: json['content'],
    mood: json['mood'],
    smokingDesireLevel: json['smokingDesireLevel'],
    copingStrategy: json['copingStrategy'],
  );
}

// 감정 통계를 위한 클래스
class MoodStats {
  final Map<String, int> moodCounts;
  final double averageSmokingDesire;
  final List<DiaryEntry> recentEntries;

  MoodStats({
    required this.moodCounts,
    required this.averageSmokingDesire,
    required this.recentEntries,
  });
}