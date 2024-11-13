// screens/diary_stats_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/diary_entry.dart';

class DiaryStatsScreen extends StatelessWidget {
  final List<DiaryEntry> entries;

  const DiaryStatsScreen({Key? key, required this.entries}) : super(key: key);

  MoodStats _calculateStats() {
    final moodCounts = <String, int>{};
    var totalSmokingDesire = 0;

    for (var entry in entries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
      totalSmokingDesire += entry.smokingDesireLevel;
    }

    return MoodStats(
      moodCounts: moodCounts,
      averageSmokingDesire: entries.isEmpty ? 0 : totalSmokingDesire / entries.length,
      recentEntries: entries.take(7).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('감정 통계'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 감정 분포 카드
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '감정 분포',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: stats.moodCounts.entries.map((e) {
                            return BarChartGroupData(
                              x: stats.moodCounts.keys.toList().indexOf(e.key),
                              barRods: [
                                BarChartRodData(
                                  toY: e.value.toDouble(),
                                  color: Theme.of(context).primaryColor,
                                  width: 20,
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    stats.moodCounts.keys.toList()[value.toInt()],
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 흡연 욕구 추이
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '흡연 욕구 추이',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                reservedSize: 40,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= stats.recentEntries.length) {
                                    return const Text('');
                                  }
                                  final date = stats.recentEntries[value.toInt()].date;
                                  return Text(
                                    '${date.day}일',
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: const Color(0xff37434d)),
                          ),
                          minX: 0,
                          maxX: 6,
                          minY: 0,
                          maxY: 5,
                          lineBarsData: [
                            LineChartBarData(
                              spots: stats.recentEntries.asMap().entries.map((e) {
                                return FlSpot(
                                  e.key.toDouble(),
                                  e.value.smokingDesireLevel.toDouble(),
                                );
                              }).toList(),
                              isCurved: true,
                              color: Theme.of(context).primaryColor,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '평균 흡연 욕구: ${stats.averageSmokingDesire.toStringAsFixed(1)}/5',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),

            // 최근 기록 요약
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '최근 기록 분석',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '가장 많이 느낀 감정: ${_getMostFrequentMood(stats.moodCounts)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '기록 횟수: ${entries.length}일',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMostFrequentMood(Map<String, int> moodCounts) {
    if (moodCounts.isEmpty) return '데이터 없음';
    return moodCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}