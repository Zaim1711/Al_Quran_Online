import 'package:flutter/material.dart';

const Color appBlue = Color(0xFF030F2C);
const Color appBlueDark = Color(0xFF131927);
const Color appBlueLight = Color(0xff2F4372);
const Color appYellowLight = Color.fromARGB(255, 245, 228, 162);
const Color appYellow = Color(0xffE7D37F);
const Color appOrange = Color(0xffFD9B63);
const Color appWhite = Color.fromRGBO(254, 251, 251, 0.991);

final ThemeData appLight = ThemeData(
  brightness: Brightness.light,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appBlueDark,
  ),
  primaryColor: appWhite,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(backgroundColor: appBlue),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: appBlue)),
  listTileTheme: const ListTileThemeData(textColor: appBlueDark),
  tabBarTheme: const TabBarThemeData(
    labelColor: appBlueDark,
    unselectedLabelColor: Colors.grey,
    indicatorColor: appBlueDark,
  ),
);

final ThemeData appDark = ThemeData(
  brightness: Brightness.dark,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appWhite,
  ),
  primaryColor: appBlue,
  scaffoldBackgroundColor: appBlueDark,
  appBarTheme: const AppBarTheme(backgroundColor: appBlueDark),
  textTheme: const TextTheme(bodySmall: TextStyle(color: appWhite)),
  listTileTheme: const ListTileThemeData(textColor: appWhite),
  tabBarTheme: const TabBarThemeData(
    labelColor: appWhite,
    unselectedLabelColor: Colors.grey,
    indicatorColor: appWhite,
  ),
);
