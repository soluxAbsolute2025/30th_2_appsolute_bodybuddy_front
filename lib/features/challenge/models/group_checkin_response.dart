class GroupCheckInResponse {
  final int status;
  final String message;
  final GroupCheckInData data;

  GroupCheckInResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GroupCheckInResponse.fromJson(Map<String, dynamic> json) {
    return GroupCheckInResponse(
      status: (json['status'] ?? 0) as int,
      message: (json['message'] ?? '') as String,
      data: GroupCheckInData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class GroupCheckInData {
  final int challengeId;
  final String nickname;
  final String title;
  final int earnedPoints;
  final MyStatus myStatus;
  final double groupAverageRate;
  final DateTime checkInTime;

  GroupCheckInData({
    required this.challengeId,
    required this.nickname,
    required this.title,
    required this.earnedPoints,
    required this.myStatus,
    required this.groupAverageRate,
    required this.checkInTime,
  });

  factory GroupCheckInData.fromJson(Map<String, dynamic> json) {
    return GroupCheckInData(
      challengeId: (json['challengeId'] ?? 0) as int,
      nickname: (json['nickname'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      earnedPoints: (json['earnedPoints'] ?? 0) as int,
      myStatus: MyStatus.fromJson(json['myStatus'] as Map<String, dynamic>),
      groupAverageRate: (json['groupAverageRate'] as num?)?.toDouble() ?? 0.0,
      checkInTime: DateTime.parse((json['checkInTime'] ?? '') as String),
    );
  }
}

class MyStatus {
  final double updatedAchievementRate;
  final int currentRank;

  MyStatus({
    required this.updatedAchievementRate,
    required this.currentRank,
  });

  factory MyStatus.fromJson(Map<String, dynamic> json) {
    return MyStatus(
      updatedAchievementRate:
          (json['updatedAchievementRate'] as num?)?.toDouble() ?? 0.0,
      currentRank: (json['currentRank'] ?? 0) as int,
    );
  }
}
