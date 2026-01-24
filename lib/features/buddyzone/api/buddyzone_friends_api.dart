import 'dart:io';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';

class BuddysApi {
  final Dio _dio = DioClient.dio;

  Future<BuddyResponse> getBuddyList() async {
    final response = await _dio.get('/api/buddy');
    debugPrint(response.data.toString());
    return BuddyResponse.fromJson(response.data);
  }

  Future<BuddyDetail> getBuddyDetail({required int userId}) async {
    final response = await _dio.get('/api/buddy/${userId}');
    debugPrint(response.data.toString());

    return BuddyDetail.fromJson(response.data);
  }

  Future<void> acceptBuddyRequest({required int requestId}) async {
    final response = await _dio.patch('/api/buddy/${requestId}/accept');
    debugPrint(response.toString());
  }

  Future<void> deleteBuddyRequest({required int requestId}) async {
    final response = await _dio.patch('/api/buddy/${requestId}/reject');
    debugPrint(response.toString());
  }

  Future<void> postBuddyRequest({required int userId}) async {
    final response = await _dio.post(
      '/api/buddy',
      data: {'targetUserId': userId.toInt()},
    );
    debugPrint(response.toString());
  }

  Future<BuddyDetail> getBuddySearch({required String userName}) async {
    final response = await _dio.get(
      '/api/buddy/search',
      queryParameters: {'nickname': userName},
    );

    return BuddyDetail.fromJson(response.data);
  }
}

class PockApi {
  final Dio _dio = DioClient.dio;

  Future<void> postPock({required int userId}) async {
    final response = await _dio.post('/api/pokes/${userId}');
    debugPrint(response.data.toString());
  }

  Future<Buddy> getPockList() async {
    final response = await _dio.get('/api/pokes');
    debugPrint(response.toString());
    return Buddy.fromJson(response.data);
  }
}
