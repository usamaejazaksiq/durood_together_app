import 'dart:developer';

import 'package:durood_together_app/AppReserved/city_codes.dart';
import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/Models/ReportsScreenData.dart';
import 'package:durood_together_app/Models/city_reports_data.dart';
import 'package:durood_together_app/Models/country_reports_data.dart';
import 'package:durood_together_app/Models/reports_table_model.dart';
import 'package:durood_together_app/Models/user_reports_data.dart';

ReportsScreenData translateCountryDataForReports(CountryReportsData data) {
  ReportsScreenData convertedData = ReportsScreenData.empty();
  try {
    data.countryData.sort(
        (a, b) => int.tryParse(a["rank"])!.compareTo(int.tryParse(b["rank"])!));
  } catch (e) {
    // log('rank not available');
  }

  convertedData.mohrFlag =
      Constants.countryCodes[data.countryData[0]["name"]]?.toLowerCase() ?? "";
  convertedData.mohrName = data.countryData[0]["name"];
  convertedData.mohrCount = data.countryData[0]["count"].toString();
  convertedData.rank2Flag =
      Constants.countryCodes[data.countryData[1]["name"]]?.toLowerCase() ?? "";
  convertedData.rank2Name = data.countryData[1]["name"];
  convertedData.rank2Count = data.countryData[1]["count"].toString();
  convertedData.rank3Flag =
      Constants.countryCodes[data.countryData[2]["name"]]?.toLowerCase() ?? "";
  convertedData.rank3Name = data.countryData[2]["name"];
  convertedData.rank3Count = data.countryData[2]["count"].toString();

  for (int i = 3; i < data.countryData.length; i++) {
    ReportsTableModel tableRow = ReportsTableModel.empty();
    tableRow.firstColumn = data.countryData[i]["rank"].toString();
    tableRow.secondColumn = data.countryData[i]["name"];
    tableRow.thirdColumn = data.countryData[i]["count"].toString();
    convertedData.tableRows.add(tableRow);
  }

  return convertedData;
}

ReportsScreenData translateCityDataForReports(CityReportsData data) {
  ReportsScreenData convertedData = ReportsScreenData.empty();
  try {
    data.cityData.sort(
        (a, b) => int.tryParse(a["rank"])!.compareTo(int.tryParse(b["rank"])!));
  } catch (e) {
    log('rank not available');
  }
  convertedData.mohrFlag =
      CityCodes.cities[data.cityData[0]["name"]]?.toLowerCase() ?? "";
  convertedData.mohrName = data.cityData[0]["name"];
  convertedData.mohrCount = data.cityData[0]["count"].toString();
  convertedData.rank2Flag =
      CityCodes.cities[data.cityData[1]["name"]]?.toLowerCase() ?? "";
  convertedData.rank2Name = data.cityData[1]["name"];
  convertedData.rank2Count = data.cityData[1]["count"].toString();
  convertedData.rank3Flag =
      CityCodes.cities[data.cityData[2]["name"]]?.toLowerCase() ?? "";
  convertedData.rank3Name = data.cityData[2]["name"];
  convertedData.rank3Count = data.cityData[2]["count"].toString();

  for (int i = 3; i < data.cityData.length; i++) {
    ReportsTableModel tableRow = ReportsTableModel.empty();
    tableRow.firstColumn = data.cityData[i]["rank"].toString();
    tableRow.secondColumn = data.cityData[i]["name"];
    tableRow.thirdColumn = data.cityData[i]["count"].toString();
    convertedData.tableRows.add(tableRow);
  }

  return convertedData;
}

ReportsScreenData translateUserDataForReports(UserReportsData data) {
  ReportsScreenData convertedData = ReportsScreenData.empty();

  convertedData.mohrFlag =
      Constants.countryCodes[data.userCountryName]?.toLowerCase() ?? "";
  convertedData.mohrName = "";
  convertedData.mohrCount = data.userMonthCount;
  convertedData.rank2Flag =
      Constants.countryCodes[data.userCountryName]?.toLowerCase() ?? "";
  convertedData.rank2Name = data.userCountryName;
  convertedData.rank2Count =
      data.userCountryName == "" ? "" : data.userCountryCount;
  convertedData.rank3Flag =
      CityCodes.cities[data.userCityName]?.toLowerCase() ?? "";
  convertedData.rank3Name = data.userCityName;
  convertedData.rank3Count = data.userCityName == "" ? "" : data.userCityCount;

  convertedData.globalRank = data.globalRank;
  convertedData.cityRank = data.userCityName == "" ? "" : data.cityRank;
  convertedData.countryRank =
      data.userCountryName == "" ? "" : data.countryRank;

  convertedData.userCount = data.userMonthCount;
  convertedData.logs = data.userLogs;

  return convertedData;
}
