import 'dart:convert';

class PrivacyResponse {
  bool waterPublic;
  bool workoutPublic;
  bool dietPublic;
  bool sleepPublic;

  PrivacyResponse({
    required this.waterPublic,
    required this.workoutPublic,
    required this.dietPublic,
    required this.sleepPublic,
  });

  factory PrivacyResponse.fromJson(Map<String, dynamic> json) {
    return PrivacyResponse(
      waterPublic: json['waterPublic'] ?? true,
      workoutPublic: json['workoutPublic'] ?? true,
      dietPublic: json['dietPublic'] ?? true,
      sleepPublic: json['sleepPublic'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "waterPublic": waterPublic,
      "workoutPublic": workoutPublic,
      "dietPublic": dietPublic,
      "sleepPublic": sleepPublic,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
