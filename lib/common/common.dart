import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Common {
  static const storage = FlutterSecureStorage();

  // 👇 실수 방지를 위해 변수로 관리하는 게 좋습니다.
  static const _key = 'accessToken';

  static String? token;

  static Future<void> setToken(String newToken) async {
    token = newToken;
    // 👇 'ACCESS_TOKEN' -> _key (즉, 'accessToken') 로 변경
    await storage.write(key: _key, value: newToken);
    print("[Common] 토큰 전역 설정 완료 (Key: $_key)");
  }

  static Future<void> init() async {
    // 👇 여기도 변경
    token = await storage.read(key: _key);
    if (token != null) {
      print("[Common] 저장된 토큰 복구 완료: ${token!.substring(0, 10)}...");
    } else {
      print("[Common] 저장된 토큰 없음");
    }
  }

  static Future<void> logout() async {
    token = null;
    // 👇 여기도 변경
    await storage.delete(key: _key);
    print("[Common] 토큰 삭제 완료");
  }
}