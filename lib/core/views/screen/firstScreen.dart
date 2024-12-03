import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class FileHandlerController extends GetxController {
  var isLoading = false.obs; // حالة التحميل
  var selectedFilePath = "".obs; // مسار الملف المحدد
  var fileType = "".obs; // نوع الملف

  void pickFile(String type) async {
    try {
      FilePickerResult? result;
      if (type == "pdf") {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
      } else if (type == "excel") {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx', 'xls'],
        );
      }

      if (result != null) {
        selectedFilePath.value = result.files.single.path!;
        fileType.value = type;
      } else {
        Get.snackbar("تنبيه", "لم يتم اختيار أي ملف");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء اختيار الملف: $e");
    }
  }

  void readExcelFile() {
    if (selectedFilePath.isEmpty) return;

    try {
      var bytes = File(selectedFilePath.value).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        print("Sheet: $table");
        for (var row in excel.tables[table]!.rows) {
          print("Row: $row");
        }
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء قراءة ملف Excel: $e");
    }
  }
}

class FileHandlerControllerr extends GetxController {
  var capturedImagePath = "".obs; // مسار الصورة الملتقطة
  var extractedText = "".obs; // النص المستخرج من الصورة

  final ImagePicker _imagePicker = ImagePicker();

  void captureImage() async {
    try {
      final XFile? photo =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        capturedImagePath.value = photo.path;
        analyzeImage(File(photo.path));
      } else {
        Get.snackbar("تنبيه", "لم يتم التقاط أي صورة");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء التقاط الصورة: $e");
    }
  }

  void analyzeImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textDetector = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText =
          await textDetector.processImage(inputImage);

      extractedText.value = recognizedText.text;
      textDetector.close();

      if (extractedText.value.isEmpty) {
        Get.snackbar("تنبيه", "لم يتم العثور على نص في الصورة");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تحليل الصورة: $e");
    }
  }

  Future<void> saveTextToPDF() async {
    if (extractedText.value.isEmpty) {
      Get.snackbar("تنبيه", "لا يوجد نص لحفظه");
      return;
    }

    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Center(
            child: pw.Text(
              extractedText.value,
              style: pw.TextStyle(fontSize: 18),
            ),
          ),
        ),
      );

      final outputDir = await getApplicationDocumentsDirectory();
      final file = File('${outputDir.path}/extracted_text.pdf');
      await file.writeAsBytes(await pdf.save());

      Get.snackbar("نجاح", "تم حفظ النصوص في ملف PDF: ${file.path}");
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء حفظ النصوص: $e");
    }
  }
}

class FileHandlerScreen extends StatelessWidget {
  final FileHandlerController controller = Get.put(FileHandlerController());
  final FileHandlerControllerr controllerr = Get.put(FileHandlerControllerr());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("رقمن المحلل الذكي"),
          backgroundColor: Color(0xFF004651),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Ensures the content scrolls if it overflows
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () => controllerr.captureImage(),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("فتح الكاميرا"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF007ACC),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controllerr.capturedImagePath.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.file(
                            File(controllerr.capturedImagePath.value),
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "النص المستخرج:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controllerr.extractedText.value,
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => controllerr.saveTextToPDF(),
                            icon: const Icon(Icons.save),
                            label: const Text("حفظ كملف PDF"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF00A181),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "التقط صورة لاستخراج النصوص منها",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }
                }),
                ElevatedButton.icon(
                  onPressed: () => controller.pickFile("pdf"),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("اختر ملف PDF"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004651),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.pickFile("excel"),
                  icon: const Icon(Icons.table_chart),
                  label: const Text("اختر ملف Excel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF004651),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // الانتقال لشاشة التحليل
                    Navigator.pushReplacementNamed(context, "/result");
                  },
                  icon: const Icon(Icons.analytics),
                  label: const Text("عرض التحليل"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00A181),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.fileType.value == "pdf" &&
                      controller.selectedFilePath.isNotEmpty) {
                    return PDFView(
                      filePath: controller.selectedFilePath.value,
                    );
                  } else if (controller.fileType.value == "excel" &&
                      controller.selectedFilePath.isNotEmpty) {
                    controller.readExcelFile();
                    return const Text(
                      "تم قراءة ملف Excel بنجاح. راجع Console للمخرجات.",
                      style: TextStyle(color: Colors.black),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "اختر ملفًا لعرضه هنا",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تحليل البيانات"),
        backgroundColor: Color(0xFF004651),
      ),
      body: Center(
        child: Text(
          "هنا يتم عرض تحليل البيانات.",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
