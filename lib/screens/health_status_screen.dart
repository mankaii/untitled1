// screens/health_status_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/health_status.dart';
import '../models/user_settings.dart';
import 'package:untitled1/models/daily_survey.dart';
import '../services/gemini_service.dart';

// Chart 라이브러리를 사용하려면 (선택사항)
import 'package:fl_chart/fl_chart.dart';

class HealthStatusScreen extends StatefulWidget {
  final UserSettings settings;
  final List<DailySurvey> surveys;

  const HealthStatusScreen({
    Key? key,
    required this.settings,
    required this.surveys,
  }) : super(key: key);

  @override
  _HealthStatusScreenState createState() => _HealthStatusScreenState();
}

class _HealthStatusScreenState extends State<HealthStatusScreen> {
  late HealthStatus _healthStatus;
  bool _isLoading = true;
  String _aiAdvice = '';

  @override
  void initState() {
    super.initState();
    _loadHealthStatus();
  }

  Future<void> _loadHealthStatus() async {
    final hours = DateTime.now().difference(widget.settings.quitDate).inHours;

    // 건강 상태 계산
    final lungCapacity = HealthStatus.calculateLungCapacity(hours);
    final bloodCirculation = HealthStatus.calculateBloodCirculation(hours);
    final nicotineLevel = HealthStatus.calculateNicotineLevel(hours);

    // AI 분석을 위한 프롬프트 생성
    final prompt = _createHealthAnalysisPrompt(hours, widget.surveys);

    // Gemini AI 분석 요청
    final analysis = await _getAIAnalysis(prompt);

    setState(() {
      _healthStatus = HealthStatus(
        smokeFreeHours: hours,
        lungCapacityImprovement: lungCapacity,
        bloodCirculationImprovement: bloodCirculation,
        nicotineLevel: nicotineLevel,
        improvements: _calculateImprovements(hours),
        recentSurveys: widget.surveys,
        aiAnalysis: analysis,
      );
      _isLoading = false;
    });
  }

  String _createHealthAnalysisPrompt(int hours, List<DailySurvey> surveys) {
    final avgStressLevel = surveys.isEmpty
        ? 0
        : surveys.map((s) => s.stressLevel).reduce((a, b) => a + b) / surveys.length;
    final avgUrgencyLevel = surveys.isEmpty
        ? 0
        : surveys.map((s) => s.urgencyLevel).reduce((a, b) => a + b) / surveys.length;

    return '''
사용자의 금연 상태를 분석하고 건강 조언을 해주세요:

금연 시간: $hours 시간
평균 스트레스 레벨: $avgStressLevel/5
평균 흡연 욕구: $avgUrgencyLevel/5

최근 설문 데이터:
${surveys.map((s) => '- 날짜: ${s.date}, 스트레스: ${s.stressLevel}, 흡연욕구: ${s.urgencyLevel}').join('\n')}

다음 내용을 포함해주세요:
1. 현재 건강 상태 분석
2. 개선된 신체 기능들
3. 주의해야 할 점
4. 스트레스 관리 조언
5. 앞으로의 건강 개선 전망

의학적 근거를 바탕으로 구체적으로 설명해주세요.
''';
  }

  Future<String> _getAIAnalysis(String prompt) async {
    // Gemini API 호출
    try {
      final response = await GeminiService.getResponse(prompt);
      return response;
    } catch (e) {
      return '건강 분석을 불러오는데 실패했습니다.';
    }
  }

  List<String> _calculateImprovements(int hours) {
    final improvements = <String>[];

    if (hours >= 8) improvements.add('혈중 산소량 정상화');
    if (hours >= 24) improvements.add('심장마비 위험 감소');
    if (hours >= 48) improvements.add('후각과 미각 개선');
    if (hours >= 72) improvements.add('기관지 기능 회복');
    if (hours >= 336) improvements.add('폐 기능 개선'); // 2주
    if (hours >= 2160) improvements.add('심장질환 위험 절반으로 감소'); // 3개월

    return improvements;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('건강 상태', style: TextStyle(color: Color(0xFF2D3142))),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHealthMetricsCard(),
              const SizedBox(height: 20),
              _buildImprovementsCard(),
              const SizedBox(height: 20),
              _buildAIAnalysisCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthMetricsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '건강 지표',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildMetricRow(
              icon: Icons.air,
              title: '폐 기능',
              value: _healthStatus.lungCapacityImprovement,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              icon: Icons.favorite,
              title: '혈액순환',
              value: _healthStatus.bloodCirculationImprovement,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              icon: Icons.healing,
              title: '니코틴 수치',
              value: _healthStatus.nicotineLevel,
              color: Colors.orange,
              isReverse: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String title,
    required double value,
    required Color color,
    bool isReverse = false,
  }) {
    final percentage = isReverse ? 100 - value : value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildImprovementsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '개선된 건강 지표',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...(_healthStatus.improvements.map((improvement) =>
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          improvement,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAnalysisCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI 건강 분석',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _healthStatus.aiAnalysis,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}