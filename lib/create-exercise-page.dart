import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/challenge.dart';
import 'package:monthly_music_challenge/database/DBHelper.dart';
import 'dart:async';

class CreateExercisePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateExercisePageState();
  }
}

class CreateExercisePageState extends State<CreateExercisePage> {
  final _formKey = GlobalKey<FormState>();
  DBHelper dbHelper = new DBHelper();
  bool saved = false;

  Challenge challenge = new Challenge.createEmpty();

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (!saved) {
      child = new Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Design your new training",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter name";
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Name of the exercise",
                        labelStyle: TextStyle(color: Colors.greenAccent),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.white24, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 1.0))),
                    onSaved: (String value) {
                      challenge.name = value;
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter description";
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(color: Colors.greenAccent),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.white24, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 1.0))),
                    onSaved: (String value) {
                      challenge.description = value;
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Duration";
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Minutes",
                        labelStyle: TextStyle(color: Colors.greenAccent),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.white24, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 1.0))),
                    onSaved: (String value) {
                      challenge.goalMinutes = int.parse(value);
                    },
                    keyboardType: TextInputType.number,
                  ),
                  OutlineButton(
                      onPressed: () => {
                            if (_formKey.currentState.validate()) {submit()}
                          },
                      child:
                          Text("Save", style: TextStyle(color: Colors.greenAccent)),
                      borderSide: BorderSide(color: Colors.greenAccent),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)))
                ],
              )));
    } else {
      child = new Container(
        child: Center(
          child: Text("New exercise saved!",
              style: TextStyle(color: Colors.greenAccent, fontSize: 20)),
        ),
      );
    }
    return Scaffold(
        backgroundColor: Color(0xFF2D333F),
        appBar: AppBar(
          title: Text("Exercise Designer"),
        ),
        body: child);
  }

  void submit() {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      challenge.completedMinutes = 0;
      dbHelper.saveChallenge(challenge);
      setState(() {
        saved = true;
      });
    }
  }
}
