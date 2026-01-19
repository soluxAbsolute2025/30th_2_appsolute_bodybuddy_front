class TagSuggest {
  final bool success;
  final List<String> data;

  TagSuggest({required this.success, required this.data});

  /// JSON → Dart 객체
  factory TagSuggest.fromJson(Map<String, dynamic> json) {
    return TagSuggest(
      success: json['success'] as bool,
      data: List<String>.from(json['data']),
    );
  }

  /// Dart 객체 → JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data};
  }
}
