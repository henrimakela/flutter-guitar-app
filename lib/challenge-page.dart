import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import "create-exercise-page.dart";
import 'statistics-page.dart';
import 'package:monthly_music_challenge/database/DBHelper.dart';

class ChallengePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ChallengePageState();
  }
}

class _ChallengePageState extends State<ChallengePage> {
  final List<String> challengeList = new List();
  final DBHelper dbHelper = new DBHelper();
  bool itemRemoved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            MaterialButton(
              padding: EdgeInsets.all(40),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateExercisePage()),
                )
              },
              child: Text("Create new exercise",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            Expanded(
                child: FutureBuilder(
              future: dbHelper.getAllChallenges(),
              initialData: List(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Container(child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, int position) {
                          final challenge = snapshot.data[position];
                          return Dismissible(
                            key: Key(snapshot.data[position].id.toString()),
                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              color: Colors.redAccent,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (DismissDirection direction) async {
                              final bool res = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm"),
                                      content: const Text(
                                          "Are you sure you wish to delete this item?"),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              dbHelper.deleteChallengeById(
                                                  challenge.id);
                                              setState(() {
                                                itemRemoved = true;
                                              });
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text("DELETE")),
                                        FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("CANCEL"),
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: makeCard(challenge, context),
                          );
                        },
                      ))
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ))
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Card makeCard(Challenge challenge, BuildContext context) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(challenge, context),
      ),
    );

ListTile makeListTile(Challenge challenge, BuildContext context) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(
        challenge.name,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                child: LinearProgressIndicator(
                    backgroundColor: Color(0xF41FF00),
                    value: calculateProgress(challenge),
                    valueColor: AlwaysStoppedAnimation(Color(0xFF41FF00))),
              ))
        ],
      ),
      trailing: Icon(Icons.keyboard_arrow_right,
          color: Color(0xFF41FF00), size: 30.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StatisticsPage(challenge.id)),
        );
      },
    );


double calculateProgress(Challenge challenge) {
  double hoursIn = double.parse(challenge.completedHours);
  double goal = double.parse(challenge.goalHours);
  double completedPercentage = hoursIn / goal;

  print("percentage  " + completedPercentage.toString());
  return completedPercentage;
}
