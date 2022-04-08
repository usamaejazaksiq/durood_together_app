class CityReportsData{
  List<Map<String, dynamic>>? _cityData;

  List<Map<String, dynamic>> get cityData => _cityData!;

  set cityData(List<Map<String, dynamic>> value) {
    _cityData = value;
  }

  CityReportsData.fromFirestore(Map<String, dynamic>? firestoreMap) {
    _cityData = (firestoreMap!['cityData'] as List).cast<Map<String, dynamic>>();
  }

  @override
  String toString() {
    return 'CityReportsData{_cityData: $_cityData}';
  }

  CityReportsData(this._cityData);

  CityReportsData.test() {
    _cityData = [
      {
        "rank": 1,
        "name": "Karachi",
        "count": 213456,
      },
      {
        "rank": 4,
        "name": "Hyderabad",
        "count": 21356,
      },
      {
        "rank": 5,
        "name": "Toronto",
        "count": 21345,
      },
      {
        "rank": 3,
        "name": "Karachi",
        "count": 13456,
      },
      {
        "rank": 2,
        "name": "Karachi",
        "count": 3456,
      },
    ];
  }

  CityReportsData.empty() {
    _cityData = [
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
