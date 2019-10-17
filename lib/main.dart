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
  Color backgroundColor = Color(0xFF2D333F);
  @override
  Widget build(BuildContext context) {
  
    final alternativeTextTheme = Theme.of(context).textTheme.apply(
      bodyColor: Colors.greenAccent,
      displayColor: Colors.greenAccent
    );
    return MaterialApp(
      title: "Guitar App",
      theme: ThemeData(
        cardColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        dialogBackgroundColor: backgroundColor,
        primaryColor: backgroundColor,
        textTheme: alternativeTextTheme),
      home: Scaffold(
        appBar: AppBar(

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


