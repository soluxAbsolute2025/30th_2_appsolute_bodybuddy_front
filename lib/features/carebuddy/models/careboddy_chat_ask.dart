class ChatAskModel {
  final bool success;
  final List<ChatAskData> data;

  ChatAskModel({required this.success, required this.data});

  factory ChatAskModel.fromJson(Map<String, dynamic> json) {
    return ChatAskModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => ChatAskData.fromJson(e))
          .toList(),
    );
  }
}

class ChatAskData {
  final String messageId;
  final String role;
  final String content;
  final DateTime createAt;

  ChatAskData({
    required this.messageId,
    required this.role,
    required this.content,
    required this.createAt,
  });

  factory ChatAskData.fromJson(Map<String, dynamic> json) {
    return ChatAskData(
      messageId: json['messageId'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createAt: DateTime.parse(json['createdAt']),
    );
  }
}
