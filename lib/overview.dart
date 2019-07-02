import 'package:flutter/material.dart';
import 'models/stats.dart';
import 'models/session.dart';
import 'database/DBHelper.dart';

class OverView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
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
              "You've trained ${overviewStats.totalHours} hours of guitar with this app",
              style: TextStyle(color: Colors.greenAccent, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Text(
              "You've had ${overviewStats.sessionCount} training sessions",
              style: TextStyle(color: Colors.greenAccent, fontSize: 20),
              textAlign: TextAlign.center
            ),
            SizedBox(height: 50),
            Text(
              "By average, your training session lasts for ${overviewStats.averageSessionTime} hours",
              style: TextStyle(color: Colors.greenAccent, fontSize: 20),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Future<double> getTotalCompletedHours() async {
    DBHelper dbHelper = new DBHelper();
    return dbHelper.getTotalHours();
  }

  Future<Stats> buildOverViewStats() async {
    DBHelper dbHelper = new DBHelper();

    double totalHours = await dbHelper.getTotalHours();
    List<Session> sessions = await dbHelper.getAllSessions();
    int sessionCount = sessions.length;
    double averageTrainingTime = _getAverageSessionTime(sessions);

    return new Stats(totalHours, sessionCount, averageTrainingTime);
  }

  double _getAverageSessionTime(List<Session> sessions){

    double totalTime = 0;
    double averageTime = 0;
      for(int i = 0; i < sessions.length; i++){
          totalTime += sessions[i].duration;
      }
    
    averageTime = totalTime / sessions.length;
    return averageTime;
  }
}
