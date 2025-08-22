import 'package:equatable/equatable.dart';
import 'package:motogen/features/chat_screen/model/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;
  final List<ChatSession> sessions;
  final String? activeSessionId;

  const ChatState({
    required this.messages,
    this.isLoading = false,
    this.errorMessage,
    this.sessions = const [],
    this.activeSessionId,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
    List<ChatSession>? sessions,
    String? activeSessionId,
  }) {
    return ChatState(
      messages: messages ?? List.of(this.messages),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      sessions: sessions ?? List.of(this.sessions),
      activeSessionId: activeSessionId ?? this.activeSessionId,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    isLoading,
    errorMessage,
    sessions,
    activeSessionId,
  ];
}
