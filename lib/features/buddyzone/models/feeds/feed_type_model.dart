enum FeedMode { normal, search, tag }

class FeedRequest {
  final FeedMode mode;
  final String? keyword;
  final String? tag;

  FeedRequest({required this.mode, this.keyword, this.tag});
}
