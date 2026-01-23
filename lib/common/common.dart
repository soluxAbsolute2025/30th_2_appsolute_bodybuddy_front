import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Common {
  static const storage = FlutterSecureStorage();

  // 1. 키 이름을 하나로 확실히 고정합니다.
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

  // 토큰 저장 로직 단순화
  static Future<void> setToken(String newToken) async {
    token = newToken;
    await storage.write(key: _key, value: newToken);

    final payload = _decodeJwt(newToken);
    userId = payload?['userId'];

    print("[Common] 토큰 설정 완료 (userId=$userId)");
  }

  // 초기화 로직 (에러 방지 핵심)
  static Future<void> init() async {
    try {
      // 오직 한 가지 키로만 읽어옵니다.
      token = await storage.read(key: _key);

      if (token != null && token!.isNotEmpty) {
        final payload = _decodeJwt(token!);

        if (payload != null) {
          userId = payload['userId'];
          print("[Common] 토큰 복구 성공: userId=$userId");
        } else {
          print("[Common] 토큰 형식이 올바르지 않음");
          await logout(); // 잘못된 토큰이면 삭제
        }
      } else {
        print("[Common] 저장된 토큰이 없습니다.");
        token = null;
        userId = null;
      }
    } catch (e) {
      print("[Common] 초기화 중 에러 발생: $e");
      await logout(); // 에러 발생 시 안전하게 로그아웃 처리
    }
  }

  static Future<void> logout() async {
    token = null;
    userId = null;
    await storage.delete(key: _key);
    // 혹시 모를 옛날 키값도 같이 삭제
    await storage.delete(key: 'ACCESS_TOKEN');
    print("[Common] 모든 토큰 및 유저 정보 삭제 완료");
  }
}