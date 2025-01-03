import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum ABC {
  a,
  b,
  c,
}

class Snackbar {
  static final snackBarKeyA = GlobalKey<ScaffoldMessengerState>();
  static final snackBarKeyB = GlobalKey<ScaffoldMessengerState>();
  static final snackBarKeyC = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> getSnackbar(ABC abc) {
    switch (abc) {
      case ABC.a:
        return snackBarKeyA;
      case ABC.b:
        return snackBarKeyB;
      case ABC.c:
        return snackBarKeyC;
    }
  }

  static show(ABC abc, String msg, {required bool success}) {
    final snackBar = success
        ? SnackBar(
          content: Text(
            msg,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ), 
          backgroundColor: Color.fromRGBO(89, 231, 101, 0.82),
          duration: const Duration(milliseconds: 1500),
          width: 300.0, // Width of the SnackBar.
          padding: const EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        )
        : SnackBar(
          content: Text(msg), 
          backgroundColor: Colors.red
        );
    getSnackbar(abc).currentState?.removeCurrentSnackBar();
    getSnackbar(abc).currentState?.showSnackBar(snackBar);
  }
}


String prettyException(String prefix, dynamic e) {
  if (e is FlutterBluePlusException) {
    return "$prefix ${e.description}";
  } else if (e is PlatformException) {
    return "$prefix ${e.message}";
  }
  return prefix + e.toString();
}
