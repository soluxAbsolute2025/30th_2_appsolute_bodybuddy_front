import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import '../models/group_checkin_response.dart';

class GroupChallengeCheckInApi {
  Future<GroupCheckInResponse> checkIn({
    required int challengeId,
  }) async {
    final dio = DioClient.dio;

    final res = await dio.post(
      '/api/challenges/group/$challengeId/check-in',
      data: null, // ✅ RequestBody 없음
      options: Options(
        // 필요하면 statusCode 201도 허용(기본도 통과됨)
        validateStatus: (status) => status != null && status >= 200 && status < 300,
      ),
    );

    return GroupCheckInResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
