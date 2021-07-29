import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

TextStyle textStyle = TextStyle(
    color: Colors.white, fontSize: 16, textBaseline: TextBaseline.alphabetic);

const kTextDecorationStyle = InputDecoration(
  // contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 0),
  enabled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  fillColor: Colors.transparent,
  filled: true,
);

const kGradientColor = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0052D4), Color(0xFF6FB1FC)],
  ),
);

var kContainerElevation = [
  BoxShadow(color: Colors.black38, offset: Offset(15, 15), blurRadius: 10)
];
var kSubtitleTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.white.withOpacity(0.9),
    fontStyle: FontStyle.italic);

var kTitleTextStyle = TextStyle(
    color: Colors.indigo,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'nunito');

showToast(
    {required String message,
    color = Colors.white,
    gravity = ToastGravity.BOTTOM}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black87,
      textColor: color,
      gravity: gravity,
      fontSize: 18);
}

showDialogue(
  context, {
  String title = 'Confirm',
  String content = 'This message will be permanently deleted.\n\nAre you sure?',
  Color titleColor = Colors.indigo,
  Color contentColor = Colors.deepPurple,
  Color buttonColor = Colors.deepPurple,
}) {
  return AlertDialog(
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: kTitleTextStyle.copyWith(color: titleColor),
    ),
    content: Text(
      content,
      style: TextStyle(fontSize: 18, color: contentColor),
    ),
    contentPadding: EdgeInsets.only(top: 12, left: 24, right: 20, bottom: 0),
    actions: [
      TextButton(
          style: TextButton.styleFrom(
            elevation: 15,
            backgroundColor: buttonColor.withOpacity(0.6),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            'Yes',
            style: TextStyle(
              fontSize: 22,
              color: Colors.red.shade900,
              fontWeight: FontWeight.w900,
            ),
          )),
      SizedBox(width: 10),
      TextButton(
          style: TextButton.styleFrom(
            elevation: 15,
            backgroundColor: buttonColor.withOpacity(0.6),
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(
            'No',
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFF096EFA),
              fontWeight: FontWeight.w900,
            ),
          )),
    ],
  );
}
