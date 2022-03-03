import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:package_info/package_info.dart';
import 'package:waslcom/core/repos/app_properties_repo.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';

class AppVersioningService {
  static Future checkAppVersion() async {
    String _appVer;
    PackageInfo _packageInfo;
    _packageInfo = await PackageInfo.fromPlatform();
    _appVer = await AppPropertiesRepo.getAppVersions();
    if (_appVer.compareTo(_packageInfo.version) == 1) {
      String _newVersionLink = await AppPropertiesRepo.getAppLinks();
      Get.dialog(
        AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
          title: Text("تحديث جديد",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.blueAccentColor, fontSize: 22)),
          content: Text(
            "من فضلك قم بتحميل النسخة الجديدة من التطبيق",
            style: TextStyle(color: AppColors.grey500Color, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: FlatButton(
                child: Text(
                  "تحميل",
                  style:
                      TextStyle(color: AppColors.blueAccentColor, fontSize: 15),
                ),
                onPressed: () {
                  Get.back();
                  GeneralUtils.runExternalLink(_newVersionLink);
                },
              ),
            )
          ],
        ),
        barrierDismissible: false,
      );
    }
  }
}
