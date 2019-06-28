import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import 'package:monthly_music_challenge/database/DBHelper.dart';
import 'package:monthly_music_challenge/training-page.dart';

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
  bool dataIsLoaded = false;
  double completedPercentage;
  int completed;

  //completed hours and minutes that will be shown on the screen
  int hours;
  int minutes;

  //remaining hours and minutes that will be shown on the screen
  int hoursToGo;
  int minutesOverHour;

  double remainingPercentage;
  double completedHours;
  double remainingHours;

  String challengeName;
  String challengeDesc;
  String challengeCategory;

  @override
  void initState() {
    fetchChallengeFromDatabase(widget.challengeID).then((value) {
      setState(() {
        double hoursIn = double.parse(value.completedHours);
        double goal = double.parse(value.goalHours);
        int id = value.id;

        this.completedHours = hoursIn;
        this.remainingHours = goal - hoursIn;

        this.completedPercentage = (hoursIn / goal) * 100;
        this.remainingPercentage = 100 - completedPercentage;
        //completed percentage as an integer
        completed = this.completedPercentage.truncate();

        // extract decimals from completed hour
        double number = completedHours;
        int hours = number.truncate();
        double fractional = number - hours;
        this.hours = hours;
        double min = (60 / 100) * (fractional * 100);
        this.minutes = min.truncate();

        double remainingTime = this.remainingHours;
        int remainingHours = remainingTime.truncate();
        double fractionalRemaining = remainingTime - remainingHours;

        this.hoursToGo = remainingHours;
        double remainingMin = (60 / 100) * (fractionalRemaining * 100);
        this.minutesOverHour = remainingMin.truncate();

        challengeName = value.name;
        challengeDesc = value.description;
        dataIsLoaded = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2D333F),
        appBar: AppBar(
          title: Text("Progress"),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[progressChart()],
          ),
        )));
  }

  Widget progressChart() {
    if (dataIsLoaded) {
      if (this.completedPercentage >= 100) {
        return Column(
          children: <Widget>[
            Text("You have completed this exercise",
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            AnimatedCircularChart(
              key: _chartKey,
              size: _chartSize,
              initialChartData: createData(
                  this.completedPercentage, this.remainingPercentage),
              chartType: CircularChartType.Radial,
              edgeStyle: SegmentEdgeStyle.round,
              holeLabel: "$completed %",
              percentageValues: true,
            )
          ],
        );
      } else {
        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                this.challengeName,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20,),
              Text(
                this.challengeDesc,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20,),
              AnimatedCircularChart(
                key: _chartKey,
                size: _chartSize,
                initialChartData: createData(
                    this.completedPercentage, this.remainingPercentage),
                chartType: CircularChartType.Radial,
                edgeStyle: SegmentEdgeStyle.round,
                holeLabel: "$completed %",
                percentageValues: true,
              ),
              createProgressRow(),
              SizedBox(
                height: 50,
              ),
              OutlineButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TrainingPage(widget.challengeID)),
                    );
                  },
                  child: Text("Continue training",
                      style: TextStyle(color: Colors.white)),
                  borderSide: BorderSide(color: Colors.greenAccent),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)))
            ]);
      }
    } else {
      return Center();
    }
  }

  Row createProgressRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text("Done",
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            SizedBox(
              height: 20,
            ),
            Text("$hours hours $minutes minutes")
          ],
        ),
        SizedBox(
          width: 75,
        ),
        Column(
          children: <Widget>[
            Text("Remaining",
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            SizedBox(
              height: 20,
            ),
            Text("$hoursToGo hours $minutesOverHour minutes")
          ],
        )
      ],
    );
  }

  List<CircularStackEntry> createData(double completed, double remaining) {
    print("CreateData is called");
    //hours practiced in percentage
    print(completedPercentage);
    print(remainingPercentage);
    Color dialColor = Colors.greenAccent;
    Color remainingColor = Color(0x3F69F0AE);
    labelColor = dialColor;
    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry([
        new CircularSegmentEntry(
          completed,
          dialColor,
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          remaining,
          remainingColor,
          rankKey: 'remaining',
        ),
      ]),
    ];

    return data;
  }
}

Future<Challenge> fetchChallengeFromDatabase(int id) async {
  var dbHelper = DBHelper();
  Future<Challenge> challenge = dbHelper.getChallengeById(id);
  return challenge;
}
