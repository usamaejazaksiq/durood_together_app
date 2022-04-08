import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/Services/Firebase/firestore_service_for_home.dart';
import 'package:durood_together_app/Services/Firebase/refresh_stream.dart';
import 'package:durood_together_app/Services/dialogs.dart';
import 'package:durood_together_app/Widgets/mohr_widget.dart';
import 'package:durood_together_app/Widgets/my_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vibration/vibration.dart';

class CustomTasbeeh extends StatefulWidget {
  const CustomTasbeeh({Key? key}) : super(key: key);

  @override
  _CustomTasbeehState createState() => _CustomTasbeehState();
}

class _CustomTasbeehState extends State<CustomTasbeeh> {
  int value = 0;
  bool canVibrate = true;

  final FireStoreServiceForHome myService = FireStoreServiceForHome();

  @override
  void initState() {
    super.initState();
    canVibrate = true;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Expanded(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    splashColor: Constants.appHighlightColor,
                    onTap: () {
                      setState(() {
                        value = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.replay,
                            color: Constants.appPrimaryColor,
                          ),
                          Text(
                            'Clear',
                            style: TextStyle(
                              color: Constants.appPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Switch.adaptive(
                        activeColor: Constants.appHighlightColor,
                        inactiveThumbColor: Constants.appPrimaryColor,
                        inactiveTrackColor: Constants.appGreyColor,
                        value: canVibrate,
                        onChanged: (bool value) {
                          setState(() {
                            canVibrate = !canVibrate;
                          });
                        },
                      ),
                      const Text(
                        'Vibration',
                        style: TextStyle(
                          color: Constants.appPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    splashColor: Constants.appHighlightColor,
                    onTap: () {
                      setState(() {
                        getDialog(
                          context: context,
                          closeText: "No",
                          content: Text(
                            value.toString(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          title: Text(
                            "Are you sure to save count?",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          okText: "Yes",
                          okOnPressed: () async {
                            Navigator.pop(context);
                            getWaitingDialog(context: context);
                            try {
                              await myService.saveLastCount(value);
                              setState(() {
                                value = 0;
                              });

                            } finally {
                              RefreshStream.updateStreamToRefresh();
                              Navigator.pop(context);
                            }
                          },
                        );
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.check,
                            color: Constants.appPrimaryColor,
                          ),
                          Text(
                            'Save',
                            style: TextStyle(
                              color: Constants.appPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (canVibrate) {
                      if (value%100 == 32) {
                        Vibration.vibrate(intensities: [63], duration: 500);
                      } else if (value%100 == 65) {
                        Vibration.vibrate(intensities: [127], duration: 500);
                      } else if (value%100 == 99) {
                        Vibration.vibrate(intensities: [255], duration: 500);
                      }
                      else{
                        Vibration.vibrate(intensities: [31], duration: 50);
                      }
                    }
                    value++;
                  });
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: MohrWidget(
                        height: 350,
                        width: 320,
                        child: CircularPercentIndicator(
                          radius: 100,
                          lineWidth: 50.0,
                          percent: (value % 100) / 100,
                          center: Text(
                            value.toString(),
                            style: const TextStyle(
                              color: Constants.appTextGreenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Constants.appHeading1Size,
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.butt,
                          backgroundColor: Constants.appTransparent,
                          progressColor: value%100 < 33
                              ? Constants.appHighlightColor
                              : value%100 < 66
                                  ? Constants.appPrimaryContrastColorLight
                                  : Constants.appTextGreenColor,
                        ),
                      ),
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
