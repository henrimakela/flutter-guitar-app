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

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "guitargrind.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
    "CREATE TABLE Challenge(id INTEGER PRIMARY KEY, name TEXT, description TEXT, category TEXT,completedHours TEXT, goalHours TEXT)");
    print("Created tables");
    await db.execute(
      "INSERT INTO Challenge(name, description, category, completedHours, goalHours) VALUES('Picking Accuracy', 'Train different scales using alternate picking technique', 'technique', '0', '10')"
    );
    print("Created default challenge");
  }
  
  // Retrieving employees from Employee Tables
  Future<Challenge> getCurrentChallenge() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Challenge');
    List<Challenge> challenges = new List();
    for (int i = 0; i < list.length; i++) {
      challenges.add(new Challenge(list[i]["id"], list[i]["name"], list[i]["description"], list[i]["category"], list[i]["completedHours"], list[i]["goalHours"]));
    }
    return challenges[0];
  }

  void saveProgress(double trainingHours) async {
    var dbClient = await db;
    getCurrentChallenge().then((value){
      double lastTime = double.parse(value.completedHours);
      String newTime = (lastTime + trainingHours).toString();
      
      dbClient.rawUpdate("UPDATE Challenge SET completedHours = '$newTime' WHERE id = 1");
    });
    
  }

  
  void saveChallenge(Challenge challenge) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Challenge(name, description, category, completedHours, goalHours) VALUES(' +
              '\'' +
              challenge.name +
              '\'' +
              ',' +
              '\'' +
              challenge.description +
              '\'' +
              ',' +
              '\'' +
              challenge.category +
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
      String category = challenge.category;
      String goal = challenge.goalHours;

      dbClient.rawUpdate("UPDATE Challenge SET name = '$name', description = '$description', category = '$category', completedHours = '0', goalHours = '$goal' WHERE id = 1");
  }


}