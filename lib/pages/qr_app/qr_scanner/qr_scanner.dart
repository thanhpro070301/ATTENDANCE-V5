import 'dart:io';
import 'dart:developer' as developer;
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/theme.dart';

import 'package:attendance_/pages/attendance/controller/attendance_controller.dart';
import 'package:attendance_/common/widgets/tool.dart';

final barCodeQrProvider = StateProvider.autoDispose((ref) => '');

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen>
    with WidgetsBindingObserver {
  late File imageFile;
  late bool result;
  bool isScanned = false;
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.front,
    torchEnabled: true,
  );

  @override
  void initState() {
    super.initState();
    requestCameraPermission(ref);
    ref.read(openCameraPermissionProvider);
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
        ref.read(openCameraPermissionProvider);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider.notifier).setUserState(false);
        ref.read(openCameraPermissionProvider);
        break;
    }
  }

  void selectGalleryImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        imageFile = File(res.files.first.path!);
      });

      result = await controller.analyzeImage(imageFile.path);
      developer.log(result.toString());
    }
  }

  bool isFlash = false;

  bool isCam = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(attendanceControllerProvider);
    final isCheckCP = ref.watch(openCameraPermissionProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyWhite,
        foregroundColor: AppTheme.darkText,
        leading: IconButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: TextWidget(
          text: 'Quét mã QR',
          color: AppTheme.darkerText,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
        centerTitle: true,
      ),
      body: isCheckCP
          ? Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gap(20.h),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Đưa mã QR của bạn vào đây",
                              style: AppTheme.body2.copyWith(
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              "Tự động quét",
                              style: AppTheme.body2.copyWith(
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: MobileScanner(
                          controller: controller,
                          onDetect: (capture) async {
                            if (!isScanned) {
                              HapticFeedback.heavyImpact();
                              final List<Barcode> barcodes = capture.barcodes;
                              // final Uint8List? image = capture.image;
                              late String dataQR;
                              for (final barcode in barcodes) {
                                debugPrint(
                                    'Barcode found! ${barcode.rawValue}');
                                dataQR = barcode.rawValue ?? '---';
                              }
                              if (dataQR.isNotEmpty) {
                                if (context.mounted) {
                                  ref
                                      .read(
                                          attendanceControllerProvider.notifier)
                                      .createAttendanceForLesson(
                                          context: context, idLesson: dataQR);
                                }
                                isScanned = true;
                              }
                            }
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyTool(
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                setState(() {
                                  isFlash = !isFlash;
                                });
                                controller.toggleTorch();
                              },
                              text: "Đèn pin",
                              icon: Icon(
                                Icons.flash_on,
                                color: isFlash
                                    ? const Color.fromARGB(255, 193, 193, 35)
                                    : AppTheme.nearlyWhite,
                              ),
                            ),
                            MyTool(
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                setState(() {
                                  isCam = !isCam;
                                });
                                controller.switchCamera();
                              },
                              text: "Máy ảnh",
                              icon: const Icon(
                                CupertinoIcons.camera_rotate,
                                color: Colors.white,
                              ),
                            ),
                            MyTool(
                              text: "Thư viện",
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                selectGalleryImage();
                              },
                              icon: const Icon(
                                CupertinoIcons.photo_fill_on_rectangle_fill,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading) const Loader()
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: TextWidget(
                      text:
                          ' Vui lòng cấp quyền truy \n cập camera để sử dụng ứng dụng.',
                      color: AppTheme.darkerText,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  Gap(7.h),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.settings),
                    label: TextWidget(
                      text: 'Mở trong cài đặt.',
                      color: AppTheme.darkerText,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                    onPressed: () {
                      openAppSettings(ref);
                    },
                  )
                ],
              ),
            ),
    );
  }
}
