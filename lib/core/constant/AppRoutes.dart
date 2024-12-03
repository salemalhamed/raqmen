import 'package:flutter/material.dart';
import 'package:raqmen/core/views/screen/ResultScreen.dart';
import 'package:raqmen/core/views/screen/chatbot.dart';
import 'package:raqmen/core/views/screen/firstScreen.dart';
import 'package:raqmen/core/views/screen/SplashScreen.dart';

class AppRoutes {
  //  تسوي هاندل لكل الملفات اعامل كل صفحة على اساس انها رابط
  static const String splashScreen = "/";
  static const String sfhScreen = "/first";
  static const String ResultSsreen = "/result";
  static const String chatSscreen = "/chat";
  static const String splaSscreen = "/splas";

  static Route<dynamic> generteRouts(RouteSettings Rsettings) {
    switch (Rsettings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );
      case "/result":
        return MaterialPageRoute(
          builder: (context) => ResultScreen(),
        );
      case "/first":
        return MaterialPageRoute(
          builder: (context) => FileHandlerScreen(),
        );
      case "/actlog":
        return MaterialPageRoute(
          builder: (context) => FileHandlerScreen(),
        );
      case "/chat":
        return MaterialPageRoute(
          builder: (context) => ChatbotScreen(),
        );
      case "/spla":
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );
    }
  }
}
