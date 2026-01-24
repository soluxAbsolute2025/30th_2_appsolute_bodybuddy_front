class MyPageResponse {
  final UserProfile userProfile;
  final LevelInfo levelInfo;
  final ActivitySummary activitySummary;
  final List<RecentBadge> recentBadges;

  MyPageResponse({
    required this.userProfile,
    required this.levelInfo,
    required this.activitySummary,
    required this.recentBadges,
  });

  factory MyPageResponse.fromJson(Map<String, dynamic> json) {
    return MyPageResponse(
      userProfile: UserProfile.fromJson(json['userProfile'] ?? {}),
      levelInfo: LevelInfo.fromJson(json['levelInfo'] ?? {}),
      activitySummary: ActivitySummary.fromJson(json['activitySummary'] ?? {}),
      recentBadges:
          (json['recentBadges'] as List<dynamic>?)
              ?.map((e) => RecentBadge.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// 1. 상단 프로필
class UserProfile {
  final int userId;
  final String nickname;
  final String? profileImageUrl;
  final String? introduction;
  final String email;

  UserProfile({
    required this.userId,
    required this.nickname,
    this.profileImageUrl,
    this.introduction,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] ?? 0,
      nickname: json['nickname'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      introduction: json['introduction'],
      email: json['email'] ?? '',
    );
  }
}

// 2. 레벨 섹션
class LevelInfo {
  final int currentLevel;
  final String levelName;
  final int currentExp;
  final int nextLevelExp;
  final int remainingExp;

  LevelInfo({
    required this.currentLevel,
    required this.levelName,
    required this.currentExp,
    required this.nextLevelExp,
    required this.remainingExp,
  });

  factory LevelInfo.fromJson(Map<String, dynamic> json) {
    return LevelInfo(
      currentLevel: json['currentLevel'] ?? 0,
      levelName: json['levelName'] ?? '',
      currentExp: json['currentExp'] ?? 0,
      nextLevelExp: json['nextLevelExp'] ?? 0,
      remainingExp: json['remainingExp'] ?? 0,
    );
  }
}

// 3. 핵심 성과 카드 섹션
class ActivitySummary {
  final int completedChallenges;
  final int consecutiveAttendance;

  ActivitySummary({
    required this.completedChallenges,
    required this.consecutiveAttendance,
  });

  factory ActivitySummary.fromJson(Map<String, dynamic> json) {
    return ActivitySummary(
      completedChallenges: json['completedChallenges'] ?? 0,
      consecutiveAttendance: json['consecutiveAttendance'] ?? 0,
    );
  }
}

// 4. 획득 뱃지 리스트
class RecentBadge {
  final int badgeId;
  final String badgeName;
  final String badgeImageUrl;
  final String acquiredDate;

  RecentBadge({
    required this.badgeId,
    required this.badgeName,
    required this.badgeImageUrl,
    required this.acquiredDate,
  });

  factory RecentBadge.fromJson(Map<String, dynamic> json) {
    return RecentBadge(
      badgeId: json['badgeId'] ?? 0,
      badgeName: json['badgeName'] ?? '',
      badgeImageUrl: json['badgeImageUrl'] ?? '',
      acquiredDate: json['acquiredDate'] ?? '',
    );
  }
}
