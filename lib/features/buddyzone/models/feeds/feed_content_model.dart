// 최상위 데이터 클래스
class FeedPageResponse {
  final List<FeedPost> content;
  final Pageable pageable;
  final bool last;
  final int totalPages;
  final int totalElements;
  final bool first;
  final int size;
  final int number;
  final int numberOfElements;
  final bool empty;

  FeedPageResponse({
    required this.content,
    required this.pageable,
    required this.last,
    required this.totalPages,
    required this.totalElements,
    required this.first,
    required this.size,
    required this.number,
    required this.numberOfElements,
    required this.empty,
  });

  factory FeedPageResponse.fromJson(Map<String, dynamic> json) {
    return FeedPageResponse(
      content: (json['content'] as List)
          .map((e) => FeedPost.fromJson(e))
          .toList(),
      pageable: Pageable.fromJson(json['pageable']),
      last: json['last'],
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      first: json['first'],
      size: json['size'],
      number: json['number'],
      numberOfElements: json['numberOfElements'],
      empty: json['empty'],
    );
  }
}

// 피드 Cotent 클래스
class FeedPost {
  final int id;
  final String title;
  final String content;
  final String writerNickname;
  final int viewCount;
  final int likeCount;
  final bool isLiked;
  final String visibility;
  final String place;
  final bool isEdited;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> hashtags;
  final List<String> imageUrls;
  final List<FeedComment> comments;

  FeedPost({
    required this.id,
    required this.title,
    required this.content,
    required this.writerNickname,
    required this.viewCount,
    required this.likeCount,
    required this.isLiked,
    required this.visibility,
    required this.place,
    required this.isEdited,
    required this.createdAt,
    required this.updatedAt,
    required this.hashtags,
    required this.imageUrls,
    required this.comments,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      writerNickname: json['writerNickname'],
      viewCount: json['viewCount'],
      likeCount: json['likeCount'],
      isLiked: json['isLiked'],
      visibility: json['visibility'],
      place: json['place'],
      isEdited: json['isEdited'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      hashtags: List<String>.from(json['hashtags']),
      imageUrls: List<String>.from(json['imageUrls']),
      comments: (json['comments'] as List)
          .map((e) => FeedComment.fromJson(e))
          .toList(),
    );
  }
}

class Pagination {}

// 댓글 클래스
class FeedComment {
  final int id;
  final String content;
  final String nickname;
  final DateTime createdAt;

  FeedComment({
    required this.id,
    required this.content,
    required this.nickname,
    required this.createdAt,
  });

  factory FeedComment.fromJson(Map<String, dynamic> json) {
    return FeedComment(
      id: json['id'],
      content: json['content'],
      nickname: json['nickname'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// 페이징 관련 변수 클래스
class Pageable {
  final int pageNumber;
  final int pageSize;
  final int offset;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      offset: json['offset'],
      paged: json['paged'],
      unpaged: json['unpaged'],
    );
  }
}
