import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../api/dio_client.dart';
import '../models/personal_challenge_create_model.dart';

class PersonalChallengeApi {
  Future<int> createPersonalChallenge(
    PersonalChallengeCreateModel model,
  ) async {
    final dio = DioClient.dio;

    // ✅ unit 서버값 변환
    final body = model.toJson();
    body['unit'] = _toServerUnit(body['unit'] as String? ?? '');

    final reqJson = jsonEncode(body);
    final formData = FormData();

    // ✅ request를 "application/json 파트"로 전송 (명세대로)
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
      final path = file.path;
      final fileName = path.split('/').last;

      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            path,
            filename: fileName,
            contentType: _guessImageType(path),
          ),
        ),
      );
    }
    print('[PERSONAL] requestJson=$reqJson');
    print(
      '[PERSONAL] files=${formData.files.map((e) => '${e.key}:${e.value.filename} ${e.value.contentType}').toList()}',
    );

    final res = await dio.post('/api/challenges/personal', data: formData);
    return res.data['data'] as int;
  }

  String _toServerUnit(String uiUnit) {
    switch (uiUnit) {
      case '걸음':
        return 'steps';
      case '분':
        return 'minutes';
      case '회':
        return 'count';
      case 'ml':
        return 'ml';
      default:
        return uiUnit;
    }
  }

  MediaType _guessImageType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return MediaType('image', 'png');
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    }
    return MediaType('application', 'octet-stream');
  }
}
