import 'package:flutter/material.dart';
import 'package:monthly_music_challenge/bloc/exercise_bloc.dart';
import 'package:monthly_music_challenge/misc/exer_search_delegate.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import 'package:monthly_music_challenge/view/statistics_page.dart';
import 'package:provider/provider.dart';
import '../consts.dart';

class ChallengePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ChallengePageState();
  }
}

class _ChallengePageState extends State<ChallengePage> {
  bool itemRemoved = false;
  bool sortByProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createStreamBuilder(),
    );
  }

  _createStreamBuilder() {
    return Container(
      child: StreamBuilder(
        stream: Provider.of<ExerciseBloc>(context).exercisesStream,
        initialData: List(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          setState(() {
                            sortByProgress = !sortByProgress;
                          });
                          Provider.of<ExerciseBloc>(context)
                              .setSortingMethod(sortByProgress);
                        }),
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: ExerSearchDelegate(snapshot.data));
                        })
                  ],
                  centerTitle: true,
                  pinned: true,
                  expandedHeight: 240,
                  backgroundColor: Colors.black,
                  title: Text(snapshot.data.length == 0
                      ? "No ongoing exercises"
                      : "Current exercises"),
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
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 64),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                    return makeCard(index, snapshot.data[index], context);
                  }, childCount: snapshot.data.length)),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget makeCard(int index, Challenge challenge, BuildContext context) =>
      Dismissible(
        key: UniqueKey(),
        background: Container(
          padding: EdgeInsets.only(right: 10),
          alignment: AlignmentDirectional.centerEnd,
          color: Colors.redAccent,
          child: Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (DismissDirection direction) async {
          final bool res = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm"),
                  content:
                      const Text("Are you sure you wish to delete this item?"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Provider.of<ExerciseBloc>(context)
                              .deleteChallenge(challenge.id);
                          setState(() {
                            print("Item  removed");
                            itemRemoved = true;
                          });
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("DELETE")),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("CANCEL"),
                    )
                  ],
                );
              });

          return res;
        },
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StatisticsPage(challenge.id)),
            );
          },
          child: Card(
            elevation: 25.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.white,
            margin: new EdgeInsets.fromLTRB(20, 8, 40, 8),
            child: Container(
                width: MediaQuery.of(context).size.width,
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
        ),
      );
}


ListTile placeHolderListTile() {
  return ListTile(
    title: Text(
      "No ongoing exercises",
      style: TextStyle(color: Colors.black),
    ),
  );
}

ListTile makeListTile(Challenge challenge, BuildContext context) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(
        challenge.name,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                child: LinearProgressIndicator(
                    backgroundColor: Consts.greenTransparent,
                    value: calculateProgress(challenge),
                    valueColor: AlwaysStoppedAnimation(Consts.greenColor)),
              ))
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StatisticsPage(challenge.id)),
        );
      },
    );

double calculateProgress(Challenge challenge) {
  int minutesIn = challenge.completedMinutes;
  int goal = challenge.goalMinutes;
  double completedPercentage = minutesIn / goal;
  return completedPercentage;
}
