import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../models/group_challenge_create_model.dart';
import '../models/group_challenge_create_response.dart';

class GroupChallengeApi {
  final Dio dio;
  GroupChallengeApi(this.dio);

  Future<GroupChallengeCreateResponse> create(GroupChallengeCreateModel model) async {
    final formData = FormData();

    formData.files.add(
      MapEntry(
        'request',
        MultipartFile.fromString(
          jsonEncode(model.toRequestJson()),
          filename: 'request.json',
          contentType: MediaType('application', 'json', {'charset': 'utf-8'}),
        ),
      ),
    );

    final File? imageFile = model.imageFile;
    if (imageFile != null) {
      final filename = imageFile.path.split(Platform.pathSeparator).last;
      final lower = filename.toLowerCase();

      final mediaType =
          lower.endsWith('.png') ? MediaType('image', 'png') : MediaType('image', 'jpeg');

      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: filename,
            contentType: mediaType,
          ),
        ),
      );
    }
    final res = await dio.post(
      '/api/challenges/group',
      data: formData,
      options: Options(
        validateStatus: (code) => code != null && code >= 200 && code < 300,
      ),
    );

    return GroupChallengeCreateResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
