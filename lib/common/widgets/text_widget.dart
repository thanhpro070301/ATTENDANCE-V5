import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendance_/common/values/theme.dart';

class TextWidget extends StatelessWidget {
  final Color color;
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final TextAlign textAlign;
  const TextWidget({
    super.key,
    required this.text,
    required this.fontWeight,
    Color? color,
    double? fontSize,
    TextAlign? textAlign,
  })  : color = color ?? AppTheme.darkerText,
        textAlign = textAlign ?? TextAlign.center,
        fontSize = fontSize ?? 14;

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.ellipsis,
      text,
      textAlign: textAlign,
      style: GoogleFonts.spaceGrotesk(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }
}
