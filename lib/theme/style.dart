import 'package:flutter/material.dart';

TextStyle appBarTitleStyle(BuildContext context) => Theme.of(context).textTheme.headline6.copyWith(
      color: Color(0xff233561),
      fontWeight: FontWeight.normal,
    );

// Additional text themes
TextStyle boldCaptionStyle(BuildContext context) => Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold);

TextStyle boldSubtitle(BuildContext context) => Theme.of(context).textTheme.subtitle1.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

TextStyle loginButtonTextStyle(BuildContext context) => Theme.of(context).textTheme.button.copyWith(color: Colors.black);

TextStyle normalCaptionStyle(BuildContext context) => Theme.of(context).textTheme.caption.copyWith(
      color: Colors.grey,
      fontSize: 14,
    );

TextStyle normalHeadingStyle(BuildContext context) => Theme.of(context).textTheme.headline6.copyWith(
      fontWeight: FontWeight.normal,
    );

TextStyle textFieldHintStyle(BuildContext context) => Theme.of(context).textTheme.caption.copyWith(
      color: Colors.grey[500],
      fontWeight: FontWeight.normal,
      fontSize: 15,
    );

TextStyle textFieldInputStyle(BuildContext context, FontWeight fontWeight) => Theme.of(context).textTheme.bodyText1.copyWith(
      color: Colors.black,
      fontSize: 18,
      fontWeight: fontWeight ?? FontWeight.normal,
    );

TextStyle textFieldLabelStyle(BuildContext context) => Theme.of(context).textTheme.caption.copyWith(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

TextStyle textFieldSuffixStyle(BuildContext context) => Theme.of(context).textTheme.caption.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

class ThemeUtils {
  static final ThemeData defaultAppThemeData = appTheme();

  static ThemeData appTheme() {
    // Color primaryColor = Color(0xffFF0000);
    Color primaryColor = Color(0xffdc3545);

    return ThemeData(
        fontFamily: "Google-Sans",
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch(accentColor: Color(0x26dc2e45)),
        hintColor: Color(0xFF999999),
        // Widget theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor,
            onPrimary: Color(0xffFFFFFF),
            onSurface: Color(0xff707070), // Disabled button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: primaryColor),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: primaryColor),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          elevation: 5.0,
          unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all<Color>(primaryColor),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary,
          shape: StadiumBorder(),
          disabledColor: Color(0xFFE5E3DC),
          height: 50,
        ),
        sliderTheme: SliderThemeData(
          thumbColor: primaryColor,
          activeTrackColor: primaryColor,
        ),
        cardColor: Colors.white,
        cardTheme: CardTheme(elevation: 5),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
          opacity: 1.0,
        ),
        textTheme: TextTheme(
          headline5: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
          headline6: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          subtitle1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: primaryColor,
          ),
          subtitle2: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          bodyText2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          caption: TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
          bodyText1: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          button: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2.0,
                color: Colors.black,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.7,
                color: Colors.black,
              ),
            ),
            contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
            hintStyle: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            )));
  }
}
