import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../api/dio_client.dart';
import '../models/personal_challenge_create_model.dart';

class PersonalChallengeApi {
  Future<int> createPersonalChallenge(PersonalChallengeCreateModel model) async {
    final dio = DioClient.dio;

    final formData = FormData();

    // ✅ request (application/json 파트)
    formData.files.add(
      MapEntry(
        'request',
        MultipartFile.fromString(
          jsonEncode(model.toJson()),
          contentType: DioMediaType.parse('application/json'),
        ),
      ),
    );

    // ✅ image (Optional)
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
      '/api/challenges/personal',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    final data = res.data;
    final challengeId = data?['data']?['challengeId'];
    if (challengeId is int) return challengeId;

    throw Exception('Unexpected response: $data');
  }

  DioMediaType? _guessImageType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return DioMediaType.parse('image/png');
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return DioMediaType.parse('image/jpeg');
    }
    return null;
  }
}
