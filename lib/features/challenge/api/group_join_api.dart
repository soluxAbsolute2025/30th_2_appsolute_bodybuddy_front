import 'package:dio/dio.dart';
import '../../../../../api/dio_client.dart';
import '../models/join_group_response.dart';

class GroupJoinApi {
  Future<ApiResponse<JoinGroupResponseData>> joinGroup(String code) async {
    final dio = DioClient.dio;

    final res = await dio.post(
      "/api/challenges/group/join",
      data: {"groupCode": code},
    );

    return ApiResponse.fromJson(
      res.data as Map<String, dynamic>,
      (data) => JoinGroupResponseData.fromJson(data),
    );
  }
}
