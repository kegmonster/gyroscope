
import 'gyroscope_platform_interface.dart';

class Gyroscope {
  Future<String?> getPlatformVersion() {
    return GyroscopePlatform.instance.getPlatformVersion();
  }
}
