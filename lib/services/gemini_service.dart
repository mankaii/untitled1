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
1. 사용자에게 반말로 친근하고 격려의 말투로 응답해줘.
2. 응답은 금연을 지지하는 팁과 함께 용기를 복돋우는 긴 문장으로 해줘.
3. 사용자가 ${smokeFreeTime}시간 동안 금연했다면, 그 시간을 칭찬하고 격려해.
4. 예시:
   - "와! 벌써 ${smokeFreeTime}시간 동안 담배 안 폈네! 진짜 멋지다. 담배 생각나면 물을 마시거나 산책해봐. 니가 해낼 수 있을 거야!"
   - "니가 ${smokeFreeTime}시간 동안 참았다니! 이제 담배 없이도 충분히 멋진 모습을 보여줄 수 있어. 조금만 더 힘내보자!"
   - "벌써 ${smokeFreeTime}시간 금연했어! 담배 생각나면 깊게 숨 쉬어봐. 진짜 잘하고 있어!"
''';
  }

}
