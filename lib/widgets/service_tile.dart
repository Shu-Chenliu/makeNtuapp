import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import "characteristic_tile.dart";
import 'package:makentuapp/search/searchButton.dart';
import 'package:makentuapp/search/moveTo.dart';
class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;
  final String title;
  final String? position;
  const ServiceTile({
    Key? key, 
    required this.service, 
    required this.characteristicTiles,
    required this.title,
    this.position,
  }): super(key: key);

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${service.uuid.str.toUpperCase()}';
    return Text(uuid, style: TextStyle(fontSize: 13));
  }

  @override
  Widget build(BuildContext context) {
    return characteristicTiles.isNotEmpty?
        // ? ExpansionTile(
        //     title: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         const Text('Service', style: TextStyle(color: Colors.blue)),
        //         buildUuid(context),
        //       ],
        //     ),
        //     children: characteristicTiles,
        //   ),
          SearchButton(title: title, service: service)
        : ListTile(
            title: const Text('Service'),
            subtitle: buildUuid(context),
          );
  }
}
