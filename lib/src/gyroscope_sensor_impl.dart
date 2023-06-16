import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gyroscope/gyroscope.dart';
import '../gyroscope_platform_interface.dart';
import 'gyroscope_sensor_interface.dart';

class GyroscopeSensorImpl implements GyroscopeSensorInterface {

  final EventChannel _eventChannel = const EventChannel('gyro_update_channel');
  StreamSubscription<dynamic>? _streamSubscription;
  GyroscopeSensorSubscription? _subscription;

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
  }

  void onEventReceived(dynamic data) {
    try {
      GyroscopeData gyroData = GyroscopeData(azimuth: data[0], pitch: data[1], roll: data[2]);
      if (_subscription != null) {
        _subscription!(gyroData);
      }
    }catch (error){
      print('there was a problem parsing the sensor data: $error');
    }
  }

  void onEventChannelError(dynamic error){


  }


}