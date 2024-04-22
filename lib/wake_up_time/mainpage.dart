
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:makentuapp/wake_up_time/averagewakeupview.dart';
import 'package:makentuapp/wake_up_time/wakeupclock.dart';
import 'package:makentuapp/wake_up_time/averagewakeupview.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  late final AnimationController _controller=AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );
  late final Animation<Offset> _offsetAnimation=Tween<Offset>(
    begin:Offset(0,1),
    end:Offset(0,0),
  ).animate(
    CurvedAnimation(
      parent: _controller, 
      curve: const Interval(
        0.0,
        0.3,
        curve: Curves.fastOutSlowIn,
      ),
      // curve: Curves.bounceIn,
    ),
  );
  @override
  void initState() {
    super.initState();
    _controller.forward();
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.grey.shade300,
      alignment: Alignment.topCenter,
      child:SlideTransition(
        position: _offsetAnimation,
        child: ListView(
          children: [
            BigCard(title: "Today's Wake up Time",page:ClockView(datetime: "07:00",)),
            ViewCard(title: "Average wake up time this week", page:ClockView(datetime: "07:40",)),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget{
  const BigCard({
    super.key,
    required this.title,
    required this.page
  });
  final title;
  final Widget page;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:Colors.white,
      ),
      height:300,
      width:double.infinity,
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding:EdgeInsets.fromLTRB(10,20,10,10),
      child:Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 25),
          ),
          page,
        ],
      )
    );
  }
}
class ViewCard extends StatelessWidget{
  const ViewCard({
    super.key,
    required this.title,
    required this.page
  });
  final title;
  final Widget page;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:Colors.white,
      ),
      height:380,
      width:double.infinity,
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding:EdgeInsets.all(20),
      child: Stack(
        children: [
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              page,
            ],
          ),
          Positioned(
            bottom:5,
            right:5,
            child: FilledButton(
              child: Text("View more..."),
              onPressed: (){
                Navigator.of(context).push(_createRoute());
              },
            ),
          )
        ],
      )
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const AverageWakeUpView(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.fastOutSlowIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds:800),
    reverseTransitionDuration: Duration(milliseconds: 500),
  );
}