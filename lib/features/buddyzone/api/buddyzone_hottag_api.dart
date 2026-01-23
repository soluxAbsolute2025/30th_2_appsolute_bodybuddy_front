import 'dart:io';

import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_post_model.dart';
import 'package:dio/dio.dart';
import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_type_model.dart';
import 'package:http_parser/http_parser.dart';
import '../../../common/common.dart';

class HattagApi {
  final Dio _dio = DioClient.dio;

  Future<List<String>> getHashtag(String accessToken) async {
    final response = await _dio.post('/api/feeds/hashtag/popular');

    return List<String>.from(response.data);
  }
}

class FeedsApi {
  final Dio _dio = DioClient.dio;

  Future<void> postFeeds({
    required String content,
    required String place,
    required String visibility,
    required List<String> hashtags,
  }) async {
    final response = await _dio.post(
      '/api/feeds',
      data: {
        'content': content,
        'place': place,
        'visibility': visibility,
        'hashtags': hashtags,
      },
      // options: Options(contentType: Header),
    );
    print(response);
  }

  Future<List<String>> getHashtag() async {
    final response = await _dio.get('/api/feeds/hashtag/popular');
    print(response.data);
    return List<String>.from(response.data);
  }

  Future<FeedPost> detailFeeds({required int feedId}) async {
    final response = await _dio.delete('/api/feeds/${feedId}');
    print(response.data);
    return FeedPost.fromJson(response.data);
  }

  Future<void> postFeedLike(int feedId) async {
    final response = await _dio.post('/api/posts/${feedId}/likes');
    print(response);
  }

  Future<void> postFeedComment(int feedId, String content) async {
    final response = await _dio.post(
      '/api/feeds/${feedId}/comments',
      data: {'content': content},
    );
    print(response);
  }
}

class FeedRequestAPI {
  final Dio _dio = DioClient.dio;

  Future<FeedPageResponse> getFeedRequest({
    required FeedRequest request,
  }) async {
    Response response;

    switch (request.mode) {
      case FeedMode.normal:
        response = await _dio.get(
          '/api/feeds',
          queryParameters: {'page': 0, 'size': 10},
        );
        print(response.data);
        break;
      case FeedMode.search:
        response = await _dio.get(
          '/api/feeds/search',
          queryParameters: {'keyword': request.keyword, 'page': 0, 'size': 10},
        );
        print("검색 API : " + response.data.toString());
        break;
      case FeedMode.tag:
        response = await _dio.get(
          '/api/feeds/hashtag',
          queryParameters: {'tagName': request.tag, 'page': 0, 'size': 10},
        );
        print("태그 API : " + response.data.toString());
        break;
    }
    return FeedPageResponse.fromJson(response.data);
  }
}

class FeedPostRequst {
  final Dio _dio = DioClient.dio;

  Future<void> uplodePost({
    required PostFeedModel request,
    File? imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        "request": MultipartFile.fromString(
          request.toJsonString(),
          contentType: MediaType('application/json', 'utf-8'),
        ),
        // 이미지 파일이 있을 경우 추가
        if (imageFile != null)
          "image": await MultipartFile.fromFile(
            imageFile.path,
            filename: "post_image.jpg",
            contentType: MediaType('image', 'jpeg'), // 파일 형식에 맞게 설정
          ),
      });

      // 3. 서버로 전송
      final response = await _dio.post('/api/feeds', data: formData);

      print("업로드 성공: ${response.data}");
    } catch (e) {
      print("업로드 실패: $e");
    }
  }
}
