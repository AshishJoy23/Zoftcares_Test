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

  Future<void> _onFetchPosts(FetchPostsEvent event, Emitter<PostState> emit) async {
    if (isFetching) return;  // Prevent multiple calls at the same time
    if (!hasMore){
      final existingPosts = (state as PostLoaded).posts;
      emit(PostLoaded(existingPosts));
    };
    isFetching = true;

    if (state is PostLoadingMore) {
      emit(PostLoadingMore((state as PostLoadingMore).posts));
    } else {
      emit(PostLoading());
    }
    try {
      final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
      if (token == null) {
        emit(PostError('No token found.'));
        return;
      }
      final posts = await postRepository.fetchPosts(currentPage);
      hasMore = posts.hasMore;
      currentPage++;
      // emit(PostLoaded(posts));
      if (state is PostLoaded || state is PostLoadingMore) {
        final existingPosts = (state as PostLoaded).posts;
        emit(PostLoaded(existingPosts + posts.posts));  // Append new posts
      } else {
        emit(PostLoaded(posts.posts));
      }
    } catch (e) {
      emit(PostError('Failed to fetch posts: ${e.toString()}'));
    }
    isFetching = false;
  }
}