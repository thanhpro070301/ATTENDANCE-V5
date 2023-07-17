import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required String uid,
    required String name,
    required String email,
    required String profilePic,
    required String phoneNumber,
    required String code,
    required String banner,
    required DateTime createdAt,
    required String updatedAt,
    required bool isOnline,
    required List<String> groupId,
  }) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
