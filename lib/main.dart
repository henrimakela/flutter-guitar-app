import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monthly_music_challenge/bloc/bloc_provider.dart';
import 'package:monthly_music_challenge/bloc/exercise_bloc.dart';
import 'package:monthly_music_challenge/consts.dart';
import 'package:monthly_music_challenge/view/create_exercise_page.dart';
import 'package:monthly_music_challenge/view/overview_page.dart';
import 'package:monthly_music_challenge/view/exercise_list_page.dart';
import 'package:monthly_music_challenge/view/splash_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(GuitarApp());

/*
* Logo
* Duration cannot be 0
*
*
*
*
* */

class GuitarApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return GuitarAppState();
  }
}

class GuitarAppState extends State<GuitarApp> {
  Color backgroundColor = Color(0xFF2D333F);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Provider<ExerciseBloc>(
      create: (context) => ExerciseBloc(),
      dispose: (context, value) => value.dispose(),
      child: MaterialApp(
        title: "Guitar App",
        theme: ThemeData(
          primaryColor: backgroundColor,
          appBarTheme: AppBarTheme(elevation: 0),
        ),
        home: SplashScreen(),
      ),
    );
  }
}

