import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final int smokeFreeHours;

  const ChatScreen({Key? key, required this.smokeFreeHours}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _sendInitialMessage();
  }

  void _sendInitialMessage() async {
    final prompt = GeminiService.getSmokeFreeTips(widget.smokeFreeHours);
    setState(() => _isTyping = true);

    try {
      final response = await GeminiService.getResponse(prompt);
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isTyping = false;
      });
    } catch (e) {
      setState(() => _isTyping = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메시지 전송 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isTyping = true;
    });
    _messageController.clear();

    final prompt = '''
사용자의 메시지: $text
- 현재 ${widget.smokeFreeHours}시간 동안 금연 중
- 공감적이고 지지적인 응답
''';

    try {
      final response = await GeminiService.getResponse(prompt);
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isTyping = false;
      });
    } catch (e) {
      setState(() => _isTyping = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메시지 전송 중 오류가 발생했습니다.')),
      );
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스털링과 대화하기'),
        backgroundColor: Color(0xFF4A90E2), // 상단바 색상
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F4F8), Color(0xFFE5EBF1)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return MessageBubble(message: message);
                },
              ),
            ),
            if (_isTyping)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFF4A90E2), width: 2),
                        image: DecorationImage(
                          image: AssetImage('assets/image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text('스털링이 입력 중...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(_messageController.text),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '메시지를 입력하세요...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Color(0xFF4A90E2),
                    radius: 24,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 35,
              height: 35,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF4A90E2), width: 2),
                image: DecorationImage(
                  image: AssetImage('assets/image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? Color(0xFF4A90E2) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
