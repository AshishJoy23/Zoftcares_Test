import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoftcare_test/view/home/home_screen.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../repository/auth_repo.dart';
import '../auth/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      final AuthBloc authBloc = AuthBloc(AuthRepository());

      bool isLoggedIn = await authBloc.isUserLoggedIn();
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo, // Background color matching theme
      body: Center(
        child: Text(
          'Blog App',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text on indigo background
          ),
        ),
      ),
    );
  }
}
