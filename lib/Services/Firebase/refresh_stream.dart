import 'dart:async';

class RefreshStream{
  static final StreamController<int> _refreshStatsStreamCtrl = StreamController<int>.broadcast();
  static Stream<int> get onRefreshStatsStreamCtrl => _refreshStatsStreamCtrl.stream;
  static void updateStreamToRefresh() => _refreshStatsStreamCtrl.sink.add(0);
}

