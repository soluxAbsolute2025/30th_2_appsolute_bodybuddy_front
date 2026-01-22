import 'dart:convert';

class PostFeedModel {
  final String content;
  final String visibility;
  final String? place;
  final List<String> hashtags;
  final bool imageDeleted;

  const PostFeedModel({
    required this.content,
    required this.visibility,
    this.place = null,
    required this.hashtags,
    this.imageDeleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
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
