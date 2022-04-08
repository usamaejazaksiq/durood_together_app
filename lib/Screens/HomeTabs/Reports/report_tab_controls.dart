import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/AppReserved/translators.dart';
import 'package:durood_together_app/Models/ReportsScreenData.dart';
import 'package:durood_together_app/Models/city_reports_data.dart';
import 'package:durood_together_app/Models/country_reports_data.dart';
import 'package:durood_together_app/Models/user_reports_data.dart';
import 'package:durood_together_app/Screens/HomeTabs/Reports/report_screen_template.dart';
import 'package:durood_together_app/Services/Firebase/firestore_service_for_reports.dart';
import 'package:durood_together_app/Services/Firebase/refresh_stream.dart';
import 'package:durood_together_app/Widgets/fitted_text.dart';
import 'package:durood_together_app/Widgets/my_scaffold.dart';
import 'package:flutter/material.dart';

class ReportTabs extends StatefulWidget {
  const ReportTabs({Key? key}) : super(key: key);

  @override
  _ReportTabsState createState() => _ReportTabsState();
}

class _ReportTabsState extends State<ReportTabs> with TickerProviderStateMixin {
  TabController? _tabController;
  int? selectedMonth;
  int? selectedYear;

  String? topCityName;
  String? topCityCount;

  String? topCountryName;
  String? topCountryCount;

  String? myCountryName;
  String? myCount;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: getTabs().length);

    selectedMonth = DateTime.now().month - 1;
    selectedYear = DateTime.now().year;

    topCityName = "Karachi";
    topCityCount = "0";

    topCountryName = "Pakistan";
    topCountryCount = "0";
  }

  FireStoreServiceForReports myService = FireStoreServiceForReports();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      head1: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: getDropDown(),
          ),
          getMonths(),
        ],
      ),
      head2: TabBar(
        controller: _tabController,
        unselectedLabelColor: Constants.appPrimaryColor,
        labelColor: Constants.appHighlightColor,
        labelStyle: const TextStyle(
          fontFamily: "Poppins",
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.normal,
        ),
        indicatorColor: Constants.appPrimaryColor.withOpacity(0),
        tabs: getTabs(),
      ),
      body: Expanded(
        child: Center(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: _tabController,
            children: getPages(),
          ),
        ),
      ),
    );
  }

  Widget getMonths() {
    return SizedBox(
      height: 50.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: getMonthTabs()),
      ),
    );
  }

  List<Widget> getMonthTabs() {
    List<Widget> widgets = [];
    int start = 0;
    int end = Constants.month.length;
    if (selectedYear == 2021) {
      start = 3;
      if (selectedMonth! < 3) {
        selectedMonth = 3;
      }
    }
    if (selectedYear == DateTime.now().year) {
      end = DateTime.now().month;
      if (selectedMonth! > DateTime.now().month - 1) {
        selectedMonth = DateTime.now().month - 1;
      }
    }
    for (int i = start; i < end; i++) {
      widgets.add(
        SizedBox(
          width: 80.0,
          child: Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedMonth = i;
                });
              },
              child: Text(
                Constants.month[i],
                style: TextStyle(
                  color: selectedMonth == i
                      ? Constants.appHighlightColor
                      : Constants.appPrimaryColor,
                  fontSize: selectedMonth == i
                      ? Constants.appHeading3Size
                      : Constants.appHeading4Size,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  Widget getDropDown() {
    return DropdownButton<int>(
      underline: const SizedBox(),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Constants.appPrimaryColor,
      ),
      style: const TextStyle(
        fontFamily: 'Poppins',
        color: Constants.appPrimaryColor,
        fontSize: Constants.appHeading2Size,
      ),
      // dropdownColor: Theme.of(context).backgroundColor,
      dropdownColor: Theme.of(context).backgroundColor,
      value: selectedYear,
      items: dropdownItems(),
      onChanged: (int? value) {
        setState(() {
          selectedYear = value;
        });
      },
    );
  }

  List<DropdownMenuItem<int>> dropdownItems() {
    List<DropdownMenuItem<int>> menuItems = [];
    int currentYear = DateTime.now().year;
    for (int i = Constants.appStartingYear; i <= currentYear; i++) {
      menuItems.add(
        DropdownMenuItem(child: Text(i.toString()), value: i),
      );
    }
    return menuItems;
  }

  Widget menu() {
    return TabBar(
      indicator: const BoxDecoration(
        color: Constants.appTextGreenColor,
      ),
      unselectedLabelColor: Constants.appTextGreenColor,
      labelColor: Constants.appHighlightColor,
      indicatorColor: Constants.appTransparent,
      tabs: getTabs(),
    );
  }

  Map<Widget, Widget> getDataForTabs() {
    return {
      const Tab(
        child: FittedText(
          "Personal",
          style: TextStyle(
            fontSize: Constants.appHeading6Size,
          ),
        ),
      ): StreamBuilder(
        stream: RefreshStream.onRefreshStatsStreamCtrl,
        builder: (context, snap) {
          return StreamBuilder<Map<String, dynamic>>(
            stream: myService.getUserMonthLogs(
              selectedMonth ?? DateTime.now().month - 1,
              selectedYear ?? DateTime.now().year,
            ),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> logSnapshot) {
              if (logSnapshot.hasData && logSnapshot.data != null) {
                return StreamBuilder<ReportsScreenData>(
                  stream: myService.getUserDataFromReports(
                      UserReportsData.empty(),
                      selectedMonth ?? DateTime.now().month - 1,
                      selectedYear ?? DateTime.now().year),
                  builder: (BuildContext context,
                      AsyncSnapshot<ReportsScreenData> reportDataSnapshot) {
                    if (logSnapshot.hasData && logSnapshot.data != null) {
                      return ReportScreenTemplate(
                        pageId: Constants.personalPageId,
                        mohrLabel:
                            "My count\n${Constants.months[selectedMonth ?? 0]}",
                        year: selectedYear.toString(),
                        month: Constants.months[selectedMonth ?? 0],
                        data: reportDataSnapshot.data ??
                            translateUserDataForReports(
                                UserReportsData.empty()),
                        userCount: logSnapshot.data!['count'].toString(),
                        logs: logSnapshot.data!['logs'],
                      );
                    } else {
                      return ReportScreenTemplate(
                        pageId: Constants.personalPageId,
                        mohrLabel:
                            "My count\n${Constants.months[selectedMonth ?? 0]}",
                        year: selectedYear.toString(),
                        month: Constants.months[selectedMonth ?? 0],
                        data: translateUserDataForReports(
                            UserReportsData.empty()),
                        userCount: logSnapshot.data!['count'].toString(),
                        logs: logSnapshot.data!['logs'],
                      );
                    }
                  },
                );
              } else {
                return ReportScreenTemplate(
                  pageId: Constants.personalPageId,
                  mohrLabel:
                      "My ${Constants.months[selectedMonth ?? 0]}\ncount",
                  year: selectedYear.toString(),
                  month: Constants.months[selectedMonth ?? 0],
                  data: translateUserDataForReports(UserReportsData.empty()),
                );
              }
            },
          );
        },
      ),
      const Tab(
        child: FittedText(
          "City",
          style: TextStyle(
            fontSize: Constants.appHeading6Size,
          ),
        ),
      ): StreamBuilder<ReportsScreenData>(
          stream: myService.getCityReportsData(
              selectedMonth ?? DateTime.now().month,
              selectedYear ?? DateTime.now().year),
          builder: (BuildContext context,
              AsyncSnapshot<ReportsScreenData> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ReportScreenTemplate(
                mohrLabel: "Rank 1",
                pageId: Constants.countryPageId,
                year: selectedYear.toString(),
                month: Constants.months[selectedMonth ?? 0],
                data: snapshot.data ??
                    translateCityDataForReports(CityReportsData.empty()),
              );
            } else {
              return ReportScreenTemplate(
                mohrLabel: "Rank 1",
                pageId: Constants.cityPageId,
                year: selectedYear.toString(),
                month: Constants.months[selectedMonth ?? 0],
                data: translateCityDataForReports(CityReportsData.empty()),
              );
            }
          }),
      const Tab(
        child: FittedText(
          "Country",
          style: TextStyle(
            fontSize: Constants.appHeading6Size,
          ),
        ),
      ): StreamBuilder<ReportsScreenData>(
        stream: myService.getCountryReportsData(
            selectedMonth ?? DateTime.now().month,
            selectedYear ?? DateTime.now().year),
        builder:
            (BuildContext context, AsyncSnapshot<ReportsScreenData> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ReportScreenTemplate(
              mohrLabel: "Rank 1",
              pageId: Constants.countryPageId,
              year: selectedYear.toString(),
              month: Constants.months[selectedMonth ?? 0],
              data: snapshot.data ??
                  translateCountryDataForReports(CountryReportsData.empty()),
            );
          } else {
            return ReportScreenTemplate(
              mohrLabel: "Rank 1",
              pageId: Constants.countryPageId,
              year: selectedYear.toString(),
              month: Constants.months[selectedMonth ?? 0],
              data: translateCountryDataForReports(CountryReportsData.empty()),
            );
          }
        },
      ),
    };
  }

  List<Widget> getTabs() {
    List<Widget> tabs = [];
    Map<Widget, Widget> tabData = getDataForTabs();
    for (Widget tab in tabData.keys) {
      tabs.add(tab);
    }
    return tabs;
  }

  List<Widget> getPages() {
    List<Widget> pages = [];
    Map<Widget, Widget> tabData = getDataForTabs();
    for (Widget tab in tabData.keys) {
      Widget page = tabData[tab] ?? Container();
      pages.add(page);
    }
    return pages;
  }
}
