import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:waslcom/core/network.dart';
import 'package:waslcom/core/services/storage_service.dart';

class AppPropertiesRepo {
  ///---------------------------------------------------------------------------
  static final StorageService storage = Get.find();

  ///---------------------------------------------------------------------------
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  static Map<String, String> deleteHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${storage.getTokenInfo().token}'
  };

  static Map<String, String> authHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${storage.getTokenInfo().token}'
  };

  ///---------------------------------------------------------------------------

  ///End-points
  static const Properties_ByKey = "Properties/ByKey/";

  //Adverts
  static const AndroidAdvertiseWhatsUp = "AdvertiseWhatsUp";
  static const IOSAdvertiseWhatsUpv1 = "IOSAdvertiseWhatsUpv1";

  //Compliant
  static const SendComplaintWhatsUp = "SendComplaintWhatsUp";
  static const IOSSendComplaintWhatsUpv1 = "IOSSendComplaintWhatsUpv1";

//Contact
  static const ContactUsWhatsUp = "ContactUsWhatsUp";
  static const IOSContactUsWhatsUpv1 = "IOSContactUsWhatsUpv1";

  //App links
  static const AppStoreLink = "AppStoreLink";
  static const GooglePlayStoreLink = "GooglePlayStoreLink";

  //Android version
  static const AndroidVersion = "AndroidVersion";

  ///Auto select currency
  static const AutoSelectCurrency = "AutoSelectCurrency";

  ///Auto set the receiver address on map
  static const AutoDetermineReceiverAddress = "AutoDetermineReceiverAddress";

  ///Auto delivery charge
  static const AutoDeliveryCharge = "AutoDeliveryCharge";

  ///Auto delivery time
  static const DeliveryTime = "DeliveryTime";

  static const OnlyRegisteredUsers = "OnlyRegisteredUsers";

  static const MarqueeText = "MarqueeText";

  static const PaymentViaBank = "PaymentViaBank";

  ///---------------------------------------------------------------------------

  static Future<String> getAdvertisementsLinks() async {
    String link = "http://";
    final http.Response response = await NetworkUtils.get(
        headers: authHeaders,
        url: Platform.isAndroid
            ? Properties_ByKey + AndroidAdvertiseWhatsUp
            : Properties_ByKey + IOSAdvertiseWhatsUpv1);
    log(response.body.toString(), name: "getAdvertisementsLinks response");
    if (response.statusCode == 200) {
      link = json.decode(response.body);
    } else {
      BotToast.showText(text: "الرابط غير موجود");
    }
    return link;
  }

  static Future<String> getCompliantLinks() async {
    String link = "http://";
    final http.Response response = await NetworkUtils.get(
        headers: authHeaders,
        url: Platform.isAndroid
            ? Properties_ByKey + SendComplaintWhatsUp
            : Properties_ByKey + IOSSendComplaintWhatsUpv1);
    log(response.body.toString(), name: "getCompliantLinks response");
    if (response.statusCode == 200) {
      link = json.decode(response.body);
    } else {
      BotToast.showText(text: "الرابط غير موجود");
    }
    return link;
  }

  static Future<String> getContactUsLinks() async {
    String link = "http://";
    final http.Response response = await NetworkUtils.get(
        headers: authHeaders,
        url: Platform.isAndroid
            ? Properties_ByKey + ContactUsWhatsUp
            : Properties_ByKey + IOSContactUsWhatsUpv1);
    log(response.body.toString(), name: "getContactUsLinks response");
    if (response.statusCode == 200) {
      link = json.decode(response.body);
    } else {
      BotToast.showText(text: "الرابط غير موجود");
    }
    return link;
  }

  static Future<String> getAppLinks() async {
    String link = "http://";
    final http.Response response = await NetworkUtils.get(
        headers: authHeaders,
        url: Platform.isAndroid
            ? Properties_ByKey + GooglePlayStoreLink
            : Properties_ByKey + AppStoreLink);
    log(response.body.toString(), name: "getAppLinks response");
    if (response.statusCode == 200) {
      link = json.decode(response.body);
    } else {
      BotToast.showText(text: "الرابط غير موجود");
    }
    return link;
  }

  static Future<String> getAppVersions() async {
    String androidAppVersion;
    final http.Response response = await NetworkUtils.get(
        headers: authHeaders,
        url: Platform.isAndroid
            ? Properties_ByKey + AndroidVersion
            : Properties_ByKey + AndroidVersion);
    log(response.body.toString(), name: "getAppVersions response");
    if (response.statusCode == 200) {
      androidAppVersion = json.decode(response.body);
    }
    return androidAppVersion;
  }

  ///Check auto select currency
  static Future<bool> checkAutoSetCurrency() async {
    bool _response = true;
    final http.Response response = await NetworkUtils.get(
        headers: headers, url: Properties_ByKey + AutoSelectCurrency);
    log(response.body.toString(), name: "checkAutoSetCurrency response");
    if (response.statusCode == 200) {
      _response = int.tryParse(json.decode(response.body)) == 1;
    }
    return _response;
  }

  ///Check auto determine receiver address on map
  static Future<bool> checkAutoDetermineReceiverAddress() async {
    bool _response = true;
    final http.Response response = await NetworkUtils.get(
        headers: headers, url: Properties_ByKey + AutoDetermineReceiverAddress);
    log(response.body.toString(),
        name: "checkAutoDetermineReceiverAddress response");
    if (response.statusCode == 200) {
      _response = int.tryParse(json.decode(response.body)) == 1;
    }
    return _response;
  }

  //======================================================================
  static Future<String> checkDeliveryCharger() async {
    String res;
    final http.Response response = await NetworkUtils.get(
        headers: authHeaders, url: Properties_ByKey + AutoDeliveryCharge);
    log(authHeaders.toString(), name: "checkDeliveryCharger authHeaders");

    log(response.body.toString(), name: "checkDeliveryCharger response");
    if (response.statusCode == 200) {
      res = json.decode(response.body);
    }
    return res;
  }

  static Future<String> checkDeliveryTime() async {
    String res;
    final http.Response response = await NetworkUtils.get(headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${storage.getTokenInfo().token}'
    }, url: Properties_ByKey + DeliveryTime);
    log(authHeaders.toString(), name: "checkDeliveryTime auth");

    log(response.body.toString(), name: "checkDeliveryTime response");
    if (response.statusCode == 200) {
      res = json.decode(response.body);
    }
    return res;
  }

  static Future<String> onlyRigistryUser() async {
    String res;
    final http.Response response =
        await NetworkUtils.get(url: Properties_ByKey + OnlyRegisteredUsers);

    log(response.body.toString(), name: "OnlyRegisteredUsers response");
    if (response.statusCode == 200) {
      res = json.decode(response.body);
    }
    return res;
  }

  static Future<String> getMarqee() async {
    String res;
    final http.Response response =
        await NetworkUtils.get(url: Properties_ByKey + MarqueeText);

    log(response.body.toString(), name: "MarqueeText response");
    if (response.statusCode == 200) {
      res = json.decode(response.body);
      return res;
    } else {
      log(response.statusCode.toString(), name: "MarqueeText statuscode");

      return '';
    }
  }

  static Future<String> getpaymentstate() async {
    String res;
    final http.Response response = await NetworkUtils.get(
        url: Properties_ByKey + PaymentViaBank, headers: authHeaders);

    log(response.body.toString(), name: "PaymentViaBank response");
    if (response.statusCode == 200) {
      res = json.decode(response.body);
      return res;
    } else {
      log(response.statusCode.toString(), name: "PaymentViaBank statuscode");

      return '';
    }
  }
}
