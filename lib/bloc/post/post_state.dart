part of 'post_bloc.dart';


abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
   List<Post> posts;

  PostLoaded(this.posts);
}

class PostLoadingMore extends PostState {
  final List<Post> posts;

  PostLoadingMore(this.posts);
}


class PostError extends PostState {
  final String message;

  PostError(this.message);
}