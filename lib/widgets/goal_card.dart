import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalCard extends StatelessWidget {
  final String goal;
  final DateTime quitDate;

  const GoalCard({
    Key? key,
    required this.goal,
    required this.quitDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 금연 시작일로부터 6개월 후 날짜 계산
    final targetDate = quitDate.add(const Duration(days: 180)); // 6개월 = 약 180일
    final remainingDays = targetDate.difference(DateTime.now()).inDays;
    final progress = 1 - (remainingDays / 180).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '나의 목표',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(goal),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy.MM.dd').format(quitDate),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  DateFormat('yyyy.MM.dd').format(targetDate),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              remainingDays > 0
                  ? 'D-$remainingDays'
                  : '축하합니다! 금연 성공까지 ${remainingDays.abs()}일 달성!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  Widget _buildDateLabel(BuildContext context, DateTime date, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('yyyy.MM.dd').format(date),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
