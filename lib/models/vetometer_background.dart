import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VetometerBackground extends StatelessWidget {
  final headerTitle, child, positionedWidget;
  final lightColor, darkColor, glowColor, blinkingAnimation;
  VetometerBackground(
      {@required this.child,
      @required this.headerTitle,
      @required this.positionedWidget,
      @required this.lightColor = Colors.red,
      this.blinkingAnimation = false,
      this.darkColor = const Color(0xFFB71C1C),
      this.glowColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF4364F7), Color(0xFF6FB1FC)],
          ),
        ),
        child: Stack(
          children: [
            ClipPath(
              clipper: ThemeClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6FB1FC), Color(0xFF38597E)],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: child,
            ),
            positionedWidget,

            /*  Header */
            Positioned(
              child: Hero(
                tag: 'vetometer header',
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF479DFF), Color(0xFF38597E)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF151627).withOpacity(0.8),
                        blurRadius: 6,
                        offset: Offset(10, 8), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/vetometer-logo.png',
                          height: 50.0,
                          width: 50.0,
                        ),
                        SizedBox(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vetometer',
                              style: TextStyle(
                                fontFamily: "Merienda",
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                SizedBox(width: 24.0),
                                blinkingAnimation
                                    ? BlinkingDot(
                                        lightColor: lightColor,
                                        darkColor: darkColor,
                                        glowColor: glowColor,
                                      )
                                    : Container(
                                        height: 5.0,
                                        width: 5.0,
                                        decoration: BoxDecoration(
                                          color: lightColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                SizedBox(width: 10),
                                Text(
                                  headerTitle,
                                  style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height * 0.4);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BlinkingDot extends StatefulWidget {
  final lightColor, darkColor, glowColor;
  BlinkingDot({this.lightColor, this.darkColor, this.glowColor});

  @override
  _BlinkingDotState createState() => _BlinkingDotState(
      lightColor, darkColor, glowColor ?? const Color(0xFFCC0000));
}

class _BlinkingDotState extends State<BlinkingDot> {
  var lightColor, darkColor, glowColor;
  bool isBlinking = true;
  _BlinkingDotState(this.lightColor, this.darkColor, this.glowColor);
  @override
  void initState() {
    // TODO: This animation must be disposed once this page ceases to exist.
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: isBlinking
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: lightColor,
              boxShadow: [
                BoxShadow(color: glowColor, blurRadius: 5, spreadRadius: 1)
              ],
            )
          : BoxDecoration(
              shape: BoxShape.circle,
              color: darkColor,
            ),
    );
  }

  startTime() async {
    var duration = new Duration(milliseconds: 250);
    return new Timer(duration, toggle);
  }

  toggle() {
    setState(() {
      isBlinking = !isBlinking;
    });
    startTime();
  }
}
