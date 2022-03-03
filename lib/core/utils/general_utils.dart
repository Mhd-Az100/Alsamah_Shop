import 'dart:developer';
import 'dart:math' as math;

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waslcom/core/models/currency_model.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/splash_view/splash_view.dart';

class DialogsUtils {
  /// Show related to storage service dialogs
  static showGuestLogInDialog() {
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        title: Text(
          "تسجيل الدخول مطلوب",
          textAlign: TextAlign.center,
        ),
        content: Text(
          "لاتمام هذه العملية انت بحاجة لتسجيل الدخول في التطبيق",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "تسجيل الدخول",
              style: TextStyle(color: AppColors.greenColor),
            ),
            onPressed: () {
              Get.find<StorageService>().logOut();
              Get.offAll(() => SplashView());
            },
          ),
          FlatButton(
            child: Text(
              "ليس الآن",
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

  static showMoreDetailsDialog({Size size, String content}) {
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        title: Text(
          "الوصف",
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Container(
            width: size.width * 0.6,
            child: ReadMoreText(
              content ?? "",
              textAlign: TextAlign.center,
              trimExpandedText: "عرض تفاصيل أقل",
              trimCollapsedText: "عرض المزيد",
              lessStyle: TextStyle(fontSize: 14, color: AppColors.blueColor),
              moreStyle: TextStyle(fontSize: 14, color: AppColors.blueColor),
              trimLength: 80,
              style: GoogleFonts.cairo(
                  color: AppColors.blackColor.withOpacity(0.5),
                  fontWeight: FontWeight.w600,
                  fontSize: size.longestSide / 43),
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "رجوع",
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

extension GetLogger on String {
  void getLog({String loggerName}) {
    if (this is String)
      log(this, name: loggerName);
    else
      log("Not String value", name: loggerName);
  }
}

extension ArabicStatusAsString on String {
  String getArabicStatus() {
    switch (this) {
      case "WaitingForPayment":
        return "بانتظار عملية الدفع";
        break;
      case "PaymentRejected":
        return "تم رفض عملية الدفع";
        break;
      case "Pending":
        return "تم استلام الطلب";
        break;
      case "Packaging":
        return "يتم الآن العمل";
        break;
      case "Delivering":
        return "قيد التوصيل";
        break;
      case "Done":
        return "تم التوصيل";
        break;
      case "Canceled":
        return "تم ايقاف الطلب";
        break;
      case "CustomerCanceled":
        return "ملغى من قبلي";
        break;
      default:
        return "تم استلام الطلب";
    }
  }
}

extension GerOrderNumber on int {
  String getFakeOrderNumber() {
    if (false) {
      return this.isEven
          ? (this * 2 + math.log(this * 18)).toInt().toString()
          : (this * 3 + math.log(this * 22)).toInt().toString();
    } else {
      return this?.toString();
    }
  }
}

class GeneralUtils {
  static void popUntilRoot(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      popUntilRoot(context);
    }
  }

  ///Formatter
  // static final MaskTextInputFormatter phoneFormatter =
  //     MaskTextInputFormatter(mask: "###-###-###");

  static final MaskTextInputFormatter syrianPhoneFormatter =
      MaskTextInputFormatter(mask: "####-###-###");

  ///Text input fields validators
  static String validateInNotEmpty(String value) {
    String error;
    if (value.isEmpty) {
      error = "هذا الحقل مطوب".tr;
    }
    return error;
  }

  // static String validateIsPhoneNumber(String value) {
  //   String error;
  //   if (value.isEmpty) {
  //     error = "هذا الحقل مطوب".tr;
  //   } else if (value.length < 11) {
  //     error = "رقم الهاتف يجب أن يكون مؤلفاً من عشر خانات فأكثر".tr;
  //   } else if (value.startsWith("0")) {
  //     error = "أزل الصفر من البداية".tr;
  //   }
  //   return error;
  // }

  ///Lunch external links
  static void runExternalLink(String link) async {
    try {
      BotToast.showLoading();

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
      log(e.toString(), name: "runExternalLink func error");
    } finally {
      BotToast.closeAllLoading();
    }
  }

  ///General app info

  ///Storage service
  static StorageService get getStorageService => Get.find<StorageService>();

  ///Currency info service
  static CurrencyDto get currencyInfo =>
      Get.find<StorageService>()?.getCurrencyInfo() ?? CurrencyDto();
}

///General Extentions

extension GetIsNotNullOnString on String {
  bool isNotNull() {
    bool _isNotNull = false;
    if (this != null && this.isNotEmpty) _isNotNull = true;
    return _isNotNull;
  }
}

extension GetIsNotNullOnInt on int {
  bool isNotNull() {
    bool _isNotNull = false;
    if (this != null) _isNotNull = true;
    return _isNotNull;
  }
}
