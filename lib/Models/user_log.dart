class UserLog{
  String? _date;
  String? _count;

  UserLog(this._date, this._count);

  String get date => _date!;

  set date(String value) {
    _date = value;
  }

  UserLog.empty(){
    _date = "";
    _count = "";
  }

  String get count => _count!;

  @override
  String toString() {
    return 'UserLog{_date: $_date, _count: $_count}';
  }

  set count(String value) {
    _count = value;
  }
}