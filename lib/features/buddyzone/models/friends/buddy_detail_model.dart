import 'dart:convert';

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
      userId: json['userId'] ?? 0,
      // .toString()을 붙여서 Map이 들어와도 튕기지 않게 방어합니다.
      loginId: json['loginId']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      level: json['level'] ?? 0,
      // profileImageUrl이 객체{}로 오면 null 처리하거나 문자열로 변환
      profileImageUrl: json['profileImageUrl'] is Map
          ? null
          : json['profileImageUrl']?.toString(),
      lastActivityTime: json['lastActivityTime']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      homeData:
          json['homeData'] != null && json['homeData'] is Map<String, dynamic>
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

class HomeData {
  final String? date;
  final GoalProgress? water;
  final GoalProgress? meal;
  final GoalProgress? sleep;

  HomeData({this.date, this.water, this.meal, this.sleep});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      date: json['date']?.toString(),
      // 내부 데이터가 null이거나 비어있을 때를 대비한 안전한 파싱
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

class GoalProgress {
  final int? current;
  final int? goal;

  GoalProgress({this.current, this.goal});

  factory GoalProgress.fromJson(Map<String, dynamic> json) {
    return GoalProgress(
      // double로 올 경우를 대비해 toInt() 처리
      current: (json['current'] ?? 0).toInt(),
      goal: (json['goal'] ?? 3).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'current': current, 'goal': goal};
}
