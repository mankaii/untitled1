// achievement_card.dart
import 'package:flutter/material.dart';

class AchievementCard extends StatelessWidget {
  final int points;
  final VoidCallback onProfileTap;
  final VoidCallback onChallengeTap;

  const AchievementCard({
    Key? key,
    required this.points,
    required this.onProfileTap,
    required this.onChallengeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.stars_rounded,
            iconColor: Colors.amber,
            title: '보유 포인트',
            value: '$points P',
            onTap: onProfileTap,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.grey[100],
          ),
          _buildMenuItem(
            context,
            icon: Icons.emoji_events_rounded,
            iconColor: Theme.of(context).primaryColor,
            title: '오늘의 도전과제',
            subtitle: '새로운 도전과제를 확인해보세요!',
            onTap: onChallengeTap,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required Color iconColor,
        required String title,
        String? value,
        String? subtitle,
        required VoidCallback onTap,
        required Gradient gradient,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}