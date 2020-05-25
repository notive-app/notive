import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:notive_app/models/item_model.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';

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
                height: 10,
              ),
              FluidSlider(
                value: _distValue,
                onChanged: (double newValue) {
                  setState(() {
                    _distValue = newValue;
                    widget.item.setSelectedDist(_distValue);
                  });
                },
                min: 0.0,
                max: 10000.0,
                sliderColor: kLightBlueColor,
                thumbColor: kDeepBlue,
                valueTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Preferred Distance (in meters)',
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
              FluidSlider(
                value: _freqValue,
                onChanged: (double newValue) {
                  setState(() {
                    _freqValue = newValue;
                    widget.item.setSelectedFreq(_freqValue);
                  });
                },
                min: 0.0,
                max: 500.0,
                sliderColor: kLightOrange,
                thumbColor: kMediumOrange,
                valueTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
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
              Container(
                child: Text(
                  'Preferred Frequency (in minutes)',
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
