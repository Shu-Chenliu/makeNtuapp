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
    var m=<String,List<Map<String, dynamic>>>{
      "Sun":[],
      "Mon":[],
      "Tue":[],
      "Wed":[],
      "Thur":[],
      "Fri":[],
      "Sat":[],
    };
    for(var time in times){
      if(m[wakeuptime.fromMap(time).daysofweek]!.length==1){
        await collection.deleteOne({"_id":wakeuptime.fromMap(m[wakeuptime.fromMap(time).daysofweek]![0]).id});
      }
      m[wakeuptime.fromMap(time).daysofweek]!.add(time);
    }
    final finaltimes=await collection.find().toList();
    return finaltimes;
  }
  static Future<List<String>> getTime()async{
    final times = await collection.find().toList();
    var m=<String,List<Map<String, dynamic>>>{
      "Sun":[],
      "Mon":[],
      "Tue":[],
      "Wed":[],
      "Thur":[],
      "Fri":[],
      "Sat":[],
    };
    for(var time in times){
      if(m[wakeuptime.fromMap(time).daysofweek]!.length==1){
        await collection.deleteOne({"_id":wakeuptime.fromMap(m[wakeuptime.fromMap(time).daysofweek]![0]).id});
      }
      m[wakeuptime.fromMap(time).daysofweek]!.add(time);
    }
    final finaltimes=await collection.find().toList();
    final List<String> toreturn=[];
    if(finaltimes.length!=0){
      toreturn.add(wakeuptime.fromMap(finaltimes[finaltimes.length-1]).time);
    }
    else{
      toreturn.add("");
      toreturn.add("");
      return toreturn;
    }
    var totaltime=0;
    for(var time in finaltimes){
      print(time);
      totaltime+=int.parse(wakeuptime.fromMap(time).time.split(":")[0])*60+int.parse(wakeuptime.fromMap(time).time.split(":")[1]);
      print(totaltime);
    }
    totaltime=(totaltime/finaltimes.length).floor();
    var hour=(totaltime/60).floor();
    var min=totaltime%60;
    String h=hour.toString();
    String minutes=min.toString();
    if(h.length==1){
      h="0"+h;
    }
    if(minutes.length==1){
      minutes="0"+minutes;
    }
    toreturn.add(h+":"+minutes);
    print(toreturn);
    return toreturn;
  }
  static insert(wakeuptime time) async {
    await collection.insertAll([time.toMap()]);
  }
  static delete(String id)async{
    await collection.deleteOne({"_id":id});
  }
}