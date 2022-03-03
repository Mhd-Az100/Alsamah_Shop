import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waslcom/core/repos/app_properties_repo.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/address_view/address_view_controller.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';
import 'package:waslcom/ui/views/splash_view/splash_view.dart';

enum AppLinksEnum { Compliant, Advertisement, ContactUs }

class AppDrawerController extends GetxController {
  ///---------------------------------------------------------------------------
  ///Drawer
  void lunchWhatsAppLinks(AppLinksEnum appLinksEnum) async {
    String link;
    try {
      BotToast.showLoading();
      switch (appLinksEnum) {
        case AppLinksEnum.Advertisement:
          {
            link = await AppPropertiesRepo.getAdvertisementsLinks();
          }
          break;
        case AppLinksEnum.Compliant:
          {
            link = await AppPropertiesRepo.getCompliantLinks();
          }
          break;

        case AppLinksEnum.ContactUs:
          {
            link = await AppPropertiesRepo.getContactUsLinks();
          }
          break;
      }
      if (GetUtils.isURL(link)) {
        if (await canLaunch(link)) {
          await launch(link, forceSafariVC: false, forceWebView: false);
        } else {
          log('Could not launch $link', name: "lunchLinks func error: ");
        }
      } else {
        BotToast.showText(text: "الرابط غير صحيح");
        log('Invalid $link', name: "lunchLinks func error: ");
      }
    } catch (e) {
      log(e.toString(), name: "lunchLinks error: ");
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void shareApp() async {
    try {
      BotToast.showLoading();
      final String shareLink = await AppPropertiesRepo.getAppLinks();
      if (GetUtils.isURL(shareLink)) {
        await FlutterShare.share(
            title: "مشاركة التطبيق",
            linkUrl: shareLink,
            text: "قم بتحميل تطبيق واصلكم من الرابط المرفق");
      } else {
        log('Invalid $shareLink', name: "shareApp Api error: ");
        BotToast.showText(text: "الرابط غير صحيح");
      }
    } catch (e) {
      log(e.toString(), name: "shareApp func error");
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        title: Text(
          "تسجيل الخروج",
          textAlign: TextAlign.center,
        ),
        content: Text(
          "هل أنت متأكد من عملية تسجيل الخروج",
          textAlign: TextAlign.right,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "تسجيل الخروج",
              style: TextStyle(color: AppColors.redColor),
            ),
            onPressed: () {
              Get.find<StorageService>().logOut();
              Get.find<ShoppingCartController>().emptyShoppingCart();
              Get.put(MyAddressController()).emptyAddress();

              Get.offAll(() => SplashView());
            },
          ),
          FlatButton(
            child: Text(
              "تراجع",
              style: TextStyle(color: AppColors.blue200Color),
            ),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
      barrierDismissible: false,
    );
  }
}
