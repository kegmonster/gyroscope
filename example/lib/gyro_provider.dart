import 'package:flutter/cupertino.dart';
import 'package:gyroscope/gyroscope.dart';

class GyroProvider with ChangeNotifier{

  final GyroscopeSensorImpl _gyroSensor = GyroscopeSensorImpl();
  static GyroProvider? _gyroProvider;
  GyroscopeData gyroData = const GyroscopeData(azimuth: 0, pitch: 0, roll: 0);
  bool _subscribed = false;

  bool get subscribed => _subscribed;


  static GyroProvider get instance => _gyroProvider ?? GyroProvider._();

  GyroProvider._();

  Future<void> subscribe() async {
    await _gyroSensor.subscribe((data) {
      gyroData = data;
      notifyListeners();
    }, rate: SampleRate.normal);
    _subscribed = true;
    notifyListeners();
  }

  Future<void> unsubscribe() async {
    await _gyroSensor.unsubscribe();
    _subscribed = false;
    notifyListeners();
  }


}