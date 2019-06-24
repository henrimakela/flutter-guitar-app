import 'package:flutter/material.dart';
import 'package:monthly_music_challenge/database/DBHelper.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import 'dart:async';

class TrainingPage extends StatefulWidget {
  final int challengeID;
  TrainingPage(this.challengeID);

  @override
  _TrainingPageState createState() => new _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  Stopwatch stopWatch;
  Challenge challenge;
  Timer timer;
  double trainingTime;
  String elapsedTime;
  DBHelper dbHelper;
  bool dataIsLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stopWatch = new Stopwatch();

    dbHelper = new DBHelper();

    dbHelper.getChallengeById(widget.challengeID).then((challenge) {
      setState(() {
        this.challenge = challenge;
        this.dataIsLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    stopWatch.stop();
  }

  @override
  bool get mounted => super.mounted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2D333F),
        appBar: AppBar(
          title: Text("Training"),
        ),
        body: trainingWidget());
  }

  Widget trainingWidget(){
    if (!dataIsLoaded) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
          padding: EdgeInsets.fromLTRB(5, 50, 5, 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Training on ${challenge.name}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0),
                ),
                Text(
                  elapsedTime ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    FloatingActionButton(
                        heroTag: null,
                        backgroundColor: Colors.green,
                        onPressed: () {
                          startStopWatch();
                        },
                        child: Icon(Icons.play_arrow)),
                    FloatingActionButton(
                        heroTag: null,
                        backgroundColor: Colors.red,
                        onPressed: () {
                          stopStopWatch();
                        },
                        child: Icon(Icons.stop)),
                  ],
                ),
                MaterialButton(
                  onPressed: () {
                    stopStopWatch();
                    saveProgress();
                  },
                  color: Colors.black38,
                  textColor: Colors.white,
                  child: Text("End session"),
                )
              ],
            ),
          ));
    }
  }

  startStopWatch() {
    stopWatch.start();
    timer = new Timer.periodic(new Duration(milliseconds: 1000), updateTime);
  }

  stopStopWatch() {
    stopWatch.stop();
    setTime();
  }

  setTime() {
    int timeCurrently = stopWatch.elapsedMilliseconds;
    if (mounted) {
      setState(() {
        elapsedTime = transformMilliseconds(timeCurrently);
      });
    }
  }

  transformMilliseconds(int milliSeconds) {
    int hundreds = (milliSeconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr : $secondsStr";
  }

  toHours(int milliSeconds) {
    int hundreds = (milliSeconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    double hours = (minutes / 60);
    return hours;
  }

  updateTime(Timer timer) {
    if (mounted) {
      setState(() {
        elapsedTime = transformMilliseconds(stopWatch.elapsedMilliseconds);
      });
    }
  }

  saveProgress() {
    int milliSeconds = stopWatch.elapsedMilliseconds;
    double hours = toHours(60000);
    print("Training time $milliSeconds");

    dbHelper.saveProgress(hours, widget.challengeID);
  }
}
