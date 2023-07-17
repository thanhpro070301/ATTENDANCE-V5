import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'package:attendance_/common/enum/message_enum.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/chat/controller/chat_controller.dart';
import 'package:attendance_/pages/chat/widgets/my_message_card.dart';
import 'package:attendance_/pages/chat/widgets/sender_message_card.dart';
import 'package:attendance_/provider/message_reply_provider.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const ChatList(
      {Key? key, required this.receiverUserId, required this.isGroupChat})
      : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _scrollController = ScrollController();
  bool firstAutoScrollExecuted = false;
  bool shouldAutoScroll = false;
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollListener() {
    firstAutoScrollExecuted = true;
    if (_scrollController.hasClients &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      shouldAutoScroll = true;
    } else {
      shouldAutoScroll = false;
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      firstAutoScrollExecuted = true;
      if (_scrollController.hasClients && shouldAutoScroll) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref.watch(messageReplyProvider.notifier).update(
          (state) => MessageReply(message, isMe, messageEnum),
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider)!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (_scrollController.hasClients && shouldAutoScroll) {
          _scrollToBottom();
        }

        if (!firstAutoScrollExecuted && _scrollController.hasClients) {
          _scrollToBottom();
        }
      });
    });

    return widget.isGroupChat
        ? ref.watch(getChatGroupsProvider(widget.receiverUserId)).when(
              data: (data) => AnimationLimiter(
                child: ListView.builder(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final messageData = data[index];
                    var timeSent = DateFormat.Hm().format(messageData.timeSent);

                    if (!messageData.isSeen &&
                        messageData.receiverId == user.uid) {
                      ref
                          .read(chatControllerProvider.notifier)
                          .setChatMessageSeen(
                            context,
                            widget.receiverUserId,
                            messageData.messageId,
                          );
                    }
                    if (messageData.senderId == user.uid) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: MyMessageCard(
                                message: messageData.text,
                                date: timeSent,
                                messageType: messageData.type,
                                repliedText: messageData.repliedMessage,
                                username: messageData.repliedTo,
                                messageReplyType: messageData.typeReply,
                                isSeen: messageData.isSeen,
                                onLeftSwipe: () {
                                  developer.log(index.toString());
                                  developer.log(messageData.text);
                                  onMessageSwipe(
                                    messageData.text,
                                    true,
                                    messageData.type,
                                  );
                                }),
                          ),
                        ),
                      );
                    }
                    return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                                child: SenderMessageCard(
                                    message: messageData.text,
                                    date: timeSent,
                                    type: messageData.type,
                                    username: messageData.repliedTo,
                                    repliedText: messageData.repliedMessage,
                                    messageReplyType: messageData.typeReply,
                                    onRightSwipe: () {
                                      developer.log(messageData.text);
                                      onMessageSwipe(
                                        messageData.text,
                                        false,
                                        messageData.type,
                                      );
                                    }))));
                  },
                ),
              ),
              error: (error, stackTrace) => ErrorText(text: error.toString()),
              loading: () => const Loader(),
            )
        : ref.watch(getChatStreamProvider(widget.receiverUserId)).when(
              data: (data) => AnimationLimiter(
                child: ListView.builder(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final messageData = data[index];
                    var timeSent = DateFormat.Hm().format(messageData.timeSent);
                    if (!messageData.isSeen &&
                        messageData.receiverId == user.uid) {
                      ref
                          .watch(chatControllerProvider.notifier)
                          .setChatMessageSeen(
                            context,
                            widget.receiverUserId,
                            messageData.messageId,
                          );
                    }
                    if (messageData.senderId == user.uid) {
                      final messageText = messageData.text;
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: MyMessageCard(
                                message: messageData.text,
                                date: timeSent,
                                messageType: messageData.type,
                                repliedText: messageData.repliedMessage,
                                username: messageData.repliedTo,
                                messageReplyType: messageData.typeReply,
                                isSeen: messageData.isSeen,
                                onLeftSwipe: () {
                                  developer.log(messageText);

                                  onMessageSwipe(
                                    messageData.text,
                                    true,
                                    messageData.type,
                                  );
                                }),
                          ),
                        ),
                      );
                    }
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: SenderMessageCard(
                              message: messageData.text,
                              date: timeSent,
                              type: messageData.type,
                              username: messageData.repliedTo,
                              repliedText: messageData.repliedMessage,
                              messageReplyType: messageData.typeReply,
                              onRightSwipe: () {
                                onMessageSwipe(
                                  messageData.text,
                                  true,
                                  messageData.type,
                                );
                              }),
                        ),
                      ),
                    );
                  },
                ),
              ),
              error: (error, stackTrace) => ErrorText(text: error.toString()),
              loading: () => const Loader(),
            );
  }
}
