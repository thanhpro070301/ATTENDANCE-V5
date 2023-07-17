import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/pages/select_contacts/repository/select_contacts_repository.dart';

final selectContactControllerProvider =
    StateNotifierProvider.autoDispose<SelectContactController, bool>((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactController(
      selectContactRepository: selectContactRepository);
});
final getContactsProvider = FutureProvider.autoDispose(
  (ref) {
    final selectContactController =
        ref.watch(selectContactControllerProvider.notifier);
    return selectContactController.getContacts();
  },
);

class SelectContactController extends StateNotifier<bool> {
  final SelectContactRepository _selectContactRepository;
  SelectContactController({
    required SelectContactRepository selectContactRepository,
  })  : _selectContactRepository = selectContactRepository,
        super(false);

  Future<List<Contact>> getContacts() async {
    return await _selectContactRepository.getConTacts();
  }

  void selectContact(BuildContext context, Contact selectContact) async {
    await _selectContactRepository.selectContact(context, selectContact);
  }
}
