import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/mypage_info_model.dart';
import '../models/mypage_privacy_model.dart';

class MyPageAPI {
  Dio _dio = DioClient.dio;

  Future<MyPageResponse> getMyPageAllInfo() async {
    final response = await _dio.get('/api/mypage');
    print(response.data);

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

  Future<void> getMyPageMyFeed() async {
    final response = await _dio.get('/api/mypage/posts');

    print(response.data.toString());
  }
}
