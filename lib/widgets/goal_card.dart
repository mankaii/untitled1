import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalCard extends StatelessWidget {
  final String? goal;
  final DateTime? targetDate;
  final DateTime quitDate;

  const GoalCard({
    Key? key,
    this.goal,
    this.targetDate,
    required this.quitDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (goal == null || targetDate == null) return SizedBox.shrink();

    final totalDays = targetDate!.difference(quitDate).inDays;
    final remainingDays = targetDate!.difference(DateTime.now()).inDays;
    final progress = 1 - (remainingDays / totalDays);

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
            Text(goal!),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
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
                  DateFormat('yyyy.MM.dd').format(targetDate!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'D-$remainingDays',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}