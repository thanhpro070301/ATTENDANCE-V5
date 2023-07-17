import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream.periodic(
      const Duration(microseconds: 1), (_) => DateTime.now());
});
