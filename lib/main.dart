import 'dart:io';

import 'package:raqmen/core/constant/AppRoutes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GetMaterialApp(
      builder: DevicePreview.appBuilder,
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.generteRouts,
      initialRoute: '/',
    );
  }
}
