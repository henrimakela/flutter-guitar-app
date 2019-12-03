import 'package:flutter/material.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import 'package:monthly_music_challenge/view/statistics_page.dart';

import '../consts.dart';

class ExerSearchDelegate extends SearchDelegate {
  List<Challenge> challenges;

  ExerSearchDelegate(this.challenges);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        challenges.where((a) => a.name.toLowerCase().contains(query.toLowerCase())).toList();

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
          ],
          centerTitle: true,
          pinned: true,
          expandedHeight: 240,
          backgroundColor: Colors.black,
          title: Text("Search results"),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Consts.backgroundColorDark.withOpacity(0.6),
                        BlendMode.dstATop),
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1457052002176-2d16a4f4a3ff?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          return _makeCard(context, results[index]);
        }, childCount: results.length))
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results =
        challenges.where((a) => a.name.toLowerCase().contains(query.toLowerCase()
        )).toList();
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          pinned: true,
          expandedHeight: 240,
          backgroundColor: Colors.black,
          title: Text("Search results"),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Consts.backgroundColorDark.withOpacity(0.6),
                        BlendMode.dstATop),
                    image: AssetImage(
                        "assets/images/guitar-bg.jpeg"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverList(
            delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
              return _makeCard(context, results[index]);
            }, childCount: results.length))
      ],
    );
  }

  _makeCard(BuildContext context, Challenge challenge) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StatisticsPage(challenge.id)),
        );
      },
      child: Card(
        elevation: 25.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        margin: new EdgeInsets.fromLTRB(20, 8, 40, 8),
        child: Container(
            margin: EdgeInsets.all(20),
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  challenge.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: LinearProgressIndicator(
                          backgroundColor: Consts.greenTransparent,
                          value: calculateProgress(challenge),
                          valueColor:
                              AlwaysStoppedAnimation(Consts.greenColor)),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  double calculateProgress(Challenge challenge) {
    int minutesIn = challenge.completedMinutes;
    int goal = challenge.goalMinutes;
    double completedPercentage = minutesIn / goal;
    return completedPercentage;
  }
}
