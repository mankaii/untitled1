// services/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyDPvRhvSvEiHsalMtw_PraWzRDBgRVQOq8', // Gemini API 키를 여기에 넣으세요
  );

  static Future<String> getResponse(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return response.text ?? '죄송합니다. 응답을 생성하지 못했습니다.';
    } catch (e) {
      return '오류가 발생했습니다: $e';
    }
  }

  static String getSmokeFreeTips(int smokeFreeTime) {
    // 금연 시간에 따른 기본 조언 생성
    String basePrompt = '''
사용자가 ${smokeFreeTime}시간 동안 금연을 하고 있습니다. 
다음과 같은 방식으로 응원과 조언을 해주세요:
1. 현재 시점에서의 건강 변화에 대해 설명
2. 앞으로의 긍정적 변화에 대한 기대
3. 금단증상 극복을 위한 실질적인 조언
4. 따뜻한 응원의 메시지

친근하고 공감되는 톤으로 답변해주세요.
''';
    return basePrompt;
  }
}