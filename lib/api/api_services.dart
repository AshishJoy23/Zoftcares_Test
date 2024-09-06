import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoftcare_test/api/api_endpoints.dart';

class HttpRequest {
  static Future<Response> httpGetRequest(
      {Map<String, dynamic>? bodyData, String endPoint = ''}) async {
    // Loader.showLoader();
    if (kDebugMode) {
      log('get request ====> $endPoint $bodyData ');
    }

    final Dio dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOnsiSWQiOjcsIkZpcnN0X05hbWUiOiJqb2huX2RvZSIsIkVtYWlsIjoibW9oYW5AZ21haWwuY29tIiwiUGhvbmVOdW1iZXIiOiIxMjMtNDU2LTc4OTAiLCJVc2VyX1R5cGVfSWQiOjJ9LCJpYXQiOjE3MjAwNzAwNTd9.rFEkWmUwoEh2Q65Ht88nO485cjngPR7skqLuIUtggOQ';
    final response = await dio.get(
      '${ApiEndpoints.baseUrl}$endPoint',
      options: Options(headers: {
        "Content-Type": "application/json",
        'x-auth-key': token,
      }),
      queryParameters: bodyData,
    );
    if (kDebugMode) {
      log('get result ====> $response  ');
    }
    // Loader.stopLoader();
    return response;
  }


  static Future<Response?> httpPostRequest(
      {Map<String, dynamic>? bodyData, String endPoint = ''}) async {
    // Loader.showLoader();
    if (kDebugMode) {
      log('post request ====> $endPoint $bodyData ');
    }
    final Dio dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";

    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOnsiSWQiOjcsIkZpcnN0X05hbWUiOiJqb2huX2RvZSIsIkVtYWlsIjoibW9oYW5AZ21haWwuY29tIiwiUGhvbmVOdW1iZXIiOiIxMjMtNDU2LTc4OTAiLCJVc2VyX1R5cGVfSWQiOjJ9LCJpYXQiOjE3MjAwNzAwNTd9.rFEkWmUwoEh2Q65Ht88nO485cjngPR7skqLuIUtggOQ';

    log('post token $token');
    try {
      final Response response = await dio.post(
        '${ApiEndpoints.baseUrl}$endPoint',
        options: Options(headers: {
          "Content-Type": "application/json",
          'x-auth-key': token,
        }),
        data: bodyData,
      );
      if (kDebugMode) {
        log('post result ====> ${response.data}  ');
      }

      // Loader.stopLoader();

      return response;
    } catch (e) {
      // Loader.stopLoader();
      return null;
    }
  }
}