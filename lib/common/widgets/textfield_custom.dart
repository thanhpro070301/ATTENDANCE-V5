import 'package:flutter/material.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldCustom extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isWriteListPhone;
  final void Function()? onPressed;
  const TextFieldCustom(
      {super.key,
      required this.hintText,
      this.controller,
      required this.keyboardType,
      this.isWriteListPhone = false,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      style: AppTheme.body1.copyWith(fontSize: 15.sp),
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: isWriteListPhone
            ? IconButton(
                icon: const Icon(Icons.sticky_note_2_outlined),
                onPressed: onPressed)
            : null,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        hintText: hintText,
        alignLabelWithHint: true,
        filled: true,
        border: InputBorder.none,
        fillColor: AppTheme.nearlyDarkBlue.withOpacity(0.1),
      ),
    );
  }
}

class TextFieldCustom2 extends StatelessWidget {
  const TextFieldCustom2({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.inputType,
    required this.maxLines,
  });
  final String hintText;
  final IconData icon;
  final TextInputType inputType;
  final TextEditingController controller;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        style: AppTheme.body2.copyWith(
          color: AppTheme.darkText,
        ),
        cursorColor: AppTheme.nearlyDarkBlue.withOpacity(0.9),
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.nearlyDarkBlue.withOpacity(0.9),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          hintText: hintText,
          alignLabelWithHint: true,
          filled: true,
          border: InputBorder.none,
          fillColor: AppTheme.nearlyDarkBlue.withOpacity(0.1),
        ),
      ),
    );
  }
}
