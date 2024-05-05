// import 'package:flutter/material.dart';
// import 'package:expansion_tile_group/expansion_tile_group.dart';
// import 'package:flutter/widgets.dart';

// class Search extends StatefulWidget {
//   const Search({super.key});
//   @override
//   _SearchState createState() => _SearchState();
// }

// class _SearchState extends State<Search> with SingleTickerProviderStateMixin{
//   var number=0;
//   var color=const Color.fromARGB(255, 165, 190, 220);
//   var drop=false;
//   late final AnimationController _controller=AnimationController(
//     vsync: this,
//     duration: const Duration(seconds: 2),
//   );
//   late final Animation<Offset> _offsetAnimation=Tween<Offset>(
//     begin:const Offset(0,1),
//     end:const Offset(0,0),
//   ).animate(
//     CurvedAnimation(
//       parent: _controller, 
//       curve:const Interval(
//         0.0,
//         0.5,
//         curve: Curves.fastOutSlowIn,
//       ),
//     ),
//   );
//   final ExpansionTileController _expansionTileController = ExpansionTileController();
//   late final Animation<Offset> _animation=Tween<Offset>(
//     begin:Offset(0,0),
//     end:Offset(0,1),
//   ).animate(
//     CurvedAnimation(
//       parent: _controller, 
//       curve:const Interval(
//         0.0,
//         2,
//         curve: Curves.elasticIn,
//       ),
//     ),
//   );
//   final GlobalKey<ExpansionTileCustomState> itemKey = GlobalKey();
//   @override
//   void initState() {
//     super.initState();
//     _controller.forward();
//   }
//   void beep(){
//     setState(() {
//       color = Colors.amber;
//     });
//     //TODO: connect with bluetooth and send data to beep
//   }
//   void move(){
//     //TODO: connect with bluetooth and send data to move
//   }
//   @override
//   void dispose(){
//     _controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color:color,
//       alignment: Alignment.topCenter,
//       child: SlideTransition(
//         position: _offsetAnimation,
//         child: ListView(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: SearchButton(func:beep, title: "call my slippers",)
//             ),
//             MoveTo(itemKey: itemKey,onPressed: beep,),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MoveTo extends StatelessWidget {
//   const MoveTo({
//     super.key,
//     required this.itemKey,
//     required this.onPressed,
//   });

//   final GlobalKey<ExpansionTileCustomState> itemKey;
//   final Function onPressed;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//       child: ExpansionTileWithoutBorderItem(
//         tilePadding: const EdgeInsets.all(0),
//         title: SearchButton(
//           func:(){
//             itemKey.currentState?.toggle();
//           },
//           title:"move my\nslippers to..."
//         ),
//         expansionKey: itemKey,
//         isHasTrailing: false,
//         children: [
//           SizedBox(
//             width:double.infinity,
//             child: ElevatedButton(
//               onPressed: (){
                
//               },
//               child: Text(
//                 "My Bed",
//                 style:TextStyle(
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class SearchButton extends StatelessWidget {
//   const SearchButton({
//     super.key,
//     required this.func,
//     required this.title,
//   });
//   final VoidCallback func;
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       height: 200,
//         decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: RadialGradient( 
//           center: Alignment.center, 
//           radius: 1, 
//           colors: [
//             Color.fromRGBO(245, 255, 198, 0.922), 
//             Color.fromARGB(255, 255, 255, 255) 
//           ], 
//         ),        
//       ),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shape: const CircleBorder(),
//           padding: EdgeInsets.zero,
//           elevation: 0,
//           shadowColor: Colors.transparent,
//         ),
//         onPressed: func,
//         child: Padding( 
//           padding: const EdgeInsets.all(16.0), 
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 25, 
//               fontWeight: FontWeight.w500,
//               color: Color.fromARGB(255, 0, 35, 95),
//             ),
//             softWrap: true, 
//             overflow: TextOverflow.visible, 
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import '../utils/snackbar.dart';
import '../utils/extra.dart';
class Search extends StatefulWidget {
  final BluetoothDevice device;
  const Search({super.key,required this.device});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin{
  var number=0;
  var color=Color.fromARGB(255, 20, 60, 97);
  var drop=false;
  late final AnimationController _controller=AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );
  int? _rssi;
  int? _mtuSize;
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  List<BluetoothService> _services = [];

  bool _isDiscoveringServices = false;
  bool _isConnecting = false;
  bool _isDisconnecting = false;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;
  late StreamSubscription<int> _mtuSubscription;
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
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  final String TARGET_DEVICE_NAME = "ESP32 makeNTU";
  final GlobalKey<ExpansionTileCustomState> itemKey = GlobalKey();
  
  @override
  void initState()async {
    super.initState();

    _connectionStateSubscription = widget.device.connectionState.listen((state) async {
      _connectionState = state;
      if (state == BluetoothConnectionState.connected) {
        _services = []; // must rediscover services
      }
      if (state == BluetoothConnectionState.connected && _rssi == null) {
        _rssi = await widget.device.readRssi();
      }
      if (mounted) {
        setState(() {});
      }
    });
    
  }
  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }
  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }
  // Future onWritePressed() async {
  //   if (mounted) {
  //     setState(() {
  //       _isDiscoveringServices = true;
  //     });
  //   }
  //   try {
  //     _services = await widget.device.discoverServices();
  //     Snackbar.show(ABC.c, "Discover Services: Success", success: true);
  //   } catch (e) {
  //     Snackbar.show(ABC.c, prettyException("Discover Services Error:", e), success: false);
  //   }
  //   if (mounted) {
  //     setState(() {
  //       _isDiscoveringServices = false;
  //     });
  //   }
  //   for(BluetoothService service in _services){
  //     List<BluetoothCharacteristic> characteristics=service.characteristics;
  //     for(BluetoothCharacteristic characteristic in characteristics){
  //       if(characteristic.properties.write){
  //         BluetoothCharacteristic c=characteristic;
  //         try {
  //           await c.write(utf8.encode("sing"), withoutResponse: c.properties.writeWithoutResponse);
  //           if (c.properties.read) {
  //             await c.read();
  //           }
  //         } catch (e) {
            
  //         }
  //       }
  //     }
  //   }
  // }
  Future beep()async{
    // if (mounted) {
    //   setState(() {
    //     _isDiscoveringServices = true;
    //   });
    // }
    // try {
    //   _services = await widget.device.discoverServices();
    //   Snackbar.show(ABC.c, "Discover Services: Success", success: true);
    // } catch (e) {
    //   Snackbar.show(ABC.c, prettyException("Discover Services Error:", e), success: false);
    // }
    // if (mounted) {
    //   setState(() {
    //     _isDiscoveringServices = false;
    //   });
    // }
    // for(BluetoothService service in _services){
    //   List<BluetoothCharacteristic> characteristics=service.characteristics;
    //   for(BluetoothCharacteristic characteristic in characteristics){
    //     if(characteristic.properties.write){
    //       BluetoothCharacteristic c=characteristic;
    //       try {
    //         await c.write(utf8.encode("sing"), withoutResponse: c.properties.writeWithoutResponse);
    //         if (c.properties.read) {
    //           await c.read();
    //         }
    //       } catch (e) {
            
    //       }
    //     }
    //   }
    // }
  }
  void move()async{

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color:color,
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: _offsetAnimation,
        child: ListView(
          // padding: EdgeInsets.symmetric(vertical: 20), // 统一设置ListView的垂直填充
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 80, vertical: 40), // 设置水平和垂直边距
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 设置圆角
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
      margin: const EdgeInsets.fromLTRB(80, 40, 80, 40),
      child: ExpansionTileWithoutBorderItem(
        tilePadding: const EdgeInsets.all(0),
        title: SearchButton(
          func:(){
            itemKey.currentState?.toggle();
          },
          title:"move my slippers to..."
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
                  fontSize: 22
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SearchButton extends StatefulWidget {
  const SearchButton({
    Key? key,
    required this.func,
    required this.title,
    this.isCircular = true, // Add a flag to indicate if the button is circular
  }) : super(key: key);
  final VoidCallback func;
  final String title;
  final bool isCircular; // Add this to determine the shape of the button

  @override
  _SearchButtonState createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isExpanded = false; // Add the expanded flag

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        widget.func();
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
              widget.title,
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