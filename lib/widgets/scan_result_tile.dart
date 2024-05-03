import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = widget.result.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  String getNiceManufacturerData(List<List<int>> data) {
    return data.map((val) => '${getNiceHexArray(val)}').join(', ').toUpperCase();
  }

  String getNiceServiceData(Map<Guid, List<int>> data) {
    return data.entries.map((v) => '${v.key}: ${getNiceHexArray(v.value)}').join(', ').toUpperCase();
  }

  String getNiceServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Widget _buildTitle(BuildContext context) {
    if (widget.result.device.platformName.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.result.device.platformName,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.result.device.remoteId.str,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
    } else {
      return Text(widget.result.device.remoteId.str);
    }
  }

Widget _buildConnectButton(BuildContext context) {
  // Define academic style colors
  const Color academicBackgroundColor = Color.fromARGB(255, 101, 167, 230); // Dark gray for professionalism
  const Color academicForegroundColor = Color(0xFFEDEDED); // Light gray for readability
  const Color academicConnectedColor = Color(0xFF4CAF50); // Green signifies connected state, also easy on the eyes

  return ElevatedButton(
    child: isConnected ? const Text('OPEN') : const Text('CONNECT'),
    style: ElevatedButton.styleFrom(
      backgroundColor: isConnected ? academicConnectedColor : academicBackgroundColor,
      foregroundColor: academicForegroundColor,
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0), // Reduced the border radius for a more subdued, professional appearance
      ),
      elevation: 2.0, // Lowered elevation for a flatter design preferred in academic settings
      textStyle: TextStyle(
        fontSize: 16.0, // Slightly larger text size for readability without being too bold
        fontWeight: FontWeight.w400, // Regular font weight as opposed to bold
      ),
    ),
    onPressed: widget.result.advertisementData.connectable ? widget.onTap : null,
  );
}


  Widget _buildAdvRow(BuildContext context, String title, String value) {
  // Use ThemeData to ensure that the app stays true to overall theme of the application
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Change to subtitle1 for a bit larger and bolder title that stands out
        Text(
          title,
          style: theme.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          // Change to bodyText2 for the value which is a standard body text style
          child: Text(
            value,
            style: theme.textTheme.bodyText2,
            softWrap: true,
          ),
        ),
      ],
    ),
  );
}
bool _isExpanded = false;

@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final adv = widget.result.advertisementData;

  // Light brown color for the unexpanded tile background
  final lightBrown = Color.fromRGBO(223, 249, 252, 1);
  // Light yellow color for the expanded area background
  final lightYellow = Color(0xFFFFF9C4);

  // Custom styling for the ExpansionTile to improve visibility and styling
  return Container(
    color: lightBrown,
    child: Theme(
      data: theme.copyWith(
        dividerColor: theme.dividerColor.withOpacity(0.1),
        // Use light yellow for background when expanded
        cardColor: lightYellow,
      ),
      child: ListTileTheme(
        tileColor: lightBrown,
        child: ExpansionTile(
          title: _buildTitle(context),
          leading: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              widget.result.rssi.toString(),
              style: theme.textTheme.bodyText1?.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
          trailing: _buildConnectButton(context),
          children: <Widget>[
            // Use Container with the desired background
            Container(
              color: lightYellow,
              child: Column(
                children: <Widget>[
                  if (adv.advName.isNotEmpty) _buildAdvRow(context, 'Name', adv.advName),
                  if (adv.txPowerLevel != null) _buildAdvRow(context, 'Tx Power Level', '${adv.txPowerLevel}'),
                  if ((adv.appearance ?? 0) > 0) _buildAdvRow(context, 'Appearance', '0x${adv.appearance!.toRadixString(16)}'),
                  if (adv.msd.isNotEmpty) _buildAdvRow(context, 'Manufacturer Data', getNiceManufacturerData(adv.msd)),
                  if (adv.serviceUuids.isNotEmpty) _buildAdvRow(context, 'Service UUIDs', getNiceServiceUuids(adv.serviceUuids)),
                  if (adv.serviceData.isNotEmpty) _buildAdvRow(context, 'Service Data', getNiceServiceData(adv.serviceData)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}