import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import '../models/group_challenge_list_item.dart';

class GroupChallengeListApi {
  final Dio _dio = DioClient.dio;

  /// 그룹 챌린지 목록 조회 (RECRUITING + ONGOING 섞여서 내려오는 목록)
  Future<List<GroupChallengeListItem>> fetchGroupChallenges() async {
    try {
      final res = await _dio.get('/api/challenges/group');
      print('[GROUP] body=${res.data}');

      final body = res.data;
      final rawList = (body['data'] as List<dynamic>? ?? []);

      return rawList
          .map((e) => GroupChallengeListItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      print('❌ [GET /api/challenges/group] ${e.response?.statusCode}');
      print('❌ body: ${e.response?.data}');
      rethrow;
    }
  }
}
