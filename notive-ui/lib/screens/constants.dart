import 'package:flutter/material.dart';

//from input_page.dart
const double kBottomContainerHeight = 80;
const Color kButtonColor = Color(0xFFFB8C00);
const Color kCardColorChosen = Color(0xFF64B5F6);
const Color kCardColor = Color(0xFF7C4DFF);
const Color kBottomContainerColor = Color(0xFFEB1555);

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

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
