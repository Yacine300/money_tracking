import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthNotifier extends StateNotifier<int> {
  MonthNotifier() : super(DateTime.now().month);

  void selectMonth(int selectedMonth) {
    state = selectedMonth;
  }
}

final monthProvider = StateNotifierProvider<MonthNotifier, int>(
  (ref) => MonthNotifier(),
);
