import 'dart:convert';

class PostFeedModel {
  final String title;
  final String content;
  final String visibility;
  final String? place;
  final List<String> hashtags;
  final bool imageDeleted;

  const PostFeedModel({
    required this.title,
    required this.content,
    required this.visibility,
    this.place,
    required this.hashtags,
    required this.imageDeleted,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "content": content,
      "visibility": visibility,
      "place": place,
      "hashtags": hashtags,
      "imageDeleted": imageDeleted,
    };
  }

  /// MultipartFile에 바로 넣기 위한 JSON string
  String toJsonString() => jsonEncode(toJson());
}
