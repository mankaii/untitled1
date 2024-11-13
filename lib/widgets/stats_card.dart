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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.8),
            Theme.of(context).primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  context,
                  daysSince.toString(),
                  '일째',
                  '금연 중',
                  Icons.calendar_today_rounded,
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildStatItem(
                  context,
                  NumberFormat.currency(
                    symbol: '₩',
                    locale: 'ko_KR',
                    decimalDigits: 0,
                  ).format(savedMoney),
                  '',
                  '절약 금액',
                  Icons.savings_rounded,
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildStatItem(
                  context,
                  savedCigarettes.toString(),
                  '개비',
                  '참은 담배',
                  Icons.smoke_free_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String value,
      String unit,
      String label,
      IconData icon,
      ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: unit,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}