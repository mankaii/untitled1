// models/diary_entry.dart
class DiaryEntry {
  final String id;
  final DateTime date;
  final String content;
  final String mood;
  final int smokingDesireLevel;
  final String copingStrategy;

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