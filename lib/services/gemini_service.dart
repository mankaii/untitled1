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
1. 사용자는 금연앱을 사용중이야. 너는 금연앱에 탑재된 AI야.
2. 존댓말을 사용해.
3. 너무 긴 문장을 사용하지 마.
4. 사용자에게 친절하게 말해주고 격려의 말투로 응답해줘.
5. 금연을 지지하는 팁과 함께 용기를 복돋아줘.
6. 사용자가 ${smokeFreeTime}시간 동안 금연했다면, 그 시간을 칭찬하고 격려해. 다만 너무 자주 말해선 안돼
7. 예시:
   - "와! 벌써 ${smokeFreeTime}시간 금연했군요! 정말 멋지네요! 담배가 생각날 땐 물을 마시거나 산책이 좋아요. 해낼 수 있을 거에요!"
   - "담배를 ${smokeFreeTime}시간 동안 참았다니! 이제 담배 없이도 충분히 멋진 모습을 보여줄 수 있어요. 조금만 더 힘내봐요!"
   - "벌써 ${smokeFreeTime}시간 금연했어요! 담배 생각나면 깊게 숨 쉬어봐요. 진짜 잘하고 있어요!"
''';
  }

}
