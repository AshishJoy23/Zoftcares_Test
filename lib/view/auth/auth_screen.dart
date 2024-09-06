import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoftcare_test/bloc/post/post_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../repository/auth_repo.dart';
import '../home/home_screen.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String version = '';

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(FetchVersionEvent());

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            log('message');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
          } else if (state is AuthUnauthenticated || state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state is AuthUnauthenticated
                      ? state.message
                      : 'Login failed')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AuthScreen()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login to Your Account',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(
                        child: Transform.scale(
                      scale: 0.6,
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.indigo,
                      ),
                    ));
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber, // Amber button color
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context.read<AuthBloc>().add(
                            LoginEvent(
                                emailController.text, passwordController.text),
                          );
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 100),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthVersionLoaded) {
                    version = state.version;
                    log('version $version');
                  }
                  return Text(
                    'Version : $version',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
