import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';

class AssetsUtils {
  static String get appName => "السماح";

  static String get appLogo => "assets/pngs/alsamah_logo.png";

  static String get appTypedLogo => "assets/pngs/alsamah_logo.png";

  static String get appTypedLogoappbar => "assets/pngs/alsamahLogo.png";

  static String get appSplashLogo => "assets/pngs/alsamah_logo.png";

  static String get appPlaceHolderLogo => "assets/pngs/alsamah_logo.png";

  static Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  static Future<File> getCashImagePath() async {
    //read and write
    final filename = 'cash_payment.png';
    var bytes = await rootBundle.load("assets/pngs/cash_payment.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    return await writeToFile(bytes, '$dir/$filename');
  }

  //write to app path
  static Future<File> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
