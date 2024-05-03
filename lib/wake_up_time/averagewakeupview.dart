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

class _AverageWakeUpViewState extends State<AverageWakeUpView> {
  TextStyle weekstyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.grey[800],
  );
  TextStyle timestyle = TextStyle(
    fontSize: 48,
    fontFamily: 'SFDigitalReadout',
    fontWeight: FontWeight.bold,
    color: Colors.blue[900],
    letterSpacing: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Smart Slippers',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 27, 1, 74),
        elevation: 4,
      ),
      body: FutureBuilder(
        future: MongoDb.getTimes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Center(
                child: Container(
                  alignment: Alignment.topCenter,
                  color: Color.fromARGB(255, 237, 219, 247),
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => WakeUp(
                      weekstyle: weekstyle,
                      timestyle: timestyle,
                      time: wakeuptime.fromMap(snapshot.data![index]),
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: Text('No data yet'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class WakeUp extends StatelessWidget {
  const WakeUp({
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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time.daysofweek,
              style: weekstyle,
            ),
            Text(
              time.time,
              style: timestyle,
            ),
          ],
        ),
      ),
    );
  }
}