class JoinGroupRequest {
  final String groupCode;
  JoinGroupRequest({required this.groupCode});

  Map<String, dynamic> toJson() => {"groupCode": groupCode};
}

class JoinGroupResponseData {
  final int userChallengeId;
  final int challengeId;

  JoinGroupResponseData({
    required this.userChallengeId,
    required this.challengeId,
  });

  factory JoinGroupResponseData.fromJson(Map<String, dynamic> json) {
    return JoinGroupResponseData(
      userChallengeId: json["userChallengeId"],
      challengeId: json["challengeId"],
    );
  }
}

class ApiResponse<T> {
  final int status;
  final String message;
  final T? data;

  ApiResponse({required this.status, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : fromJsonT(json["data"]),
    );
  }
}
