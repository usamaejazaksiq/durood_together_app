class CountryReportsData {
  List<Map<String, dynamic>>? _countryData;

  List<Map<String, dynamic>> get countryData => _countryData!;

  set countryData(List<Map<String, dynamic>> value) {
    _countryData = value;
  }

  CountryReportsData.fromFirestore(Map<String, dynamic>? firestoreMap) {
    _countryData = (firestoreMap!['countryData'] as List).cast<Map<String, dynamic>>();
  }

  @override
  String toString() {
    return 'CountryReportsData{_countryData: $_countryData}';
  }

  CountryReportsData(this._countryData);

  CountryReportsData.test() {
    _countryData = [
      {
        "rank": 1,
        "name": "India",
        "count": 256,
      },
      {
        "rank": 3,
        "name": "Bangladesh",
        "count": 56,
      },
      {
        "rank": 5,
        "name": "Russia",
        "count": 2456,
      },
      {
        "rank": 2,
        "name": "United States of America",
        "count": 21,
      },
      {
        "rank": 4,
        "name": "Poland",
        "count": 213456,
      },
    ];
  }

  CountryReportsData.empty() {
    _countryData = [
      {
        "rank": 0,
        "name": "",
        "count": 0,
      },
      {
        "rank": 0,
        "name": "",
        "count": 0,
      },
      {
        "rank": 0,
        "name": "",
        "count": 0,
      },
    ];
  }
}
