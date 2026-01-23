import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import '../models/ongoing_group_challenge.dart';

class OngoingGroupChallengeApi {
  final Dio _dio = DioClient.dio;

  Future<List<OngoingGroupChallenge>> fetchOngoingGroupChallenges() async {
    try {
      final res = await _dio.get('/api/challenges/group/ongoing');

      final body = res.data;
      print('[ONGOING] body=$body'); // ✅ 실제 응답 확인

      final rawList = (body['data'] as List<dynamic>? ?? []);
      print('[ONGOING] data length=${rawList.length}');

      final parsed = <OngoingGroupChallenge>[];
      for (final item in rawList) {
        try {
          parsed.add(OngoingGroupChallenge.fromJson(item as Map<String, dynamic>));
        } catch (e, s) {
          print('❌ [ONGOING] item parse error: $e');
          print('❌ [ONGOING] item=$item');
          print(s);
          rethrow;
        }
      }
      return parsed;
    } on DioException catch (e, s) {
      print('❌ [ONGOING] DioException: ${e.response?.statusCode}');
      print('❌ [ONGOING] Dio body: ${e.response?.data}');
      print(s);
      rethrow;
    } catch (e, s) {
      print('❌ [ONGOING] Unknown error: $e');
      print(s);
      rethrow;
    }
  }
}
