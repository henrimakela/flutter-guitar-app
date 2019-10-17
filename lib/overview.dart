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
      return Container();
    }
  }

  Widget showOverViewStats() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OverViewCard(heading: "You've trained", content: overviewStats.totalTrainingTime.toString(), trailing: "minutes of guitar with this app."),
              SizedBox(height: 20),
              OverViewCard(heading: "You've had", content: overviewStats.sessionCount.toString(), trailing: "training sessions."),
              SizedBox(height: 20),
              OverViewCard(heading: "Your average training session is", content: overviewStats.averageSessionTime.toString(),trailing: "minutes.",)
            ],
          ),
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

class OverViewCard extends StatelessWidget {

  final String heading;
  final String content;
  final String trailing;

  OverViewCard({
    @required this.heading,
    @required this.content,
    @required this.trailing
  });

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 8.0,
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(heading),
              SizedBox(height: 10,),
              Text(content, style: Theme.of(context).textTheme.display1,),
              SizedBox(height: 10,),
              Text(trailing)
            ],
          ),
        ),
      );

  }
}
