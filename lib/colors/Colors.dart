import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/constant/Constants.dart';

ThemeData themeData(bool isDarkTheme, BuildContext context) {
  return ThemeData(
    
    primaryColor: isDarkTheme ? Colors.black : Colors.white,
    indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
    hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
    highlightColor: isDarkTheme ? Color(0xff372901) : primaryColor.withOpacity(0.4),
    hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
    focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
    disabledColor: Colors.grey,
    cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
    canvasColor: isDarkTheme ? Colors.black87 : Colors.grey[100],
    brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    dividerColor: isDarkTheme ? Colors.white54 : Colors.black12,
    textTheme: TextTheme(
      bodyText1:  themeTextStyle(isDarkTheme),
      bodyText2:  themeTextStyle(isDarkTheme),
      subtitle1: themeTextStyle(isDarkTheme),
      subtitle2: themeTextStyle(isDarkTheme),
      headline6: themeTextStyle(isDarkTheme),
      headline5: themeTextStyle(isDarkTheme),
    ),
    buttonTheme: Theme.of(context).buttonTheme.copyWith(
      colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light(),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      backgroundColor: isDarkTheme ? Colors.blue[900] : primaryColor,
      iconTheme: IconThemeData(color: Colors.white), systemOverlayStyle: SystemUiOverlayStyle.light, toolbarTextStyle: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ).bodyText2, titleTextStyle: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ).headline6,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor:
      isDarkTheme ? Colors.white60 : Colors.black.withOpacity(0.8),
    ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: isDarkTheme ? Colors.grey : Color(0xffF1F5FB)),
  );
}


TextStyle themeTextStyle(bool isDarkTheme){
  return TextStyle(
    color: isDarkTheme
        ? Colors.white.withOpacity(0.8)
        : Colors.black.withOpacity(0.8),
    fontFamily: poppinsFont,
  );
}
const orangeredColor = const Color(0xffff4500);
const primaryColor = Color(0xFF1B81F8);
const primaryColorLight = Color(0xFFADD8E6);
Color primaryColorDark = Color(0xFF0C4587);
const mattColor = Color(0xFF171717);
const lightGreyColor = Color(0xff333333);
const secondaryColor = Color(0xff434343);
const reddishColor = Color(0xffFF7C7C);
const pinkishColor = Color(0xffFDD7D7);
const screenOverlayShadowColor = Color(0xFF757575);
const Color inactiveIconColor = Color(0xFFB6B6B6);
Color darkGreyColor =  Color(0xFF333333);
Color darkBackgroundColor = Color(0xFF121212);

Color bottomBarIconDark = Colors.white.withOpacity(0.8);
Color bottomBarIconSelectedLight =Colors.white;
