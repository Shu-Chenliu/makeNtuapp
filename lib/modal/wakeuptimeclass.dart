import 'package:mongo_dart/mongo_dart.dart';
class wakeuptime{
  final ObjectId id;
  final String daysofweek;
  final String time;
  wakeuptime({
    required this.time,
    required this.daysofweek,
    required this.id,
  });
  // factory wakeuptime.fromJson(Map<String,dynamic> json) => wakeuptime(
  //   id: json['id'],
  //   time: json['time'],
  //   daysofweek: json['daysofweek'],
  // );
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'time':time,
      'daysofweek': daysofweek,
    };
  }
  wakeuptime.fromMap(Map<String, dynamic> map)
      : time = map['time'],
        id = map['_id'],
        daysofweek = map['daysofweek'];
}