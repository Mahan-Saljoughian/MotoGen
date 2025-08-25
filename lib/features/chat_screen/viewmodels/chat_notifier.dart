import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/chat_screen/data/chat_repository.dart';
import 'package:motogen/features/chat_screen/model/chat_message.dart';
import 'package:motogen/features/chat_screen/model/chat_state.dart';

class ChatNotifier extends AsyncNotifier<ChatState> {
  ChatState? get currentState => state.value;

  @override
  Future<ChatState> build() async {
    // Just delegate to the use case extension
    return await loadInitialSession();
  }

  final List<String> _suggestionQuestions = [
    "زمان تعویض روغن ماشین من کیه؟",
    "هر چند وقت یه بار باید فیلتر هوا عوض بشه؟",
    "ماشین من ۸۰هزار کیلومتر کار کرده، چه سرویس‌هایی لازمه؟",
  ];

  List<String> get suggestionQuestions => _suggestionQuestions;

  ChatRepository get _chatRepository => ChatRepository();

  /// Called from build() to preload first session if exists
  Future<ChatState> loadInitialSession() async {
    // Empty starting state
    var initial = ChatState(messages: [], sessions: [], activeSessionId: null);

    final sessions = await _chatRepository.getAllSessions();
    if (sessions.isEmpty) {
      // Nothing to load → return empty
      return initial;
    }

    // Take first session for now
    final first = sessions.first;
    final firstSession = ChatSession(
      id: first['id'],
      title: first['title'] ?? 'Chat',
    );

    // Load messages for first session
    final msgsData = await _chatRepository.getSessionMessages(firstSession.id);
    final msgs = msgsData
        .map(
          (m) => ChatMessage(
            content: m['content'] ?? '',
            sender: m['sender'] == "USER"
                ? MessageSender.user
                : MessageSender.ai,
          ),
        )
        .toList();

    return initial.copyWith(
      sessions: [firstSession],
      activeSessionId: firstSession.id,
      messages: msgs,
    );
  }

  Future<void> sendUserMessage(String text) async {
    final current = state.value;

    if (currentState == null) return;
    state = AsyncValue.data(
      currentState!.copyWith(
        messages: [
          ...currentState!.messages,
          ChatMessage(content: text, sender: MessageSender.user),
        ],
        isLoading: true,
      ),
    );
    // No sessions loaded yet → try to load
    if (current!.sessions.isEmpty) {
      final loaded = await loadInitialSession();
      if (loaded.sessions.isEmpty) {
        await _startNewSession(text);
        return;
      } else {
        state = AsyncValue.data(loaded);
      }
    }

    // Always send to active session after ensuring we have one
    await _sendToActiveSession(text);
  }

  Future<void> _startNewSession(String firstMessage) async {
    state = AsyncValue.data(state.value!.copyWith(isLoading: true));

    try {
      final response = await _chatRepository.createSession(firstMessage);

      if (response['success'] != true) {
        final aiError = ChatMessage(
          content: response['message'] ?? 'خطا در شروع گفتگو',
          sender: MessageSender.ai,
        );
        final newSession = ChatSession(
          id: 'temp-error-${DateTime.now().millisecondsSinceEpoch}',
          title: 'New Chat (Error)',
          messages: [
            ChatMessage(content: firstMessage, sender: MessageSender.user),
            aiError,
          ],
        );

        state = AsyncValue.data(
          state.value!.copyWith(
            sessions: [newSession],
            activeSessionId: newSession.id,
            messages: newSession.messages,
          ),
        );
        return; // exit early, finally will still run
      }
      final data = response['data'];
      final newSession = ChatSession(
        id: data['chatSessionId'],
        title: data['chatSessionTitle'] ?? 'New Chat',
        messages: [
          ChatMessage(content: firstMessage, sender: MessageSender.user),
          ChatMessage(
            content: data['aiResponse'] ?? '',
            sender: MessageSender.ai,
          ),
        ],
      );

      state = AsyncValue.data(
        state.value!.copyWith(
          sessions: [newSession],
          activeSessionId: newSession.id,
          messages: newSession.messages,
        ),
      );
    } catch (e, stTrace) {
      debugPrint("debug startNewSession error: $e , $stTrace");

      final aiError = ChatMessage(
        content: 'خطای شبکه',
        sender: MessageSender.ai,
      );
      final newSession = ChatSession(
        id: 'temp-error-${DateTime.now().millisecondsSinceEpoch}',
        title: 'New Chat (Error)',
        messages: [
          ChatMessage(content: firstMessage, sender: MessageSender.user),
          aiError,
        ],
      );

      state = AsyncValue.data(
        state.value!.copyWith(
          sessions: [newSession],
          activeSessionId: newSession.id,
          messages: newSession.messages,
        ),
      );
    } finally {
      state = AsyncValue.data(state.value!.copyWith(isLoading: false));
    }
  }

  Future<void> _sendToActiveSession(String text) async {
    final st = state.value!;
    final sessionId = st.activeSessionId!;
    state = AsyncValue.data(st.copyWith(isLoading: true));

    try {
      final response = await _chatRepository.sendMessage(sessionId, text);

      String reply;
      if (response['success'] != true) {
        reply = response['message'] ?? 'خطا در ارسال پیام';
      } else {
        reply = response['data']['aiResponse'] ?? '';
      }

      state = AsyncValue.data(
        state.value!.copyWith(
          messages: List.of(state.value!.messages)
            ..add(ChatMessage(content: reply, sender: MessageSender.ai)),
        ),
      );
    } catch (e, st) {
      debugPrint("debug the error is $e , $st");
      state = AsyncValue.data(
        state.value!.copyWith(
          messages: List.of(state.value!.messages)
            ..add(ChatMessage(content: 'خطای شبکه', sender: MessageSender.ai)),
        ),
      );
    } finally {
      state = AsyncValue.data(state.value!.copyWith(isLoading: false));
    }
  }
}

final chatNotifierProvider = AsyncNotifierProvider<ChatNotifier, ChatState>(
  () => ChatNotifier(),
);
