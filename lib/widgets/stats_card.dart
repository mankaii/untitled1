import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsCard extends StatelessWidget {
  final int daysSince;
  final int savedMoney;
  final int savedCigarettes;

  const StatsCard({
    Key? key,
    required this.daysSince,
    required this.savedMoney,
    required this.savedCigarettes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              '$daysSince일',
              '금연 기간',
              Icons.calendar_today,
            ),
            _buildStatItem(
              context,
              '${NumberFormat.currency(
                symbol: '₩',
                locale: 'ko_KR',
                decimalDigits: 0,
              ).format(savedMoney)}',
              '절약 금액',
              Icons.savings,
            ),
            _buildStatItem(
              context,
              '$savedCigarettes개비',
              '참은 담배',
              Icons.smoke_free,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String value,
      String label,
      IconData icon,
      ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}