import 'package:attendance_/common/values/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 90,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.fromBorderSide(BorderSide(
            width: 0.5,
            color: AppTheme.dismissibleBackground,
            style: BorderStyle.solid,
          )),
          color: AppTheme.nearlyWhite,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: LoadingAnimationWidget.flickr(
          leftDotColor: const Color(0xFF0063DC),
          rightDotColor: const Color(0xFFFF0084),
          size: 25.r,
        ),
      ),
    );
  }
}

class Loader2 extends StatelessWidget {
  const Loader2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.flickr(
        leftDotColor: const Color(0xFF0063DC),
        rightDotColor: const Color(0xFFFF0084),
        size: 25.r,
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: AppTheme.dismissibleBackground,
          size: 50.r,
        ),
      ),
    );
  }
}
