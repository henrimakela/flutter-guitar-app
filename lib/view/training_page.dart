import 'package:flutter/material.dart';
import 'package:monthly_music_challenge/bloc/bloc_provider.dart';
import 'package:monthly_music_challenge/bloc/exercise_bloc.dart';
import 'package:monthly_music_challenge/models/session.dart';
import 'package:monthly_music_challenge/database/DBHelper.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../consts.dart';

class TrainingPage extends StatefulWidget {
  final Challenge challenge;

  TrainingPage(this.challenge);

  @override
  _TrainingPageState createState() => new _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  Stopwatch stopWatch;
  Challenge challenge;
  Timer timer;
  String elapsedTimeString;
  double elapsedTimeSeconds = 0.0;


  @override
  void initState() {
    super.initState();
    challenge = widget.challenge;
    stopWatch = new Stopwatch();
    elapsedTimeSeconds = challenge.completedMinutes.toDouble() * 60;
    elapsedTimeString = transformMilliseconds(0);
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
        backgroundColor: Consts.backgroundColorDark,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Training",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: <Widget>[
                    _headerWidget(),
                    _trainingWidget(),

                  ],
                ),
              )
            );
  }

  Widget _headerWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Container(
          margin: EdgeInsets.all(20),
          child: Text(
            challenge.description,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget _trainingWidget() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: 20,
      right: 20,
      child: Column(
        children: <Widget>[
          Card(
            color: Consts.backgroundColorDark,
            elevation: 25,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Container(
              margin: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 175,
                    width: 175,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      backgroundColor: Consts.greenTransparent,
                      value: calculateProgress(challenge),
                      valueColor: AlwaysStoppedAnimation(Consts.greenColor),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    elapsedTimeString ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          iconSize: 50,
                          icon: Icon(
                            Icons.pause_circle_outline,
                            color: Consts.greenColor,
                          ),
                          onPressed: () {
                            stopStopWatch();
                          }),
                      SizedBox(
                        width: 100,
                      ),
                      IconButton(
                          iconSize: 50,
                          icon: Icon(
                            Icons.play_circle_outline,
                            color: Consts.greenColor,
                          ),
                          onPressed: () {
                            startStopWatch();
                          })
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 30,),
          MaterialButton(
              height: 50,
              minWidth: 250,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
              ),
              onPressed: (){
                stopStopWatch();
                saveProgress();
              },

              color: Colors.white,
              child: Text("End training",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold))
          )
        ],
      ),
    );
  }

  double calculateProgress(Challenge challenge) {
    int goalInSeconds = challenge.goalMinutes * 60;
    double completedPercentage = elapsedTimeSeconds / goalInSeconds;
    return completedPercentage;
  }

  startStopWatch() {
    stopWatch.start();

    timer = new Timer.periodic(new Duration(milliseconds: 1000), updateTime);
  }

  stopStopWatch() {
    stopWatch.stop();
    setTime();
  }

  resetTime() {
    stopWatch.reset();
    setTime();
  }

  setTime() {
    int timeCurrently = stopWatch.elapsedMilliseconds;
    if (mounted) {
      setState(() {
        elapsedTimeString = transformMilliseconds(timeCurrently);
        elapsedTimeSeconds = timeCurrently / 1000;
      });
    }
  }

  transformMilliseconds(int milliSeconds) {
    milliSeconds += challenge.completedMinutes * 60 * 1000;
    int hundreds = (milliSeconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr : $secondsStr";
  }

  toMinutes(int milliSeconds) {
    int hundreds = (milliSeconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).round();

    return minutes;
  }

  updateTime(Timer timer) {
    if (mounted) {
      setState(() {
        elapsedTimeString = transformMilliseconds(stopWatch.elapsedMilliseconds);
        elapsedTimeSeconds = stopWatch.elapsedMilliseconds / 1000 + challenge.completedMinutes * 60;
      });
    }
  }

  saveProgress() {
    int milliSeconds = stopWatch.elapsedMilliseconds;
    int minutes = toMinutes(milliSeconds);
    print("Training time $minutes");
    var date = DateTime.now();

    Provider.of<ExerciseBloc>(context).saveProgress(minutes, challenge.id);
    Provider.of<ExerciseBloc>(context).saveSession(new Session(minutes, date.toString()));
  }
}
