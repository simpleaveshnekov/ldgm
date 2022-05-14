import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyInkWell extends StatefulWidget {
  final String introText;
  final TextStyle textStyle;
  final String mainText;
  final Function onPressed;
  MyInkWell({
    @required this.onPressed,
    @required this.introText,
    @required this.mainText,
    this.textStyle,
  }) : super();

  @override
  _MyInkWellState createState() => _MyInkWellState(introText: introText, textStyle: textStyle, mainText: mainText, onPressed: onPressed);
}

class _MyInkWellState extends State<MyInkWell> {
  String introText;
  TextStyle textStyle;
  String mainText;
  Function onPressed;
  _MyInkWellState({
    @required this.onPressed,
    @required this.introText,
    @required this.mainText,
    this.textStyle,
  });
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(
        style: textStyle ?? textTheme.headline6,
        children: [
          TextSpan(
            text: introText,
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          TextSpan(
            text: mainText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onPressed,
          ),
        ],
      ),
    );
  }
}
