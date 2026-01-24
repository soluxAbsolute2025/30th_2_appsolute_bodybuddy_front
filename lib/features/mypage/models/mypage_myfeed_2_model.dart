// import 'package:bodybuddy_frontend/features/mypage/models/mypage_myfeed_model.dart';
//
// class MyPageFeedResponse {
//   final int postId;
//   final String nickname;
//   final int userLevel;
//   final String? profileImageUrl;
//   final DateTime createdAt;
//   String? place;
//   final String content;
//   final List<String> hashtags;
//   final String? postImageUrl; // Nullable로 변경
//   final int commentCount;
//   int likeCount;
//   bool liked;
//
//   MyPageFeedResponse({
//     required this.postId,
//     required this.nickname,
//     required this.userLevel,
//     this.profileImageUrl,
//     required this.createdAt,
//     this.place,
//     required this.content,
//     required this.hashtags,
//     this.postImageUrl,
//     required this.likeCount,
//     required this.liked,
//     required this.commentCount,
//   });
//
//   // 🔥 [핵심] 서버 JSON(왼쪽)을 앱 변수명(오른쪽)으로 직접 매핑
//   factory MyPageFeedResponse.fromJson(Map<String, dynamic> json) {
//     return MyPageFeedResponse(
//       // 1. ID 매핑 (id -> postId)
//       postId: json['id'] ?? 0,
//
//       // 2. 닉네임 매핑 (writerNickname -> nickname)
//       nickname: json['writerNickname'] ?? '',
//
//       // 3. 레벨 매핑 (writerLevel -> userLevel)
//       userLevel: json['writerLevel'] ?? 0,
//
//       // 4. 프로필 이미지 (writerProfileImageUrl -> profileImageUrl)
//       profileImageUrl: json['writerProfileImageUrl'],
//
//       // 5. 생성일
//       createdAt: DateTime.parse(json['createdAt']),
//
//       // 6. 장소
//       place: json['place'] ?? '',
//
//       // 7. 내용
//       content: json['content'] ?? '',
//
//       // 8. 해시태그 (List 변환 안전하게)
//       hashtags: List<String>.from(json['hashtags'] ?? []),
//
//       // 🔥 9. 대망의 이미지 매핑 (imageUrl -> postImageUrl)
//       // 로그에 imageUrl로 들어오고 있으므로 여기서 잡아줍니다.
//       postImageUrl: json['imageUrl'],
//
//       // 10. 좋아요/댓글 수
//       likeCount: json['likeCount'] ?? 0,
//       commentCount: json['commentCount'] ?? 0,
//       liked: json['liked'] ?? false,
//     );
//   }
//
//   // 기존 FeedItem으로 변환해주는 헬퍼 메서드 (UI에 넘길 때 유용)
//   FeedItem toFeedItem() {
//     return FeedItem(
//       postId: postId,
//       nickname: nickname,
//       userLevel: userLevel,
//       profileImageUrl: profileImageUrl,
//       createdAt: createdAt,
//       place: place,
//       content: content,
//       hashtags: hashtags,
//       postImageUrl: postImageUrl ?? '', // FeedItem은 String을 원하므로 null이면 빈문자열
//       likeCount: likeCount,
//       commentCount: commentCount,
//       liked: liked,
//     );
//   }
// }
