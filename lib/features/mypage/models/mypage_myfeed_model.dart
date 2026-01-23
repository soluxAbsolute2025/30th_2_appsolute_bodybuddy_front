import 'dart:convert';

class MyFeedModel {
  final List<FeedItem> data;
  final String message;
  final int status;

  MyFeedModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory MyFeedModel.fromJson(Map<String, dynamic> json) {
    return MyFeedModel(
      data: (json['data'] as List).map((i) => FeedItem.fromJson(i)).toList(),
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}

class FeedItem {
  final int postId;
  final String nickname;
  final int userLevel;
  final String? profileImageUrl; // null 허용
  final DateTime createdAt;
  final String place;
  final String content;
  final List<String> hashtags;
  final String postImageUrl;
  final int commentCount;
  int likeCount;
  bool liked;

  FeedItem({
    required this.postId,
    required this.nickname,
    required this.userLevel,
    this.profileImageUrl,
    required this.createdAt,
    required this.place,
    required this.content,
    required this.hashtags,
    required this.postImageUrl,
    required this.likeCount,
    this.liked = false,
    required this.commentCount,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      postId: json['postId'] ?? 0,
      nickname: json['nickname'] ?? '',
      userLevel: json['userLevel'] ?? 0,
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      place: json['place'] ?? '',
      content: json['content'] ?? '',
      // List<dynamic>을 List<String>으로 변환
      hashtags: List<String>.from(json['hashtags'] ?? []),
      postImageUrl: json['postImageUrl'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      liked: false,
    );
  }
}
