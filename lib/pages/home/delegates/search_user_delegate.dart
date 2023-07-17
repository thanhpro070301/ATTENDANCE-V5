import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';

class SearchUserDelegate extends SearchDelegate {
  final WidgetRef _ref;
  SearchUserDelegate({required WidgetRef ref}) : _ref = ref;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _ref.watch(searchUserDataProvider(query)).when(
        data: (users) => SizedBox(
              height: 1000.h,
              child: ListView.separated(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = users[index];
                  return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                      ),
                      title: Text(user.name, style: AppTheme.body2),
                      onTap: () => navigateToUserProfile(context, user.uid));
                },
                separatorBuilder: (_, __) => Gap(5.h),
              ),
            ),
        error: (error, stackTrace) => ErrorText(text: error.toString()),
        loading: () => const LoadingPage());
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Navigator.push(
      context,
      PageTransition(
        curve: Curves.bounceOut,
        type: PageTransitionType.leftToRightWithFade,
        alignment: Alignment.topCenter,
        child: UserProfile(uid: uid),
      ),
    );
  }
}
