import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:monthly_music_challenge/models/session.dart';
import 'package:path_provider/path_provider.dart';
import 'package:monthly_music_challenge/models/challenge.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "guitargrind.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Challenge(id INTEGER PRIMARY KEY, name TEXT, description TEXT,completedMinutes INTEGER, goalMinutes INTEGER)");

    await db.execute(
        "CREATE TABLE Session(id INTEGER PRIMARY KEY, duration INTEGER, date TEXT)");
  }

  Future<Challenge> getCurrentChallenge() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Challenge');
    List<Challenge> challenges = new List();
    for (int i = 0; i < list.length; i++) {
      challenges.add(new Challenge(
          list[i]["id"],
          list[i]["name"],
          list[i]["description"],
          list[i]["completedMinutes"],
          list[i]["goalMinutes"]));
    }
    return challenges[0];
  }

  Future<List<Challenge>> getAllChallenges() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Challenge');
    List<Challenge> challenges = new List();
    for (int i = 0; i < list.length; i++) {
      challenges.add(new Challenge(
          list[i]["id"],
          list[i]["name"],
          list[i]["description"],
          list[i]["completedMinutes"],
          list[i]["goalMinutes"]));
    }
    return challenges;
  }

  void saveProgress(int trainingMinutes, int id) async {
    var dbClient = await db;
    getChallengeById(id).then((value) {
      int lastTime = value.completedMinutes;
      int newTime = lastTime + trainingMinutes;

      dbClient.rawUpdate(
          "UPDATE Challenge SET completedMinutes = '$newTime' WHERE id  = '$id'");
    });
  }

  void saveSession(Session session) async {
    var dbClient = await db;
    var ret = await dbClient.rawInsert(
        "INSERT INTO Session(duration,date) VALUES (${session.duration},'${session.date}')");

    print(ret);
  }

  //fix this as done above
  void saveChallenge(Challenge challenge) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          "INSERT INTO Challenge(name, description, completedMinutes, goalMinutes) VALUES('${challenge.name}', '${challenge.description}', ${challenge.completedMinutes}, ${challenge.goalMinutes})");
    });
  }

  Future<int> getTotalTime() async {
    var dbClient = await db;
    int totalMinutes = 0;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Challenge');
    for (int i = 0; i < list.length; i++) {
      totalMinutes += list[i]["completedMinutes"];
    }
    return totalMinutes;
  }

  Future<List<Session>> getAllSessions() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Session');
    List<Session> sessions = new List();

    for (int i = 0; i < list.length; i++) {
      sessions.add(new Session(list[i]['duration'], list[i]['date']));
    }

    return sessions;
  }

  Future<Challenge> getChallengeById(int id) async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery("SELECT * FROM Challenge WHERE id  = '$id'");
    return new Challenge(list[0]["id"], list[0]["name"], list[0]["description"],
        list[0]["completedMinutes"], list[0]["goalMinutes"]);
  }

  void deleteChallengeById(int id) async {
    var dbClient = await db;
    dbClient.delete("Challenge", where: "id = ?", whereArgs: [id]);
  }
}
