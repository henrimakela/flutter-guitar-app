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
    return Scaffold(
        backgroundColor: Color(0xFF2D333F),
        appBar: AppBar(
          title: Text("Exercise Designer"),
        ),
        body: saved ? _showExerciseSaved() : _showCreateExercise());
  }

  _showExerciseSaved() {
    return Container(
      child: Center(
        child: Text("New exercise saved!",
            style: TextStyle(color: Colors.greenAccent, fontSize: 20)),
      ),
    );
  }
  _inputDecoration(String label){
    return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.greenAccent),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          BorderSide(color: Colors.white24, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: Colors.greenAccent, width: 1.0)));
  }


  _showCreateExercise() {
    return Container(
        margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Create your new training",
                  style: TextStyle(fontSize: 20),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter name";
                    }
                    return null;
                  },
                  decoration: _inputDecoration("Name of the exercise"),
                  onSaved: (String value) {
                    challenge.name = value;
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter description";
                    }
                    return null;
                  },
                  decoration: _inputDecoration("Description"),
                  onSaved: (String value) {
                    challenge.description = value;
                  },
                ),
                TextFormField(
                  validator: (value) {

                    try{
                      int.parse(value);
                    } on FormatException catch (e){
                      return "Use numbers";
                    }
                    if (value.isEmpty) {
                      return "Duration";
                    }
                    return null;
                  },
                  decoration: _inputDecoration("Minutes"),
                  onSaved: (String value) {
                    challenge.goalMinutes = int.parse(value);
                  },
                  keyboardType: TextInputType.number,
                ),
                OutlineButton(
                    onPressed: () =>
                    {
                      if (_formKey.currentState.validate()) {submit()}
                    },
                    child:
                    Text("Save", style: TextStyle(color: Colors.greenAccent)),
                    borderSide: BorderSide(color: Colors.greenAccent),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)))
              ],
            )));
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
