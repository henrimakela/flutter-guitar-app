import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import 'package:monthly_music_challenge/database/DBHelper.dart';

class StatisticsPage extends StatefulWidget {
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
    print("init state called");

    fetchChallengeFromDatabase().then((value) {
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
        double remainingMin = (60/100) * (fractionalRemaining * 100);
        this.minutesOverHour = remainingMin.truncate();
        
        print("minutes: $minutes");

        challengeName = value.name;
        challengeDesc = value.description;
        challengeCategory = value.category;
        dataIsLoaded = true;
        print(
          "id is $id"
            );
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build called");
    TextStyle _labelStyle = Theme.of(context)
        .textTheme
        .title
        .merge(new TextStyle(color: labelColor));
    return Scaffold(
        backgroundColor: Colors.greenAccent,
        body: Container(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Your progression in the current challenge",
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              progressChart()
            ],
          ),
        )));
  }

  Widget progressChart() {
    print(
        "progress chart is called completed percentage: $completedPercentage");
    /*if(dataIsLoaded){
      return Center(
      child: Column(
        children: <Widget>[
          Text(this.challengeName),
          Text(this.challengeDesc),
          Text(this.challengeCategory),
          Text(this.completedPercentage.toString()),
          Text(this.remainingPercentage.toString())
        ],
      ),
    );
    }
    else{
      return Center();
    }
    */
    if (dataIsLoaded) {
      print("if clause");

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        Text(
          this.challengeName,
          style: TextStyle(fontSize: 25, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        Text(
          this.challengeDesc,
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        AnimatedCircularChart(
          key: _chartKey,
          size: _chartSize,
          initialChartData:
              createData(this.completedPercentage, this.remainingPercentage),
          chartType: CircularChartType.Radial,
          edgeStyle: SegmentEdgeStyle.round,
          holeLabel: "$completed %",
          percentageValues: true,
        ),
        Text(
          "You have trained this challenge for $hours hours $minutes minutes",
          style: TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        Text("You have $hoursToGo hours $minutesOverHour remaining")
      ]);
    } else {
      print("else clause");
      return Center();
    }
  }

  List<CircularStackEntry> createData(double completed, double remaining) {
    print("CreateData is called");
    //hours practiced in percentage
    print(completedPercentage);
    print(remainingPercentage);
    Color dialColor = Colors.blue;
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
          Colors.blueGrey[600],
          rankKey: 'remaining',
        ),
      ]),
    ];

    return data;
  }
}

Future<Challenge> fetchChallengeFromDatabase() async {
  var dbHelper = DBHelper();
  Future<Challenge> challenge = dbHelper.getCurrentChallenge();
  return challenge;
}
