import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attendance_/pages/class_and_subject/subject/provider/home_provider.dart';

class ClockWidget extends ConsumerWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTime = ref.watch(clockProvider).value;

    final formattedTime = currentTime != null
        ? "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}:${currentTime.second.toString().padLeft(2, '0')}"
        : '';

    return Text(
      formattedTime,
      style: const TextStyle(fontSize: 24),
    );
  }
}
