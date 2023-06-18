import 'package:flutter/cupertino.dart';
import 'package:gyroscope/gyroscope.dart';

class MyGyro with ChangeNotifier{

  final GyroscopeSensorImpl _gyroSensor = GyroscopeSensorImpl();
  static MyGyro? _myGyro;
  GyroscopeData gyroData = const GyroscopeData(azimuth: 0, pitch: 0, roll: 0);


  static MyGyro get instance => _myGyro ?? MyGyro._();

  MyGyro._();

  Future<void> subscribe() async {
    await _gyroSensor.subscribe((data) {
      gyroData = data;
      notifyListeners();
    }, rate: SampleRate.normal);
  }

  Future<void> unsubscribe() async {
    await _gyroSensor.unsubscribe();
  }



}