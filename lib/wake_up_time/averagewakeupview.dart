import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:makentuapp/database/databaseService.dart';
import 'package:makentuapp/database/mongodb.dart';
import 'package:makentuapp/modal/wakeuptimeclass.dart';
class AverageWakeUpView extends StatefulWidget {
  const AverageWakeUpView({super.key});
  @override
  _AverageWakeUpViewState createState() => _AverageWakeUpViewState();
}
class _AverageWakeUpViewState extends State<AverageWakeUpView>{
  TextStyle weekstyle=TextStyle(
    fontSize: 50,

  );
  TextStyle timestyle=TextStyle(
    fontSize: 70,
    fontFamily: 'SFDigitalReadout',
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
  @override
  void initState() {
    super.initState();
  }
  @override
  
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: FutureBuilder(
        future: MongoDb.getTimes(),
        builder:(context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if(snapshot.hasData){
            if (snapshot.data !=null) {
              return Center(
                child: Container(
                  alignment: Alignment.topCenter,
                  color: Colors.grey.shade300,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child:ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => wakeUp(weekstyle: weekstyle, timestyle: timestyle, time: wakeuptime.fromMap(snapshot.data![index])),
                    // children: [
                    //   wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Mon',time: "07:00",),
                    //   wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Tue',time: "07:00",),
                    //   wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Wed',time: "07:00",),
                    //   wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Thu',time: "07:00",),
                    //   wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Fri',time: "07:00",),
                    //   wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Sat',time: "07:00",),
                    //   wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Sun',time: "07:00",),
                    // ],
                  ),
                )
              );
            }
            return const Center(
              child: Text('No data yet'),
            );
          }
          return const SizedBox.shrink();
        },   
      ),
      // body:Center(
      //   child: Container(
      //     alignment: Alignment.topCenter,
      //     color: Colors.grey.shade300,
      //     width: double.infinity,
      //     padding: EdgeInsets.all(20),
      //     child:ListView(
      //       children: [
      //         wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Mon',time: "07:00",),
      //         wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Tue',time: "07:00",),
      //         wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Wed',time: "07:00",),
      //         wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Thu',time: "07:00",),
      //         wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Fri',time: "07:00",),
      //         wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Sat',time: "07:00",),
      //         wakeUp(weekstyle: weekstyle, timestyle: timestyle,dayofweek: 'Sun',time: "07:00",),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

class wakeUp extends StatelessWidget {
  const wakeUp({
    super.key,
    required this.weekstyle,
    required this.timestyle,
    required this.time,
  });

  final TextStyle weekstyle;
  final TextStyle timestyle;
  final wakeuptime time;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Expanded(
            child: Container(
              alignment: Alignment(0.0,0),
              child: Text(
                time.daysofweek,
                style:weekstyle,
              ),
            ),
          ),
          SizedBox(width:20),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(5,10,0,0),
              alignment: Alignment.center,
              child:Text(
                time.time,
                style:timestyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}