import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ledrgb_gas/color.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermission();
    widget.device.state.listen((state) {
      if (state == BluetoothDeviceState.connected) {
        // Navega a la pantalla de color cuando el dispositivo esté conectado
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ColorScreen(device: widget.device)));
      }
    });
  }

  void _requestPermission() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map((e) => Column(
              children: [
                ListTile(
                  title: const Text("OFF"),
                  onTap: () {
                    e.characteristics[0].write([0]);
                  },
                ),
                ListTile(
                  title: const Text("ON"),
                  onTap: () {
                    e.characteristics[0].write([1]);
                  },
                ),
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              if (snapshot.data == BluetoothDeviceState.connected) {
                onPressed = () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                          ColorScreen(device: widget.device)));
                };
                text = 'CONNECTED';
              } else if (snapshot.data == BluetoothDeviceState.disconnected) {
                onPressed = () => widget.device.connect();
                text = 'CONNECT';
              } else {
                onPressed = null;
                text = snapshot.data.toString().substring(21).toUpperCase();
              }
              return TextButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: widget.device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? const Icon(Icons.bluetooth_connected)
                    : const Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${widget.device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: widget.device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data! ? 1 : 0,
                    children: <Widget>[
                      TextButton(
                        child: const Text("Show Services"),
                        onPressed: () async {
                          await widget.device.discoverServices();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ColorScreen(device: widget.device)));
                        },
                      ),
                      const IconButton(
                        icon: SizedBox(
                          width: 18.0,
                          height: 18.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: widget.device.services,
              initialData: const [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
