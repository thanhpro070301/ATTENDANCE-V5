import 'dart:async';
import 'dart:io';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/path_provider.dart';
import 'package:excel/excel.dart' as ex;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snack;

Set<Map<String, dynamic>> studentDataSet = {};

List<Map<String, dynamic>> studentData = studentDataSet.toList();
Set<Map<String, dynamic>> studentDataRead = {};
Set<Map<String, dynamic>> studentDataRead2 = {};
final Set<String> listPhoneNumberExcel = {};

Set<Map<String, dynamic>> testDataImport = {};

Future<void> createExcelFile(
    BuildContext context, WidgetRef ref, String nameFile) async {
  final excel = ex.Excel.createExcel();

  final sheet = excel['Sheet1'];

  sheet.cell(ex.CellIndex.indexByString("A1")).value = "Tên";
  sheet.cell(ex.CellIndex.indexByString("B1")).value = "Trạng thái điểm danh";
  sheet.cell(ex.CellIndex.indexByString("C1")).value = "Tên thiết bị";
  sheet.cell(ex.CellIndex.indexByString("D1")).value = "Địa chỉ";
  sheet.cell(ex.CellIndex.indexByString("E1")).value = "Thời gian điểm danh";

  for (int i = 0; i < studentData.length; i++) {
    sheet.cell(ex.CellIndex.indexByString("A${i + 2}")).value =
        studentData[i]["name"];
    sheet.cell(ex.CellIndex.indexByString("B${i + 2}")).value =
        studentData[i]["statusAttendance"];
    sheet.cell(ex.CellIndex.indexByString("C${i + 2}")).value =
        studentData[i]["deviceName"];
    sheet.cell(ex.CellIndex.indexByString("D${i + 2}")).value =
        studentData[i]["location"];
    sheet.cell(ex.CellIndex.indexByString("E${i + 2}")).value =
        studentData[i]["timeAttendance"];
  }

  final excelData = excel.encode();
  final checkPermission = await getPublicDirectoryPath(ref);

  if (checkPermission) {
    final pathDownload = ref.read(pathDownloadProvider);
    final pathDcim = ref.read(pathDcimProvider);
    final pathDocument = ref.read(pathDocumentProvider);

    if (pathDownload.isNotEmpty) {
      final filePath = '$pathDownload/$nameFile.xlsx';
      final file = File(filePath);
      if (studentData.isEmpty) {
        if (context.mounted) {
          showSnackBarCustom(
              context,
              snack.ContentType.warning,
              'Có một vấn đề nhỏ!',
              'Danh sách điểm danh của bạn đang trống, vui lòng kiểm tra lại!');
          return;
        }
      } else {
        await file.writeAsBytes(excelData!).then((value) => showSnackBarCustom(
            context,
            snack.ContentType.success,
            'Thành công!',
            'Xuất Excel thành công'));
        developer.log('Excel file created at: $filePath');
      }
      return;
    } else if (pathDownload.isEmpty && pathDocument.isNotEmpty) {
      final filePath = '$pathDocument/$nameFile.xlsx';
      final file = File(filePath);
      if (studentData.isEmpty) {
        if (context.mounted) {
          showSnackBarCustom(
              context,
              snack.ContentType.warning,
              'Có một vấn đề nhỏ!',
              'Danh sách điểm danh của bạn đang trống, vui lòng kiểm tra lại!');
          return;
        }
        studentData.clear();
      } else {
        await file.writeAsBytes(excelData!).then((value) => showSnackBarCustom(
            context,
            snack.ContentType.success,
            'Thành công!',
            'Xuất Excel thành công'));
        developer.log('Excel file created at: $filePath');
      }
      studentData.clear();
      return;
    } else if (pathDownload.isEmpty ||
        pathDocument.isEmpty && pathDcim.isNotEmpty) {
      final filePath = '$pathDcim/$nameFile.xlsx';
      final file = File(filePath);
      if (studentData.isEmpty) {
        if (context.mounted) {
          showSnackBarCustom(
              context,
              snack.ContentType.warning,
              'Có một vấn đề nhỏ!',
              'Danh sách điểm danh của bạn đang trống, vui lòng kiểm tra lại!');
          return;
        }
      } else {
        await file.writeAsBytes(excelData!).then((value) => showSnackBarCustom(
            context,
            snack.ContentType.success,
            'Thành công!',
            'Xuất Excel thành công'));
        developer.log('Excel file created at: $filePath');
      }
      studentData.clear();
      return;
    } else {
      getPublicDirectoryPath(ref);
    }
  }
}

Set<String> getPhoneOfExcel() {
  for (var element in studentDataRead) {
    final name = element['name']?.toString() ?? '';
    final numberPhone = element['numberPhone']?.toString() ?? '';

    debugPrint(name);
    listPhoneNumberExcel.add(numberPhone);
    developer.log('$listPhoneNumberExcel');
  }
  return listPhoneNumberExcel;
}

String getTableNameExcel(ex.Excel excel) {
  String nameTable = '';
  for (var table in excel.tables.keys) {
    nameTable = table;
  }
  return nameTable;
}

Future<void> readExcelFile(WidgetRef ref) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    studentDataRead.clear();

    developer.log('PATH: ${file.name}');

    final checkPermission = await getPublicDirectoryPath(ref);

    if (checkPermission) {
      final pathDownload = ref.read(pathDownloadProvider);
      final pathDcim = ref.read(pathDcimProvider);
      final pathDocument = ref.read(pathDocumentProvider);

      if (pathDownload.isNotEmpty) {
        final filePath = '$pathDownload/${file.name}';

        File excelFile = File(filePath);

        List<int> bytes = excelFile.readAsBytesSync();

        final excel = ex.Excel.decodeBytes(bytes);

        final sheet = excel[getTableNameExcel(excel)];
        print(getTableNameExcel(excel));
        for (int i = 2; i <= sheet.maxRows; i++) {
          final name = sheet.cell(ex.CellIndex.indexByString("A$i")).value;
          final numberPhone =
              sheet.cell(ex.CellIndex.indexByString("B$i")).value;

          if (name != null && numberPhone != null) {
            final student = {
              "name": name,
              "numberPhone": numberPhone,
            };

            studentDataRead.add(student);
          }
        }
        developer.log('Student nek $studentDataRead');
        return;
      } else if (pathDownload.isEmpty && pathDocument.isNotEmpty) {
        final filePath = '$pathDocument/${file.name}';

        File excelFile = File(filePath);

        List<int> bytes = excelFile.readAsBytesSync();

        final excel = ex.Excel.decodeBytes(bytes);

        final sheet = excel[getTableNameExcel(excel)];

        for (int i = 2; i <= sheet.maxRows; i++) {
          final name = sheet.cell(ex.CellIndex.indexByString("A$i")).value;
          final numberPhone =
              sheet.cell(ex.CellIndex.indexByString("B$i")).value;

          if (name != null && numberPhone != null) {
            final student = {
              "name": name,
              "numberPhone": numberPhone,
            };

            studentDataRead.add(student);
          }
        }

        developer.log('$studentDataRead');
        return;
      } else if (pathDownload.isEmpty &&
          pathDocument.isEmpty &&
          pathDcim.isNotEmpty) {
        final filePath = '$pathDcim/${file.name}';

        File excelFile = File(filePath);

        List<int> bytes = excelFile.readAsBytesSync();

        final excel = ex.Excel.decodeBytes(bytes);

        final sheet = excel[getTableNameExcel(excel)];

        for (int i = 2; i <= sheet.maxRows; i++) {
          final name = sheet.cell(ex.CellIndex.indexByString("A$i")).value;
          final numberPhone =
              sheet.cell(ex.CellIndex.indexByString("B$i")).value;

          if (name != null && numberPhone != null) {
            final student = {
              "name": name,
              "numberPhone": numberPhone,
            };

            studentDataRead.add(student);
          }
        }
        developer.log('Student nek $studentDataRead');

        return;
      } else {
        getPublicDirectoryPath(ref);
      }
    }
  }
}

List<Map<String, dynamic>> testDataList = testDataImport.toList();

Future<void> createExcelFileTest(
    BuildContext context, WidgetRef ref, String nameFile) async {
  final excel = ex.Excel.createExcel();

  final sheet = excel['Sheet1'];

  sheet.cell(ex.CellIndex.indexByString("A1")).value = "Tên";
  sheet.cell(ex.CellIndex.indexByString("B1")).value = "Số điện thoại";

  for (int i = 0; i < testDataList.length; i++) {
    sheet.cell(ex.CellIndex.indexByString("A${i + 2}")).value =
        testDataList[i]["name"];
    sheet.cell(ex.CellIndex.indexByString("B${i + 2}")).value =
        testDataList[i]["phoneNumber"];
  }

  final excelData = excel.encode();

  final checkPermission = await getPublicDirectoryPath(ref);

  if (checkPermission) {
    final pathDownload = ref.read(pathDownloadProvider);
    final pathDcim = ref.read(pathDcimProvider);
    final pathDocument = ref.read(pathDocumentProvider);

    if (pathDownload.isNotEmpty) {
      final filePath = '$pathDownload/TESTDATA$nameFile.xlsx';
      final file = File(filePath);
      if (testDataList.isEmpty) {
        if (context.mounted) {
          showSnackBarCustom(
              context,
              snack.ContentType.warning,
              'Có một vấn đề nhỏ!',
              'Danh sách điểm danh của bạn trống, vui lòng kiểm tra lại!');
          return;
        }
      } else {
        developer.log('Excel file: $testDataList');
        await file.writeAsBytes(excelData!).then((value) => showSnackBarCustom(
            context,
            snack.ContentType.success,
            'Thành công!',
            'Xuất Excel Test $filePath'));
        developer.log('Excel file created at: $filePath');
      }
      return;
    } else if (pathDownload.isEmpty && pathDocument.isNotEmpty) {
      final filePath = '$pathDocument/TESTDATA$nameFile.xlsx';
      final file = File(filePath);
      if (testDataList.isEmpty) {
        if (context.mounted) {
          showSnackBarCustom(
              context,
              snack.ContentType.warning,
              'Có một vấn đề nhỏ!',
              'Danh sách điểm danh của bạn trống, vui lòng kiểm tra lại!');
          return;
        }
      } else {
        developer.log('Excel file: $testDataList');
        await file.writeAsBytes(excelData!).then((value) => showSnackBarCustom(
            context,
            snack.ContentType.success,
            'Thành công!',
            'Xuất Excel Test $filePath'));
        developer.log('Excel file created at: $filePath');
      }
      return;
    } else if (pathDownload.isEmpty &&
        pathDocument.isEmpty &&
        pathDcim.isNotEmpty) {
      final filePath = '$pathDcim/TESTDATA$nameFile.xlsx';
      final file = File(filePath);
      if (testDataList.isEmpty) {
        if (context.mounted) {
          showSnackBarCustom(
              context,
              snack.ContentType.warning,
              'Có một vấn đề nhỏ!',
              'Danh sách điểm danh của bạn trống, vui lòng kiểm tra lại!');
          return;
        }
      } else {
        developer.log('Excel file: $testDataList');
        await file.writeAsBytes(excelData!).then((value) => showSnackBarCustom(
            context,
            snack.ContentType.success,
            'Thành công!',
            'Xuất Excel Test $filePath'));
        developer.log('Excel file created at: $filePath');
      }
      return;
    }
  }
  testDataList.clear();
}

Future<void> createExcelStatisticalFile(
    BuildContext context, WidgetRef ref, String nameFile) async {
  final excel = ex.Excel.createExcel();

  final sheet = excel['Sheet1'];

  sheet.cell(ex.CellIndex.indexByString("A1")).value = "Tên";
  sheet.cell(ex.CellIndex.indexByString("B1")).value = "Trạng thái điểm danh";
  sheet.cell(ex.CellIndex.indexByString("C1")).value = "Tên thiết bị";
  sheet.cell(ex.CellIndex.indexByString("D1")).value = "Địa chỉ";
  sheet.cell(ex.CellIndex.indexByString("E1")).value = "Thời gian điểm danh";

  for (int i = 0; i < studentData.length; i++) {
    sheet.cell(ex.CellIndex.indexByString("A${i + 2}")).value =
        studentData[i]["name"];
    sheet.cell(ex.CellIndex.indexByString("B${i + 2}")).value =
        studentData[i]["statusAttendance"];
    sheet.cell(ex.CellIndex.indexByString("C${i + 2}")).value =
        studentData[i]["deviceName"];
    sheet.cell(ex.CellIndex.indexByString("D${i + 2}")).value =
        studentData[i]["location"];
    sheet.cell(ex.CellIndex.indexByString("E${i + 2}")).value =
        studentData[i]["timeAttendance"];
  }

  final excelData = excel.encode();
  final checkPermission = await getPublicDirectoryPath(ref);
  if (checkPermission) {
    final pathDownload = ref.read(pathDownloadProvider);
    final pathDcim = ref.read(pathDcimProvider);
    final pathDocument = ref.read(pathDocumentProvider);

    if (pathDownload.isNotEmpty) {
      final filePath = '$pathDownload/$nameFile.xlsx';
      final file = File(filePath);
      if (studentData.isEmpty) {
        if (context.mounted) {
          showSnackBarCustom(
              context,
              snack.ContentType.warning,
              'Có một vấn đề nhỏ!',
              'Danh sách điểm danh của bạn đang trống, vui lòng kiểm tra lại!');
          return;
        }
      } else {
        await file.writeAsBytes(excelData!).then((value) => showSnackBarCustom(
            context,
            snack.ContentType.success,
            'Thành công!',
            'Xuất Excel thành công'));
        developer.log('Excel file created at: $filePath');
        studentData.clear();
      }
      return;
    } else if (pathDownload.isEmpty && pathDocument.isNotEmpty) {
      final filePath = '$pathDocument/$nameFile.xlsx';
      final file = File(filePath);
      if (studentData.isEmpty) {
        if (context.mounted) {
          showSnackBarCustom(
              context,
              snack.ContentType.warning,
              'Có một vấn đề nhỏ!',
              'Danh sách điểm danh của bạn đang trống, vui lòng kiểm tra lại!');
          return;
        }
      } else {
        await file.writeAsBytes(excelData!).then((value) => showSnackBarCustom(
            context,
            snack.ContentType.success,
            'Thành công!',
            'Xuất Excel thành công'));
        developer.log('Excel file created at: $filePath');
      }
      studentData.clear();
      return;
    } else if (pathDownload.isEmpty ||
        pathDocument.isEmpty && pathDcim.isNotEmpty) {
      final filePath = '$pathDcim/$nameFile.xlsx';
      final file = File(filePath);
      if (studentData.isEmpty) {
        if (context.mounted) {
          showSnackBarCustom(
              context,
              snack.ContentType.warning,
              'Có một vấn đề nhỏ!',
              'Danh sách điểm danh của bạn đang trống, vui lòng kiểm tra lại!');
          return;
        }
      } else {
        await file.writeAsBytes(excelData!).then((value) => showSnackBarCustom(
            context,
            snack.ContentType.success,
            'Thành công!',
            'Xuất Excel thành công'));
        developer.log('Excel file created at: $filePath');
        studentData.clear();
      }
      return;
    }
  } else {
    getPublicDirectoryPath(ref);
  }
}
