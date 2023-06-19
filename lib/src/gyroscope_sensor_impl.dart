import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gyroscope/gyroscope.dart';
import '../gyroscope_platform_interface.dart';
import 'gyroscope_sensor_interface.dart';

class GyroscopeSensorImpl implements GyroscopeSensorInterface {

  final EventChannel _eventChannel = const EventChannel('gyro_update_channel');
  StreamSubscription<dynamic>? _streamSubscription;
  GyroscopeSensorSubscription? _subscription;
  GyroscopeData gyroData = const GyroscopeData(azimuth: 0, pitch: 0, roll: 0);

  GyroscopeSensorImpl(){
    setupEventChannel();
  }

  @override
  Future<void> subscribe(GyroscopeSensorSubscription subscription, {required SampleRate rate,}) async {
    _subscription = subscription;
    return GyroscopePlatform.instance.subscribe(rate);
  }

  void setupEventChannel() {
    _streamSubscription = _eventChannel.receiveBroadcastStream().listen(onEventReceived, onError: onEventChannelError);
  }

  @override
  Future<void> unsubscribe() async {
    GyroscopePlatform.instance.unsubscribe();
    gyroData = const GyroscopeData(azimuth: 0, pitch: 0, roll: 0);
  }

  void onEventReceived(dynamic data) {
    try {
      GyroscopeData gyroscopeData = GyroscopeData(pitch: data[0], roll: data[1], azimuth: data[2]);
      if (_subscription != null) {
        _subscription!(gyroscopeData);
      }
    }catch (error){
      print('there was a problem parsing the sensor data: $error');
    }
  }

  void onEventChannelError(dynamic error){
    print('Error on the event channel' + error);

  }


}