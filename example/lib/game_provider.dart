import 'package:flutter/material.dart';
import 'package:gyroscope/gyroscope.dart';
import 'package:gyroscope_example/gyro_provider.dart';
import 'dart:math' as math;

class GameProvider with ChangeNotifier{

  Color _target = const Color.fromARGB(255,100,0,0);
  GameOver onGameOver;
  int _difficultyOffset = 10;
  bool _running = false;
  DateTime startTime = DateTime.now();

  final MyGyro _myGyro = MyGyro.instance;
  Color _currentColor = Colors.grey;
  bool get running => _running;
  Color get currentColor => _currentColor;
  GyroscopeData debugValues = const GyroscopeData(azimuth: 0, pitch: 0, roll: 0);
  Color get target => _target;

  GameProvider(this.onGameOver){
    _myGyro.addListener(() {
      debugValues = _myGyro.gyroData;
      _currentColor = gyrodataToColor(_myGyro.gyroData);
      bool gameWon = isColorCloseEnough(_currentColor);
      if (gameWon){
        stop();
        onGameOver(true, Duration(seconds: (DateTime.now().millisecond - startTime.millisecond)*1000));

      }else {
        notifyListeners();
      }
    });
  }


  start(){
    _running = true;
    startTime = DateTime.now();
    _myGyro.subscribe();
    notifyListeners();
  }

  stop(){
    _running = false;
    _myGyro.unsubscribe();
    notifyListeners();
  }

  bool isColorCloseEnough(Color current) {

    int rDiff = (current.red - _target.red).abs();
    int gDiff = (current.green - _target.green).abs();
    int bDiff = (current.blue - _target.blue).abs();
    // Handle overflow cases
    if (rDiff > _difficultyOffset / 2) {
      rDiff = 255 - rDiff;
    }
    if (gDiff > _difficultyOffset / 2) {
      gDiff = 255 - gDiff;
    }
    if (bDiff > _difficultyOffset / 2) {
      bDiff = 255 - bDiff;
    }
    return rDiff <= _difficultyOffset && gDiff <= _difficultyOffset && bDiff <= _difficultyOffset;
  }

  static Color gyrodataToColor(GyroscopeData gyroData) {
    return Color.fromARGB(255,
        mapPitchToRGB(gyroData.pitch),
        mapToRGB(gyroData.roll),
        mapToRGB(gyroData.azimuth));
  }

  static int mapToRGB(double value) {
    // Map radians from -π to π to a range of 0-1
    double normalizedValue = (value + math.pi) / (2 * math.pi);

    // Map the normalized value to the range of 0-510
    int colorValue = (normalizedValue * 510).round();
    if (colorValue > 255){
      colorValue = 255 - (colorValue -255);
    }

    return colorValue.clamp(0, 510);
  }

  static int mapPitchToRGB(double value) {
    // Map radians from -π to π to a range of 0-1
    double normalizedValue = (value + math.pi/2) / ( math.pi);

    // Map the normalized value to the range of 0-510
    int colorValue = (normalizedValue * 510).round();
    if (colorValue > 255){
      colorValue = 255 - (colorValue -255);
    }

    return colorValue.clamp(0, 510);
  }
}

typedef GameOver = Function(bool win, Duration duration);
