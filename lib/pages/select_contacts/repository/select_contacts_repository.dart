import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snack;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/firebase_constants.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/chat/screens/mobile_chat_screen.dart';
import 'package:attendance_/provider/firebase_provider.dart';
import 'package:quickalert/quickalert.dart';

final selectContactRepositoryProvider = Provider.autoDispose(
  (ref) {
    return SelectContactRepository(
      firebaseFirestore: ref.watch(firebaseFirestoreProvider),
    );
  },
);

abstract class ISelectContactRepository {
  Future<List<Contact>> getConTacts();
  Future selectContact(BuildContext context, Contact selectedContact);
}

class SelectContactRepository implements ISelectContactRepository {
  final FirebaseFirestore _firebaseFirestore;
  SelectContactRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  @override
  Future<List<Contact>> getConTacts() async {
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      return contacts;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  @override
  Future selectContact(BuildContext context, Contact selectedContact) async {
    try {
      var userCollection = await _firebaseFirestore
          .collection(FirebaseConstants.usersCollection)
          .get();
      bool isFound = false;
      for (var doc in userCollection.docs) {
        var userData = UserModel.fromJson(doc.data());

        String selectedPhoneNum =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (!selectedPhoneNum.startsWith("+84")) {
          selectedPhoneNum = "+84${selectedPhoneNum.substring(1)}";
          developer.log(selectedPhoneNum);
          if (selectedPhoneNum == userData.phoneNumber) {
            isFound = true;
            if (context.mounted) {
              Navigator.pushNamed(context, MobileChatScreen.routeName,
                  arguments: {
                    'name': userData.name,
                    'uid': userData.uid,
                    'isGroupChat': false,
                    'profilePic': userData.profilePic,
                  });
            }
          }
        }
      }
      if (!isFound) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            title: 'Ô có một lỗi nhỏ',
            type: QuickAlertType.info,
            text: 'Số điện thoại này không tồn tại trong ứng dụng.',
          );
        }
      }
    } catch (e) {
      developer.log(e.toString());

      if (e.toString() ==
          'RangeError (index): Invalid value: Valid value range is empty: 0') {
        if (context.mounted) {
          QuickAlert.show(
            title: 'Ô có 1 lỗi nhỏ',
            context: context,
            type: QuickAlertType.warning,
            text:
                'Số điện thoại của bạn có thể đang rỗng, vui lòng kiểm tra lại!!.',
          );
        }
      } else {
        showSnackBarCustom(
            context, snack.ContentType.failure, 'Oh Snap!', e.toString());
      }
    }
  }
}
