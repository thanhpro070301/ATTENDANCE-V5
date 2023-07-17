import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/chat/screens/mobile_chat_screen.dart';
import 'package:attendance_/pages/class_and_subject/class/controller/class_controller.dart';
import 'package:attendance_/pages/user_profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UserProfile extends ConsumerWidget {
  static const routeName = '/user-profile';
  final String uid;

  const UserProfile({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userReal = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getUserDataByIdProvider(uid)).when(
            data: (user) {
              return NestedScrollView(
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      expandedHeight: 240,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                              child: Image.network(
                            user.banner,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Colors.grey, BlendMode.saturation),
                                  child: Loader(),
                                );
                              }
                            },
                            fit: BoxFit.cover,
                          )),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding:
                                const EdgeInsets.all(20).copyWith(bottom: 70),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius: 35,
                            ),
                          ),
                          if (userReal.uid == uid)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.all(20.w),
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, EditProfile.routeName,
                                      arguments: user.uid);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.background,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w)),
                                child: Text('Sửa thông tin',
                                    style: AppTheme.body2.copyWith(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          if (userReal.uid != uid)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.all(20.w),
                              child: OutlinedButton(
                                onPressed: () {
                                  ref.read(getUserDataByIdProvider(uid)).when(
                                        data: (userData) => Navigator.pushNamed(
                                            context, MobileChatScreen.routeName,
                                            arguments: {
                                              'name': userData.name,
                                              'uid': userData.uid,
                                              'isGroupChat': false,
                                              'profilePic': userData.profilePic,
                                            }),
                                        error: (error, stackTrace) =>
                                            ErrorText(text: error.toString()),
                                        loading: () => const Loader(),
                                      );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.background,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w)),
                                child: Text('Nhắn tin',
                                    style: AppTheme.body2.copyWith(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(16.w),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Gap(5.h),
                            SizedBox(
                              width: context.screenSize.width / 2,
                              child: Text(
                                'Tên: ${user.name}',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Gap(5.h),
                            SizedBox(
                              width: context.screenSize.width / 2,
                              child: Text(
                                'SĐT: ${user.phoneNumber}',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Gap(5.h),
                            SizedBox(
                              width: context.screenSize.width / 2,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                'Email: ${user.email}',
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Gap(5.h),
                            SizedBox(
                              width: context.screenSize.width / 2,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                'Mã code: ${user.code}',
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: ref.watch(getClassProvider(uid)).when(
                      data: (data) {
                        return SizedBox(
                          height: 500,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return null;
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10.h,
                            ),
                          ),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader(),
                    ),
              );
            },
            error: (error, stackTrace) => ErrorText(text: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
