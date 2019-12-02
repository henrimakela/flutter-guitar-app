import 'package:flutter/material.dart';
import 'package:monthly_music_challenge/bloc/bloc_provider.dart';
import 'package:monthly_music_challenge/bloc/exercise_bloc.dart';
import 'package:monthly_music_challenge/models/stats.dart';
import 'package:monthly_music_challenge/models/session.dart';
import 'package:monthly_music_challenge/database/DBHelper.dart';
import 'package:provider/provider.dart';

import '../consts.dart';

class OverView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OverViewState();
  }
}

class _OverViewState extends State<OverView> {
  ExerciseBloc bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ExerciseBloc>(context).getOverViewStats();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Overview",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Consts.backgroundColorDark,
        body: _overViewWidget());
  }

  Widget _overViewWidget() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Consts.backgroundColorDark.withOpacity(0.4), BlendMode.dstATop),
            image: NetworkImage(
                "https://images.unsplash.com/photo-1457052002176-2d16a4f4a3ff?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80"),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
      ),
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[_headerWidget(), _cardColumn()],
      ),
    );
  }

  Widget _headerWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
    );
  }

  _cardColumn() {
    return Positioned(
      top: 0,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 40, 10),
        child: StreamBuilder<Object>(
            stream: Provider.of<ExerciseBloc>(context).statsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Stats stats = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OverViewCard(
                        content: stats.totalTrainingTime == null
                            ? "0"
                            : stats.totalTrainingTime.toString(),
                        trailing: "Total training time in minutes"),
                    SizedBox(height: 20),
                    OverViewCard(
                        content: stats.sessionCount.toString(),
                        //TODO show completed / ongoing sessions
                        trailing: "Sessions"),
                    SizedBox(height: 20),
                    OverViewCard(
                      content: stats.averageSessionTime == null
                          ? "0"
                          : stats.averageSessionTime.toString(),
                      trailing: "Average session time in minutes",
                    )
                  ],
                );
              } else
                return CircularProgressIndicator();
            }),
      ),
    );
  }
}

class OverViewCard extends StatelessWidget {
  final String content;
  final String trailing;

  OverViewCard({@required this.content, @required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Consts.backgroundColorDark,
      elevation: 35,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        margin: EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              content,
              style: TextStyle(
                  color: Consts.greenColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            Text(trailing,
                style: TextStyle(
                    color: Consts.greenColor, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
