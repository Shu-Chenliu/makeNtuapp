import 'package:makentuapp/database/constantsformongodb.dart';
import 'package:makentuapp/modal/wakeuptimeclass.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDb{
  static var db, collection;
  static connect() async{
    db=await Db.create(MONGO_URL);
    await db.open();
    collection=db.collection(collectionName);
  }
  static Future<List<Map<String, dynamic>>> getTimes() async {
    final times = await collection.find().toList();
    return times;
  }
  static insert(wakeuptime time) async {
    await collection.insertAll([time.toMap()]);
  }
}