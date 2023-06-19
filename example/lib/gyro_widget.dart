import 'package:flutter/material.dart';
import 'package:gyroscope/gyroscope.dart';
import 'package:gyroscope_example/game_provider.dart';
import 'package:gyroscope_example/sample_rate_dropdown.dart';
import 'package:provider/provider.dart';


class GyroWidget extends StatefulWidget {
  const GyroWidget({super.key});


  @override
  State<GyroWidget> createState() => _GyroWidgetState();
}

class _GyroWidgetState extends State<GyroWidget> {

  SampleRate currentRate = SampleRate.normal;

  _GyroWidgetState() {
    game = GameProvider(
            (win, duration) {
          showDialog(context: context, builder: (ctx) {
            return AlertDialog(
              title: const Text('You Won!'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  late GameProvider game;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<GameProvider>.value(
      value: game,
      builder: (BuildContext context, _) {
        return Consumer<GameProvider>(
          builder: (_, game, __) {
            return ListView(
              shrinkWrap: true,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('The goal of this game is to try and match the color of the logo with the background. '
                      'You control the red, blue and green tint of the color by rotating your device around each axis',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(height: 20,),
                Stack(
                  children: [
                    Container(height: 100,color: game.target,),
                    Center(
                      child: Image.asset('assets/cc.png',
                        color: game.currentColor,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SampleRateDropDown((SampleRate rate) {
                        setState(() {
                          currentRate = rate;
                        });
                      }),
                      TextButton(
                          onPressed: () {
                            if (!game.running) {
                              game.start(currentRate);
                            }
                            else {
                              game.stop();
                            }
                          },
                          child: Text(game.running ? 'Stop game' : 'Start game')
                      ),
                    ],
                  ),
                ),
                //Expanded(child: Container()),
                debugValues(),

              ],
            );
          },
        );
      },
    );
  }

  Widget debugValues(){
    return Column(
      children: [
        debugValueRow('Pitch', GyroscopeData.toDegrees(game.debugValues.pitch)),
        debugValueRow('Roll', GyroscopeData.toDegrees(game.debugValues.roll)),
        debugValueRow('Azimuth', GyroscopeData.toDegrees(game.debugValues.azimuth)),
      ],
    );
  }

  Widget debugValueRow(String dimension, double value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(dimension),
        Text(value.toStringAsFixed(3))
      ],
    );
  }
}