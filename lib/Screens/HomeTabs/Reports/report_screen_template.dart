import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/AppReserved/helpers.dart';
import 'package:durood_together_app/Models/ReportsScreenData.dart';
import 'package:durood_together_app/Models/user_log.dart';
import 'package:durood_together_app/Widgets/scrollable_text.dart';
import 'package:durood_together_app/Widgets/fitted_rich_text.dart';
import 'package:durood_together_app/Widgets/fitted_text.dart';
import 'package:durood_together_app/Widgets/mohr_widget.dart';
import 'package:flutter/material.dart';

class ReportScreenTemplate extends StatefulWidget {
  final int pageId; //0 for city, 1 for country, 2 for personal
  final String mohrLabel;
  final ReportsScreenData data;
  final String month;
  final String year;
  final String? userCount;
  final List<UserLog>? logs;

  const ReportScreenTemplate({
    Key? key,
    required this.mohrLabel,
    required this.pageId,
    required this.month,
    required this.year,
    required this.data,
    this.userCount,
    this.logs,
  }) : super(key: key);

  @override
  State<ReportScreenTemplate> createState() => _ReportScreenTemplateState();
}

class _ReportScreenTemplateState extends State<ReportScreenTemplate>
    with AutomaticKeepAliveClientMixin {
  String tableHead = "";

  @override
  void initState() {
    super.initState();
    tableHead = widget.pageId == Constants.personalPageId
        ? "My"
        : widget.pageId == Constants.cityPageId
            ? "City"
            : "Country";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Column(
          children: <Widget>[
            //Mohr Image
            MohrWidget(
              child: buildMohrData(),
            ),
            //Row for Top Country and City
            getTopDataRow(),
            const SizedBox(
              height: 25,
            ),
            getPersonalRanking(),
            const SizedBox(
              height: 15,
            ),
            getTable(),
            // getTable(),
          ],
        ),
      ),
    );
  }

  Column buildMohrData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Monthly Global Count
        Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
          ),
          child: widget.pageId == Constants.personalPageId
              ? const Icon(
                  Icons.person,
                  size: 50,
                  color: Constants.appTextGreenColor,
                )
              : widget.data.mohrFlag != ""
                  ? Image.asset(
                      'icons/flags/png/${widget.data.mohrFlag}.png',
                      package: 'country_icons',
                      height: 50,
                      width: 50,
                    )
                  : const SizedBox(
                      height: 50,
                      width: 50,
                    ),
        ),
        //Count Label
        Visibility(
          visible: widget.data.mohrName != "",
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ScrollableText(
              widget.data.mohrName,
              style: const TextStyle(
                color: Constants.appTextGreenColor,
                fontSize: Constants.appHeading5Size,
              ),
              width: 80.0,
              // height: 20.0,
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 100.0,
            maxWidth: 100.0,
          ),
          child: FittedText(
            widget.pageId == Constants.personalPageId
                ? convertNumber(widget.userCount??"0")
                : convertNumber(widget.data.mohrCount),
            style: const TextStyle(
              color: Constants.appTextGreenColor,
              fontSize: Constants.appHeading4Size,
              // Index 0 Contains Name
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 60.0,
            maxWidth: 60.0,
          ),
          child: FittedText(
            widget.mohrLabel,
            style: const TextStyle(
              color: Constants.appTextGreenColor,
              fontSize: Constants.appHeading7Size,
              // Index 0 Contains Name
            ),
          ),
        ),
      ],
    );
  }

  Widget getTopDataRow() {
    return Visibility(
      visible: widget.pageId != Constants.personalPageId,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrollableText(
                  widget.data.rank2Name,
                  // height: 16.0,
                  width: 80.0,
                  style: const TextStyle(
                    color: Constants.appPrimaryColor,
                    fontSize: Constants.appHeading7Size,
                  ),
                ),
                //CountryCount
                FittedText(
                  widget.data.rank2Count == ""
                      ? ""
                      : convertNumber(widget.data.rank2Count),
                  style: const TextStyle(
                    color: Constants.appPrimaryColor,
                  ),
                  alignment: TextAlign.left,
                ),
                //Rank
                FittedText(
                  widget.pageId == Constants.personalPageId
                      ? 'My Country'
                      : 'Rank 2',
                  style: const TextStyle(
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
                  widget.data.rank3Name,
                  // height: 16.0,
                  reverse: true,
                  width: 80.0,
                  style: const TextStyle(
                    color: Constants.appPrimaryColor,
                    fontSize: Constants.appHeading7Size,
                  ),
                ),
                //CityCount
                FittedText(
                  widget.data.rank3Count == ""
                      ? ""
                      : convertNumber(widget.data.rank3Count),
                  style: const TextStyle(
                    color: Constants.appPrimaryColor,
                  ),
                  alignment: TextAlign.right,
                ),
                //Rank
                FittedText(
                  widget.pageId == Constants.personalPageId
                      ? 'My City'
                      : 'Rank 3',
                  style: const TextStyle(
                    color: Constants.appHighlightColor,
                  ),
                  alignment: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getTable() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              minWidth: 400,
              maxHeight: 50,
              minHeight: 50,
            ),
            child: FittedText(
              '$tableHead Contribution',
              style: const TextStyle(
                color: Constants.appTextColor,
                fontSize: Constants.appHeading3Size,
              ),
            ),
          ),
          widget.pageId == Constants.personalPageId
              ? getPersonalReport()
              : getLocationReport(),
          // StickyHeaderBuilder(
          //   builder: (BuildContext context, double stuckAmount) {
          //     stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
          //     return Container(
          //       color: Color.lerp(Constants.appTransparent,
          //           Theme.of(context).backgroundColor, stuckAmount),
          //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //       alignment: Alignment.centerLeft,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           FittedText(
          //             "Rank",
          //             style: const TextStyle(
          //               color: Constants.appHighlightColor,
          //               fontSize: Constants.appHeading5Size,
          //             ),
          //           ),
          //           FittedText(
          //             tableHead,
          //             style: const TextStyle(
          //               color: Constants.appHighlightColor,
          //               fontSize: Constants.appHeading5Size,
          //             ),
          //           ),
          //           const FittedText(
          //             'Count',
          //             style: TextStyle(
          //               color: Constants.appHighlightColor,
          //               fontSize: Constants.appHeading5Size,
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          //   content: Table(
          //     children: [
          //       for (int i = 0; i < widget.data.tableRows.length; i++)
          //         TableRow(
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.symmetric(
          //                 vertical: 4.0,
          //               ),
          //               child: Center(
          //                 child: Text(
          //                   widget.data.tableRows[i].firstColumn,
          //                   style: const TextStyle(
          //                     color: Constants.appTextColor,
          //                     fontSize: Constants.appHeading6Size,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.symmetric(vertical: 4.0),
          //               child: Visibility(
          //                 visible: (widget.pageId != Constants.personalPageId),
          //                 child: ScrollableText(
          //                   widget.data.tableRows[i].secondColumn,
          //                   // alignment: TextAlign.left,
          //                   style: const TextStyle(
          //                     color: Constants.appTextColor,
          //                     fontSize: Constants.appHeading7Size,
          //                   ),
          //                   width: 80.0,
          //                 ),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.symmetric(vertical: 4.0),
          //               child: Center(
          //                 child: Text(
          //                   convertNumber(widget.data.tableRows[i].thirdColumn),
          //                   style: const TextStyle(
          //                     color: Constants.appTextColor,
          //                     fontSize: Constants.appHeading6Size,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget getPersonalReport() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FixedColumnWidth(100.0), //fixed to 100 width
          },
          children: [
            const TableRow(
              children: [
                Text(
                  "Date",
                  style: TextStyle(
                    color: Constants.appHighlightColor,
                    fontSize: Constants.appHeading6Size,
                  ),
                ),
                Text(
                  "Count",
                  style: TextStyle(
                    color: Constants.appHighlightColor,
                    fontSize: Constants.appHeading6Size,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            if (widget.logs != null)
              for (int i = 0; i < widget.logs!.length; i++)
                TableRow(
                  children: [
                    Text(
                      widget.logs![i].date,
                      style: const TextStyle(
                        color: Constants.appTextColor,
                        fontSize: Constants.appHeading6Size,
                      ),
                    ),
                    Text(
                      convertNumber(widget.logs![i].count),
                      style: const TextStyle(
                        color: Constants.appTextColor,
                        fontSize: Constants.appHeading6Size,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget getLocationReport() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(70.0), // fixed to 100 width
            1: FlexColumnWidth(),
            2: FixedColumnWidth(70.0), //fixed to 100 width
          },
          children: [
            TableRow(
              children: [
                const Text(
                  "Rank",
                  style: TextStyle(
                    color: Constants.appHighlightColor,
                    fontSize: Constants.appHeading6Size,
                  ),
                ),
                Text(
                  tableHead,
                  style: const TextStyle(
                    color: Constants.appHighlightColor,
                    fontSize: Constants.appHeading6Size,
                  ),
                ),
                const Text(
                  "Count",
                  style: TextStyle(
                    color: Constants.appHighlightColor,
                    fontSize: Constants.appHeading6Size,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            for (int i = 0; i < widget.data.tableRows.length; i++)
              TableRow(
                children: [
                  Text(
                    widget.data.tableRows[i].firstColumn,
                    style: const TextStyle(
                      color: Constants.appTextColor,
                      fontSize: Constants.appHeading6Size,
                    ),
                  ),
                  ScrollableText(
                    widget.data.tableRows[i].secondColumn,
                    // alignment: TextAlign.left,
                    style: const TextStyle(
                      color: Constants.appTextColor,
                      fontSize: Constants.appHeading7Size,
                    ),
                    width: 80.0,
                  ),
                  Text(
                    convertNumber(widget.data.tableRows[i].thirdColumn),
                    style: const TextStyle(
                      color: Constants.appTextColor,
                      fontSize: Constants.appHeading6Size,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget getPersonalRanking() {
    return Visibility(
      visible: widget.pageId == Constants.personalPageId,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              minWidth: 400,
              maxHeight: 50,
              minHeight: 50,
            ),
            child: const FittedText(
              'My Ranking',
              style: TextStyle(
                color: Constants.appTextColor,
                fontSize: Constants.appHeading2Size,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FittedRichText(
                      widget.data.countryRank == ""
                          ? ""
                          : widget.data.countryRank,
                      style: const TextStyle(
                        color: Constants.appTextColor,
                        fontSize: Constants.appHeading3Size,
                      ),
                      rankStyle: const TextStyle(
                        color: Constants.appTextColor,
                        fontSize: Constants.appHeading6Size,
                      ),
                    ),
                    const FittedText(
                      'Country',
                      style: TextStyle(
                        color: Constants.appHighlightColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    FittedRichText(
                      widget.data.cityRank == ""
                          ? "No City Set"
                          : widget.data.cityRank,
                      style: const TextStyle(
                        color: Constants.appTextColor,
                        fontSize: Constants.appHeading3Size,
                      ),
                      rankStyle: const TextStyle(
                        color: Constants.appTextColor,
                        fontSize: Constants.appHeading6Size,
                      ),
                    ),
                    const FittedText(
                      'City',
                      style: TextStyle(
                        color: Constants.appHighlightColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    FittedText(
                      widget.data.globalRank,
                      style: const TextStyle(
                        color: Constants.appTextColor,
                        fontSize: Constants.appHeading3Size,
                      ),
                    ),
                    const FittedText(
                      'Global',
                      style: TextStyle(
                        color: Constants.appHighlightColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
