import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gyroscope/gyroscope.dart';

import 'gyroscope_platform_interface.dart';

/// An implementation of [GyroscopePlatform] that uses method channels.
class MethodChannelGyroscope extends GyroscopePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gyroscope');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> subscribe(SampleRate rate) async{
    bool? success = await methodChannel.invokeMethod<bool>('subscribe',{'rate':rate.toHz()});
    if (success == null || !success) {
      throw SensorException();
    }
  }

  @override
  Future<void> unsubscribe() async{
    bool? success = await methodChannel.invokeMethod<bool>('unsubscribe');
    if (success == null || !success){
      throw SensorException();
    }

  }
}
