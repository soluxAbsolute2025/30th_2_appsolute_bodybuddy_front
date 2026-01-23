import 'dart:io';
import 'package:dio/dio.dart';
import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';

class BuddysApi {
  final Dio _dio = DioClient.dio;

  Future<void> getBuddyList() async {
    final response = await _dio.get('/api/buddy');
    debugPrint(response.data.toString());
    // return BuddyResponse.fromJson(response.data);
  }

  Future<void> getBuddyDetail({required int userId}) async {
    final response = await _dio.get('/api/buddy/${userId}');
    debugPrint(response.data.toString());

    // return BuddyResponse.fromJson(response.data);
  }

  // Future<void>
}
