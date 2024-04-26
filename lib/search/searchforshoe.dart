import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin{
  var number=0;
  var color=Color.fromARGB(255, 165, 190, 220);
  var drop=false;
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
      curve:const Interval(
        0.0,
        0.5,
        curve: Curves.fastOutSlowIn,
      ),
    ),
  );
  final ExpansionTileController _expansionTileController = ExpansionTileController();
  late final Animation<Offset> _animation=Tween<Offset>(
    begin:Offset(0,0),
    end:Offset(0,1),
  ).animate(
    CurvedAnimation(
      parent: _controller, 
      curve:const Interval(
        0.0,
        2,
        curve: Curves.elasticIn,
      ),
    ),
  );
  final GlobalKey<ExpansionTileCustomState> itemKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _controller.forward();
  }
  void beep(){
    setState(() {
      color = Colors.amber;
    });
  }
  void move(){

  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color:color,
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: _offsetAnimation,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SearchButton(func:beep, title: "call my slippers",)
            ),
            MoveTo(itemKey: itemKey,onPressed: beep,),
          ],
        ),
      ),
    );
  }
}

class MoveTo extends StatelessWidget {
  const MoveTo({
    super.key,
    required this.itemKey,
    required this.onPressed,
  });

  final GlobalKey<ExpansionTileCustomState> itemKey;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: ExpansionTileWithoutBorderItem(
        tilePadding: const EdgeInsets.all(0),
        title: SearchButton(
          func:(){
            itemKey.currentState?.toggle();
          },
          title:"move my\nslippers to..."
        ),
        expansionKey: itemKey,
        isHasTrailing: false,
        children: [
          Container(
            width:double.infinity,
            child: ElevatedButton(
              onPressed: (){
                onPressed();
              },
              child: Text(
                "My Bed",
                style:TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
    required this.func,
    required this.title,
  });
  final VoidCallback func;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
        decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient( 
          center: Alignment.center, 
          radius: 1, 
          colors: [
            Color.fromRGBO(245, 255, 198, 0.922), 
            Color.fromARGB(255, 255, 255, 255) 
          ], 
        ),        
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: CircleBorder(),
          padding: EdgeInsets.zero,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        onPressed: func,
        child: Padding( 
          padding: const EdgeInsets.all(16.0), 
          child: Text(
            title,
            style: TextStyle(
              fontSize: 25, 
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 0, 35, 95),
            ),
            softWrap: true, 
            overflow: TextOverflow.visible, 
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}