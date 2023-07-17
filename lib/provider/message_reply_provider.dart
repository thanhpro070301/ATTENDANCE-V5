import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/enum/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(this.message, this.isMe, this.messageEnum);
}

final messageReplyProvider =
    StateProvider.autoDispose<MessageReply?>((ref) => null);