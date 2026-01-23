// lib/features/bodylog/data/medicine_api_service.dart

import 'package:dio/dio.dart';
import '../../../../common/common.dart'; // ★ Common 클래스 import (토큰 사용)
import 'medicine_model.dart';

class MedicineApiService {
  // 에뮬레이터: 10.0.2.2, 실제기기: 내 PC IP
  final String _baseUrl = 'http://52.79.228.227:8080';

  late final Dio _dio;

  MedicineApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        // 👇 [핵심] 토큰 인증 (403 에러 방지)
        'Authorization': 'Bearer ${Common.token}',
        // 👇 [핵심] JSON 형식 명시 (400 에러 방지)
        'Content-Type': 'application/json',
      },
    ));
  }

  // [GET] 날짜별 조회
  Future<List<MedicineRecord>> getMedicines(String date) async {
    try {
      final response = await _dio.get(
        '/api/medicine-log',
        queryParameters: {'date': date},
      );

      // 데이터 파싱
      final List data = response.data['data'] ?? [];
      return data.map((e) => MedicineRecord.fromJson(e)).toList();
    } catch (e) {
      print('약 조회 실패: $e');
      return [];
    }
  }

  // [POST] 약 추가
  Future<void> createMedicine(Map<String, dynamic> data) async {
    try {
      await _dio.post('/api/medicine-log', data: data);
    } catch (e) {
      print('약 추가 실패: $e');
      rethrow;
    }
  }

  // [PATCH] 약 수정
  Future<void> updateMedicine(int id, Map<String, dynamic> data) async {
    try {
      await _dio.patch('/api/medicine-log/$id', data: data);
    } catch (e) {
      print('약 수정 실패: $e');
      rethrow;
    }
  }

  // [DELETE] 약 삭제
  Future<void> deleteMedicine(int id) async {
    try {
      await _dio.delete('/api/medicine-log/$id');
    } catch (e) {
      print('약 삭제 실패: $e');
      rethrow;
    }
  }

  // [POST/PATCH] 복용 체크 토글
  Future<void> toggleCheck(int id) async {
    try {
      // 서버 API 명세에 맞춰 경로 확인 (/check 또는 상태값 update)
      await _dio.post('/api/medicine-log/$id/check');
    } catch (e) {
      print('체크 토글 실패: $e');
      rethrow;
    }
  }
}