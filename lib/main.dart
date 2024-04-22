import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makentuapp/database/databaseService.dart';
import 'package:makentuapp/database/mongodb.dart';
import 'package:makentuapp/home.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomeScreen(),
    );
  }
}
