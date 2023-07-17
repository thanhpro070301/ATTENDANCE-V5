import 'package:flutter/material.dart';
import 'package:attendance_/common/values/theme.dart';

class ChooseDateButton extends StatelessWidget {
  final VoidCallback voidCallback;
  final String text;

  const ChooseDateButton({
    super.key,
    required this.voidCallback,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.nearlyDarkBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        onPressed: voidCallback,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            fixedSize: const Size(250, 50),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
