class GroupChallengeDetailResponse {
  final int status;
  final String message;
  final GroupChallengeDetailData data;

  GroupChallengeDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GroupChallengeDetailResponse.fromJson(Map<String, dynamic> json) {
    return GroupChallengeDetailResponse(
      status: (json['status'] ?? 0) as int,
      message: (json['message'] ?? '') as String,
      data: GroupChallengeDetailData.fromJson(
        (json['data'] ?? {}) as Map<String, dynamic>,
      ),
    );
  }
}

class GroupChallengeDetailData {
  final int challengeId;
  final GroupChallengeInfo challengeInfo;
  final MyStatus myStatus;
  final double groupAverageRate;
  final List<GroupChallengeParticipant> participants;

  GroupChallengeDetailData({
    required this.challengeId,
    required this.challengeInfo,
    required this.myStatus,
    required this.groupAverageRate,
    required this.participants,
  });

  factory GroupChallengeDetailData.fromJson(Map<String, dynamic> json) {
    return GroupChallengeDetailData(
      challengeId: (json['challengeId'] ?? 0) as int,
      challengeInfo: GroupChallengeInfo.fromJson(
        (json['challengeInfo'] ?? {}) as Map<String, dynamic>,
      ),
      myStatus: MyStatus.fromJson(
        (json['myStatus'] ?? {}) as Map<String, dynamic>,
      ),
      groupAverageRate: _toDouble(json['groupAverageRate']),
      participants: ((json['participants'] ?? []) as List)
          .map((e) => GroupChallengeParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// ✅ 너 페이지에서 쓰는 타입: GroupChallengeDetail
/// (섹션 위젯들이 GroupChallengeDetail을 받으니까)
class GroupChallengeDetail {
  final GroupChallengeInfo challengeInfo;
  final MyStatus myStatus;
  final double groupAverageRate;
  final List<GroupChallengeParticipant> participants;

  GroupChallengeDetail({
    required this.challengeInfo,
    required this.myStatus,
    required this.groupAverageRate,
    required this.participants,
  });

  factory GroupChallengeDetail.fromData(GroupChallengeDetailData data) {
    return GroupChallengeDetail(
      challengeInfo: data.challengeInfo,
      myStatus: data.myStatus,
      groupAverageRate: data.groupAverageRate,
      participants: data.participants,
    );
  }
}

class GroupChallengeInfo {
  final String title;
  final String description;
  final String? imageUrl;
  final String startDate; // "2025.11.27"
  final String endDate;   // "2025.12.15"
  final String status;    // 모집중/진행중/완료 등
  final int currentParticipantCount;
  final int maxParticipantCount;
  final String groupCode;
  final bool isPublic;
  final int expectedRewardPoints;

  GroupChallengeInfo({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.currentParticipantCount,
    required this.maxParticipantCount,
    required this.groupCode,
    required this.isPublic,
    required this.expectedRewardPoints,
  });

  factory GroupChallengeInfo.fromJson(Map<String, dynamic> json) {
    return GroupChallengeInfo(
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      imageUrl: json['imageUrl'] as String?,
      startDate: (json['startDate'] ?? '') as String,
      endDate: (json['endDate'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      currentParticipantCount: (json['currentParticipantCount'] ?? 0) as int,
      maxParticipantCount: (json['maxParticipantCount'] ?? 0) as int,
      groupCode: (json['groupCode'] ?? '') as String,
      isPublic: (json['isPublic'] ?? false) as bool,
      expectedRewardPoints: (json['expectedRewardPoints'] ?? 0) as int,
    );
  }
}

class MyStatus {
  final double myAchievementRate;
  final int myRank;

  MyStatus({
    required this.myAchievementRate,
    required this.myRank,
  });

  factory MyStatus.fromJson(Map<String, dynamic> json) {
    return MyStatus(
      myAchievementRate: _toDouble(json['myAchievementRate']),
      myRank: (json['myRank'] ?? 0) as int,
    );
  }
}

class GroupChallengeParticipant {
  final int rank;
  final String nickname;
  final String? profileImageUrl;
  final double achievementRate;
  final bool isMe;

  GroupChallengeParticipant({
    required this.rank,
    required this.nickname,
    required this.profileImageUrl,
    required this.achievementRate,
    required this.isMe,
  });

  factory GroupChallengeParticipant.fromJson(Map<String, dynamic> json) {
    return GroupChallengeParticipant(
      rank: (json['rank'] ?? 0) as int,
      nickname: (json['nickname'] ?? '') as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      achievementRate: _toDouble(json['achievementRate']),
      isMe: (json['isMe'] ?? false) as bool,
    );
  }
}

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}
