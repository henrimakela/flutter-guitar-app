import 'package:flutter/material.dart';
import 'overview.dart';
import 'package:monthly_music_challenge/challenge-page.dart';

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
  final _pageOptions = [ChallengePage(), OverView()];
  
  @override
  Widget build(BuildContext context) {
  
    final alternativeTextTheme = Theme.of(context).textTheme.apply(
      bodyColor: Colors.greenAccent,
      displayColor: Colors.greenAccent
    );
    return MaterialApp(
      title: "Guitar App",
      theme: ThemeData(
        dialogBackgroundColor: Color(0xFF2D333F),
        primaryColor: Color(0xFF2D333F),
        textTheme: alternativeTextTheme),
      home: Scaffold(
        backgroundColor: Color(0xFF2D333F),
        appBar: AppBar(
          title: Text("Guitar App"),
          textTheme: alternativeTextTheme,
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
                icon: Icon(Icons.list), title: Text("My Excercises")),
            BottomNavigationBarItem(
                icon: Icon(Icons.feedback), title: Text("Overview"))
          ],
        ),
      ),
    );
  }
}


