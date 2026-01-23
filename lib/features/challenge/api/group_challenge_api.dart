import 'package:dio/dio.dart';
import '../../../../../api/dio_client.dart';
import '../models/group_challenge_detail_model.dart';

class GroupChallengeApi {
  final Dio _dio = DioClient.dio;

  /// GET /api/challenges/group/ongoing/{id}
  Future<GroupChallengeDetail> getOngoingGroupChallengeDetail(int id) async {
    try {
      final res = await _dio.get('/api/challenges/group/ongoing/$id');

      // 서버가 {status, message, data} 형태
      final body = res.data as Map<String, dynamic>;
      final parsed = GroupChallengeDetailResponse.fromJson(body);

      return GroupChallengeDetail.fromData(parsed.data);
    } on DioException catch (e) {
      // 디버깅 편하게 메시지 정리
      final status = e.response?.statusCode;
      final data = e.response?.data;
      throw Exception('[GroupChallengeApi] detail failed ($status): $data');
    } catch (e) {
      throw Exception('[GroupChallengeApi] detail parse error: $e');
    }
  }
}
