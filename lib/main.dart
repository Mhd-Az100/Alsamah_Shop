import 'dart:io' show Platform;

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as screen;
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/lcoator.dart';
import 'package:waslcom/ui/views/splash_view/splash_view.dart';

final botToastBuilder = BotToastInit();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocator();

  screen.SystemChrome.setPreferredOrientations([
    screen.DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Get.deviceLocale,
      builder: (context, child) {
        child = botToastBuilder(context, child);
        return child;
      },
      title: 'Waslcom',
      theme: ThemeData(textTheme: GoogleFonts.cairoTextTheme()),
      debugShowCheckedModeBanner: false,
      defaultTransition:
          Platform.isAndroid ? Transition.fadeIn : Transition.cupertino,
      fallbackLocale: Locale('en', 'US'),
      home: SplashView(),
    );
  }
}
