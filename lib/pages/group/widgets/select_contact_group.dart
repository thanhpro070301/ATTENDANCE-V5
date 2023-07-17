import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/pages/select_contacts/controller/select_contacts_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

final selectedGroupContacts =
    StateProvider.autoDispose<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup>
    with WidgetsBindingObserver {
  List<int> selectedContactsIndex = [];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider.notifier).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider.notifier).setUserState(false);
        break;
    }
  }

  void selectContact(int index, Contact contact) {
    HapticFeedback.heavyImpact();
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.notifier)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (contactList) => Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (BuildContext context, int index) {
                  final contact = contactList[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: InkWell(
                          onTap: () => selectContact(index, contact),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(contact.displayName,
                                  style: AppTheme.body2),
                              leading: selectedContactsIndex.contains(index)
                                  ? IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.done,
                                          color: AppTheme.darkText, size: 23.r),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          error: (err, trace) => ErrorText(
            text: err.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
