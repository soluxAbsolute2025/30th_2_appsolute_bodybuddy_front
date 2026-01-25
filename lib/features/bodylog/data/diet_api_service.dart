import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../api/dio_client.dart'; // 경로는 본인 프로젝트에 맞게 확인
import 'package:bodybuddy_frontend/common/common.dart';
import 'diet_model.dart';

class DietApiService {
  final Dio _dio = DioClient.dio;

  // ------------------------------------------------------------------------
  // [GET] 식단 목록 조회
  // ------------------------------------------------------------------------
  Future<List<DietRecord>> getMealLogs(String date) async {
    try {
      final response = await _dio.get(
        '/api/meal-log',
        queryParameters: {'date': date},
      );

      // 🔍 [수정됨] Dio에서는 bodyBytes 대신 data를 바로 찍습니다.
      print("🔥 [DEBUG] 서버 응답 코드: ${response.statusCode}");
      print("🔥 [DEBUG] 서버 응답 데이터: ${response.data}");

      if (response.statusCode == 200) {
        // 데이터가 List인지 Map인지 확인하여 처리
        if (response.data is List) {
          return (response.data as List).map((e) => DietRecord.fromJson(e)).toList();
        } else if (response.data is Map && response.data['data'] is List) {
          // 만약 { "status": 200, "data": [...] } 형태라면
          return (response.data['data'] as List).map((e) => DietRecord.fromJson(e)).toList();
        } else {
          print("⚠️ 데이터 형식이 예상과 다릅니다: ${response.data.runtimeType}");
          return [];
        }
      }
      return [];
    } on DioException catch (e) {
      print('데이터 조회 실패: ${e.message}');
      print('서버 응답 내용: ${e.response?.data}');
      return [];
    } catch (e) {
      print('기타 에러: $e');
      return [];
    }
  }

  // ------------------------------------------------------------------------
  // [POST] 식단 기록 생성
  // ------------------------------------------------------------------------
  Future<void> createMeal({
    required String mealType,
    required String intakeDate,
    required String intakeTime,
    required List<String> foods,
    required String memo,
    File? imageFile,
  }) async {
    try {
      final formData = FormData();

      // 1. JSON 데이터 준비
      final Map<String, dynamic> jsonMap = {
        "mealType": mealType,
        "intakeDate": intakeDate,
        "intakeTime": intakeTime,
        "foods": foods,
        "memo": memo,
      };

      // 2. JSON 파트 추가
      formData.files.add(
        MapEntry(
          "request",
          MultipartFile.fromString(
            jsonEncode(jsonMap),
            contentType: MediaType('application', 'json'),
          ),
        ),
      );

      // 3. 이미지 파트 추가
      if (imageFile != null) {
        final String path = imageFile.path;
        final String fileName = path.split('/').last;

        MediaType contentType = MediaType('image', 'jpeg');
        if (path.toLowerCase().endsWith('.png')) {
          contentType = MediaType('image', 'png');
        }

        formData.files.add(
          MapEntry(
            "image",
            await MultipartFile.fromFile(
              path,
              filename: fileName,
              contentType: contentType,
            ),
          ),
        );
      }

      // 4. 전송
      await _dio.post(
        '/api/meal-log',
        data: formData,
      );
      print("✅ 식단 업로드 성공");

    } on DioException catch (e) {
      print("❌ 식단 등록 실패 (Dio): ${e.response?.statusCode}");
      print("응답 내용: ${e.response?.data}");
      throw e;
    } catch (e) {
      print("❌ 식단 등록 실패 (기타): $e");
      throw e;
    }
  }

  // ------------------------------------------------------------------------
  // [DELETE] 식단 삭제
  // ------------------------------------------------------------------------
  Future<void> deleteMeal(int id) async {
    try {
      await _dio.delete('/api/meal-log/$id');
    } catch (e) {
      print("삭제 실패: $e");
      throw e;
    }
  }

  // ------------------------------------------------------------------------
  // [PATCH] 식단 수정
  // ------------------------------------------------------------------------
  Future<void> updateMeal(int id, Map<String, dynamic> data) async {
    try {
      await _dio.patch(
        '/api/meal-log/$id',
        data: data,
      );
    } catch (e) {
      print("수정 실패: $e");
      throw e;
    }
  }
}