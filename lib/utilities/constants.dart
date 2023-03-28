import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double containerDim = 140.w;
const Color containerColor = Color(0xFF1cab83);
const EdgeInsets containerMargin = EdgeInsets.all(10);
const EdgeInsets containerPadding = EdgeInsets.all(10);
const List<BoxShadow> containerShadow = [
  BoxShadow(
    color: Color(0xff92ffb7),
    blurRadius: 4.0,
    spreadRadius: 3.0,
  ),
];
Border containerBorder = Border.all(color: Color(0xff0aec52), width: 5.0);

const Color chatGPTCardColor = Color(0xFF2B2B38);
const Color chatGPTAppBarColor = Color(0xFF464A61);

final chatMessages = [
  {
    "msg": "Hello, How are you?",
    "chatIndex": 0,
  },
  {
    "msg": "I am Good. How can I help you?",
    "chatIndex": 1,
  },
  {
    "msg": "Name the alphabets",
    "chatIndex": 0,
  },
  {
    "msg": "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z",
    "chatIndex": 1,
  },
];
