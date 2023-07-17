import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/enum/message_enum.dart';
import 'package:attendance_/models/chat_contact_model/chat_contact_model.dart';
import 'package:attendance_/models/group_model/group_model.dart';
import 'package:attendance_/models/message_model/message_model.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/chat/repository/chat_repository.dart';
import 'package:attendance_/provider/message_reply_provider.dart';

final chatControllerProvider =
    StateNotifierProvider.autoDispose<ChatController, bool>(
  (ref) => ChatController(
      chatRepository: ref.watch(chatRepositoryProvider), ref: ref),
);

final getChatContactsProvider =
    StreamProvider.autoDispose.family((ref, String uid) {
  final chatController = ref.watch(chatControllerProvider.notifier);
  return chatController.chatContacts(uid);
});

final getChatStreamProvider = StreamProvider.autoDispose.family(
  (ref, String receiverUserId) {
    final chatController = ref.watch(chatControllerProvider.notifier);
    return chatController.getChatStream(receiverUserId);
  },
);

final getGroupsProvider = StreamProvider.autoDispose.family(
  (ref, String uid) {
    final chatController = ref.watch(chatControllerProvider.notifier);
    return chatController.getGroup(uid);
  },
);

final getChatGroupsProvider =
    StreamProvider.autoDispose.family((ref, String groupId) {
  final chatController = ref.watch(chatControllerProvider.notifier);
  return chatController.getGroupChatStream(groupId);
});

class ChatController extends StateNotifier<bool> {
  final ChatRepository _chatRepository;
  final Ref _ref;
  ChatController({required ChatRepository chatRepository, required Ref ref})
      : _chatRepository = chatRepository,
        _ref = ref,
        super(false);

  void sentTextMessage({
    required BuildContext context,
    required String text,
    required receiverUserId,
    required bool isGroupChat,
  }) {
    final messageReply = _ref.read(messageReplyProvider);

    final senderUser = _ref.read(userProvider)!;
    _chatRepository.sentTextMessage(
      receiverUserId: receiverUserId,
      senderUser: senderUser,
      text: text,
      context: context,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
    _ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  Stream<List<ChatContactModel>> chatContacts(String uid) {
    return _chatRepository.getChatContacts(uid);
  }

  Stream<List<GroupModel>> getGroup(String uid) {
    return _chatRepository.getGroups(uid);
  }

  Stream<List<MessageModel>> getChatStream(String receiverUserId) async* {
    final user = _ref.read(userProvider)!;
    yield* _chatRepository.getChatStream(receiverUserId, user.uid);
  }

  Stream<List<MessageModel>> getGroupChatStream(String groupId) {
    return _chatRepository.getChatGroupStream(groupId);
  }

  void sentFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required MessageEnum messageType,
    required bool isGroupChat,
  }) {
    final messageReply = _ref.read(messageReplyProvider);
    final senderUserData = _ref.read(userProvider)!;
    _chatRepository.sentFileMessage(
      receiverUserId: receiverUserId,
      senderUserData: senderUserData,
      file: file,
      context: context,
      messageType: messageType,
      ref: _ref,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );

    _ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sentGIF({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required MessageEnum messageType,
    required bool isGroupChat,
  }) {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPath = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPath/200.gif';
    final messageReply = _ref.read(messageReplyProvider);
    final senderUser = _ref.read(userProvider)!;
    _chatRepository.sentGIFMessage(
      context: context,
      gifUrl: newGifUrl,
      receiverUserId: receiverUserId,
      senderUser: senderUser,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
    _ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    _chatRepository.setChatMessageSeen(
      context: context,
      messageId: messageId,
      receiverUserId: receiverUserId,
    );
  }
}
