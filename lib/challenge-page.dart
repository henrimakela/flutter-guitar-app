import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import 'package:monthly_music_challenge/database/DBHelper.dart';

class ChallengePage extends StatelessWidget {
  final List<String> challengeList = new List();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.greenAccent,
        body: StreamBuilder(
          stream: Firestore.instance.collection("exercises").snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) return Text("Loading...");
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
            );
          },
        )
    );
  }
}

Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot){
    return ListTile(
      title: Text(snapshot['name']),
      subtitle:Text(snapshot['description']),
      trailing: Text(snapshot['time'].toString() + " hours"),
      leading: Text(snapshot['category']),
      onTap: () {
        saveAsCurrentChallenge(snapshot);
      },
    );
}

void saveAsCurrentChallenge(DocumentSnapshot snapshot){
    DBHelper dbHelper = new DBHelper();
    Challenge challenge = new Challenge(1, snapshot['name'], snapshot['description'], snapshot['category'], "0", snapshot['time'].toString());
    dbHelper.updateCurrentChallengeToNew(challenge);
}

