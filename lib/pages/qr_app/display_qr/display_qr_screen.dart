import 'package:attendance_/common/utils.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/qr_app/qr_scanner/qr_scanner.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/common/widgets/tool.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class DisplayQrScreen extends ConsumerStatefulWidget {
  static const routeName = '/display-qr-screen';
  final String data;
  const DisplayQrScreen({super.key, required this.data});

  @override
  ConsumerState<DisplayQrScreen> createState() => _DisplayQrScreenState();
}

class _DisplayQrScreenState extends ConsumerState<DisplayQrScreen>
    with WidgetsBindingObserver {
  late PermissionStatus permissionStatus;
  final GlobalKey _globalKey = GlobalKey();
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
        debugPrint('Resumed');
        ref.read(authControllerProvider.notifier).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        debugPrint('Inactive');
        ref.read(authControllerProvider.notifier).setUserState(false);
        break;
    }
  }

  Uint8List modifyImageColor(Uint8List imageData,
      {int red = 255, int green = 255, int blue = 0}) {
    img.Image image = img.decodeImage(imageData.toList())!;
    for (int x = 0; x < image.width; x++) {
      for (int y = 0; y < image.height; y++) {
        int color = image.getPixel(x, y);
        int alpha = img.getAlpha(color);
        int newColor = img.getColor(red, green, blue, alpha);
        image.setPixel(x, y, newColor);
      }
    }
    return Uint8List.fromList(img.encodePng(image));
  }

  _saveScreen() async {
    HapticFeedback.heavyImpact();
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      Uint8List imageData = byteData.buffer.asUint8List();
      Uint8List modifiedImageData =
          modifyImageColor(imageData, red: 255, green: 255, blue: 0);
      await ImageGallerySaver.saveImage(modifiedImageData);

      if (context.mounted) {
        showSnackBarCustom(
            context, ContentType.success, 'Thành công!', 'Lưu ảnh thành công');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppTheme.darkText,
        centerTitle: true,
        backgroundColor: AppTheme.nearlyWhite,
        title: Text(
          "Quét QR",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AnimationLimiter(
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    Gap(20.h),
                    RepaintBoundary(
                      key: _globalKey,
                      child: QrImageView(
                        data: widget.data,
                        size: 230,
                        version: QrVersions.auto,
                      ),
                    ),
                    Gap(25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyTool(
                            icon: const Icon(CupertinoIcons.down_arrow),
                            text: "Lưu",
                            onPressed: _saveScreen),
                        MyTool(
                          icon: const Icon(CupertinoIcons.doc_text_viewfinder),
                          text: "Quét QR",
                          onPressed: () {
                            HapticFeedback.heavyImpact();

                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: const QrScannerScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
