import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import '../models/group_checkin_response.dart';

class GroupChallengeCheckInApi {
  Future<GroupCheckInResponse> checkIn({required int challengeId}) async {
    final dio = DioClient.dio;

    final res = await dio.post(
      '/api/challenges/group/$challengeId/check-in',
      options: Options(
        // ✅ 전역 Content-Type 강제 제거
        contentType: null,
        headers: {
          'Content-Type': null,
          'Accept': 'application/json',
        },
        validateStatus: (s) => s != null && s >= 200 && s < 300,
      ),
    );

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected response: ${res.data}');
    }
    return GroupCheckInResponse.fromJson(data);
  }
}
