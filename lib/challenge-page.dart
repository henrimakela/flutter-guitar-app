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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateExercisePage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: FutureBuilder(
                    future: dbHelper.getAllChallenges(),
                    initialData: List(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length == 0) {
                          return placeHolderListTile();
                        }
                        else {return Container(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (_, int position) {

                                final challenge = snapshot.data[position];
                                return Dismissible(
                                  key: Key(
                                      snapshot.data[position].id.toString()),
                                  background: Container(
                                    padding: EdgeInsets.only(right: 10),
                                    alignment: AlignmentDirectional.centerEnd,
                                    color: Colors.redAccent,
                                    child: Icon(
                                        Icons.delete, color: Colors.white),
                                  ),
                                  confirmDismiss: (
                                      DismissDirection direction) async {
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
                                                    dbHelper
                                                        .deleteChallengeById(
                                                        challenge.id);
                                                    setState(() {
                                                      itemRemoved = true;
                                                    });
                                                    Navigator.of(context).pop(
                                                        true);
                                                  },
                                                  child: const Text("DELETE")),
                                              FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(
                                                        false),
                                                child: const Text("CANCEL"),
                                              )
                                            ],
                                          );
                                        });

                                    return res;
                                  },
                                  child: makeCard(challenge, context),
                                );
                              },
                            ));}
                      }
                      else {
                        return Center(
                            child: CircularProgressIndicator()
                        );
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Card makeCard(Challenge challenge, BuildContext context) =>
    Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(challenge, context),
      ),
    );

ListTile placeHolderListTile() {
  return ListTile(
    title: Text("No ongoing exercises"),
  );
}

ListTile makeListTile(Challenge challenge, BuildContext context) =>
    ListTile(
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
                    valueColor: AlwaysStoppedAnimation(Colors.greenAccent)),
              ))
        ],
      ),
      trailing: Icon(Icons.keyboard_arrow_right,
          color: Colors.greenAccent, size: 30.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StatisticsPage(challenge.id)),
        );
      },
    );

double calculateProgress(Challenge challenge) {
  int minutesIn = challenge.completedMinutes;
  int goal = challenge.goalMinutes;
  double completedPercentage = minutesIn / goal;
  //this  might not be accurate
  print("percentage  " + completedPercentage.toString());
  return completedPercentage;
}
