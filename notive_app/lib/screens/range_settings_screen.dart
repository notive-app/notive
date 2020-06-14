import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:notive_app/models/item_model.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';
import 'package:slider/slider.dart';
import 'package:notive_app/components/custom_slider.dart';

class RangeSettingsScreen extends StatefulWidget {
  static const String id = 'range_settings_screen';
  ItemModel item;

  RangeSettingsScreen({this.item});

  @override
  _RangeSettingsScreenState createState() => _RangeSettingsScreenState();
}

class _RangeSettingsScreenState extends State<RangeSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    double _distValue = widget.item.selectedDist.toDouble();
    double _freqValue = widget.item.selectedFreq.toDouble();

    int _intDist = _distValue.toInt();
    int _intFreq = _freqValue.toInt();

    // access to item by using "widget.item"
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Range Settings: ' + widget.item.name,
        ),
        leading: BackButton(
          onPressed: () {
            Provider.of<UserModel>(context, listen: false)
                .changeItemDesiredDist(widget.item, _distValue);
            Provider.of<UserModel>(context, listen: false)
                .changeItemDesiredFreq(widget.item, _freqValue);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage('images/settings.png'),
                  height: MediaQuery.of(context).size.height * 0.23,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
//                  border: Border.all(
//                    color: kLightestBlue,
//                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.red[700],
                      inactiveTrackColor: Colors.red[100],
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape: CustomSliderThumbCircle(
                          thumbRadius: 25.0,
                          unit: " km",
                          val: _intDist,
                          dist: true),
                      thumbColor: Colors.redAccent,
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.red[700],
                      inactiveTickMarkColor: Colors.black26,
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.redAccent,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      value: _distValue,
                      onChanged: (double newValue) {
                        setState(() {
                          _distValue = newValue;
                          widget.item.setSelectedDist(_distValue);
                        });
                      },
                      label: '$_intDist m',
                      min: 0,
                      max: 10000,
                      divisions: 20,
//                sliderColor: kLightBlueColor,
//                thumbColor: kDeepBlue,
//                valueTextStyle: TextStyle(
//                  color: Colors.white,
//                  fontSize: 15,
//                ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Text(
                  'Preferred Distance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    //color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
//                  border: Border.all(
//                    color: kLightestBlue,
//                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.red[700],
                      inactiveTrackColor: Colors.red[100],
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape: CustomSliderThumbCircle(
                        thumbRadius: 25.0,
                        unit: " h",
                        val: _intFreq,
                        dist: false,
                      ),
                      thumbColor: Colors.redAccent,
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.red[700],
                      inactiveTickMarkColor: Colors.black26,
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.redAccent,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      value: _freqValue,
                      onChanged: (double newValue) {
                        setState(() {
                          _freqValue = newValue;
                          widget.item.setSelectedFreq(_freqValue);
                        });
                      },
                      min: 15.0,
                      max: 315.0,
                      divisions: 20,
                      label: '$_intFreq min',
//                sliderColor: kLightOrange,
//                thumbColor: kMediumOrange,
//                valueTextStyle: TextStyle(
//                  color: Colors.white,
//                  fontSize: 15,
//                ),
//                start: Icon(
//                  Icons.timer_off,
//                  color: Colors.white,
//                ),
//                end: Icon(
//                  Icons.timer,
//                  color: Colors.white,
//                ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Preferred Frequency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    //color: Colors.white,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
