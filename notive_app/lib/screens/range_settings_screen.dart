import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:notive_app/screens/constants.dart';

class RangeSettingsScreen extends StatefulWidget {
  static const String id = 'range_settings_screen';
  @override
  _RangeSettingsScreenState createState() => _RangeSettingsScreenState();
}

class _RangeSettingsScreenState extends State<RangeSettingsScreen> {
  double _distValue = 0.0;
  double _freqValue = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Range Settings',
        ),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FluidSlider(
                value: _distValue,
                onChanged: (double newValue) {
                  setState(() {
                    _distValue = newValue;
                  });
                },
                min: 0.0,
                max: 100.0,
                sliderColor: kPurpleColor,
                thumbColor: kDarkPurpleColor,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 50.0,
                  child: Stack(
                    //alignment: ,
                    children: <Widget>[
                      Text(
                        'Preffered Distance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.white10,
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        'Preffered Distance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
              FluidSlider(
                value: _freqValue,
                onChanged: (double newValue) {
                  setState(() {
                    _freqValue = newValue;
                  });
                },
                min: 0.0,
                max: 500.0,
                sliderColor: kPurpleColor,
                thumbColor: kDarkPurpleColor,
                start: Icon(
                  Icons.timer_off,
                  color: Colors.white,
                ),
                end: Icon(
                  Icons.timer,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  //height: 40.0,
                  //width: 200,

                  child: Stack(
                //alignment: ,
                children: <Widget>[
                  Text(
                    'Preffered Frequency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.white10,
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    'Preffered Frequency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ))
            ]),
      ),
    );
  }
}
