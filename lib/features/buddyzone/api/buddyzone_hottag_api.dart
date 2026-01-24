import 'dart:io';

import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_post_model.dart';
import 'package:dio/dio.dart';
import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_type_model.dart';
import 'package:http_parser/http_parser.dart';

import '../models/feeds/feed_post_model.dart';

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
    );
    print(response);
  }

  Future<List<String>> getHashtag() async {
    final response = await _dio.get('/api/feeds/hashtag/popular');
    print(response.data);
    return List<String>.from(response.data);
  }

  Future<FeedPost> detailFeeds({required int feedId}) async {
    final response = await _dio.get('/api/feeds/${feedId}');
    print(response.data);
    return FeedPost.fromJson(response.data);
  }

  Future<void> deleteFeed({required int feedId}) async {
    final response = await _dio.delete('/api/feeds/${feedId}');
    print('삭제 완료 : ${response}');
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

  Future<void> deleteFeedComment(int commentId) async {
    final response = await _dio.delete('/api/feeds/comments/${commentId}');
    print('나의 반응 삭제 완료 : $response');
  }

  Future<void> patchFeedComment(int commentId, String content) async {
    final response = await _dio.patch(
      '/api/feeds/comments/${commentId}',
      data: {'content': content},
    );

    print(response);
  }

  Future<void> checkUserInfo() async {
    print("checkUserInfo 호출됨.");
    try {
      final response = await _dio.get('/api/users');

      print("🎉 업로드 성공: ${response.statusCode}");
      print("응답 데이터: ${response.data}");
    } on DioException catch (e) {
      print("❌ 업로드 실패 (DioError): ${e.response?.statusCode}");
      print("서버 응답: ${e.response?.data}");
      print("에러 메시지: ${e.message}");
    } catch (e) {
      print("❌ 업로드 실패 (기타): $e");
    }
    // final response = await _dio.get('/api/users');
    // print("/api/users :" + response.data);
    // if (response.data != null) {
    //   print('별다른 처리가 되지 않았습니다.');
    // }
    // return List<String>.from(response.data);
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
      final formData = FormData();

      formData.files.add(
        MapEntry(
          "request",
          MultipartFile.fromString(
            request.toJsonString(),
            // [핵심 수정] 문법을 고쳤습니다.
            contentType: MediaType('application', 'json'),
          ),
        ),
      );

      // 2. 이미지 파일 추가
      if (imageFile != null) {
        final String path = imageFile.path;
        final String fileName = path.split('/').last;

        // 확장자 체크
        MediaType contentType = MediaType('image', 'jpeg');
        if (path.toLowerCase().endsWith('.png')) {
          contentType = MediaType('image', 'png');
        } else if (path.toLowerCase().endsWith('.jpg') ||
            path.toLowerCase().endsWith('.jpeg')) {
          contentType = MediaType('image', 'jpeg');
        }

        formData.files.add(
          MapEntry(
            "image",
            await MultipartFile.fromFile(
              path,
              filename: fileName,
              contentType: contentType,
            ),
          ),
        );
      }

      print("--- [서버 전송 시작] ---");
      print("JSON Data: ${request.toJsonString()}");

      // 3. 전송
      // 백엔드 예시에는 헤더를 직접 넣었지만, Dio에서는 FormData를 넣으면
      // 알아서 Content-Type: multipart/form-data; boundary=... 를 만들어줍니다.
      final response = await _dio.post(
        '/api/feeds',
        data: formData,
        // options: Options(...) <-- 이 부분은 삭제하세요. Dio에게 맡기는 게 가장 안전합니다.
      );

      print("🎉 업로드 성공: ${response.statusCode}");
      print("응답 데이터: ${response.data}");
    } on DioException catch (e) {
      print("❌ 업로드 실패 (DioError): ${e.response?.statusCode}");
      print("서버 응답: ${e.response?.data}");
      print("에러 메시지: ${e.message}");
    } catch (e) {
      print("❌ 업로드 실패 (기타): $e");
    }
  }
}
