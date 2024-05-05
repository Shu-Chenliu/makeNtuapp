import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import '../widgets/service_tile.dart';
import '../widgets/characteristic_tile.dart';
import '../widgets/descriptor_tile.dart';
import '../utils/snackbar.dart';
import '../utils/extra.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
class moveTo extends StatefulWidget {
  const moveTo({
    Key? key,
    required this.title,
    required this.service,
    required this.position,
    this.isCircular = true, // Add a flag to indicate if the button is circular
  }) : super(key: key);
  final BluetoothService service;
  final String title;
  final bool isCircular; // Add this to determine the shape of the button
  final String position;
  @override
  _moveToState createState() => _moveToState();
}

class _moveToState extends State<moveTo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isExpanded = false; // Add the expanded flag
  late List<BluetoothCharacteristic> characteristics;
  late BluetoothCharacteristic c;
  final GlobalKey<ExpansionTileCustomState> itemKey= GlobalKey();
  @override
  void initState() {
    super.initState();
    isExpanded = false; // Ensure the button starts unexpanded
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.addListener(() {
      setState(() {}); // Trigger a rebuild whenever the animation changes value
    });
    characteristics=widget.service.characteristics;
    c=characteristics.firstWhere((c) => c.properties.write);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Future write()async{  
    if(!isExpanded){
      return;
    }
    try {
      await c.write(utf8.encode("move"), withoutResponse: c.properties.writeWithoutResponse);
      Snackbar.show(ABC.c, "Write: Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }
  void toggleExpand() {
    // Add a method to toggle the expansion state
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        // Start the button shrinking animation
        _controller.forward();
      } else {
        // Start the button expanding animation
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to ensure proper size even on state changes
    // final double size = MediaQuery.of(context).size.width - 40; // Calculate correct size
    final double borderRadius = isExpanded ? 10 : 100; // Calculate correct border radius

    return GestureDetector(
      onTap: () {
        toggleExpand(); // Toggle expand when tapped
        write();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: isExpanded ? 10 : 50,
          height: isExpanded ? 75 : 200,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(borderRadius),
              color: isExpanded ? 
                Color.fromRGBO(171, 239, 181, 1)
              : 
                Color.fromRGBO(170, 217, 246, 1),
                   
          ),
          child: Center(
            child: Text(
              widget.title+" to Bed",
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
      ),
    );
  }
}