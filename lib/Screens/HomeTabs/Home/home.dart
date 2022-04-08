import 'dart:developer';

import 'package:durood_together_app/AppReserved/city_codes.dart';
import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/AppReserved/helpers.dart';
import 'package:durood_together_app/Models/home_screen_general_data.dart';
import 'package:durood_together_app/Models/home_screen_user_data.dart';
import 'package:durood_together_app/Models/push_notification.dart';
import 'package:durood_together_app/Services/Firebase/firestore_service_for_home.dart';
import 'package:durood_together_app/Services/Firebase/refresh_stream.dart';
import 'package:durood_together_app/Services/dialogs.dart';
import 'package:durood_together_app/Widgets/notification_badge.dart';
import 'package:durood_together_app/Widgets/scrollable_text.dart';
import 'package:durood_together_app/Widgets/fitted_text.dart';
import 'package:durood_together_app/Widgets/app_elevated_button.dart';
import 'package:durood_together_app/Widgets/app_text_field.dart';
import 'package:durood_together_app/Services/thousand_separator.dart';
import 'package:durood_together_app/Widgets/mohr_widget.dart';
import 'package:durood_together_app/Widgets/my_scaffold.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:overlay_support/overlay_support.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FocusNode countFocusNode = FocusNode();
  final TextEditingController countTextController = TextEditingController();
  final digitMaskFormatter = MaskTextInputFormatter(
    filter: {"#": RegExp(r'[0-9]')},
  );

  int count = 0;
  String lastCount = '';
  late final FireStoreServiceForHome myService;
  late HomeScreenGeneralData? screenGeneralData;
  late HomeScreenUserData? screenUserData;

  late final FirebaseMessaging _messaging;

  @override
  void initState() {
    myService = FireStoreServiceForHome();
    screenGeneralData = HomeScreenGeneralData.empty();
    screenUserData = HomeScreenUserData.empty();
    checkForInitialMessage();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //To hide keyboard on outside tab
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MyScaffold(
        homeResize: false,
        //Main Heading
        head1: const FittedText(
          "Cumulative to Date Count",
          style: TextStyle(
            color: Constants.appPrimaryColor,
            fontSize: Constants.appHeading3Size - 1,
          ),
          padding: 8.0,
        ),
        //Heading 2
        head2: buildHeadDivider(),
        head2Padding: 4.0,
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            //Mohr Image
            MohrWidget(
              home: true,
              child: buildMohrData(),
            ),
            //Row for Top Country and City
            getTopDataRow(),
            //TextField for Durood Count
            getDuroodCountField(),
            //SaveCountButton
            //Last Durood Labels
            StreamBuilder(
                stream: RefreshStream.onRefreshStatsStreamCtrl,
                builder: (context, snapshot) {
                  return getBasicStats();
                }),
            getLastDuroodLabels(),
            //Basic Stats
          ],
        ),
      ),
    );
  }

  Widget getTopDataRow() {
    return StreamBuilder<HomeScreenGeneralData>(
      stream: myService.getHomeScreenGeneralData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Center(
          //   child: Padding(
          //     padding: const EdgeInsets.all(15.0),
          //     child: LinearProgressIndicator(
          //         backgroundColor: Theme.of(context).primaryColor,
          //         color: Theme.of(context).highlightColor),
          //   ),
          // );
          return Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScrollableText(
                      screenGeneralData!.topCountryName,
                      // height: 16.0,
                      width: 80.0,
                      style: const TextStyle(
                        color: Constants.appPrimaryColor,
                        fontSize: Constants.appHeading7Size,
                      ),
                    ),
                    FittedText(
                      convertNumber(screenGeneralData!.topCountryCount),
                      style: const TextStyle(
                        color: Constants.appPrimaryColor,
                      ),
                      alignment: TextAlign.left,
                    ),
                    //Rank
                    const FittedText(
                      'Top Country',
                      style: TextStyle(
                        color: Constants.appHighlightColor,
                      ),
                      alignment: TextAlign.left,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ScrollableText(
                      screenGeneralData!.topCityName,
                      // height: 16.0,
                      width: 80.0,
                      reverse: true,
                      style: const TextStyle(
                        color: Constants.appPrimaryColor,
                        fontSize: Constants.appHeading7Size,
                      ),
                    ),
                    FittedText(
                      convertNumber(screenGeneralData!.topCityCount),
                      style: const TextStyle(
                        color: Constants.appPrimaryColor,
                      ),
                      alignment: TextAlign.right,
                    ),
                    //Rank
                    const FittedText(
                      'Top City',
                      style: TextStyle(
                        color: Constants.appHighlightColor,
                      ),
                      alignment: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data != null) {
            screenGeneralData?.topCityName = snapshot.data!.topCityName;
            screenGeneralData?.topCountryName = snapshot.data!.topCountryName;
            screenGeneralData?.topCityCount = snapshot.data!.topCityCount;
            screenGeneralData?.topCountryCount = snapshot.data!.topCountryCount;
          }
          if (screenGeneralData!.topCityName == "" ||
              CityCodes.cities[screenGeneralData!.topCityName] == null) {}

          if (screenGeneralData!.topCountryName == "" ||
              Constants.countryCodes[screenGeneralData!.topCountryName] ==
                  null) {}

          return Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScrollableText(
                      screenGeneralData!.topCountryName,
                      // height: 16.0,
                      width: 80.0,
                      style: const TextStyle(
                        color: Constants.appPrimaryColor,
                        fontSize: Constants.appHeading7Size,
                      ),
                    ),
                    FittedText(
                      convertNumber(screenGeneralData!.topCountryCount),
                      style: const TextStyle(
                        color: Constants.appPrimaryColor,
                      ),
                      alignment: TextAlign.left,
                    ),
                    //Rank
                    const FittedText(
                      'Top Country',
                      style: TextStyle(
                        color: Constants.appHighlightColor,
                      ),
                      alignment: TextAlign.left,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ScrollableText(
                      screenGeneralData!.topCityName,
                      // height: 16.0,
                      width: 80.0,
                      reverse: true,
                      style: const TextStyle(
                        color: Constants.appPrimaryColor,
                        fontSize: Constants.appHeading7Size,
                      ),
                    ),
                    FittedText(
                      convertNumber(screenGeneralData!.topCityCount),
                      style: const TextStyle(
                        color: Constants.appPrimaryColor,
                      ),
                      alignment: TextAlign.right,
                    ),
                    //Rank
                    const FittedText(
                      'Top City',
                      style: TextStyle(
                        color: Constants.appHighlightColor,
                      ),
                      alignment: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return FittedText(
            "No data available",
            style: TextStyle(color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  Widget getDuroodCountField() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
        left: 10,
        right: 10,
        bottom: 20,
      ),
      child: AppTextField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          count = int.tryParse(digitMaskFormatter.getUnmaskedText()) ?? 0;
        },
        controller: countTextController,
        focusNode: countFocusNode,
        hintText: "Enter Count",
        formatter: [
          FilteringTextInputFormatter.digitsOnly,
          ThousandsSeparatorInputFormatter(),
          LengthLimitingTextInputFormatter(7),
        ],
        suffix: getSaveButton(),
      ),
    );
  }

  Widget getSaveButton() {
    return AppElevatedButton(
      buttonText: "Save",
      onPressed: () async {
        countFocusNode.unfocus();
        lastCount = countTextController.text;
        count = int.tryParse(lastCount.replaceAll(',', '')) ?? 0;
        if (count > 0) {
          if (count >= 100000) {
            getDialog(
              context: context,
              closeText: 'No',
              title: const Text('Are you sure'),
              content: Text("Save $count Duroods?"),
              okText: "Yes",
              okOnPressed: () async {
                Navigator.pop(context);
                getWaitingDialog(context: context);
                try {
                  await myService.saveLastCount(count);
                  countTextController.text = '';
                  count = 0;
                } finally {
                  Navigator.pop(context);
                }
              },
            );
          } else {
            getWaitingDialog(context: context);
            try {
              await myService.saveLastCount(count);
              countTextController.text = '';
              count = 0;
            } finally {
              RefreshStream.updateStreamToRefresh();
              Navigator.pop(context);
            }
          }
        } else {
          final snackBar = SnackBar(
            duration: const Duration(seconds: 2),
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            backgroundColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            content: Text(
              'Please Enter Some Count',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  Widget getLastDuroodLabels() {
    return StreamBuilder<HomeScreenUserData>(
      stream: myService.getHomeScreenUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasData) {
          if (snapshot.data != null) {
            screenUserData?.lastCount = snapshot.data!.lastCount;
          }
          return Visibility(
            visible: screenUserData?.lastCount != 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Delete Last Count:",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        splashColor: Constants.appHighlightColor,
                        onTap: () {
                          getDialog(
                            context: context,
                            closeText: 'No',
                            title: const Text('Are you sure'),
                            content: Text(
                                "Delete Last Entered ${screenUserData?.lastCount} Duroods?"),
                            okText: "Yes",
                            okOnPressed: () async {
                              Navigator.pop(context);
                              getWaitingDialog(context: context);
                              try {
                                await myService.deleteLastCount();
                              } finally {
                                RefreshStream.updateStreamToRefresh();
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Icon(
                            Icons.delete, //"Delete Last Count?",
                            color: Theme.of(context).highlightColor,
                            size: Constants.appHeading4Size,
                            // style: Constants.appLabelStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildMohrData() {
    return StreamBuilder<HomeScreenGeneralData>(
      stream: myService.getHomeScreenGeneralData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Monthly Global Count
              Padding(
                padding: const EdgeInsets.only(
                  top: 90.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120.0,
                    maxWidth: 120.0,
                    minHeight: 30.0,
                    maxHeight: 30.0,
                  ),
                  child: FittedText(
                    convertNumber("0"),
                    style: Constants.appMohrHeadStyle,
                  ),
                ),
              ),
              //Count Label
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 80.0,
                  maxWidth: 80.0,
                  minHeight: 30.0,
                  maxHeight: 100.0,
                ),
                child: FittedText(
                  '${Constants.months[DateTime.now().month - 1]}\nContribution',
                  style: const TextStyle(
                    color: Constants.appTextGreenColor,
                    fontSize: Constants.appHeading3Size,
                    // Index 0 Contains Name
                  ),
                ),
              ),
            ],
          );
          // return Center(
          //   child: Padding(
          //     padding: const EdgeInsets.all(15.0),
          //     child: LinearProgressIndicator(
          //         backgroundColor: Theme.of(context).primaryColor,
          //         color: Theme.of(context).highlightColor),
          //   ),
          // );
        } else if (snapshot.hasData) {
          if (snapshot.data != null) {
            screenGeneralData?.currentMonthCount =
                snapshot.data!.currentMonthCount;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Monthly Global Count
              Padding(
                padding: const EdgeInsets.only(
                  top: 90.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120.0,
                    maxWidth: 120.0,
                    minHeight: 30.0,
                    maxHeight: 30.0,
                  ),
                  child: FittedText(
                    convertNumber(screenGeneralData!.currentMonthCount),
                    style: Constants.appMohrHeadStyle,
                  ),
                ),
              ),
              //Count Label
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 80.0,
                  maxWidth: 80.0,
                  minHeight: 30.0,
                  maxHeight: 100.0,
                ),
                child: FittedText(
                  '${Constants.months[DateTime.now().month - 1]}\nContribution',
                  style: const TextStyle(
                    color: Constants.appTextGreenColor,
                    fontSize: Constants.appHeading3Size,
                    // Index 0 Contains Name
                  ),
                ),
              ),
            ],
          );
        } else {
          return FittedText(
            "No data available",
            style: TextStyle(color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  Widget buildHeadDivider() {
    return StreamBuilder<HomeScreenGeneralData>(
      stream: myService.getHomeScreenGeneralData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Center(
          //   child: Padding(
          //     padding: const EdgeInsets.all(15.0),
          //     child: LinearProgressIndicator(
          //         backgroundColor: Theme.of(context).primaryColor,
          //         color: Theme.of(context).highlightColor),
          //   ),
          // );
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Opacity(opacity: 0, child: Icon(Icons.help)),
              Text(
                "-",
                style: TextStyle(
                  color: Constants.appHighlightColor,
                  fontSize: Constants.appHeading4Size,
                ),
              ),
              Tooltip(
                message: "Last Sync: Loading",
                waitDuration: Duration(seconds: 2),
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(Icons.info),
              ),
            ],
          );
        } else if (snapshot.hasData) {
          if (snapshot.data != null) {
            screenGeneralData?.cummulativeCount =
                snapshot.data!.cummulativeCount;
            screenGeneralData?.lastSync = snapshot.data!.lastSync;
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Opacity(opacity: 0, child: Icon(Icons.help)),
              Text(
                screenGeneralData!.cummulativeCount,
                style: const TextStyle(
                  color: Constants.appHighlightColor,
                  fontSize: Constants.appHeading4Size,
                ),
              ),
              Tooltip(
                message: "Last Sync: ${screenGeneralData!.lastSync}",
                waitDuration: const Duration(seconds: 2),
                triggerMode: TooltipTriggerMode.tap,
                child: const Icon(Icons.info),
              ),
            ],
          );
        } else {
          return FittedText(
            "No data available",
            style: TextStyle(color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  Widget getBasicStats() {
    return StreamBuilder<Map<String, String>>(
      stream: myService.getRecentStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Center(
          //   child: Padding(
          //     padding: const EdgeInsets.all(15.0),
          //     child: LinearProgressIndicator(
          //         backgroundColor: Theme.of(context).primaryColor,
          //         color: Theme.of(context).highlightColor),
          //   ),
          // );
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Column(
                    children: [
                      const FittedText('Your latest Durood Salawat Count'),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            const Divider(
                              color: Constants.appPrimaryColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    FittedText(
                                      convertNumber(
                                          "${screenUserData?.yesterdayCount}"),
                                    ),
                                    FittedText(
                                      "Yesterday",
                                      style: TextStyle(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 60,
                                  child: VerticalDivider(
                                      color: Constants.appPrimaryColor),
                                ),
                                Column(
                                  children: [
                                    FittedText(
                                      convertNumber(
                                          "${screenUserData?.todayCount}"),
                                    ),
                                    FittedText(
                                      "Today",
                                      style: TextStyle(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 60,
                                  child: VerticalDivider(
                                      color: Constants.appPrimaryColor),
                                ),
                                Column(
                                  children: [
                                    FittedText(
                                      convertNumber(
                                          "${screenUserData?.thisWeekCount}"),
                                    ),
                                    FittedText(
                                      "Last 7 Days",
                                      style: TextStyle(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              color: Constants.appPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data != null) {
            screenUserData?.todayCount =
                int.tryParse(snapshot.data!["today"] ?? "0") ?? 0;
            screenUserData?.yesterdayCount =
                int.tryParse(snapshot.data!["yesterday"] ?? "0") ?? 0;
            screenUserData?.thisWeekCount =
                int.tryParse(snapshot.data!["weekly"] ?? "0") ?? 0;
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Column(
                    children: [
                      const FittedText('Your latest Durood Salawat Count'),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            const Divider(
                              color: Constants.appPrimaryColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    FittedText(
                                      convertNumber(
                                          "${screenUserData?.yesterdayCount}"),
                                    ),
                                    FittedText(
                                      "Yesterday",
                                      style: TextStyle(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 60,
                                  child: VerticalDivider(
                                      color: Constants.appPrimaryColor),
                                ),
                                Column(
                                  children: [
                                    FittedText(
                                      convertNumber(
                                          "${screenUserData?.todayCount}"),
                                    ),
                                    FittedText(
                                      "Today",
                                      style: TextStyle(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 60,
                                  child: VerticalDivider(
                                      color: Constants.appPrimaryColor),
                                ),
                                Column(
                                  children: [
                                    FittedText(
                                      convertNumber(
                                          "${screenUserData?.thisWeekCount}"),
                                    ),
                                    FittedText(
                                      "Last 7 Days",
                                      style: TextStyle(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              color: Constants.appPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return FittedText(
            "No data yet",
            style: TextStyle(color: Theme.of(context).errorColor),
          );
        }
      },
    );
  }

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
      });
    } else {
      log('User declined or has not accepted permission');
    }
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    log("Handling a background message: ${message.messageId}");
  }

  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
    }
  }
}
