import 'package:flutter/material.dart';
import 'package:monthly_music_challenge/challenge-page.dart';
import 'package:monthly_music_challenge/training-page.dart';
import 'package:monthly_music_challenge/statistics-page.dart';

//export PATH="$PATH:`pwd`/flutter/bin" add flutter to path from terminal
void main() => runApp(GuitarApp());

class GuitarApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GuitarAppState();
  }
}

class GuitarAppState extends State<GuitarApp> {
  int _selectedPage = 0;
  final _pageOptions = [ChallengePage(), StatisticsPage(1)];
  
  @override
  Widget build(BuildContext context) {
    final terminalTextTheme = Theme.of(context).textTheme.apply(
      bodyColor: Color(0xFF41FF00),
      displayColor: Color(0xFF41FF00)
    );
    return MaterialApp(
      title: "Guitar App",
      theme: ThemeData(
        primaryColor: Color(0xFF2D333F),
        textTheme: terminalTextTheme),
      home: Scaffold(
        backgroundColor: Color(0xFF2D333F),
        appBar: AppBar(
          title: Text("Guitar App"),
          textTheme: terminalTextTheme,
        ),
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          backgroundColor: Color(0xFF2D333F),
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("My Excercises")),
            BottomNavigationBarItem(
                icon: Icon(Icons.event_note), title: Text("Overview"))
          ],
        ),
      ),
    );
  }
}


