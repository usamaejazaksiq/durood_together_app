class UserProfile{
  String? _name;
  String? _country;
  String? _city;

  UserProfile(this._name, this._country, this._city);

  String get city => _city!;

  @override
  String toString() {
    return 'UserProfile{_name: $_name, _country: $_country, _city: $_city}';
  }

  set city(String value) {
    _city = value;
  }

  String get country => _country!;

  set country(String value) {
    _country = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

   UserProfile.fromFirestore(Map<String, dynamic>? firestoreMap) {
    _name = firestoreMap!['name']?? "";
    _country = firestoreMap['country']??"";
    _city = firestoreMap['city']??"";
   }
}