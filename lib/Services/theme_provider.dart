import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  SharedPreferences? mSharedPrefs;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider({required bool darkThemeOn}) {
    _themeMode = darkThemeOn ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance?.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return _themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool darkThemeOn) async {
    mSharedPrefs = await SharedPreferences.getInstance();
    if (darkThemeOn) {
      _themeMode = ThemeMode.dark;
      // mSharedPrefs!.setBool(Constants.darkModeString, true);
    } else {
      _themeMode = ThemeMode.light;
      // mSharedPrefs!.setBool(Constants.darkModeString, false);
    }
    mSharedPrefs!.setBool(Constants.darkModeString, darkThemeOn);
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Constants.appPrimaryDarkColor,
    highlightColor: Constants.appHighlightColor,
    focusColor: Constants.appTextGreenColor,
    colorScheme: const ColorScheme.dark(
      error: Constants.appPrimaryColor,
      primary: Constants.appPrimaryDarkColor,
      secondary: Constants.appPrimaryColor,
    ),
    indicatorColor: Constants.appPrimaryContrastColorLight,
    primaryColor: Constants.appPrimaryDarkColor,
    primaryColorDark: Constants.appPrimaryColor,
    backgroundColor: Constants.appPrimaryContrastColorDark,
    iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: Constants.appPrimaryColor),
    textTheme: const TextTheme(
      headline4: TextStyle(
        color: Constants.appPrimaryColor,
        fontSize: Constants.appHeading4Size,
      ),
      headline3: TextStyle(
        color: Constants.appPrimaryColor,
        fontSize: Constants.appHeading3Size,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(
        color: Constants.appPrimaryColor,
      ),
    ),
  );

  static final lightTheme = ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: Constants.appPrimaryColor,
    highlightColor: Constants.appHighlightColor,
    primaryColor: Constants.appPrimaryColor,
    focusColor: Constants.appTextGreenColor,
    primaryColorDark: Constants.appTextGreenColor,
    backgroundColor: Constants.appPrimaryContrastColorLight,
    colorScheme: const ColorScheme.light(
      error: Constants.appPrimaryColor,
      primary: Constants.appPrimaryColor,
      secondary: Constants.appTextGreenColor,
    ),
    indicatorColor: Constants.appPrimaryColor,
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: Constants.appPrimaryColor),
    textTheme: const TextTheme(
      headline4: TextStyle(
        color: Constants.appPrimaryColor,
        fontSize: Constants.appHeading4Size,
      ),
      headline3: TextStyle(
        color: Constants.appPrimaryColor,
        fontSize: Constants.appHeading3Size,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(
        color: Constants.appPrimaryColor,
      ),
    ),
    iconTheme:
        const IconThemeData(color: Constants.appPrimaryColor, opacity: 0.8),
  );
}
