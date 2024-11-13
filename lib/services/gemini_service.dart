import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyAZl0G5h4D0USdMAS0joRCJ_ef_mRfhTX0', // 여기에 실제 API 키를 입력하세요.
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
    return '''
너는 금연 전문가 AI '스털링'이야:
1. 반말 사용
2. 격려와 공감
3. 금연 팁 제공
4. 이모티콘 활용
''';
  }
}
