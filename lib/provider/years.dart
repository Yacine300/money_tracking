import 'package:flutter_riverpod/flutter_riverpod.dart';

class YearNotifier extends StateNotifier<int> {
  YearNotifier() : super(DateTime.now().year);

  int getYear() {
    return state;
  }

  void selectYear(int selectedMonth) {
    state = selectedMonth;
  }
}

final currentYearProvider = StateNotifierProvider<YearNotifier, int>(
  (ref) => YearNotifier(),
);
