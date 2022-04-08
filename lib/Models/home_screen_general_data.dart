class HomeScreenGeneralData {
  String? _cummulativeCount = "";
  String? _currentMonthCount = "";

  String? _topCountryName = "";
  String? _topCountryCount = "";

  String? _topCityName = "";
  String? _topCityCount = "";
  String? _lastSync = "";

  @override
  String toString() {
    return 'HomeScreenData{_cummulativeCount: $_cummulativeCount, _currentMonthCount: $_currentMonthCount, _topCountryName: $_topCountryName, _topCountryCount: $_topCountryCount, _topCityName: $_topCityName, _topCityCount: $_topCityCount, _lastSync: $_lastSync}';
  }

  String get lastSync => _lastSync!;

  String get cummulativeCount => _cummulativeCount!;

  String get currentMonthCount => _currentMonthCount!;

  String get topCountryName => _topCountryName!;

  String get topCountryCount => _topCountryCount!;

  String get topCityName => _topCityName!;

  String get topCityCount => _topCityCount!;

  Map<String, dynamic> createMap() {
    return {
      'cummulativeCount': _cummulativeCount,
      'currentMonthCount': _currentMonthCount,
      'topCountryName': _topCountryName,
      'topCountryCount': _topCountryCount,
      'topCityName': _topCityName,
      'topCityCount': _topCityCount,
      'lastSync': _lastSync,
    };
  }

  HomeScreenGeneralData(
    this._cummulativeCount,
    this._currentMonthCount,
    this._topCountryName,
    this._topCountryCount,
    this._topCityName,
    this._topCityCount,
    this._lastSync,
  );

  HomeScreenGeneralData.empty() {
    _cummulativeCount = "";
    _currentMonthCount = "";
    _topCountryName = "";
    _topCountryCount = "";
    _topCityName = "";
    _topCityCount = "";
    _lastSync = "";
  }

  HomeScreenGeneralData.fromFirestore(Map<String, dynamic>? firestoreMap) {
    _cummulativeCount = firestoreMap!['cummulativeCount'] ?? "";
    _currentMonthCount = firestoreMap['currentMonthCount'] ?? "";
    _topCountryName = firestoreMap['topCountryName'] ?? "";
    _topCountryCount = firestoreMap['topCountryCount'] ?? "";
    _topCityName = firestoreMap['topCityName'] ?? "";
    _topCityCount = firestoreMap['topCityCount'] ?? "";
    _lastSync = firestoreMap['lastSync'] ?? "";
  }

  set currentMonthCount(String value) {
    _currentMonthCount = value;
  }

  set topCountryName(String value) {
    _topCountryName = value;
  }

  set topCountryCount(String value) {
    _topCountryCount = value;
  }

  set topCityName(String value) {
    _topCityName = value;
  }

  set topCityCount(String value) {
    _topCityCount = value;
  }

  set lastSync(String value) {
    _lastSync = value;
  }

  set cummulativeCount(String value) {
    _cummulativeCount = value;
  }
}
