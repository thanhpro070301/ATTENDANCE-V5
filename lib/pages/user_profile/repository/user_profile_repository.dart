import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/firebase_constants.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/provider/firebase_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userProfileRepositoryProvider = Provider.autoDispose((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return UserProfileRepository(
    firestore: firestore,
  );
});

abstract class IUserProfileRepository {
  CollectionReference get users;
  FutureEitherVoid editUserProfile(UserModel userModel);
}

class UserProfileRepository implements IUserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  CollectionReference get users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  @override
  FutureEitherVoid editUserProfile(UserModel userModel) async {
    try {
      return right(await users.doc(userModel.uid).update(
            userModel.toJson(),
          ));
    } on FirebaseException catch (e) {
      return left(Failure('Error Firebase $e'));
    } catch (e) {
      return left(Failure('Error $e'));
    }
  }
}
