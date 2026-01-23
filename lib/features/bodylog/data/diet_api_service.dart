import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../api/dio_client.dart';
import 'package:bodybuddy_frontend/common/common.dart';
import 'diet_model.dart';

class DietApiService {
  // DioClient에서 만든 dio 인스턴스 (인터셉터로 토큰 자동 주입됨)
  final Dio _dio = DioClient.dio;

  // ------------------------------------------------------------------------
  // [GET] 식단 목록 조회
  // 엔드포인트: /api/meal-log
  // ------------------------------------------------------------------------
  Future<List<DietRecord>> getMealLogs(String date) async {
    try {
      final response = await _dio.get(
        '/api/meal-log', // ★ 수정됨 (/api/diets -> /api/meal-log)
        queryParameters: {'date': date},
      );

      // 응답 데이터 처리
      if (response.statusCode == 200) {
        // 서버 응답이 배열인지, 객체 감싸져 있는지 확인 필요하지만
        // 보통 List<dynamic>으로 옵니다.
        final List<dynamic> list = response.data;
        return list.map((e) => DietRecord.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      // 403 에러 등의 경우 여기서 잡힘
      print('데이터 조회 실패: ${e.message} / ${e.response?.statusCode}');
      // 필요시 rethrow;
      return [];
    } catch (e) {
      print('기타 에러: $e');
      return [];
    }
  }

  // ------------------------------------------------------------------------
  // [POST] 식단 기록 생성 (이미지 업로드 포함)
  // 엔드포인트: /api/meal-log
  // 방식: Multipart/form-data
  // 규칙: 'request'(JSON) + 'image'(File)
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

      // 2. JSON 파트 추가 (Content-Type: application/json 강제 지정)
      // ★ formData.files.add로 넣어야 헤더가 꼬이지 않습니다.
      formData.files.add(
        MapEntry(
          "request", // 서버가 요구한 Key 이름
          MultipartFile.fromString(
            jsonEncode(jsonMap),
            contentType: MediaType('application', 'json'), // ★ 핵심 포인트
          ),
        ),
      );

      // 3. 이미지 파트 추가 (있을 경우만)
      if (imageFile != null) {
        final String path = imageFile.path;
        final String fileName = path.split('/').last;

        // 확장자 확인
        MediaType contentType = MediaType('image', 'jpeg');
        if (path.toLowerCase().endsWith('.png')) {
          contentType = MediaType('image', 'png');
        }

        formData.files.add(
          MapEntry(
            "image", // 서버가 요구한 Key 이름
            await MultipartFile.fromFile(
              path,
              filename: fileName,
              contentType: contentType,
            ),
          ),
        );
      }
      print("🔥 서비스에서 사용하는 토큰: ${Common.token}");

      // 4. 전송
      await _dio.post(
        '/api/meal-log', // ★ 수정됨
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
  // 엔드포인트: /api/meal-log/{id}
  // ------------------------------------------------------------------------
  Future<void> deleteMeal(int id) async {
    try {
      await _dio.delete('/api/meal-log/$id'); // ★ 수정됨
    } catch (e) {
      print("삭제 실패: $e");
      throw e;
    }
  }

  // ------------------------------------------------------------------------
  // [PATCH] 식단 수정
  // 엔드포인트: /api/meal-log/{id}
  // 주의: 수정 시에도 이미지를 바꾼다면 POST처럼 Multipart를 써야 할 수도 있음.
  // 현재는 텍스트만 수정한다고 가정하고 JSON 전송으로 구현.
  // ------------------------------------------------------------------------
  Future<void> updateMeal(int id, Map<String, dynamic> data) async {
    try {
      await _dio.patch(
        '/api/meal-log/$id', // ★ 수정됨
        data: data,
      );
    } catch (e) {
      print("수정 실패: $e");
      throw e;
    }
  }
}