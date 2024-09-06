import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/post/post_bloc.dart';
import '../auth/auth_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  late PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _postBloc = BlocProvider.of<PostBloc>(context);
    _postBloc.add(FetchPostsEvent()); // Initial fetch
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _postBloc.add(FetchPostsEvent()); // Fetch next page
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Posts', style: GoogleFonts.poppins()),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            log('message');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AuthScreen()),
            );
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.indigo,
              ));
            } else if (state is PostLoaded) {
              var posts = state.posts;

              return ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount:
                    posts.length + 1, // Show loading indicator at the bottom
                itemBuilder: (context, index) {
                  if (index >= posts.length) {
                    return Center(
                        child: Transform.scale(
                      scale: 0.6,
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.indigo,
                      ),
                    ));
                  }
                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Post Title
                          Text(
                            '${post.id}. ${post.title}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Post Body
                          Text(
                            post.body,
                            style: GoogleFonts.poppins(),
                          ),
                          const SizedBox(height: 15),

                          // Image at the Bottom
                          Image.network(
                            "https://images.pexels.com/photos/307008/pexels-photo-307008.jpeg",
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return Center(
                                child: Icon(Icons.image_not_supported_outlined,
                                    color: Colors.blueGrey[200], size: 40),
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.indigo,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              }
                            },
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'Something went wrong!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
