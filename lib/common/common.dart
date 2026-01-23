import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Common {
  static const storage = FlutterSecureStorage();

  // 👇 실수 방지를 위해 변수로 관리하는 게 좋습니다.
  static const _key = 'accessToken';

  static String? token;
  static int? userId;

  /// JWT payload 디코딩
  static Map<String, dynamic>? _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      return jsonDecode(payload) as Map<String, dynamic>;
    } catch (e) {
      print('[Common] JWT decode 실패: $e');
      return null;
    }
  }

  static Future<void> setToken(String newToken) async {
    token = newToken;
    await storage.write(key: 'ACCESS_TOKEN', value: newToken);

    // ✅ token에서 userId 추출
    final payload = _decodeJwt(newToken);
    userId = payload?['userId'];

    print("[Common] 토큰 전역 설정 완료 (userId=$userId)");
    token = newToken;
    // 👇 'ACCESS_TOKEN' -> _key (즉, 'accessToken') 로 변경
    await storage.write(key: _key, value: newToken);
    print("[Common] 토큰 전역 설정 완료 (Key: $_key)");
  }

  static Future<void> init() async {
    // 👇 여기도 변경
    token = await storage.read(key: _key);
    token = await storage.read(key: 'ACCESS_TOKEN');

    if (token != null) {
      print("[Common] 저장된 토큰 복구 완료: ${token!.substring(0, 10)}...");
    } else {
      print("[Common] 저장된 토큰 없음");
      final payload = _decodeJwt(token!);
      userId = payload?['userId'];
      print("[Common] 저장된 토큰 복구 완료 (userId=$userId)");
    }
  }

  static Future<void> logout() async {
    token = null;
    userId = null; // ✅ 중요
    await storage.delete(key: 'ACCESS_TOKEN');
    // 👇 여기도 변경
    await storage.delete(key: _key);
    print("[Common] 토큰 삭제 완료");
  }
}
