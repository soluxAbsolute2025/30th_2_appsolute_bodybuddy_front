import 'dart:convert';

class MyProfileModel {
  final String? nickname;
  final String? introduction;
  final String? email;
  final bool? isImageDeleted;
  // final bool imageDeleted;

  const MyProfileModel({
    this.nickname,
    this.introduction,
    this.email,
    this.isImageDeleted,
  });

  Map<String, dynamic> toJson() {
    return {
      if (nickname != null) "nickname": nickname,
      if (introduction != null) "introduction": introduction,
      if (email != null) "email": email,
      if (isImageDeleted != null) "isImageDeleted": isImageDeleted,
    };
  }

  /// MultipartFile에 바로 넣기 위한 JSON string
  String toJsonString() => jsonEncode(toJson());
}
