import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import 'package:permission_handler/permission_handler.dart';

final pathDownloadProvider = StateProvider((ref) => '');
final pathDocumentProvider = StateProvider((ref) => '');
final pathDcimProvider = StateProvider((ref) => '');

Future<bool> getPublicDirectoryPath(WidgetRef ref) async {
  PermissionStatus status = await Permission.manageExternalStorage.status;
  developer.log('$status');

  if (!status.isGranted) {
    status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      developer.log('Chưa cấp quyền truy cập');
      return false;
    }
  }

  String pathDOWNLOADS = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
  String pathdirectoryDocuments =
      await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOCUMENTS);
  String pathdirectoryDcim =
      await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DCIM);

  if (pathDOWNLOADS.isNotEmpty) {
    developer.log('PATH DOWNLOADS: $pathDOWNLOADS');
    ref.read(pathDownloadProvider.notifier).update((state) => pathDOWNLOADS);
    return true;
  } else if (pathDOWNLOADS.isEmpty && pathdirectoryDocuments.isNotEmpty) {
    developer.log('PATH DIRECTORY DOCUMENTS: $pathdirectoryDocuments');
    ref
        .read(pathDocumentProvider.notifier)
        .update((state) => pathdirectoryDocuments);
    return true;
  } else if (pathdirectoryDocuments.isEmpty && pathdirectoryDcim.isNotEmpty) {
    ref.read(pathDcimProvider.notifier).update((state) => pathdirectoryDcim);
    return true;
  } else {
    debugPrint('You don\'t have a valid path');
    return false;
  }
}
