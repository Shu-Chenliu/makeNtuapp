// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:makentuapp/modal/wakeuptimeclass.dart';

// const String dbName="makeNTU.db";
// const String tableName="makeNTU";
// class DatabaseService{
//   DatabaseService._init();
//   static final DatabaseService instance =DatabaseService._init();
//   Database? _database;
//   Future<Database> get database async{
//     if(_database!=null){
//       return _database!;
//     }
//     _database=await _initialize();
//     return _database!;
//   }
//   Future<Database> _initialize() async{
//     final dbPath=await getDatabasesPath();
//     final path =await join(dbPath,dbName);
//     var database=await openDatabase(
//       path,
//       onCreate: create,
//       version: 1,
//     );
//     return database;
//   }
//   Future create(Database db,int version)async{
//     await db.execute('''CREATE TABLE $tableName (
//       id INTEGER PRIMARY KEY, 
//       time TEXT NOT NULL, 
//       daysofweek TEXT NOT NULL)'''
//     );
//   }
//   Future<void> createTime(wakeuptime time)async{
//     final db=await instance.database;
//     final id=await db.insert(tableName, time.toJson());
//   }
//   Future<List<wakeuptime>?> getAllTimes()async{
//     final db=await instance.database;
//     final result=await db.query(tableName);
//     return result.map((json) => wakeuptime.fromJson(json)).toList();
//   }
//   Future<void> close()async{
//     final db=await instance.database;
//     db.close();
//   }
//   // static const int _version = 1;
//   // static const String _dbName = "makeNTU.db";
//   // static Future<Database> _getDB() async {
//   //   return openDatabase(join(await getDatabasesPath(), _dbName),
//   //       onCreate: (db, version) async => await db.execute(
//   //           "CREATE TABLE wakeup(id INTEGER PRIMARY KEY, time TEXT NOT NULL, daysofweek TEXT NOT NULL);"),
//   //       version: _version);
//   // }

//   // static Future<int> addtime(wakeuptime time) async {
//   //   final db = await _getDB();
//   //   return await db.insert("wakeup", time.toJson(),
//   //       conflictAlgorithm: ConflictAlgorithm.replace);
//   // }

//   // static Future<int> deletetime(wakeuptime time) async {
//   //   final db = await _getDB();
//   //   return await db.delete(
//   //     "wakeup",
//   //     where: 'id = ?',
//   //     whereArgs: [time.id],
//   //   );
//   // }

//   // static Future<List<wakeuptime>?> getAllTimes() async {
//   //   final db = await _getDB();

//   //   final List<Map<String, dynamic>> maps = await db.query("wakeup");

//   //   if (maps.isEmpty) {
//   //     return null;
//   //   }

//   //   return List.generate(maps.length, (index) => wakeuptime.fromJson(maps[index]));
//   // }
// }