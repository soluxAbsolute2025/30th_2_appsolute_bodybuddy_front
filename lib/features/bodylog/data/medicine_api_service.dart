import 'package:dio/dio.dart';
import '../../../../common/common.dart';
import 'medicine_model.dart';

class MedicineApiService {
  // ✅ 서버 주소
  final String _baseUrl = 'http://52.79.228.227:8080';
  late final Dio _dio;

  MedicineApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      validateStatus: (status) => true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (Common.token == null || Common.token!.isEmpty) {
          Common.token = await Common.storage.read(key: 'accessToken');
        }
        options.headers['Authorization'] = 'Bearer ${Common.token}';
        options.headers['Content-Type'] = 'application/json';

        print("💊 [API 요청] ${options.method} ${options.uri}");
        if (options.data != null) {
          print("📦 [보내는 데이터] ${options.data}");
        }
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

  // 1. [GET] 약 목록 조회 (Preset)
  Future<List<MedicineRecord>> getMedicines(String date) async {
    try {
      // ✅ 기록(Log)이 아니라 프리셋(Preset) 목록을 가져옵니다.
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

  // 2. [POST] 약 추가 (Preset 등록)
  Future<void> createMedicine(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/medication-preset', data: data);
    print("✨ 등록 결과: ${response.data}");
  }

  // 3. [PATCH] 약 수정
  Future<void> updateMedicine(int id, Map<String, dynamic> data) async {
    await _dio.patch('/api/medication-preset/$id', data: data);
  }

  // 4. [DELETE] 약 삭제
  Future<void> deleteMedicine(int id) async {
    await _dio.delete('/api/medication-preset/$id');
  }

  // 5. [TOGGLE] 복용 체크 (수정됨: 기록 생성)
  // 🚨 중요: 단순히 ID만 보내는 게 아니라, 기록(Log) 데이터를 만들어 보냅니다.
  Future<void> toggleCheck(MedicineRecord med) async {
    final now = DateTime.now();
    final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00";

    // 서버에 보낼 '복용 기록' 데이터
    final Map<String, dynamic> data = {
      "presetId": med.id,
      "medicationName": med.name,
      "intakeDate": dateStr,
      "intakeTime": timeStr,
      "timing": med.timing,
      "type": "MEDICINE"
    };

    try {
      // ✅ Log 생성 (POST)
      await _dio.post('/api/medication-log', data: data);
      print("✅ 복용 기록 생성 완료");
    } catch (e) {
      print("⚠️ 복용 기록 생성 실패: $e");
      rethrow;
    }
  }
}