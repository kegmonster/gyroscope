import 'package:flutter/material.dart';
import 'package:gyroscope/gyroscope.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool subscribed = false;
  final gyrosensor = GyroscopeSensorImpl();
  GyroscopeData lastUpdate = const GyroscopeData(azimuth: 0, pitch: 0, roll: 0);

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
          child: Column(
            children: [
              Text('Running on: ${lastUpdate.azimuth}\n'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text(subscribed ? 'unsubscribe' : 'subscribe'),
          onPressed: (){
            if(!subscribed) {
              gyrosensor.subscribe((data) {
                setState(() {
                  lastUpdate = data;
                });
              }, rate: SampleRate.normal);
              setState(() {
                subscribed = true;
              });
            }else{
              gyrosensor.unsubscribe();
              setState(() {
                subscribed = false;
              });
            }
          },
        ),
      ),
    );
  }
}
