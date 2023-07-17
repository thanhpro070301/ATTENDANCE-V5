// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Failure {
  final String message;
  Failure(this.message);
}

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef DialogBuilder = Widget Function(BuildContext context, String message);

final displayValueProvider = StateProvider((ref) => '');

void openAppSettings(WidgetRef ref) async {
  final opened = await _geolocatorPlatform.openAppSettings();

  if (opened) {
    ref
        .read(displayValueProvider.notifier)
        .update((state) => 'Opened Application Settings.');
  } else {
    ref
        .read(displayValueProvider.notifier)
        .update((state) => 'Error opening Application Settings.');
  }
}

void openLocationSettings(WidgetRef ref) async {
  final opened = await _geolocatorPlatform.openLocationSettings();

  if (opened) {
    ref
        .read(displayValueProvider.notifier)
        .update((state) => 'Opened Location Settings');
  } else {
    ref
        .read(displayValueProvider.notifier)
        .update((state) => 'Error opening Location Settings');
  }
}

extension ScreenSizeExtension on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
}

String formatTimeAttendance(String dateTimeString) {
  List<String> dateTimeParts = dateTimeString.split(' ');
  String timeString = dateTimeParts[1];

  List<String> timeParts = timeString.split(':');
  String hour = timeParts[0];
  String minute = timeParts[1];

  String formattedTime = "$hour:$minute";

  return formattedTime;
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}

Future<String> saveImageLocally(Uint8List imageData) async {
  Directory tempDir = Directory.systemTemp;
  String fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
  String filePath = '${tempDir.path}/$fileName';
  File file = File(filePath);
  await file.writeAsBytes(imageData);
  return filePath;
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBarCustom(context, ContentType.failure, 'Oh Snap!', e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBarCustom(context, ContentType.failure, 'Oh Snap!', e.toString());
  }
  return video;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: 'CgUBkOYWiHhR9DtJ0ugdCboAfaFKrkWU',
    );
  } catch (e) {
    showSnackBarCustom(context, ContentType.failure, 'Oh Snap!', e.toString());
  }
  return gif;
}

Future<void> getCurrentPosition(Ref ref) async {
  final hasPermission = await _handlePermission();

  if (!hasPermission) {
    return;
  }

  final position = await _geolocatorPlatform.getCurrentPosition();

  final List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  if (placemarks.isNotEmpty) {
    final Placemark placemark = placemarks.last;
    ref.read(userAddressProvider.notifier).state =
        placemark.administrativeArea!;
  }
}

final openCameraPermissionProvider = StateProvider((ref) => false);
Future<bool> requestCameraPermission(WidgetRef ref) async {
  PermissionStatus status = await Permission.camera.request();
  if (status.isGranted) {
    ref.read(openCameraPermissionProvider.notifier).update((state) => true);
  } else {
    ref.read(openCameraPermissionProvider.notifier).update((state) => false);
  }
  return status.isGranted;
}

final userAddressProvider = StateProvider((ref) => '');

final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
Future<bool> _handlePermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  permission = await _geolocatorPlatform.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await _geolocatorPlatform.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  return true;
}

Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId = '';

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.product;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor!;
  }

  developer.log('Device ID: $deviceId');

  return deviceId;
}

String capitalize(String word) {
  if (word.isEmpty) {
    return word;
  }

  return word[0].toUpperCase() + word.substring(1);
}

void showSnackBarCustom(BuildContext context, ContentType contentType,
    String title, String content) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: content,
      messageFontSize: 15.sp,
      titleFontSize: 17.sp,
      contentType: contentType,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

String formatTime(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = remainingSeconds.toString().padLeft(2, '0');
  return '$minutesStr:$secondsStr';
}

String formatDate(DateTime date) {
  String dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());
  return dateNow;
}

String formatDateTime(DateTime date) {
  String dateNow = DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now());
  return dateNow;
}
