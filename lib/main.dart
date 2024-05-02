import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makentuapp/database/databaseService.dart';
import 'package:makentuapp/database/mongodb.dart';
import 'package:makentuapp/home.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  await MongoDb.connect();
  // await DatabaseService.instance.database;
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 158, 175, 189)),
      ),
      home: const HomeScreen(),
    );
  }
}
