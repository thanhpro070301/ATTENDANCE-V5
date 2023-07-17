import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snack;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/firebase_constants.dart';
import 'package:attendance_/models/group_model/group_model.dart';
import 'package:attendance_/provider/firebase_provider.dart';
import 'package:attendance_/provider/storage_repository.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider.autoDispose((ref) => GroupRepository(
      firebaseAuth: ref.watch(firebaseAuthProvider),
      firebaseFirestore: ref.watch(firebaseFirestoreProvider),
      ref: ref,
    ));

abstract class IGroupRepository {
  void createGroup({
    required BuildContext context,
    required String name,
    required File profilePic,
    required List<Contact> selectedContact,
  });
}

class GroupRepository implements IGroupRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final Ref _ref;

  GroupRepository(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firebaseFirestore,
      required Ref ref})
      : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _ref = ref;

  @override
  void createGroup(
      {required BuildContext context,
      required String name,
      required File profilePic,
      required List<Contact> selectedContact}) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var userCollection = await _firebaseFirestore
            .collection(FirebaseConstants.usersCollection)
            .where(
              'phoneNumber',
              isEqualTo: selectedContact[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userCollection.docs.isNotEmpty &&
            userCollection.docs[0].exists &&
            userCollection.docs[0].data()['uid'] !=
                _firebaseAuth.currentUser!.uid) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();

      String profileUrl =
          await _ref.read(storageRepositoryProvider).storeFileStorage(
                'group/$groupId',
                profilePic,
              );
      GroupModel groupModel = GroupModel(
        senderId: _firebaseAuth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: [_firebaseAuth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await _firebaseFirestore
          .collection(FirebaseConstants.groupCollection)
          .doc(groupId)
          .set(groupModel.toJson());
    } catch (e) {
      showSnackBarCustom(
          context, snack.ContentType.failure, 'Oh Snap!', e.toString());
    }
  }
}
