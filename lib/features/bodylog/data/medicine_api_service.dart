import 'package:dio/dio.dart';
import '../../../../common/common.dart';
import 'medicine_model.dart';

class MedicineApiService {
  final String _baseUrl = 'http://52.79.228.227:8080';
  late final Dio _dio;

  MedicineApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      responseType: ResponseType.json,
      validateStatus: (status) => true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (Common.token == null || Common.token!.isEmpty) {
          Common.token = await Common.storage.read(key: 'accessToken');
        }
        options.headers['Authorization'] = 'Bearer ${Common.token}';

        // ✅ [한글 깨짐 해결] 이 설정 아주 훌륭합니다! 그대로 유지합니다.
        options.headers['Content-Type'] = 'application/json; charset=utf-8';

        print("💊 [API 요청] ${options.method} ${options.uri}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.statusCode! >= 400) {
          print("⚠️ [서버 에러 ${response.statusCode}] ${response.data}");
        } else {
          print("✅ [성공] ${response.requestOptions.uri.path}");
        }
        return handler.next(response);
      },
      onError: (e, handler) {
        print("❌ [통신 실패] ${e.message}");
        return handler.next(e);
      },
    ));
  }

  // 1. [GET] 약 목록 조회
  Future<List<MedicineRecord>> getMedicines(String date) async {
    try {
      final response = await _dio.get('/api/medication-preset');
      if (response.statusCode != 200) return [];

      final dynamic rawData = response.data;
      List<dynamic> list = [];

      if (rawData is List) {
        list = rawData;
      } else if (rawData is Map && rawData['data'] is List) {
        list = rawData['data'];
      }
      return list.map((e) => MedicineRecord.fromJson(e)).toList();
    } catch (e) {
      print("⚠️ 목록 조회 실패: $e");
      return [];
    }
  }

  // 2. [POST] 약 추가
  Future<void> createMedicine(Map<String, dynamic> data) async {
    await _dio.post('/api/medication-preset', data: data);
  }

  // 3. [PATCH] 약 수정
  Future<void> updateMedicine(int id, Map<String, dynamic> data) async {
    await _dio.patch('/api/medication-preset/$id', data: data);
  }

  // 4. [DELETE] 약 삭제 (프리셋)
  Future<void> deleteMedicine(int id) async {
    await _dio.delete('/api/medication-preset/$id');
  }

  // =============================================================
  // 👇 여기가 진짜 중요합니다! (500 에러 해결 & 취소 기능 추가)
  // =============================================================

  // 5. [POST] 복용 체크 (Log 생성)
  // -> 성공하면 생성된 '로그 ID(숫자)'를 반환합니다. (취소할 때 써야 하니까요)
  Future<int?> checkMedicine(MedicineRecord med) async {
    final now = DateTime.now();
    final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00";

    // 🚨 [500 에러 해결의 열쇠] 서버가 'MORNING', 'LUNCH' 같은 걸 원합니다.
    // 사용자가 설정한 한글 시간대를 영어 코드로 바꿔줍니다.
    String slot = "MORNING"; // 기본값
    if (med.timeKor.contains("점심") || med.timing.contains("점심")) {
      slot = "LUNCH";
    } else if (med.timeKor.contains("저녁") || med.timing.contains("저녁")) {
      slot = "DINNER";
    } else if (med.timeKor.contains("취침") || med.timing.contains("취침")) {
      slot = "BEFORE_SLEEP"; // 혹시 몰라 추가
    }

    final Map<String, dynamic> data = {
      "presetId": med.id,
      "medicationName": med.name, // 이제 한글 잘 들어감
      "intakeDate": dateStr,
      "intakeTime": timeStr,
      "intakeSlot": slot,         // 👈 이거 없으면 서버가 죽습니다 (500 Error)
      "type": "MEDICINE"
    };

    try {
      print("🚀 [복용 체크 시도] 데이터: $data");
      final response = await _dio.post('/api/medication-log', data: data);

      // 성공 시, 생성된 로그의 ID를 찾아서 반환
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map) {
          // data.id 혹은 data.data.id 등 구조에 따라 유연하게 대처
          if (response.data['id'] != null) return response.data['id'];
          if (response.data['data'] is int) return response.data['data'];
          if (response.data['data'] is Map && response.data['data']['id'] != null) {
            return response.data['data']['id'];
          }
        }
        return -1; // 성공은 했지만 ID 못 찾음
      }
      return null;
    } catch (e) {
      print("❌ 복용 체크 실패: $e");
      throw e;
    }
  }

  // 6. [DELETE] 복용 취소 (Log 삭제) -> 이게 있어야 체크 해제가 됨
  Future<void> cancelMedicine(int logId) async {
    if (logId <= 0) {
      print("⚠️ 삭제할 로그 ID가 유효하지 않습니다.");
      return;
    }
    print("🗑️ [복용 취소 시도] 로그ID: $logId");
    await _dio.delete('/api/medication-log/$logId');
  }
}