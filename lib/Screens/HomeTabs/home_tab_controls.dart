import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/Screens/HomeTabs/Home/home.dart';
import 'package:durood_together_app/Screens/HomeTabs/Reports/report_tab_controls.dart';
import 'package:durood_together_app/Screens/HomeTabs/Settings/settings.dart';
import 'package:durood_together_app/Screens/HomeTabs/Tasbeeh/custom_tasbeeh.dart';
import 'package:durood_together_app/Widgets/fitted_text.dart';
import 'package:flutter/material.dart';

class MyHomeTabs extends StatefulWidget {
  const MyHomeTabs({Key? key}) : super(key: key);

  @override
  State<MyHomeTabs> createState() => _MyHomeTabsState();
}

class _MyHomeTabsState extends State<MyHomeTabs>
    with SingleTickerProviderStateMixin {
  late final _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      
      vsync: this,
      length: getTabs().length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _tabController.index = 0;
        return false;
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: getTabs().length,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: getPages(),
            controller: _tabController,
          ),
        ),
      ),
    );
  }

  Widget menu() {
    return TabBar(
      unselectedLabelColor: Theme.of(context).primaryColorDark,
      labelColor: Constants.appHighlightColor,
      indicatorColor: Constants.appTransparent,
      tabs: getTabs(),
      controller: _tabController,
    );
  }

  Map<Widget, Widget> getDataForTabs() {
    return {
      const Tab(
        child: FittedText("Home"),
        icon: Icon(Icons.home),
      ): const Home(), //const Home(),
      const Tab(
        child: FittedText("Tasbeeh"),
        icon: Icon(Icons.wb_sunny_outlined),
      ): const CustomTasbeeh(),
      const Tab(
        child: FittedText("Reports"),
        icon: Icon(Icons.bar_chart),
      ): const ReportTabs(),
      const Tab(
        child: FittedText("Settings"),
        icon: Icon(Icons.settings),
      ): const SettingsScreen(),
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
