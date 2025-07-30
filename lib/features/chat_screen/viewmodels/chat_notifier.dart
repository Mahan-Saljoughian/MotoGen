import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/chat_screen/model/chat_message.dart';
import 'package:motogen/features/chat_screen/model/chat_state.dart';


class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() => ChatState(messages: []);

  final List<String> _suggestionQuestions = [
    "زمان تعویض روغن ماشین من کیه؟",
    "هر چند وقت یه بار باید فیلتر هوا عوض بشه؟",
    "ماشین من ۸۰هزار کیلومتر کار کرده، چه سرویس‌هایی لازمه؟",
  ];

  List<String> get suggestionQuestions => _suggestionQuestions;

  void sendUserMessage(String question) {
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(text: question, sender: MessageSender.user),
      ],
      isLoading: true,
    );

    Future.delayed(Duration(seconds: 2), () {
      _addAIMessage(_aiReply(question));
    });
  }

  void _addAIMessage(String reply) {
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(text: reply, sender: MessageSender.ai),
      ],
      isLoading: false,
    );
  }

  String _aiReply(String question) {
    // Replace with actual API
    if (question.contains('روغن')) return 'هر ۵۰۰۰ کیلومتر روغن رو عوض کن!';
    if (question.contains('سرویس')) return 'سرویس کامل شامل روغن، فیلتر و ترمز!';
    return 'پاسخ ثبت شد!';
  }

  void clearAll() => state = state.copyWith(messages: []);
}

final chatNotifierProvider = NotifierProvider<ChatNotifier, ChatState>(
  () => ChatNotifier(),
);
