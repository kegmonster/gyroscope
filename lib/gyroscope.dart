
import 'dart:async';

import 'package:flutter/services.dart';

import 'gyroscope_platform_interface.dart';

class Gyroscope {
  final EventChannel _eventChannel = const EventChannel('your_event_channel_name');
  StreamSubscription<dynamic>? _streamSubscription;

  Gyroscope(){
    startListeningToGyroscopeData();
  }

  void startListeningToGyroscopeData() {
    _streamSubscription = _eventChannel.receiveBroadcastStream().listen((dynamic data) {
      print(data);
    }, onError: (dynamic error) {
      // Handle any errors that occur during the stream
    });
  }
  Future<String?> getPlatformVersion() {
    return GyroscopePlatform.instance.getPlatformVersion();
  }

  Future<bool?> subscribe() {
    return GyroscopePlatform.instance.subscribe();
  }
}
