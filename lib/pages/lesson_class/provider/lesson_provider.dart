import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDateProvider = StateProvider.autoDispose<DateTime?>(
  (ref) {
    DateTime? selectedDate = DateTime.now();
    return selectedDate;
  },
);

final selectedTimeStartProvider = StateProvider.autoDispose<TimeOfDay?>(
  (ref) {
    TimeOfDay? selectedTime = const TimeOfDay(hour: 0, minute: 0);
    return selectedTime;
  },
);

final selectedTimeEndProvider = StateProvider.autoDispose<TimeOfDay?>(
  (ref) {
    TimeOfDay? selectedTime = const TimeOfDay(hour: 0, minute: 0);
    return selectedTime;
  },
);
