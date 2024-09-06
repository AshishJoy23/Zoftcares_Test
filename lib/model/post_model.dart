import 'dart:convert';

class PostModel {
  final bool hasMore;
  final List<Post> posts;

  PostModel({required this.hasMore, required this.posts});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> listData = json['data'];
    List<Post> postList = listData.map((e) => Post.fromJson(e)).toList();
    return PostModel(hasMore: json['hasMore'], posts: postList);
  }
}

class Post {
  final String id;
  final String title;
  final String body;
  final String image;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'image': image,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      title: json['title'],
      body: json['body'],
      image: json['image'],
    );
  }
}
