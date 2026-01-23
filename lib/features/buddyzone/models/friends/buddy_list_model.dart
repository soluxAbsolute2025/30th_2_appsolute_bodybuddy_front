import 'dart:convert';

class BuddyResponse {
  final List<Buddy> myBuddies;
  final List<BuddyRequest> requests;

  BuddyResponse({required this.myBuddies, required this.requests});

  factory BuddyResponse.fromJson(Map<String, dynamic> json) {
    return BuddyResponse(
      myBuddies: (json['myBuddies'] as List)
          .map((i) => Buddy.fromJson(i))
          .toList(),
      requests: (json['requests'] as List)
          .map((i) => BuddyRequest.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'myBuddies': myBuddies.map((i) => i.toJson()).toList(),
    'requests': requests.map((i) => i.toJson()).toList(),
  };
}

class Buddy {
  final int userId;
  final String nickname;
  final int level;
  final String lastActiveTime;
  final bool isPokedToday;

  Buddy({
    required this.userId,
    required this.nickname,
    required this.level,
    required this.lastActiveTime,
    required this.isPokedToday,
  });

  factory Buddy.fromJson(Map<String, dynamic> json) {
    return Buddy(
      userId: json['userId'] ?? 0,
      nickname: json['nickname'] ?? '',
      level: json['level'] ?? 0,
      lastActiveTime: json['lastActiveTime'] ?? '',
      isPokedToday: json['isPokedToday'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'nickname': nickname,
    'level': level,
    'lastActiveTime': lastActiveTime,
    'isPokedToday': isPokedToday,
  };
}

class BuddyRequest {
  final int requestId;
  final int userId;
  final String nickname;
  final int level;
  final String lastActiveTime;

  BuddyRequest({
    required this.requestId,
    required this.userId,
    required this.nickname,
    required this.level,
    required this.lastActiveTime,
  });

  factory BuddyRequest.fromJson(Map<String, dynamic> json) {
    return BuddyRequest(
      requestId: json['requestId'] ?? 0,
      userId: json['userId'] ?? 0,
      nickname: json['nickname'] ?? '',
      level: json['level'] ?? 0,
      lastActiveTime: json['lastActiveTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'requestId': requestId,
    'userId': userId,
    'nickname': nickname,
    'level': level,
    'lastActiveTime': lastActiveTime,
  };
}
