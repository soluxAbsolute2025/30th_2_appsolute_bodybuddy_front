class GroupChallengeCreateResponse {
  final int status;
  final int groupId;
  final String groupCode;
  final String message;

  GroupChallengeCreateResponse({
    required this.status,
    required this.groupId,
    required this.groupCode,
    required this.message,
  });

  factory GroupChallengeCreateResponse.fromJson(Map<String, dynamic> json) {
    return GroupChallengeCreateResponse(
      status: json['status'] ?? 0,
      groupId: json['groupId'] ?? 0,
      groupCode: json['groupCode'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
