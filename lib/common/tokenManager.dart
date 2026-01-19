import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();

  static const _accessKey = 'accessToken';

  // 저장소에서 Access Token을 꺼내오는 함수
  static Future<String?> getAccessToken() async {
    // 저장소에서 _accessKey에 해당하는 값을 읽어서 반환
    return await _storage.read(key: _accessKey);
  }

  // 토큰 저장하는 함수 (필요 시)
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessKey, value: token);
  }

  // 로그아웃 시 토큰 삭제하는 함수
  static Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessKey);
  }
}