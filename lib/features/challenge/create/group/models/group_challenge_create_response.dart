class GroupChallengeCreateResponse {
  final int status;
  final int groupId;
  final String groupCode;
  final String message;

  const GroupChallengeCreateResponse({
    required this.status,
    required this.groupId,
    required this.groupCode,
    required this.message,
  });

  factory GroupChallengeCreateResponse.fromJson(Map<String, dynamic> json) {
    return GroupChallengeCreateResponse(
      status: (json['status'] as num?)?.toInt() ?? 0,
      groupId: (json['groupId'] as num?)?.toInt() ?? 0,
      groupCode: json['groupCode']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}
