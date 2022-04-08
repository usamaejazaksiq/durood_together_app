class ReportsTableModel {
  String? _firstColumn;
  String? _secondColumn;
  String? _thirdColumn;

  ReportsTableModel(this._firstColumn, this._secondColumn, this._thirdColumn);

  ReportsTableModel.empty(){
    _firstColumn = "";
    _secondColumn = "";
    _thirdColumn = "";
  }

  String get firstColumn => _firstColumn!;

  set firstColumn(String value) {
    _firstColumn = value;
  }

  String get secondColumn => _secondColumn!;

  set secondColumn(String value) {
    _secondColumn = value;
  }

  String get thirdColumn => _thirdColumn!;

  set thirdColumn(String value) {
    _thirdColumn = value;
  }
}
