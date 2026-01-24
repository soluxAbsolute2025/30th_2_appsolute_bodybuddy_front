import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../api/dio_client.dart';
import '../models/group_challenge_create_model.dart';
import '../models/group_challenge_create_response.dart';

class GroupChallengeApi {
  Future<GroupChallengeCreateResponse> createGroupChallenge(
    GroupChallengeCreateModel model,
  ) async {
    final dio = DioClient.dio;

    final reqJson = jsonEncode(model.toJson());
    print('[GROUP CREATE] request=$reqJson');

    final formData = FormData();

    // ✅ request(JSON)
    formData.files.add(
      MapEntry(
        'request',
        MultipartFile.fromString(
          reqJson,
          filename: 'request.json',
          contentType: MediaType('application', 'json'),
        ),
      ),
    );

    // ✅ image(Optional)
    if (model.imageFile != null) {
      final file = model.imageFile!;
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: _guessImageType(file.path),
          ),
        ),
      );
    }

    final res = await dio.post(
      '/api/challenges/group', // ✅ 명세 엔드포인트에 맞게 유지/수정
      data: formData,
      options: Options(
        contentType: 'multipart/form-data', // ✅ DioClient json 헤더 덮어쓰기
      ),
    );

    // 서버 응답이 {status, groupId, groupCode, message} 형태
    return GroupChallengeCreateResponse.fromJson(
      Map<String, dynamic>.from(res.data),
    );
  }

  MediaType _guessImageType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return MediaType('image', 'png');
    if (lower.endsWith('.webp')) return MediaType('image', 'webp');
    if (lower.endsWith('.gif')) return MediaType('image', 'gif');
    return MediaType('image', 'jpeg');
  }
}
