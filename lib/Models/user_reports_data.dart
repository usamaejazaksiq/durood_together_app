import 'package:durood_together_app/Models/user_log.dart';
class UserReportsData{
  List<UserLog>? _userLogs;
  String? _cityRank;
  String? _countryRank;
  String? _globalRank;
  String? _userCityName;
  String? _userCountryName;
  String? _userCityCount;
  String? _userCountryCount;
  String? _userMonthCount;

  UserReportsData.empty(){
    _userLogs = [];
    _cityRank = " ";
    _countryRank = " ";
    _globalRank = " ";
    _userCityCount = "0";
    _userCityName = " ";
    _userCountryCount = "0";
    _userCountryName = " ";
    _userMonthCount = "0";
  }

  UserReportsData.test(){
    _userLogs = [];
    _cityRank = "12";
    _countryRank = "25";
    _globalRank = "226";
    _userCityCount = "123451";
    _userCityName = "London";
    _userCountryCount = "45687";
    _userCountryName = "Norway";
    _userMonthCount = "40000";
  }


  UserReportsData(
      this._userLogs,
      this._cityRank,
      this._countryRank,
      this._globalRank,
      this._userCityName,
      this._userCountryName,
      this._userCityCount,
      this._userCountryCount,
      this._userMonthCount);

  String get cityRank => _cityRank!;

  set cityRank(String value) {
    _cityRank = value;
  }

  String get userMonthCount => _userMonthCount!;


  @override
  String toString() {
    return 'UserReportsData{_userLogs: $_userLogs, _cityRank: $_cityRank, _countryRank: $_countryRank, _globalRank: $_globalRank, _userCityName: $_userCityName, _userCountryName: $_userCountryName, _userCityCount: $_userCityCount, _userCountryCount: $_userCountryCount, _userMonthCount: $_userMonthCount}';
  }

  set userMonthCount(String value) {
    _userMonthCount = value;
  }

  String get userCountryCount => _userCountryCount!;

  set userCountryCount(String value) {
    _userCountryCount = value;
  }

  String get userCityCount => _userCityCount!;

  set userCityCount(String value) {
    _userCityCount = value;
  }

  String get userCountryName => _userCountryName!;

  set userCountryName(String value) {
    _userCountryName = value;
  }

  String get userCityName => _userCityName!;

  set userCityName(String value) {
    _userCityName = value;
  }

  List<UserLog> get userLogs => _userLogs!;

  set userLogs(List<UserLog> value) {
    _userLogs = value;
  }

  String get countryRank => _countryRank!;

  set countryRank(String value) {
    _countryRank = value;
  }

  String get globalRank => _globalRank!;

  set globalRank(String value) {
    _globalRank = value;
  }
}