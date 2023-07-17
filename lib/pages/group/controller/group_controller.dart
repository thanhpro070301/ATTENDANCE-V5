import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/pages/group/repository/group_repository.dart';

final groupControllerProvider =
    StateNotifierProvider.autoDispose<GroupController, bool>(
  (ref) => GroupController(groupRepository: ref.watch(groupRepositoryProvider)),
);

class GroupController extends StateNotifier<bool> {
  final GroupRepository _groupRepository;

  GroupController({required GroupRepository groupRepository})
      : _groupRepository = groupRepository,
        super(false);
  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContact) {
    state = true;
    _groupRepository.createGroup(
      context: context,
      name: name,
      profilePic: profilePic,
      selectedContact: selectedContact,
    );
    state = false;
  }
}
