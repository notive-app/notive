import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:notive_app/screens/constants.dart';
import 'constants.dart';

class RangeSettingsScreen extends StatefulWidget {
  static const String id = 'range_settings_screen';
  @override
  _RangeSettingsScreenState createState() => _RangeSettingsScreenState();
}

class _RangeSettingsScreenState extends State<RangeSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var _distValue = 10.0;
    var _freqValue = 0.0;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Range Settings',
          ),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 220.0,
                height: 70.0,
              ),
              SizedBox(
                width: 400,
                child: FluidSlider(
                  valueTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                  sliderColor: kPurpleColor,
                  thumbColor: kDarkPurpleColor,
                  value: _distValue,
                  onChanged: (double newValue) {
                    setState(() {
                      _distValue = newValue;
                    });
                  },
                  min: 0.0,
                  max: 100.0,
                ),
              ),
              SizedBox(
                width: 220.0,
                height: 20.0,
              ),
              SizedBox(
                height: 60.0,
                child: Text(
                  'Preffered Distance',
                  style: TextStyle(color: kDarkPurpleColor, fontSize: 16),
                ),
              ),
              SizedBox(
                width: 400,
                child: FluidSlider(
                  valueTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                  sliderColor: kPurpleColor,
                  thumbColor: kDarkPurpleColor,
                  value: _freqValue,
                  onChanged: (double newValue) {
                    setState(() {
                      _freqValue = newValue;
                    });
                  },
                  min: 0.0,
                  max: 100.0,
                ),
              ),
              SizedBox(
                width: 220.0,
                height: 20.0,
              ),
              SizedBox(
                height: 20.0,
                child: Text(
                  'Preffered Frequency',
                  style: TextStyle(color: kDarkPurpleColor, fontSize: 16),
                ),
              ),
            ],
          ),
        ));
  }
}
