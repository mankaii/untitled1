import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final String goal;
  final DateTime quitDate;
  final DateTime? targetDate;

  GoalCard({
    required this.goal,
    required this.quitDate,
    required this.targetDate,
  });

  @override
  Widget build(BuildContext context) {
    final daysSinceQuit = DateTime.now().difference(quitDate).inDays;
    final totalGoalDays =
    targetDate != null ? targetDate!.difference(quitDate).inDays : null;
    final progress = totalGoalDays != null
        ? (daysSinceQuit / totalGoalDays).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      width: double.infinity, // 부모 위젯의 전체 너비 사용
      height: 180, // 다른 위젯과 동일한 높이 설정
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "나의 목표",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                goal,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              targetDate != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "목표일자: ${targetDate!.year}년 ${targetDate!.month}월 ${targetDate!.day}일",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height: 8.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300],
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "진척도: ${daysSinceQuit}일 / ${totalGoalDays ?? "∞"}일",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              )
                  : Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "목표일자가 설정되지 않았습니다.",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
