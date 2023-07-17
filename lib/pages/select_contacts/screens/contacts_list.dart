import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:attendance_/common/values/theme.dart';
import 'dart:developer' as developer;
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/chat/controller/chat_controller.dart';
import 'package:attendance_/pages/chat/screens/mobile_chat_screen.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                ref.watch(getGroupsProvider(user.uid)).when(
                      data: (data) => AnimationLimiter(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final groupData = data[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          HapticFeedback.heavyImpact();
                                          Navigator.of(context).pushNamed(
                                              MobileChatScreen.routeName,
                                              arguments: {
                                                'name': groupData.name,
                                                'uid': groupData.groupId,
                                                'isGroupChat': true,
                                                'profilePic': groupData.groupPic
                                              });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: ListTile(
                                            title: Text(groupData.name,
                                                style: AppTheme.body1.copyWith(
                                                    color: AppTheme.darkText,
                                                    fontSize: 18)),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Text(
                                                groupData.lastMessage,
                                                style:
                                                    TextStyle(fontSize: 15.sp),
                                              ),
                                            ),
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  groupData.groupPic),
                                              radius: 30,
                                            ),
                                            trailing: Text(
                                              DateFormat.Hm()
                                                  .format(groupData.timeSent),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                          color: AppTheme.nearlyDarkBlue
                                              .withOpacity(0.9),
                                          indent: 85),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader(),
                    ),
                ref.watch(getChatContactsProvider(user.uid)).when(
                      data: (data) => AnimationLimiter(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final chatContactData = data[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          developer
                                              .log(chatContactData.contactId);
                                          HapticFeedback.heavyImpact();
                                          Navigator.of(context).pushNamed(
                                              MobileChatScreen.routeName,
                                              arguments: {
                                                'name': chatContactData.name,
                                                'uid':
                                                    chatContactData.contactId,
                                                'isGroupChat': false,
                                                'profilePic':
                                                    chatContactData.profilePic,
                                              });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: ListTile(
                                            title: Text(chatContactData.name,
                                                style: AppTheme.body1.copyWith(
                                                    color: AppTheme.darkText,
                                                    fontSize: 18.sp)),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Text(
                                                chatContactData.lastMessenger,
                                                style:
                                                    TextStyle(fontSize: 15.sp),
                                              ),
                                            ),
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  chatContactData.profilePic),
                                              radius: 30,
                                            ),
                                            trailing: Text(
                                              DateFormat.Hm().format(
                                                  chatContactData.timeSent),
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                          color: AppTheme.nearlyDarkBlue
                                              .withOpacity(0.9),
                                          indent: 85),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader(),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
