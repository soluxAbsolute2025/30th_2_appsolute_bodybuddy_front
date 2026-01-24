import 'dart:convert';

/// 전체 친구 상세 정보 모델
class BuddyDetail {
  final int userId;
  final String loginId;
  final String nickname;
  final int level;
  final String? profileImageUrl;
  final String lastActivityTime;
  final String status;
  final HomeData? homeData;

  BuddyDetail({
    required this.userId,
    required this.loginId,
    required this.nickname,
    required this.level,
    this.profileImageUrl,
    required this.lastActivityTime,
    required this.status,
    this.homeData,
  });

  factory BuddyDetail.fromJson(Map<String, dynamic> json) {
    return BuddyDetail(
      userId: json['userId'] is int ? json['userId'] : 0,
      loginId: json['loginId']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      level: json['level'] is int ? json['level'] : 0,
      // profileImageUrl이 null이거나 실제 url string일 때만 가져옴
      profileImageUrl: json['profileImageUrl']?.toString(),
      lastActivityTime: json['lastActivityTime']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      // homeData가 null이 아니고 Map 형태일 때만 파싱
      homeData:
          (json['homeData'] != null && json['homeData'] is Map<String, dynamic>)
          ? HomeData.fromJson(json['homeData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'loginId': loginId,
    'nickname': nickname,
    'level': level,
    'profileImageUrl': profileImageUrl,
    'lastActivityTime': lastActivityTime,
    'status': status,
    'homeData': homeData?.toJson(),
  };
}

/// 홈 데이터 (물, 식사, 수면 포함)
class HomeData {
  final String? date;
  final GoalProgress? water;
  final GoalProgress? meal;
  final GoalProgress? sleep;

  HomeData({this.date, this.water, this.meal, this.sleep});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      date: json['date']?.toString(),
      // 각각의 데이터가 있는지 확인 후 파싱
      water: (json['water'] != null && json['water'] is Map<String, dynamic>)
          ? GoalProgress.fromJson(json['water'])
          : null,
      meal: (json['meal'] != null && json['meal'] is Map<String, dynamic>)
          ? GoalProgress.fromJson(json['meal'])
          : null,
      sleep: (json['sleep'] != null && json['sleep'] is Map<String, dynamic>)
          ? GoalProgress.fromJson(json['sleep'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'water': water?.toJson(),
    'meal': meal?.toJson(),
    'sleep': sleep?.toJson(),
  };
}

/// 목표 진행 상황 (current, goal만 추출)
/// Water, Meal, Sleep 모두 공통 구조를 가지므로 하나로 재사용합니다.
class GoalProgress {
  final int current;
  final int goal;

  GoalProgress({required this.current, required this.goal});

  factory GoalProgress.fromJson(Map<String, dynamic> json) {
    return GoalProgress(
      current: (json['current'] is num) ? (json['current'] as num).toInt() : 0,
      goal: (json['goal'] is num) ? (json['goal'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() => {'current': current, 'goal': goal};
}
