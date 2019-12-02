import 'dart:async';

import 'package:monthly_music_challenge/database/DBHelper.dart';
import 'package:monthly_music_challenge/models/challenge.dart';
import 'package:monthly_music_challenge/models/session.dart';
import 'package:monthly_music_challenge/models/stats.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class ExerciseBloc extends Bloc {
  final DBHelper _dbHelper = new DBHelper();
  final _exercisesController = BehaviorSubject<List<Challenge>>();
  final _sessionController = BehaviorSubject<List<Session>>();
  final _statsController = BehaviorSubject<Stats>();
  final _sortController = BehaviorSubject<bool>();
  final _singleExerciseController = BehaviorSubject<Challenge>();

  Stream<List<Challenge>> get exercisesStream => _exercisesController.stream;

  Stream<List<Session>> get sessionStream => _sessionController.stream;

  Stream<bool> get sortByProgress => _sortController.stream;

  Stream<Stats> get statsStream => _statsController.stream;

  Stream<Challenge> get singleExerciseStream =>
      _singleExerciseController.stream;

  ExerciseBloc() {
    _sortController.sink.add(false);
    sortByProgress.listen((sortByProgress) {
      _fetchAllExercises(sortByProgress);
    });
    _fetchAllSessions();
  }

  _fetchAllSessions() {
    _dbHelper.getAllSessions().then((value) {
      _sessionController.sink.add(value);
    });
  }

  _fetchAllExercises(bool byProgress) {
    _dbHelper.getAllChallenges(sortByProgress: byProgress).then((value) {
      _exercisesController.sink.add(value);
    });
  }

  void getExerciseById(int id) {
    _dbHelper.getChallengeById(id).then((value) {
      _singleExerciseController.sink.add(value);
    });
  }

  void getOverViewStats() async {
    int totalTrainingTime = await _dbHelper.getTotalTime();
    int sessionCount = await _dbHelper.getSessionCount();
    double average = await _dbHelper.getSessionDurationAVG();

    _statsController.sink.add(Stats(totalTrainingTime, sessionCount, average));
  }

  void saveExercise(Challenge exercise) {
    _dbHelper.saveChallenge(exercise);
    sortByProgress.listen((sortMethod) {
      _fetchAllExercises(sortMethod);
    }); //refresh stream
  }

  setSortingMethod(bool sortByProg) {
    _sortController.sink.add(sortByProg);
  }

  void saveSession(Session session) {
    _dbHelper.saveSession(session);
  }

  void saveProgress(int trainingMinutes, int id) {
    _dbHelper.saveProgress(trainingMinutes, id);
  }

  void deleteChallenge(int id) {
    _dbHelper.deleteChallengeById(id);
    sortByProgress.listen((sortMethod) {
      _fetchAllExercises(sortMethod);
    });
  }

  @override
  void dispose() {
    _exercisesController.close();
    _singleExerciseController.close();
    _sessionController.close();
    _statsController.close();
    _sortController.close();
  }
}
