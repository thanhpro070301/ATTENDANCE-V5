import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:attendance_/common/enum/message_enum.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  factory MessageModel({
    required String senderId,
    required String receiverId,
    required String messageId,
    required String text,
    required MessageEnum type,
    required DateTime timeSent,
    required bool isSeen,
    required String repliedMessage,
    required String repliedTo,
    required MessageEnum typeReply,
  }) = _MessageModel;
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
