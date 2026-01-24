import 'dart:io';

import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_post_model.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_myfeed_model.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/mypage_info_model.dart';
import '../models/mypage_privacy_model.dart';

class MyPageAPI {
  Dio _dio = DioClient.dio;

  Future<MyPageResponse> getMyPageAllInfo() async {
    final response = await _dio.get('/api/mypage');
    print('나의 정보 확인하기 : ${response.data}');

    return MyPageResponse.fromJson(response.data);
  }

  Future<PrivacyResponse> getMyPagePrivacy() async {
    final response = await _dio.get('/api/mypage/privacy');
    print("마이페이지 프라이버시시 정보: " + response.data.toString());

    return PrivacyResponse.fromJson(response.data);
  }

  Future<PrivacyResponse> patchMyPagePrivacy(
    PrivacyResponse privacyResponse,
  ) async {
    final response = await _dio.patch(
      '/api/mypage/privacy',
      data: privacyResponse.toJson(),
    );
    print("프라이버시 수정: " + response.data.toString());

    return PrivacyResponse.fromJson(response.data);
  }

  Future<MyFeedModel> getMyPageMyFeed() async {
    final response = await _dio.get('/api/mypage/posts');

    print(response.data.toString());
    return MyFeedModel.fromJson(response.data);
  }

  Future<void> patchMypageProfile() async {
    final response = await _dio.patch('/api/mypage/profile');
  }
}

class ProfileApi {
  final Dio _dio = DioClient.dio;

  Future<void> updateProfile({
    required MyProfileModel request,
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
            contentType: http.MediaType('application', 'json'),
          ),
        ),
      );

      // 2. 이미지 파일 추가
      if (imageFile != null) {
        final String path = imageFile.path;
        final String fileName = path.split('/').last;

        // 확장자 체크
        http.MediaType contentType = http.MediaType('image', 'jpeg');
        if (path.toLowerCase().endsWith('.png')) {
          contentType = http.MediaType('image', 'png');
        } else if (path.toLowerCase().endsWith('.jpg') ||
            path.toLowerCase().endsWith('.jpeg')) {
          contentType = http.MediaType('image', 'jpeg');
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
      final response = await _dio.patch(
        '/api/users/profile',
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
