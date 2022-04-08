import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/Screens/Splash/splash_screen.dart';
import 'package:durood_together_app/Services/Firebase/authentication.dart';
import 'package:durood_together_app/Services/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences mSharedPrefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(ChangeNotifierProvider(
      create: (BuildContext context) {
        return ThemeProvider(
            darkThemeOn:
                mSharedPrefs.getBool(Constants.darkModeString) ?? false);
      },
      child: const MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (BuildContext context) => Auth(),
            ),
          ],
          child: OverlaySupport(
            child: MaterialApp(
              title: 'Durood Together',
              debugShowCheckedModeBanner: false,
              themeMode: themeProvider.themeMode,
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              home: const SplashScreen(),
            ),
          ),
        );
      },
    );
  }
}
