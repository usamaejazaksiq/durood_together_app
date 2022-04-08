import 'package:durood_together_app/Models/reports_table_model.dart';
import 'package:durood_together_app/Models/user_log.dart';

class ReportsScreenData {
  String? _mohrCount;
  String? _mohrName;
  String? _mohrFlag;

  String? _rank2Name;
  String? _rank2Count;
  String? _rank2Flag;

  String? _rank3Name;
  String? _rank3Count;
  String? _rank3Flag;

  List<UserLog>? _logs;

  List<UserLog> get logs => _logs!;

  set logs(List<UserLog> value) {
    _logs = value;
  }

  String? _userCount;

  List<ReportsTableModel>? _tableRows;

  //UserPage Specific
  String? _cityRank;
  String? _globalRank;
  String? _countryRank;

  ReportsScreenData(
    this._mohrCount,
    this._mohrName,
    this._mohrFlag,
    this._rank2Name,
    this._rank2Count,
    this._rank2Flag,
    this._rank3Name,
    this._rank3Count,
    this._rank3Flag,
    this._tableRows,
    this._cityRank,
    this._globalRank,
    this._countryRank,
    this._logs,
    this._userCount,
  );

  ReportsScreenData.empty() {
    _mohrCount = "";
    _mohrName = "";
    _mohrFlag = "";
    _rank2Name = "";
    _rank2Count = "";
    _rank2Flag = "";
    _rank3Name = "";
    _rank3Count = "";
    _rank3Flag = "";
    _tableRows = [];
    _cityRank = "";
    _globalRank = "";
    _countryRank = "";
    _logs = [];
    _userCount = "0";
  }


  @override
  String toString() {
    return 'ReportsScreenData{_mohrCount: $_mohrCount, _mohrName: $_mohrName, _mohrFlag: $_mohrFlag, _rank2Name: $_rank2Name, _rank2Count: $_rank2Count, _rank2Flag: $_rank2Flag, _rank3Name: $_rank3Name, _rank3Count: $_rank3Count, _rank3Flag: $_rank3Flag, _logs: $_logs, _userCount: $_userCount, _tableRows: $_tableRows, _cityRank: $_cityRank, _globalRank: $_globalRank, _countryRank: $_countryRank}';
  }

  String get mohrCount => _mohrCount!;

  set mohrCount(String value) {
    _mohrCount = value;
  }

  String get mohrName => _mohrName!;

  set mohrName(String value) {
    _mohrName = value;
  }

  String get countryRank => _countryRank!;

  set countryRank(String value) {
    _countryRank = value;
  }

  String get globalRank => _globalRank!;

  set globalRank(String value) {
    _globalRank = value;
  }

  String get cityRank => _cityRank!;

  set cityRank(String value) {
    _cityRank = value;
  }

  List<ReportsTableModel> get tableRows => _tableRows!;

  set tableRows(List<ReportsTableModel> value) {
    _tableRows = value;
  }

  String get rank3Flag => _rank3Flag!;

  set rank3Flag(String value) {
    _rank3Flag = value;
  }

  String get rank3Count => _rank3Count!;

  set rank3Count(String value) {
    _rank3Count = value;
  }

  String get rank3Name => _rank3Name!;

  set rank3Name(String value) {
    _rank3Name = value;
  }

  String get rank2Flag => _rank2Flag!;

  set rank2Flag(String value) {
    _rank2Flag = value;
  }

  String get rank2Count => _rank2Count!;

  set rank2Count(String value) {
    _rank2Count = value;
  }

  String get rank2Name => _rank2Name!;

  set rank2Name(String value) {
    _rank2Name = value;
  }

  String get mohrFlag => _mohrFlag!;

  set mohrFlag(String value) {
    _mohrFlag = value;
  }

  String get userCount => _userCount!;

  set userCount(String value) {
    _userCount = value;
  }
}
