class HomeScreenUserData {
  int? _lastCount = 0;
  int? _todayCount = 0;

  int? _yesterdayCount = 0;
  int? _thisWeekCount = 0;

  Map<String, dynamic> createMap() {
    return {
      'lastCount': {
        "time": DateTime.now(),
        "count": _lastCount,
      },
      'todayCount': _todayCount,
      'yesterdayCount': _yesterdayCount,
      'thisWeekCount': _thisWeekCount,
    };
  }

  HomeScreenUserData(
    this._lastCount,
    this._todayCount,
    this._yesterdayCount,
    this._thisWeekCount,
  );

  HomeScreenUserData.empty() {
    _lastCount = 0;
    _todayCount = 0;
    _yesterdayCount = 0;
    _thisWeekCount = 0;
  }

  HomeScreenUserData.fromFirestore(Map<String, dynamic>? firestoreMap) {
    _lastCount = firestoreMap!['lastCount']['count'] ?? 0;
  }

  int get todayCount => _todayCount!;

  set todayCount(int value) {
    _todayCount = value;
  }

  int get yesterdayCount => _yesterdayCount!;

  set yesterdayCount(int value) {
    _yesterdayCount = value;
  }

  int get thisWeekCount => _thisWeekCount!;

  set thisWeekCount(int value) {
    _thisWeekCount = value;
  }

  int get lastCount => _lastCount!;

  set lastCount(int value) {
    _lastCount = value;
  }

  @override
  String toString() {
    return 'HomeScreenUserData{_lastCount: $_lastCount, _todayCount: $_todayCount, _yesterdayCount: $_yesterdayCount, _thisWeekCount: $_thisWeekCount}';
  }
}
