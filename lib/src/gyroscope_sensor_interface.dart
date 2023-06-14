import 'gyroscope_data.dart';
import 'sample_rate.dart';

typedef GyroscopeSensorSubscription = Function(GyroscopeData data);

abstract class GyroscopeSensorInterface {

  /// Subscribes to the native gyroscope sensor updates.
  /// Depending on the [rate] the [subscription] gets called for each
  /// update.
  ///
  /// Throws a [SensorException] in case of any error.
  Future<void> subscribe(
      final GyroscopeSensorSubscription subscription, {
        required SampleRate rate,
      });

  /// Unsubscribe from the native gyroscope sensor updates.
  ///
  /// Throws a [SensorException] in case of any error.
  Future<void> unsubscribe();
}