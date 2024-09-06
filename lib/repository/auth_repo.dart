import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:zoftcare_test/api/api_endpoints.dart';
import 'package:zoftcare_test/api/api_services.dart';

class AuthRepository {
  final Dio dio = Dio();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await HttpRequest.httpPostRequest(
        bodyData: {'email': email, 'password': password},
        endPoint: ApiEndpoints.login);
    log('???????$response');
    if (response == null) {
      log('message---Failed to login');
      throw Exception('Failed to login');
    }
    if (response.statusCode == 200) {
      var data = response.data;
      return {
        'token': data['data']['accessToken'],
        'validity': data['data']['validity'] // in milliseconds
      };
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String> getVersion() async {
    final response = await HttpRequest.httpGetRequest(
        endPoint: ApiEndpoints.appVersion);
    log('???????$response');
    if (response.statusCode == 200) {
      var data = response.data;
      return data['data']['version'];
    } else {
      throw Exception('Failed to get version');
    }
  }
}
