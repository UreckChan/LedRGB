import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ColorScreen extends StatefulWidget {
  final BluetoothDevice device;

  const ColorScreen({Key? key, required this.device}) : super(key: key);

  @override
  _ColorScreenState createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  Color _currentColor = Colors.green;
  var _switchValue = false;
  final _controller = CircleColorPickerController(
    initialColor: Colors.green,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        appBar: AppBar(
          title: const Text(
            'RGB LED',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromRGBO(26, 26, 26, 1),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 48),
            Center(
              child: CircleColorPicker(
                controller: _controller,
                onChanged: (color) {
                  setState(() {
                    _currentColor = color;
                  });
                },
              ),
            ),
            SizedBox(height: 48),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Red',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Green',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Blue',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Slider(
                      value: _currentColor.red.toDouble(),
                      min: 0,
                      max: 255,
                      onChanged: (value) {
                        setState(() {
                          _controller.color = Color.fromRGBO(
                            value.toInt(),
                            _currentColor.green,
                            _currentColor.blue,
                            1,
                          );
                        });
                      },
                    ),
                    Slider(
                      value: _currentColor.green.toDouble(),
                      min: 0,
                      max: 255,
                      onChanged: (value) {
                        setState(() {
                          _controller.color = Color.fromRGBO(
                            _currentColor.red,
                            value.toInt(),
                            _currentColor.blue,
                            1,
                          );
                        });
                      },
                    ),
                    Slider(
                      value: _currentColor.blue.toDouble(),
                      min: 0,
                      max: 255,
                      onChanged: (value) {
                        setState(() {
                          _controller.color = Color.fromRGBO(
                            _currentColor.red,
                            _currentColor.green,
                            value.toInt(),
                            1,
                          );
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _switchValue ? 'Apagar' : 'Encender',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      activeColor: Colors.lightBlue,
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
