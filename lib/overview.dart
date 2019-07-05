import 'package:flutter/material.dart';
import 'models/stats.dart';
import 'models/session.dart';
import 'database/DBHelper.dart';

class OverView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OverViewState();
  }
}

class _OverViewState extends State<OverView> {
  bool dataIsLoaded = false;
  Stats overviewStats;

  @override
  void initState() {
    super.initState();
    buildOverViewStats().then((stats) => {
          setState(() {
            dataIsLoaded = true;
            overviewStats = stats;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    if (dataIsLoaded) {
      return showOverViewStats();
    } else {
      return Center(
          child: Column(
        children: <Widget>[
          CircularProgressIndicator(),
          Text(
            "Generating your stats...",
            style: TextStyle(color: Colors.greenAccent, fontSize: 20),
            textAlign: TextAlign.center,
          )
        ],
      ));
    }
  }

  Widget showOverViewStats() {
    return Container(
      margin: EdgeInsets.all(25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "You've trained ${overviewStats.totalTrainingTime} minutes of guitar with this app",
              style: TextStyle(color: Colors.greenAccent, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Text("You've had ${overviewStats.sessionCount} training sessions",
                style: TextStyle(color: Colors.greenAccent, fontSize: 20),
                textAlign: TextAlign.center),
            SizedBox(height: 50),
            Text(
              "Your average training session is ${overviewStats.averageSessionTime} minutes",
              style: TextStyle(color: Colors.greenAccent, fontSize: 20),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }



  Future<Stats> buildOverViewStats() async {
    DBHelper dbHelper = new DBHelper();

    List<Session> sessions = await dbHelper.getAllSessions();
    int sessionCount = sessions.length;
    int totalTrainingTimeString = await dbHelper.getTotalTime();
        
    double avgTimeString = _getAverageSessionTime(sessions);

    return new Stats(totalTrainingTimeString, sessionCount, avgTimeString);
  }

  double _getAverageSessionTime(List<Session> sessions) {
    int totalMinutes = 0;
    double averageTime = 0;
    for (int i = 0; i < sessions.length; i++) {
      totalMinutes += sessions[i].duration;
    }
    if(totalMinutes == 0) return 0;
    
    averageTime = totalMinutes / sessions.length;
    return averageTime;
  }

}
