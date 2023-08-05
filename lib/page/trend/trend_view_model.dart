import 'package:flutter/foundation.dart';

import '../../model/trend_model.dart';
import '../../model/user_model.dart';

class TrendViewModel with ChangeNotifier {
  List<Trend> get trends => _trends;
  final List<Trend> _trends = [];
  final user = User();

  void addTrend(Trend trend) {
    _trends.add(trend);
    notifyListeners();
  }

  Future<void> init() async {
    await user.loadTrend();
    _trends.addAll(user.oldTrend);
  }
}
