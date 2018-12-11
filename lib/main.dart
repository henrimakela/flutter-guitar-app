import 'package:flutter/material.dart';
import 'package:monthly_music_challenge/challenge-page.dart';
import 'package:monthly_music_challenge/training-page.dart';
import 'package:monthly_music_challenge/statistics-page.dart';

void main() {
  runApp(new MaterialApp(
    color: Colors.greenAccent,
    home: new HomePage(),
    routes: <String, WidgetBuilder>{
      "/TrainingPage": (BuildContext context) => new TrainingPage(),
      "/ChallengePage": (BuildContext context) => new ChallengePage(),
      "/StatisticsPage": (BuildContext context) => new StatisticsPage()
    },
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.greenAccent,
        body: Container(
          child: Center(
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Navigator.of(context).pushNamed("/StatisticsPage");
                    },
                    child: Image(image: AssetImage("assets/statistics.png"))),
                FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Navigator.of(context).pushNamed("/TrainingPage");
                    },
                    child: Image(image: AssetImage("assets/guitar.png"))),
                FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Navigator.of(context).pushNamed("/ChallengePage");
                    },
                    child: Image(image: AssetImage("assets/clipboard.png"))),
              ],
            ),
          ),
        ));
  }
}




