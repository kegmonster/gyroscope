import 'package:flutter/material.dart';
import 'package:gyroscope/gyroscope.dart';
import 'package:gyroscope_example/gyro_provider.dart';
import 'package:provider/provider.dart';

class GyroWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<GyroProvider>.value(
      value: GyroProvider.instance,
      builder: (BuildContext context, _) {
        return Consumer<GyroProvider>(
          builder: (_, gyro, __) {
            return Column(
              children: [
                Text(GyroscopeData.toDegrees(gyro.gyroData.pitch).toString()),
                Text(GyroscopeData.toDegrees(gyro.gyroData.azimuth).toString()),
                Text(GyroscopeData.toDegrees(gyro.gyroData.roll).toString()),
                TextButton(
                    onPressed: () {
                      if (gyro.subscribed){
                        gyro.unsubscribe();
                      }
                      else {
                        gyro.subscribe();
                      }
                    },
                    child: Text(gyro.subscribed ? 'Unsubscribe' : 'Subscribe')
                ),
              ],
            );
          },
        );
      },
    );
  }

}