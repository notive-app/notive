import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:notive_app/screens/constants.dart';

class ConfigSlider extends StatefulWidget {
  //final int selectedIndex;
  
  ConfigSlider();
  @override
  State<StatefulWidget> createState() => _ConfigSliderState(); 
}

class _ConfigSliderState extends State<ConfigSlider> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double _distValue = 0.0;
    double _freqValue = 10.0;
    return Column(
      children: <Widget>[
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
                  
      ],
    );
    
  }

}