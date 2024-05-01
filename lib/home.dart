import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:makentuapp/wake_up_time/mainpage.dart';
import 'package:makentuapp/search/searchforshoe.dart';
import 'package:makentuapp/connect_bt_drawer.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  Widget page=Container(
    color:Colors.lightGreen.shade100,
    alignment: Alignment.center,
  );
  var barIndex=0;
  @override
  void initState(){
    page=MyHomePage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    );


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Slippers',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
          ),
        ),
        backgroundColor: Color.fromARGB(255, 30, 0, 81), 
        elevation: 4, 
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: const Drawer(
        child: ConnectBT(),
      ),
      body: Center(
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.nights_stay),
            label: 'Sleeping Time',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find Slippers',
          ),
        ],
        currentIndex: barIndex,
        onTap: (value) {
          setState(() {
            barIndex = value;
            if(barIndex==0){
              page=MyHomePage();
            }
            else{
              page=Search();
            }
          });
        },
      ),
    );
  }
}