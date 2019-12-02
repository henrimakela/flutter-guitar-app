import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:monthly_music_challenge/bloc/bloc_provider.dart';
import 'package:monthly_music_challenge/bloc/exercise_bloc.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import 'package:monthly_music_challenge/database/DBHelper.dart';
import 'package:monthly_music_challenge/view/training_page.dart';
import 'package:provider/provider.dart';

import '../consts.dart';

class StatisticsPage extends StatefulWidget {
  final int challengeID;

  StatisticsPage(this.challengeID);

  @override
  _StatisticsPageState createState() => new _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final Size _chartSize = const Size(250.0, 250.0);
  Color labelColor = Colors.white;

  @override
  Widget build(BuildContext context) {

    Provider.of<ExerciseBloc>(context).getExerciseById(widget.challengeID);

    return Scaffold(
        backgroundColor: Consts.backgroundColorDark,
        appBar: AppBar(
          backgroundColor: Consts.backgroundColorDark,
          title: Text("Progress"),
        ),
        body: Container(
            margin: EdgeInsets.all(20),
            child: StreamBuilder<Challenge>(
                stream: Provider.of<ExerciseBloc>(context).singleExerciseStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _statsView(snapshot.data);
                  }
                  return Container();
                })));
  }

  _statsView(Challenge challenge) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _progressCard(challenge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.fromLTRB(
                        0,
                        10,
                        7,
                        0,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Consts.backgroundColorDark,
                      elevation: 35,
                      child: Container(
                        height: 140,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  child: Text(
                                    "Completed",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              challenge.completedMinutes.toString(),
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Consts.greenColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text("Minutes",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Consts.greenColor,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.fromLTRB(
                        7,
                        10,
                        0,
                        0,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Consts.backgroundColorDark,
                      elevation: 35,
                      child: Container(
                        height: 140,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  child: Text(
                                    "Remaining",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              (challenge.goalMinutes -
                                      challenge.completedMinutes)
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Consts.greenColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text("Minutes",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Consts.greenColor,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          MaterialButton(
              height: 50,
              minWidth: 250,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TrainingPage(challenge)),
                );
              },
              color: Colors.white,
              child: Text("Exercise",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }

  _progressCard(Challenge challenge) {
    double completedPercentage =
        (challenge.completedMinutes / challenge.goalMinutes) * 100;
    double remainingPercentage = 100 - completedPercentage;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Consts.backgroundColorDark,
      elevation: 35,
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Text(
                    challenge.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Center(
                child: AnimatedCircularChart(
              key: _chartKey,
              size: _chartSize,
              initialChartData:
                  createData(completedPercentage, remainingPercentage),
              chartType: CircularChartType.Radial,
              edgeStyle: SegmentEdgeStyle.round,
              holeLabel: "${completedPercentage.toStringAsFixed(1)} %",
              labelStyle: TextStyle(
                  fontSize: 28,
                  color: Consts.greenColor,
                  fontWeight: FontWeight.bold),
              percentageValues: true,
            )),
          ],
        ),
      ),
    );
  }

  List<CircularStackEntry> createData(double completed, double remaining) {
    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry([
        new CircularSegmentEntry(
          completed,
          Consts.greenColor,
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          remaining,
          Consts.greenTransparent,
          rankKey: 'remaining',
        ),
      ]),
    ];

    //this means are coming back from training page so chart should be animated again
    if (_chartKey.currentState != null) {
      _chartKey.currentState.updateData(data);
    }

    return data;
  }
}
