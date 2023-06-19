import 'package:flutter_test/flutter_test.dart';
import 'package:gyroscope/gyroscope.dart';
import 'package:gyroscope/gyroscope_platform_interface.dart';
import 'package:gyroscope/gyroscope_method_channel.dart';
import 'package:gyroscope/src/gyroscope_sensor_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGyroscopePlatform
    with MockPlatformInterfaceMixin
    implements GyroscopePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> subscribe(SampleRate rate) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  Future<void> unsubscribe() {
    // TODO: implement unsubscribe
    throw UnimplementedError();
  }
}

class MockGyroscopeImpl
    with MockPlatformInterfaceMixin
    implements GyroscopeSensorInterface {

  @override
  Future<void> subscribe(GyroscopeSensorSubscription subscription, {required SampleRate rate}) {
    // TODO: implement subscribe
    throw SensorException();
  }

  @override
  Future<void> unsubscribe() {
    // TODO: implement unsubscribe
    throw SensorException();
  }
}

void main() {
  final GyroscopePlatform initialPlatform = GyroscopePlatform.instance;

  test('$MethodChannelGyroscope is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGyroscope>());
  });

  test('getPlatformVersion', () async {
    MockGyroscopeImpl gyroscopeImpl = MockGyroscopeImpl();
    MockGyroscopePlatform fakePlatform = MockGyroscopePlatform();
    GyroscopePlatform.instance = fakePlatform;
    expect(() => gyroscopeImpl.subscribe((data) => null, rate: SampleRate.normal), throwsA(TypeMatcher<SensorException>()));
  });
}
