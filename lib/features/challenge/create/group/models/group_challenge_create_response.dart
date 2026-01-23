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
      status: json['status'] as int,
      groupId: json['groupId'] as int,
      groupCode: json['groupCode'] as String,
      message: json['message'] as String,
    );
  }
}
