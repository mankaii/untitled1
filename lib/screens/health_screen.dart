import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/health_timeline.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HealthScreen extends StatefulWidget {
  final DateTime quitDate;
  final int cigarettesPerDay;
  final int cigarettePrice;

  const HealthScreen({
    Key? key,
    required this.quitDate,
    required this.cigarettesPerDay,
    this.cigarettePrice = 4500,  // 한갑 기준 가격
  }) : super(key: key);

  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  late Duration _smokeFreeTime;
  late List<HealthTimeline> _healthTimeline;
  final currencyFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');

  @override
  void initState() {
    super.initState();
    _updateSmokeFreeTime();
    _loadHealthTimeline();
  }

  void _updateSmokeFreeTime() {
    _smokeFreeTime = DateTime.now().difference(widget.quitDate);
  }

  void _loadHealthTimeline() {
    _healthTimeline = [
      HealthTimeline(
        duration: const Duration(minutes: 20),
        title: '심박수와 혈압이 정상화되기 시작',
        description: '금연 20분 후부터 심장 건강이 회복되기 시작합니다.',
        icon: Icons.favorite,
      ),
      HealthTimeline(
        duration: const Duration(hours: 12),
        title: '혈액 내 산소량 증가',
        description: '혈중 일산화탄소 수치가 정상으로 돌아갑니다.',
        icon: Icons.air,
      ),
      HealthTimeline(
        duration: const Duration(days: 2),
        title: '미각과 후각이 회복',
        description: '맛과 향을 더 잘 느낄 수 있게 됩니다.',
        icon: Icons.restaurant,
      ),
      HealthTimeline(
        duration: const Duration(days: 14),
        title: '폐 기능 향상',
        description: '호흡이 편해지고 기침이 감소합니다.',
        icon: Icons.health_and_safety,
      ),
      HealthTimeline(
        duration: const Duration(days: 30),
        title: '피부 상태 개선',
        description: '피부 톤이 밝아지고 탄력이 증가합니다.',
        icon: Icons.face,
      ),
      HealthTimeline(
        duration: const Duration(days: 90),
        title: '심폐 기능 대폭 향상',
        description: '운동 능력이 향상되고 피로가 감소합니다.',
        icon: Icons.directions_run,
      ),
      HealthTimeline(
        duration: const Duration(days: 365),
        title: '심장병 위험 절반으로 감소',
        description: '1년 동안 금연을 지속하면 심장병 위험이 크게 줄어듭니다.',
        icon: Icons.monitor_heart,
      ),
    ];
  }

  double _calculateProgress(Duration targetDuration) {
    return (_smokeFreeTime.inSeconds / targetDuration.inSeconds).clamp(0.0, 1.0);
  }

  int _calculateSavedMoney() {
    final cigarettesPerPack = 20;
    final totalCigarettesSaved = (_smokeFreeTime.inDays * widget.cigarettesPerDay);
    final packsSaved = totalCigarettesSaved / cigarettesPerPack;
    return (packsSaved * widget.cigarettePrice).floor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('건강 상태'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 금연 진행 상황 카드
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '금연 ${_smokeFreeTime.inDays}일 ${_smokeFreeTime.inHours % 24}시간',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '절약한 금액: ${currencyFormat.format(_calculateSavedMoney())}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),

          // 건강 회복 타임라인
          Expanded(
            child: ListView.builder(
              itemCount: _healthTimeline.length,
              itemBuilder: (context, index) {
                final timeline = _healthTimeline[index];
                final progress = _calculateProgress(timeline.duration);
                final isCompleted = progress >= 1.0;
                final isInProgress = progress > 0 && progress < 1.0;

                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.2,
                  isFirst: index == 0,
                  isLast: index == _healthTimeline.length - 1,
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    height: 40,
                    indicator: Container(
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green
                            : isInProgress
                            ? Colors.orange
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        timeline.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  beforeLineStyle: LineStyle(
                    color: isCompleted ? Colors.green : Colors.grey[300]!,
                  ),
                  endChild: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeline.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeline.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isInProgress)
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.orange,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}