import 'package:flutter/material.dart';
import 'package:gyroscope/gyroscope.dart';

class SampleRateDropDown extends StatefulWidget {
  final SampleRateChanged sampleRateChanged;
  SampleRateDropDown(this.sampleRateChanged, {super.key});
  @override
  _SampleRateDropDownWidgetState createState() =>
      _SampleRateDropDownWidgetState();
}

class _SampleRateDropDownWidgetState
    extends State<SampleRateDropDown> {
  late SampleRate selectedOption;
  late int selectedRadio;

  List<SampleRate> options = [
    SampleRate.normal,
    SampleRate.ui,
    SampleRate.game,
    SampleRate.fastest,
  ];

  @override
  void initState() {
    super.initState();
    selectedOption = options[0];
    selectedRadio = 0;
  }

  void onOptionChanged(SampleRate value) {
    setState(() {
      selectedOption = value;
    });
  }

  void onRadioChanged(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('UpdateRate'),

        DropdownButton<SampleRate>(
          value: selectedOption,
          onChanged: (value){
            setState(() {
              selectedOption = value!;
              widget.sampleRateChanged(selectedOption);
            });
          },
          items: options.map((SampleRate option) {
            return DropdownMenuItem<SampleRate>(
              value: option,
              child: Text(option.toString().split('.').last),
            );
          }).toList(),
        ),
      ],
    );
  }
}

typedef SampleRateChanged = Function(SampleRate rate);