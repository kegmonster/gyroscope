import 'package:flutter/material.dart';
import 'package:gyroscope/gyroscope.dart';
import 'package:gyroscope_example/gyro_provider.dart';
import 'package:gyroscope_example/gyro_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GyroWidget(),
        ),
      ),
    );
  }
}
