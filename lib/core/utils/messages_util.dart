import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/core/models/fcm_models.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';

class MessagesUtil {
  static void showNotification({NotificationDataModel model, int duration}) =>
      BotToast.showCustomNotification(
        duration: Duration(seconds: duration ?? 3),
        align: Alignment.topCenter,
        onlyOne: true,
        toastBuilder: (f) => GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 22),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: Center(
                    child: Text(
                      model.status.getArabicStatus() +
                          " للطلب رقم " +
                          int.tryParse(model.orderID).getFakeOrderNumber(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          height: 1.5,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey75Color.withOpacity(0.3),
                  offset: Offset(0, 7),
                  blurRadius: 21,
                )
              ],
              color: AppColors.blueGrey,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

  static void showFcmNotification({FcmNotificationModel model, int duration}) =>
      BotToast.showCustomNotification(
        duration: Duration(seconds: duration ?? 3),
        align: Alignment.topCenter,
        onlyOne: true,
        toastBuilder: (f) => GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 22),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: Center(
                    child: Text(
                      model.title ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          height: 1.5,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Center(
                    child: Text(
                      model.body ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          height: 1.5,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey75Color.withOpacity(0.3),
                  offset: Offset(0, 7),
                  blurRadius: 21,
                )
              ],
              color: AppColors.blueGrey,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

  static void showCustomMessage(
          {String message, MessageType messageType, int duration}) =>
      BotToast.showCustomNotification(
        duration: Duration(seconds: duration ?? 3),
        align: Alignment.topCenter,
        onlyOne: true,
        toastBuilder: (f) => GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 22),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: Center(
                    child: Text(
                      message ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          height: 1.5,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey75Color.withOpacity(0.3),
                  offset: Offset(0, 7),
                  blurRadius: 21,
                )
              ],
              color: messageType == MessageType.SuccessMessage
                  ? AppColors.greenColor
                  : AppColors.redColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}
