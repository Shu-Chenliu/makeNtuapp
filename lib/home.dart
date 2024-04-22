import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:makentuapp/wake_up_time/mainpage.dart';
import 'package:makentuapp/search/searchforshoe.dart';
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
        title: const Text('Health'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Center(
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bed),
            label: 'Sleeping Time',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find Shoes',
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