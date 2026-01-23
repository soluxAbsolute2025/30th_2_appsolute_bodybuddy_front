import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../../../api/dio_client.dart';
import '../models/personal_challenge_create_model.dart';

class PersonalChallengeApi {
  Future<int> createPersonalChallenge(PersonalChallengeCreateModel model) async {
    final dio = DioClient.dio;

    final reqJson = jsonEncode(model.toJson());
    print('[PERSONAL CREATE] request=$reqJson');

    final formData = FormData();

    // ✅ request: "application/json" 파트로 명확히 전송 + filename까지 줘서 서버가 JSON part로 인식하게
    formData.files.add(
      MapEntry(
        'request',
        MultipartFile.fromString(
          reqJson,
          filename: 'request.json',
          contentType: DioMediaType.parse('application/json'),
        ),
      ),
    );

    // ✅ image: Optional
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

    // ✅ 중요: contentType 강제하지 말기! (Dio가 boundary 포함해서 세팅)
    final res = await dio.post(
      '/api/challenges/personal',
      data: formData,
      // options: Options(contentType: 'multipart/form-data'),  <-- ❌ 빼기
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
