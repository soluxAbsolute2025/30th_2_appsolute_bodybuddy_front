import 'package:dio/dio.dart';

import '../models/group_challenge_create_model.dart';
import '../models/group_challenge_create_response.dart';

class GroupChallengeApi {
  final Dio dio;
  GroupChallengeApi(this.dio);

  Future<GroupChallengeCreateResponse> create(GroupChallengeCreateModel model) async {
    final res = await dio.post(
      '/group-challenges', 
      data: model.toJson(),
    );
    return GroupChallengeCreateResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
