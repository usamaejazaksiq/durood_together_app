class AppLocation {
  String? city;
  String? country;
  String? message;
  String? error;

  AppLocation({this.city, this.country, this.message, this.error});

  @override
  String toString() {
    return 'AppLocation{city: $city, country: $country, message: $message, error: $error}';
  }
}
