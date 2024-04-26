import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:makentuapp/database/databaseService.dart';
import 'dart:math';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class ClockView extends StatefulWidget {
  const ClockView({super.key,required this.datetime});
  final datetime;
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
Widget time = Text(
  "AM",
  style: TextStyle(
    fontSize: 16
  ),
);
  TextStyle style=TextStyle(
    fontSize: 130,
    fontFamily: 'SFDigitalReadout',
    fontWeight: FontWeight.bold,
    letterSpacing: 0.4,
  );
  late String hour;
  late String minutes;
  @override
  void initState() {
    hour = widget.datetime.substring(0,2);
    minutes=widget.datetime.substring(3);
    if(int.parse(hour)>=12){
      time=Text("PM");
    }
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color.fromARGB(255, 26, 4, 98)),
          left: BorderSide(color: Color.fromARGB(255, 26, 4, 98)),
          bottom: BorderSide(color: Color.fromARGB(255, 26, 4, 98)),
          right:BorderSide(color: Color.fromARGB(255, 26, 4, 98)),
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      height: 150,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: FittedBox(
        fit:BoxFit.contain,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            time,
            SizedBox(width:10),
            Text(
              hour,
              style: style,
            ),
            Text(
              ":",
              style:style,
            ),
            Text(
              minutes,
              style:style,
            ),
          ],
        ),
      )
    );
  }
}