enum ChatSender { my, ai }

class ChatMessage {
  final String text;
  final ChatSender sender;
  final DateTime createdAt;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.createdAt,
  });
}
