import 'dart:async';
import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/Screens/decider.dart';
import 'package:durood_together_app/Widgets/mohr_widget.dart';
import 'package:durood_together_app/Widgets/my_scaffold.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Reference ref;
  @override
  void initState() {
    super.initState();
    ref = FirebaseStorage.instance.ref().child('splash_message.png');
    Timer(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginDecider()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MyScaffold(
            head1: Container(),
            body: Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: MohrWidget(
                      splash: true,
                      height: 150,
                      width: 150,
                      child: Container(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: const [
                        FittedBox(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 3.0, bottom: 1.0),
                            child: Center(
                              child: Text(
                                "Uniting Believers in Salutation of",
                                style: TextStyle(
                                  fontSize: Constants.appHeading5Size,
                                  color: Constants.appTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 1.0, bottom: 0.0),
                            child: Center(
                              child: Text(
                                "our Beloved Prophet",
                                style: TextStyle(
                                  fontSize: Constants.appHeading5Size,
                                  color: Constants.appTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 0.0, bottom: 0.0),
                            child: Center(
                              child: Text(
                                "Muhammad \uFDFA",
                                style: TextStyle(
                                  fontSize: Constants.appHeading1Size,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.appTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: StreamBuilder<String>(
                          stream: getUrl().asStream(),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            if(snapshot.hasData && snapshot.data!=null){
                              return Image.network(
                                snapshot.data!,
                                fit: BoxFit.fitWidth,
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: LinearProgressIndicator(
                                      backgroundColor: Constants.appTransparent,
                                      color: Constants.appPrimaryColor,
                                      value: loadingProgress.expectedTotalBytes !=
                                          null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              );
                            }
                            return Image.asset(
                              "images/splash_message.png",
                              fit: BoxFit.fitWidth,
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // LinearProgressIndicator(
                          //   color: Constants.appGreyColor,
                          // ),
                          Text(
                            "Powered by Aksiq",
                            style: TextStyle(
                              color: Constants.appGreyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "images/Masjid.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getUrl() async {
    String url =await ref.getDownloadURL();
    return url;
  }
}
