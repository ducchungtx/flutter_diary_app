import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), "DiaryDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE User ("
          "id INTEGER PRIMARY KEY autoincrement,"
          "name TEXT not null,"
          "blocked BIT,"
          "isAdmin BIT,"
          ")");
      await db.insert('User', {'name': 'Chung', 'blocked': 1, 'isAdmin': 1},
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.execute("CREATE TABLE Mood ("
          "id INTEGER PRIMARY KEY autoincrement,"
          "label TEXT no null,"
          "color TEXT"
          ")");
      await db.insert('Mood', {"label": "Happy", "color": ""});
      await db.execute("CREATE TABLE Activity ("
          "id INTEGER PRIMARY KEY autoincrement,"
          "date DATETIME,"
          "title TEXT no null,"
          "note TEXT no null,"
          "foreign key(moodId) references Mood(id),"
          "foreign key(userId) references User(id)"
          ")");
    });
  }
}
