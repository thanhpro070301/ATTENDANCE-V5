import 'dart:io';
import 'dart:developer' as developer;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snack;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/enum/message_enum.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/firebase_constants.dart';
import 'package:attendance_/models/chat_contact_model/chat_contact_model.dart';
import 'package:attendance_/models/group_model/group_model.dart';
import 'package:attendance_/models/message_model/message_model.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/provider/firebase_provider.dart';
import 'package:attendance_/provider/message_reply_provider.dart';
import 'package:attendance_/provider/storage_repository.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider.autoDispose(
  (ref) => ChatRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firebaseFirestoreProvider),
  ),
);

abstract class IChatRepository {
  void saveDataToContactsSubcollection({
    required UserModel senderUserData,
    required UserModel? receiverUserData,
    required String text,
    required DateTime timeSent,
    required String receiverUserId,
    required bool isGroupChat,
  });
  void saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String? receiverUserName,
    required bool isGroupChat,
  });
  Future sentTextMessage({
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required BuildContext context,
    required MessageReply? messageReply,
    required bool isGroupChat,
  });
  Stream<List<ChatContactModel>> getChatContacts(String uid);
  Stream<List<GroupModel>> getGroups(String uid);
  Stream<List<MessageModel>> getChatStream(String receiverUserId, String uid);
  void sentFileMessage({
    required BuildContext context,
    required Ref ref,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required bool isGroupChat,
  });
  Future sentGIFMessage({
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required BuildContext context,
    required MessageReply? messageReply,
    required bool isGroupChat,
  });
  void setChatMessageSeen({
    required String receiverUserId,
    required String messageId,
    required BuildContext context,
  });
  Stream<List<MessageModel>> getChatGroupStream(String groupId);
}

class ChatRepository implements IChatRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  ChatRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  @override
  void saveDataToContactsSubcollection({
    required UserModel senderUserData,
    required UserModel? receiverUserData,
    required String text,
    required DateTime timeSent,
    required String receiverUserId,
    required bool isGroupChat,
  }) async {
    // users -> receiver user id => chats -> current user id -> set data

    if (isGroupChat) {
      await _firebaseFirestore
          .collection(FirebaseConstants.groupCollection)
          .doc(receiverUserId)
          .update({'lastMessage': text, 'timeSent': DateTime.now().toString()});
    } else {
      final receiverChatContact = ChatContactModel(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessenger: text,
      );
      await _firebaseFirestore
          .collection(FirebaseConstants.usersCollection)
          .doc(receiverUserId)
          .collection(FirebaseConstants.chatCollection)
          .doc(_firebaseAuth.currentUser!.uid)
          .set(
            receiverChatContact.toJson(),
          );
      // users -> current user id => chats -> receiver user id -> set data
      final senderChatContact = ChatContactModel(
          name: receiverUserData!.name,
          profilePic: receiverUserData.profilePic,
          contactId: receiverUserData.uid,
          timeSent: timeSent,
          lastMessenger: text);
      await _firebaseFirestore
          .collection(FirebaseConstants.usersCollection)
          .doc(_firebaseAuth.currentUser!.uid)
          .collection(FirebaseConstants.chatCollection)
          .doc(receiverUserId)
          .set(
            senderChatContact.toJson(),
          );
    }
  }

  @override
  void saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String? receiverUserName,
    required bool isGroupChat,
  }) async {
    final message = MessageModel(
      senderId: _firebaseAuth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? "" : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : receiverUserName ?? '',
      typeReply:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );

    if (isGroupChat) {
      // group -> group id -> chat -> messages
      await _firebaseFirestore
          .collection(FirebaseConstants.groupCollection)
          .doc(receiverUserId)
          .collection(FirebaseConstants.chatCollection)
          .doc(messageId)
          .set(
            message.toJson(),
          );
    } else {
      // users -> sender id -> receiver id -> messages ->message id -> store
      await _firebaseFirestore
          .collection(FirebaseConstants.usersCollection)
          .doc(_firebaseAuth.currentUser!.uid)
          .collection(FirebaseConstants.chatCollection)
          .doc(receiverUserId)
          .collection(FirebaseConstants.messageCollection)
          .doc(messageId)
          .set(message.toJson());
      // users -> receive id -> sender id -> messages ->message id -> store

      await _firebaseFirestore
          .collection(FirebaseConstants.usersCollection)
          .doc(receiverUserId)
          .collection(FirebaseConstants.chatCollection)
          .doc(_firebaseAuth.currentUser!.uid)
          .collection(FirebaseConstants.messageCollection)
          .doc(messageId)
          .set(message.toJson());
    }
  }

  @override
  Future sentTextMessage({
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required BuildContext context,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final timeSent = DateTime.now();
      UserModel? receiverUserData;

      if (!isGroupChat) {
        final userDataMap = await _firebaseFirestore
            .collection(FirebaseConstants.usersCollection)
            .doc(receiverUserId)
            .get();
        receiverUserData = UserModel.fromJson(userDataMap.data()!);
      }

      saveDataToContactsSubcollection(
        text: text,
        receiverUserData: receiverUserData,
        senderUserData: senderUser,
        receiverUserId: receiverUserId,
        timeSent: timeSent,
        isGroupChat: isGroupChat,
      );
      final messageId = const Uuid().v1();

      saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: text,
        messageType: MessageEnum.text,
        timeSent: timeSent,
        messageId: messageId,
        isGroupChat: isGroupChat,
        username: senderUser.name,
        receiverUserName: receiverUserData?.name,
        senderUsername: senderUser.name,
        messageReply: messageReply,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBarCustom(
          context, snack.ContentType.failure, 'Oh Snap!', e.toString());
    } catch (e) {
      showSnackBarCustom(
          context, snack.ContentType.failure, 'Oh Snap!', e.toString());
    }
  }

  @override
  Stream<List<ChatContactModel>> getChatContacts(String uid) {
    return _firebaseFirestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .collection(FirebaseConstants.chatCollection)
        .snapshots()
        .asyncMap(
      (event) async {
        List<ChatContactModel> contacts = [];
        for (final doc in event.docs) {
          final chatContact = ChatContactModel.fromJson(doc.data());
          final userData = await _firebaseFirestore
              .collection(FirebaseConstants.usersCollection)
              .doc(chatContact.contactId)
              .get();
          final user = UserModel.fromJson(userData.data()!);
          contacts.add(ChatContactModel(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessenger: chatContact.lastMessenger,
          ));
        }
        return contacts;
      },
    );
  }

  @override
  Stream<List<GroupModel>> getGroups(String uid) {
    return _firebaseFirestore
        .collection(FirebaseConstants.groupCollection)
        .snapshots()
        .map((event) {
      List<GroupModel> groups = [];
      for (final doc in event.docs) {
        final group = GroupModel.fromJson(doc.data());

        if (group.membersUid.contains(uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  @override
  Stream<List<MessageModel>> getChatStream(String receiverUserId, String uid) {
    return _firebaseFirestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .collection(FirebaseConstants.chatCollection)
        .doc(receiverUserId)
        .collection(FirebaseConstants.messageCollection)
        .orderBy('timeSent', descending: true)
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (final doc in event.docs) {
        messages.add(MessageModel.fromJson(doc.data()));
      }
      return messages;
    });
  }

  @override
  void sentFileMessage({
    required BuildContext context,
    required Ref ref,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();
      String imageUrl = await ref.read(storageRepositoryProvider).storeFileStorage(
          'chat${messageType.type}/${senderUserData.uid}/$receiverUserId/$messageId',
          file);

      UserModel? receiverUserData;
      if (!isGroupChat) {
        final userDataMap = await _firebaseFirestore
            .collection(FirebaseConstants.usersCollection)
            .doc(receiverUserId)
            .get();
        receiverUserData = UserModel.fromJson(userDataMap.data()!);
      }

      String contactMsg;
      switch (messageType) {
        case MessageEnum.image:
          contactMsg = 'Photo';
          break;
        case MessageEnum.video:
          contactMsg = 'Video';
          break;
        case MessageEnum.audio:
          contactMsg = 'Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'Gif';
          break;

        default:
          contactMsg = 'Text';
          break;
      }
      saveDataToContactsSubcollection(
        receiverUserData: receiverUserData,
        receiverUserId: receiverUserId,
        senderUserData: senderUserData,
        text: contactMsg,
        timeSent: timeSent,
        isGroupChat: isGroupChat,
      );
      saveMessageToMessageSubcollection(
        messageId: messageId,
        messageType: messageType,
        receiverUserId: receiverUserId,
        username: senderUserData.name,
        isGroupChat: isGroupChat,
        text: imageUrl,
        timeSent: timeSent,
        receiverUserName: receiverUserData?.name,
        senderUsername: senderUserData.name,
        messageReply: messageReply,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBarCustom(
          context, snack.ContentType.failure, 'Oh Snap!', e.message!);
    } catch (e) {
      showSnackBarCustom(
          context, snack.ContentType.failure, 'Oh Snap!', e.toString());
    }
  }

  @override
  Future sentGIFMessage({
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required BuildContext context,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final timeSent = DateTime.now();
      UserModel? receiverUserData;
      if (!isGroupChat) {
        final userDataMap = await _firebaseFirestore
            .collection(FirebaseConstants.usersCollection)
            .doc(receiverUserId)
            .get();
        receiverUserData = UserModel.fromJson(userDataMap.data()!);
      }
      saveDataToContactsSubcollection(
        text: 'GIF',
        receiverUserData: receiverUserData,
        senderUserData: senderUser,
        receiverUserId: receiverUserId,
        timeSent: timeSent,
        isGroupChat: isGroupChat,
      );
      final messageId = const Uuid().v1();

      saveMessageToMessageSubcollection(
          receiverUserId: receiverUserId,
          text: gifUrl,
          messageType: MessageEnum.gif,
          timeSent: timeSent,
          messageId: messageId,
          isGroupChat: isGroupChat,
          username: senderUser.name,
          receiverUserName: receiverUserData?.name,
          senderUsername: senderUser.name,
          messageReply: messageReply);
    } on FirebaseAuthException catch (e) {
      showSnackBarCustom(
          context, snack.ContentType.failure, 'Oh Snap!', e.message!);
    } catch (e) {
      showSnackBarCustom(
          context, snack.ContentType.failure, 'Oh Snap!', e.toString());
    }
  }

  @override
  void setChatMessageSeen({
    required String receiverUserId,
    required String messageId,
    required BuildContext context,
  }) async {
    try {
      developer.log(receiverUserId);
      await _firebaseFirestore
          .collection(FirebaseConstants.usersCollection)
          .doc(_firebaseAuth.currentUser!.uid)
          .collection(FirebaseConstants.chatCollection)
          .doc(receiverUserId)
          .collection(FirebaseConstants.messageCollection)
          .doc(messageId)
          .update({
        'isSeen': true,
      });

      await _firebaseFirestore
          .collection(FirebaseConstants.usersCollection)
          .doc(receiverUserId)
          .collection(FirebaseConstants.chatCollection)
          .doc(_firebaseAuth.currentUser!.uid)
          .collection(FirebaseConstants.messageCollection)
          .doc(messageId)
          .update({
        'isSeen': true,
      });
    } on FirebaseAuthException catch (e) {
      developer.log(e.message!);
    } catch (e) {
      developer.log(e.toString());
    }
  }

  @override
  Stream<List<MessageModel>> getChatGroupStream(String groupId) {
    return _firebaseFirestore
        .collection(FirebaseConstants.groupCollection)
        .doc(groupId)
        .collection(FirebaseConstants.chatCollection)
        .orderBy('timeSent', descending: true)
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (final doc in event.docs) {
        messages.add(MessageModel.fromJson(doc.data()));
      }
      return messages;
    });
  }
}
