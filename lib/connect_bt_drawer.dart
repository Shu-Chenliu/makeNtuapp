import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../utils/snackbar.dart';
import '../widgets/system_device_tile.dart';
import '../widgets/scan_result_tile.dart';
import '../utils/extra.dart';
class ConnectBT extends StatefulWidget {
  const ConnectBT({super.key});
  @override
  _ConnectBTState createState() => _ConnectBTState();
}
class _ConnectBTState extends State<ConnectBT>{
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("System Devices Error:", e), success: false);
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Start Scan Error:", e), success: false);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e), success: false);
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
    });
    //TODO
    // MaterialPageRoute route = MaterialPageRoute(
    //     builder: (context) => DeviceScreen(device: device), settings: RouteSettings(name: '/DeviceScreen'));
    // Navigator.of(context).push(route);
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

Widget buildScanButton(BuildContext context) {
  final ButtonStyle scanningButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey; // Disabled color
      }
      return const Color.fromARGB(255, 248, 44, 29); // Regular color
    }),
    foregroundColor: MaterialStateProperty.all(Colors.white), // Text/icon color
    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    )),
    elevation: MaterialStateProperty.all(10), // Add shadow.
  );

  final ButtonStyle notScanningButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 126, 189, 241)), // Button color
    foregroundColor: MaterialStateProperty.all(Colors.white), // Text/icon color
    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    )),
    elevation: MaterialStateProperty.all(10), // Add shadow
  );

  return Container(
    alignment: Alignment.centerRight,
    margin: EdgeInsets.all(10), // margin for the container
    child: FlutterBluePlus.isScanningNow
        ? ElevatedButton.icon(
            onPressed: onStopPressed,
            icon: const Icon(Icons.stop),
            label: const Text('STOP'),
            style: scanningButtonStyle,
          )
        : ElevatedButton.icon(
            onPressed: onScanPressed,
            icon: const Icon(Icons.search),
            label: const Text('Scan for my slippers'),
            style: notScanningButtonStyle,
          ),
  );
}

  List<Widget> _buildSystemDeviceTiles(BuildContext context) {
    return _systemDevices
        .map(
          (d) => SystemDeviceTile(
            device: d,
            onOpen: (){},
            //TODO
            // onOpen: () => Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => DeviceScreen(device: d),
            //     settings: RouteSettings(name: '/DeviceScreen'),
            //   ),
            // ),
            onConnect: () => onConnectPressed(d),
          ),
        )
        .toList();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () => onConnectPressed(r.device),
          ),
        )
        .toList();
  }
  @override
  Widget build(BuildContext context){
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 100,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 24, 0, 118),
            ),
            child: buildScanButton(context),
          ),
        ),
        ..._buildSystemDeviceTiles(context),
        ..._buildScanResultTiles(context),
      ],
    );
  }
}