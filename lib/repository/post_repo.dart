import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:zoftcare_test/api/api_endpoints.dart';
import 'package:zoftcare_test/api/api_services.dart';
import 'package:zoftcare_test/model/post_model.dart';

class PostRepository {
  final Dio dio = Dio();

  Future<PostModel> fetchPosts(int page) async {
    final response =
        await HttpRequest.httpGetRequest(endPoint: '${ApiEndpoints.postLists}$page&size=10');
    log('???????$response');
    if (response.statusCode == 200) {
      var data = response.data;

      // List<dynamic> listData = data['data'];
      // log('============#${listData.length}');
      // log('convertint list #3############$listData');
      // List<PostModel> postList = listData.map((e) => PostModel.fromJson(e)).toList();
      // log('converted list #3############$postList');
      return PostModel.fromJson(data);
    } else {
      throw Exception('Failed to login');
    }
  }
}
