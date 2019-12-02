
import 'package:flutter/material.dart';
import 'package:monthly_music_challenge/view/create_exercise_page.dart';
import 'package:monthly_music_challenge/view/exercise_list_page.dart';
import 'package:monthly_music_challenge/view/overview_page.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedPage = 0;
  final _pageOptions = [ChallengePage(), OverView()];
  Color backgroundColor = Color(0xFF2D333F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _selectedPage == 0 ? Colors.black : Colors.white,
        child: IconButton(
            icon: Icon(
              Icons.add,
              color: _selectedPage == 0 ? Colors.white : Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateExercisePage()),
              );
            }),
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: new BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomAppBarItem(
                item:
                BottomAppBarItem(iconData: Icons.list, label: "Exercises"),
                index: 0),
            _bottomAppBarItem(
                item: BottomAppBarItem(
                    iconData: Icons.bubble_chart, label: "Overview"),
                index: 1),
          ],
        ),
        shape: CircularNotchedRectangle(),
      ),
    );
  }

  _bottomAppBarItem({BottomAppBarItem item, int index}) {
    Color color = _selectedPage == index ? Colors.black : Colors.grey;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              setState(() {
                _selectedPage = index;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  item.iconData,
                  color: color,
                ),
                Text(
                  item.label,
                  style: TextStyle(color: color),
                )
              ],
            ),
          )),);
  }
}

class BottomAppBarItem {
  IconData iconData;
  String label;

  BottomAppBarItem({this.iconData, this.label});
}