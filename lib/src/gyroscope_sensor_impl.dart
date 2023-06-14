import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gyroscope/gyroscope.dart';
import '../gyroscope_platform_interface.dart';
import 'gyroscope_sensor_interface.dart';

class GyroscopeSensorImpl implements GyroscopeSensorInterface {

  final EventChannel _eventChannel = const EventChannel('gyro_update_channel');
  StreamSubscription<dynamic>? _streamSubscription;
  GyroscopeSensorSubscription? subscription;

  @override
  Future<void> subscribe(GyroscopeSensorSubscription subscription, {required SampleRate rate,}) async {
    startListeningToGyroscopeData();
    this.subscription = subscription;
    return GyroscopePlatform.instance.subscribe(rate);
  }

  void startListeningToGyroscopeData() {
    _streamSubscription = _eventChannel.receiveBroadcastStream().listen((dynamic data) {
      GyroscopeData gyroData = GyroscopeData(azimuth: data[0], pitch: data[1], roll: data[2]);
      if (subscription!= null) {
        subscription!(gyroData);
      }
    }, onError: (dynamic error) {
      // Handle any errors that occur during the stream
    });
  }

  @override
  Future<void> unsubscribe() async {
    stopListeningToGyroscope();
    GyroscopePlatform.instance.unsubscribe();
  }

  void stopListeningToGyroscope(){
    _streamSubscription?.cancel();
  }

}