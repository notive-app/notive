import 'package:flutter/material.dart';

//from input_page.dart
const double kBottomContainerHeight = 80;
const Color kDarkPurpleColor = Color(0xFF57426B);
const Color kPurpleColor = Color(0xFF765A91);
const Color kDarkBlueColor = Color(0xFF4873A6);
const Color kLightBlueColor = Color(0xFF4D9CD0);
const Color kOffWhiteColor = Color(0xFFFAFAFA);
const Color kGrayColor = Color(0xFFD0D3D4);

const Color kDarkest = Color(0xFF1B1415);
const Color kDeepOrange = Color(0xFFD8420D);
const Color kMediumOrange = Color(0xFFe26831);
const Color kLightOrange = Color(0xFFeb9771);
const Color kDeepYellow = Color(0xFFF0900B);
const Color kDeepBlue = Color(0xFF114384);
const Color kLightBlue = Color(0xFF1B6BC0);
const Color kLightestBlue = Color(0xFFADD8E6);
const Color kRed = Color(0xFFD1000B);
const Color kMilitary = Color(0xFF806F5F);
const Color kGrey = Color(0xFF908C8C);

//from icon_content.dart
const double iconSize = 70.0;
const double fontSize = 18.0;
const Color fontColor = Color(0xFF8D8E98);
const double textIconSpace = 15.0;

// STYLES
const kMyTextStyle = TextStyle(
  fontSize: fontSize,
  color: fontColor,
);

const kNumberTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
);

const kLargeButtonTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const kTitleStyle = TextStyle(
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
);

const kStatusStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  color: Colors.green,
);

const kResultStyle = TextStyle(
  fontSize: 100.0,
  fontWeight: FontWeight.w900,
);

const kAnotherTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.w500,
);

const double minScale = 120.0;
const double maxScale = 220.0;

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecorationLog = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black26, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kDeepOrange, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kTextFieldDecorationSign = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black26, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kDeepYellow, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
