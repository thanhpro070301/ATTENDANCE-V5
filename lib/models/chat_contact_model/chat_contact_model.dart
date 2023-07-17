import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_contact_model.freezed.dart';
part 'chat_contact_model.g.dart';

@freezed
class ChatContactModel with _$ChatContactModel {
  factory ChatContactModel({
    required String name,
    required String profilePic,
    required String contactId,
    required DateTime timeSent,
    required String lastMessenger,
  }) = _ChatContactModel;
  factory ChatContactModel.fromJson(Map<String, dynamic> json) =>
      _$ChatContactModelFromJson(json);
}
