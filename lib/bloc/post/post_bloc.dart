import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/post_model.dart';
import '../../repository/post_repo.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  bool isFetching = false;
  bool hasMore = true;
  int currentPage = 1;

  PostBloc(this.postRepository) : super(PostInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(
      FetchPostsEvent event, Emitter<PostState> emit) async {
    if (isFetching) return; // Prevent multiple calls at the same time
    if (!hasMore) {
      log('last page!!!!!!!!!!!!!!!!');
      final state = this.state as PostLoaded;
      final existingPosts = state.posts;
      emit(PostLoaded(existingPosts));
      return; //
    }
    isFetching = true;
    if (state is! PostLoaded) {
      emit(PostLoading());
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) {
        emit(PostError('No token found.'));
        return;
      }
      final state = this.state;
      final posts = await postRepository.fetchPosts(currentPage);
      hasMore = posts.hasMore;
      currentPage++;
      if (state is PostLoaded) {
        final existingPosts = state.posts;
        List<Post> newPostList = existingPosts + posts.posts;
        emit(PostLoaded(newPostList));
      } else {
        emit(PostLoaded(posts.posts));
      }
    } catch (e) {
      log('Failed to fetch posts: ${e.toString()}');
      emit(PostError('Failed to fetch posts: ${e.toString()}'));
    }
    isFetching = false;
  }
}
