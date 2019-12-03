import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:monthly_music_challenge/bloc/bloc_provider.dart';
import 'package:monthly_music_challenge/bloc/exercise_bloc.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import 'package:provider/provider.dart';

import '../consts.dart';

class CreateExercisePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateExercisePageState();
  }
}

class CreateExercisePageState extends State<CreateExercisePage> {
  final _formKey = GlobalKey<FormState>();
  bool saved = false;
  Challenge challenge = new Challenge.createEmpty();
  int lap = 0;
  int exeDuration = 0;
  Color baseColor = Color(0xFF8EECB3).withAlpha(10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
        backgroundColor: Consts.backgroundColorDark,
        appBar: AppBar(
          backgroundColor: Consts.backgroundColorDark,
          title: Text("Exercise Designer"),
        ),
        body: saved ? _showExerciseSaved() : _showExeGenerator());
  }

  _showExeGenerator() {
    return SafeArea(
      child: Builder(
          builder: (BuildContext context) {
            return Container(
                margin: EdgeInsets.fromLTRB(20, 20,20,0),
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        Center(
                          child: Text(
                            "How long would you like to play guitar?",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: SingleCircularSlider(
                            60,
                            1,
                            height: 240,
                            width: 240,
                            baseColor: baseColor,
                            primarySectors: 6,
                            secondarySectors: 60,
                            selectionColor: Consts.greenColor,
                            onSelectionChange: _updateDuration,
                            handlerColor: Colors.white,
                            handlerOutterRadius: 12.0,
                            sliderStrokeWidth: 12.0,
                            shouldCountLaps: true,
                            child: Padding(
                              padding: const EdgeInsets.all(42.0),
                              child: Center(
                                  child: Text(_formatTime(challenge.goalMinutes),
                                      style: TextStyle(
                                          fontSize: 36.0, color: Colors.white))),
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),
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
                        SizedBox(
                          height: 10,
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
                        SizedBox(height: 60,),
                        MaterialButton(
                            height: 50,
                            minWidth: 250,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              submit(context);
                            },
                            color: Colors.white,
                            child: Text("Save",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)))
                      ],
                    )));
          }
      ),
    );
  }

  String _formatTime(int time) {
    var hours = time / 60;
    int hoursInt = hours.toInt();
    var minutes = time % 60;
    if (hoursInt > 0) {
      return '${hoursInt}h${minutes}m';
    }
    return '${minutes}m';
  }

  _updateDuration(int init, int end, int laps) {
    setState(() {
      challenge.goalMinutes = end + (laps * 60);
      if (laps > 0) {
        baseColor = Color(0xFF8EECB3).withAlpha(laps * 70);
      } else
        baseColor = Color(0xFF8EECB3).withAlpha(10);
    });
  }

  _showExerciseSaved() {
    return Container(
      child: Center(
        child: Text("New exercise saved!",
            style: TextStyle(color: Colors.greenAccent, fontSize: 20)),
      ),
    );
  }

  _inputDecoration(String label) {
    return InputDecoration(
      hasFloatingPlaceholder: false,
      labelText: label,
      contentPadding: EdgeInsets.all(20),
      labelStyle: TextStyle(color: Colors.grey),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  void submit(BuildContext context) async {
    if (this._formKey.currentState.validate() && challenge.goalMinutes > 0) {
      this._formKey.currentState.save();
      challenge.completedMinutes = 0;
      Provider.of<ExerciseBloc>(context).saveExercise(challenge);
      setState(() {
        saved = true;
      });
      _finish();
    }
    else if(challenge.goalMinutes == 0){
      final snackBar = SnackBar(content: Text('The duration cannot be 0'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  _finish() async {
    return new Timer(Duration(seconds: 1), _exit);
  }

  _exit() async {
    Navigator.of(context).pop();
  }
}
