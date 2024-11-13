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
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.stars, color: Colors.amber),
            title: Text('보유 포인트: $points P'),
            trailing: Icon(Icons.chevron_right),
            onTap: onProfileTap,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: const Text('오늘의 도전과제'),
            trailing: Icon(Icons.chevron_right),
            onTap: onChallengeTap,
          ),
        ],
      ),
    );
  }
}
