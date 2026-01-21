// 최상위 데이터 클래스
class FeedPageResponse {
  final int totalPages;
  final int totalElements;
  final int? size;
  final List<FeedPost> content;
  final int number;
  final Sort? sort;
  final int? numberOfElements;
  final Pageable? pageable;
  final bool? first;
  final bool last;
  final bool? empty;

  FeedPageResponse({
    required this.totalPages,
    required this.totalElements,
    this.size,
    required this.content,
    required this.number,
    this.sort,
    this.numberOfElements,
    this.pageable,
    this.first,
    required this.last,
    this.empty,
  });

  factory FeedPageResponse.fromJson(Map<String, dynamic> json) {
    return FeedPageResponse(
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      size: json['size'] != null ? json['size'] : null,
      content: (json['content'] as List)
          .map((e) => FeedPost.fromJson(e))
          .toList(),
      number: json['number'],
      sort: json['sort'] != null ? Sort.fromJson(json['sort']) : null,
      numberOfElements: json['numberOfElements'],
      pageable: json['pageable'] != null
          ? Pageable.fromJson(json['pageable'])
          : null,
      first: json['first'] != null ? json['first'] : null,
      last: json['last'],
      empty: json['empty'],
    );
  }
}

// 피드 Cotent 클래스
class FeedPost {
  final int id;
  // final String title;
  final String content;
  final String writerNickname;
  final String? writerProfileImageUrl;
  final int? writerLevel;
  final String? imageUrl;
  final String? place;
  int likeCount;
  final String visibility;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> hashtags;
  List<FeedComment> comments;
  int commentCount;
  bool liked;
  final bool edited;

  // final String place; // 장소 관련 저장 변수
  // final int viewCount; // 댓글 개수 저장 변수

  FeedPost({
    required this.id,
    // required this.title,
    required this.content,
    required this.writerNickname,
    required this.writerProfileImageUrl,
    required this.writerLevel,
    required this.imageUrl,
    required this.place,
    required this.likeCount,
    required this.visibility,
    required this.createdAt,
    required this.updatedAt,
    required this.hashtags,
    required this.comments,
    required this.commentCount,
    required this.liked,
    required this.edited,

    // required this.viewCount,
    // required this.place,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id'],
      // title: json['title'],
      content: json['content'],
      writerNickname: json['writerNickname'],
      writerProfileImageUrl: json['writerProfileImageUrl'],
      writerLevel: json['writerLevel'],
      imageUrl: json['imageUrl'],
      place: json['place'],
      likeCount: json['likeCount'],
      visibility: json['visibility'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      hashtags: List<String>.from(json['hashtags']),
      comments: (json['comments'] as List)
          .map((e) => FeedComment.fromJson(e))
          .toList(),
      commentCount: json['commentCount'],
      liked: json['liked'],
      edited: json['edited'],
      // viewCount: json['viewCount'],
      // place: json['place'],
    );
  }
}

// 댓글 클래스
class FeedComment {
  final int id;
  final String content;
  final String writerNickname;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool edited;

  FeedComment({
    required this.id,
    required this.content,
    required this.writerNickname,
    required this.createdAt,
    required this.updatedAt,
    required this.edited,
  });

  factory FeedComment.fromJson(Map<String, dynamic> json) {
    return FeedComment(
      id: json['id'],
      content: json['content'],
      writerNickname: json['writerNickname'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      edited: json['edited'],
    );
  }
}

// 페이징 관련 변수 클래스
class Pageable {
  final int pageNumber;
  final int offset;
  final Sort? sort;
  final int pageSize;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.pageNumber,
    required this.offset,
    this.sort,
    required this.pageSize,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      pageNumber: json['pageNumber'],
      offset: json['offset'],
      sort: json['sort'] != null ? Sort.fromJson(json['sort']) : null,
      pageSize: json['pageSize'],
      paged: json['paged'],
      unpaged: json['unpaged'],
    );
  }
}

class Sort {
  final bool empty;
  final bool unsorted;
  final bool sorted;

  Sort({required this.empty, required this.unsorted, required this.sorted});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      empty: json['empty'],
      unsorted: json['unsorted'],
      sorted: json['sorted'],
    );
  }
}

class Pagination {}
