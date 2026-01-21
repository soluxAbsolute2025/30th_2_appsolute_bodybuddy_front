import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Common {
  static const storage = FlutterSecureStorage();

  static String? token;

  static Future<void> setToken(String newToken) async {
    token = newToken; // 메모리에 저장 (즉시 사용용)
    await storage.write(key: 'ACCESS_TOKEN', value: newToken); // 저장소에 저장 (재부팅용)
    print("[Common] 토큰 전역 설정 완료");
  }

  static Future<void> init() async {
    token = await storage.read(key: 'ACCESS_TOKEN');
    if (token != null) {
      print("[Common] 저장된 토큰 복구 완료");
    }
  }

  static Future<void> logout() async {
    token = null;
    await storage.delete(key: 'ACCESS_TOKEN');
    print("[Common] 토큰 삭제 완료");
  }
}