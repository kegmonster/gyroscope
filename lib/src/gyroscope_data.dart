import 'package:equatable/equatable.dart';
import 'dart:math' as math;

class GyroscopeData extends Equatable{
// Rotation on the axis from the back to the front side of the phone
  final double azimuth;
// Rotation on the axis from the left to the right side of the phone
  final double pitch;
// Rotation on the axis from the bottom to the top of the phone
  final double roll;

  const GyroscopeData({
    required this.azimuth,
    required this.pitch,
    required this.roll,
  });

  static double toDegrees(double radians){
    return radians * (180 / math.pi);
  }

  @override
  List<Object> get props => [azimuth, pitch, roll];
}