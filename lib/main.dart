import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoftcare_test/bloc/auth/auth_bloc.dart';
import 'package:zoftcare_test/bloc/post/post_bloc.dart';
import 'package:zoftcare_test/repository/auth_repo.dart';
import 'package:zoftcare_test/repository/post_repo.dart';

import 'view/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) =>
              AuthBloc(AuthRepository())..add(FetchVersionEvent()),
        ),
        BlocProvider<PostBloc>(
          create: (BuildContext context) => PostBloc(PostRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Blog App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor:
              const Color(0xFFF5F5F5), // Lighter background
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: Colors.black87,
                  displayColor: Colors.black87,
                ),
          ), // Applying Google Fonts (Poppins in this case)
          appBarTheme: AppBarTheme(
            color: Colors.indigo,
            toolbarTextStyle: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
            ).bodyMedium,
            titleTextStyle: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
            ).titleLarge,
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.amber, // Button color
            textTheme: ButtonTextTheme.primary, // Button text theme
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
              .copyWith(secondary: Colors.amber)
              .copyWith(background: Colors.white),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
