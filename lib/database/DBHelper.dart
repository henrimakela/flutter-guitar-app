import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:monthly_music_challenge/models/challenge.dart';

class DBHelper{

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
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
    "CREATE TABLE Challenge(id INTEGER PRIMARY KEY, name TEXT, description TEXT,completedHours TEXT, goalHours TEXT)");
    print("Created tables");
  }

  Future<Challenge> getCurrentChallenge() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Challenge');
    List<Challenge> challenges = new List();
    for (int i = 0; i < list.length; i++) {
      challenges.add(new Challenge(list[i]["id"], list[i]["name"], list[i]["description"], list[i]["completedHours"], list[i]["goalHours"]));
    }
    return challenges[0];
  }

  Future<List<Challenge>> getAllChallenges() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Challenge');
    List<Challenge> challenges = new List();
    for (int i = 0; i < list.length; i++) {
      challenges.add(new Challenge(list[i]["id"], list[i]["name"], list[i]["description"], list[i]["completedHours"], list[i]["goalHours"]));
    }
    return challenges;
  }

  void saveProgress(double trainingHours, int id ) async {
    var dbClient = await db;
    getCurrentChallenge().then((value){
      double lastTime = double.parse(value.completedHours);
      String newTime = (lastTime + trainingHours).toString();
      
      dbClient.rawUpdate("UPDATE Challenge SET completedHours = '$newTime' WHERE id  = '$id'");
    });
    
  }

  
  void saveChallenge(Challenge challenge) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Challenge(name, description, completedHours, goalHours) VALUES(' +
              '\'' +
              challenge.name +
              '\'' +
              ',' +
              '\'' +
              challenge.description +
              '\'' +
              ',' +
              '\'' +
              challenge.completedHours +
              '\'' +
              ',' +
              '\'' +
              challenge.goalHours +
              '\'' +
              ')');
    });
  }

  void updateCurrentChallengeToNew(Challenge challenge) async {
      var dbClient = await db;
      String name = challenge.name;
      String description = challenge.description;
      String goal = challenge.goalHours;

      dbClient.rawUpdate("UPDATE Challenge SET name = '$name', description = '$description', completedHours = '0', goalHours = '$goal' WHERE id = 1");
  }

  Future<Challenge> getChallengeById(int id) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM Challenge WHERE id  = '$id'");
      return new Challenge(list[0]["id"], list[0]["name"], list[0]["description"], list[0]["completedHours"], list[0]["goalHours"]);
  }
  
  void deleteChallengeById(int id) async {
    var dbClient = await db;
    dbClient.delete("Challenge", where: "id = ?", whereArgs: [id]);
  }


}