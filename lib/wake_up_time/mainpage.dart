
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
      color:Color.fromARGB(255, 196, 215, 245),
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
        borderRadius: BorderRadius.circular(25), // 更圓滑的邊角
        gradient: RadialGradient( // 由内向外的渐变
          center: Alignment.center,
          radius: 1, // 半径为1表示从中心向外辐射
          colors: [Color.fromRGBO(255, 240, 125, 0.922), Color.fromARGB(255, 255, 255, 255)], // 渐变颜色
        ),
        boxShadow: [ // 添加陰影效果
          BoxShadow(
            color: Color.fromARGB(255, 1, 38, 38).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      height: 250,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(30, 30, 30, 30),
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
      child: Column(
        children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 14, 0, 95), 
          fontFamily: 'Roboto',
          letterSpacing: 2.0, 
          height: 1.2, 
          decoration: TextDecoration.none,
        ),
      ),

          Expanded(child: page),
        ],
      ),
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
        borderRadius: BorderRadius.circular(25),
        gradient: const RadialGradient(
          center: Alignment.center,
          radius: 1, 
          colors: [Color.fromRGBO(162, 220, 249, 0.922), Color.fromARGB(255, 255, 255, 255)], 
        ),
        boxShadow: [ 
          BoxShadow(
            color: Color.fromARGB(255, 11, 53, 57).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      height:350,
      width:double.infinity,
      margin: EdgeInsets.fromLTRB(30, 20, 30, 30),
      padding: EdgeInsets.fromLTRB(30, 30, 30,30),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [
              Text(
              title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold, 
                color: Color.fromARGB(255, 15, 3, 85), 
              ),
              textAlign: TextAlign.center,
              ),
              page,
            ],
          ),
          Positioned(
            bottom: 1,
            right: 3,
            child: ElevatedButton(
              child: Text(
                "View more...",
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 66, 71, 165), 
                foregroundColor: Color.fromARGB(255, 254, 254, 255), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // 按钮圆角
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 内边距调整
                elevation: 5, // 阴影效果
              ),
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