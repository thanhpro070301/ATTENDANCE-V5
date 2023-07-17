import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/models/user_model/user_model.dart';

final isSignInProvider = StateProvider.autoDispose((ref) => false);

final uidProvider = StateProvider.autoDispose((ref) => '');

final userProvider = StateProvider.autoDispose<UserModel?>((ref) => null);
