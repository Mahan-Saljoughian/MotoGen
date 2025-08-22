import 'package:equatable/equatable.dart';

enum MessageSender { user, ai, loading }

class ChatMessage extends Equatable {
  final String content;
  final MessageSender sender;
  const ChatMessage({required this.content, required this.sender});

  @override
  List<Object?> get props => [content, sender];
}

class ChatSession extends Equatable {
  final String id;
  final String title;
  //final String carId;
  final List<ChatMessage> messages;

  const  ChatSession({
    required this.id,
    required this.title,
    // required this.carId,
    this.messages = const [],
  });

  ChatSession copyWith({
    String? id,
    String? title,
    String? carId,
    List<ChatMessage>? messages,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      // carId: carId ?? this.carId,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [id, title, messages];
}
