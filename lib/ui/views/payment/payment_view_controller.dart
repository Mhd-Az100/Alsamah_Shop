import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:connection_verify/connection_verify.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/core/models/payment_models.dart';
import 'package:waslcom/core/repos/payment_account_repo.dart';
import 'package:waslcom/core/utils/messages_util.dart';

class PaymentViewController extends GetxController {
  ///---------------------------------------------------------------------------

  ///Loading indicator

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoadingSet(bool value) {
    _isLoading = value;
    update();
  }

  ///---------------------------------------------------------------------------
  ///Connection error indicator

  bool _connectionError = false;

  bool get connectionError => _connectionError;

  set connectionErrorSet(bool value) {
    _connectionError = value;
    update();
  }

  ///---------------------------------------------------------------------------
  ///Get Address info List
  var ordersList = <PaymentDto>[];

  void getAllOrders() async {
    try {
      isLoadingSet = true;
      ordersList = await PaymentAccountRepository.getAllPaymentInfo();
    } catch (e) {
      log(e.toString(), name: "getAllAddress controller  error");
    } finally {
      isLoadingSet = false;
    }
  }

  PaymentDto getData(index) => ordersList[index];

  ///---------------------------------------------------------------------------
  ///Payment card actions
  void sharePaymentAccountInfo(int index) async {
    try {
      BotToast.showLoading();
      await FlutterShare.share(
          title: "أرسل معلومات الدفع الى :",
          text: "",
          linkUrl: getData(index).description);
    } catch (e) {
      print(e.toString());
    } finally {
      BotToast.closeAllLoading();
    }
    Get.back();
  }

  void saveToClipboard(int index) async {
    try {
      BotToast.showLoading();
      await Clipboard.setData(ClipboardData(text: getData(index).description));
      BotToast.showText(
          text:
              "تم نسخ معلومات حساب الدفع، اذهب لتطبيق الدفع الخاص بك وقم بالتسديد ومن ثم أرسل الفاتورة",
          align: Alignment.center,
          duration: Duration(seconds: 8));
    } catch (e) {
      print(e.toString());
    } finally {
      BotToast.closeAllLoading();
    }
    Get.back();
  }

  ///---------------------------------------------------------------------------
  ///Upload file
  File _file;

  Future uploadFile(int orderNumber) async {
    Get.back();
    try {
      BotToast.showLoading();
      FilePickerResult result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File _file = File(result.files.single.path);
        bool _successUpload =
            await PaymentAccountRepository.uploadPaymentReceipt(
                _file.path, orderNumber);
        if (_successUpload) {
          Get.back(result: true);
          MessagesUtil.showCustomMessage(
              messageType: MessageType.SuccessMessage,
              duration: 3,
              message: "تمت عملية الدفع بنجاح");
        } else
          BotToast.showText(
              text: "حدثت مشكلة في عملية رفع الملف، يرجى المحاولة لاحقاً");
      }
    } catch (e) {
      print(e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  ///---------------------------------------------------------------------------
  ///onInit
  @override
  void onInit() async {
    connectionErrorSet = false;
    if (await ConnectionVerify.connectionStatus()) {
      getAllOrders();
    } else {
      connectionErrorSet = true;
    }
    super.onInit();
  }
}
