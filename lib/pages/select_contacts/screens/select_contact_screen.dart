import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/pages/select_contacts/controller/select_contacts_controller.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SelectContactScreen extends ConsumerStatefulWidget {
  static const routeName = '/select-contact-screen';
  const SelectContactScreen({super.key});

  @override
  ConsumerState<SelectContactScreen> createState() =>
      _SelectContactScreenState();
}

class _SelectContactScreenState extends ConsumerState<SelectContactScreen>
    with WidgetsBindingObserver {
  void selectContact(
      BuildContext context, WidgetRef ref, Contact selectContact) {
    HapticFeedback.heavyImpact();
    ref
        .read(selectContactControllerProvider.notifier)
        .selectContact(context, selectContact);
  }

  @override
  void initState() {
    super.initState();

    ref.read(selectContactControllerProvider.notifier).getContacts();
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
        ref.read(selectContactControllerProvider.notifier).getContacts();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider.notifier).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(selectContactControllerProvider);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppTheme.darkText,
        centerTitle: true,
        backgroundColor: AppTheme.background,
        title: TextWidget(
          text: 'Chọn từ danh bạ',
          color: AppTheme.darkerText,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
      ),
      body: isLoading
          ? const Loader()
          : ref.watch(getContactsProvider).when(
                data: (data) => AnimationLimiter(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final contact = data[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: InkWell(
                              onTap: () => selectContact(context, ref, contact),
                              child: Padding(
                                padding: EdgeInsets.all(2.w),
                                child: ListTile(
                                  title: Text(contact.displayName,
                                      style: AppTheme.body2),
                                  leading: contact.photo == null
                                      ? null
                                      : CircleAvatar(
                                          backgroundImage:
                                              MemoryImage(contact.photo!),
                                          radius: 30,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                error: (error, stackTrace) => ErrorText(text: error.toString()),
                loading: () => const Loader2(),
              ),
    );
  }
}
