import 'dart:developer';

import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:waslcom/core/models/fcm_models.dart';
import 'package:waslcom/core/services/deviceId_service.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'dart:convert';
import '../network.dart';

class NotificationRepository {
  static final StorageService storage = Get.find<StorageService>();
  static final DeviceIdService deviceIdService = Get.find<DeviceIdService>();
  static final Notifiaction = "notifications";

  ///---------------------------------------------------------------------------
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  static Map<String, String> authHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${storage.getTokenInfo().token}'
  };

  ///---------------------------------------------------------------------------
  ///End-points

  static const FCMToken = "FCMToken";

  ///---------------------------------------------------------------------------
  ///Calls
  static Future<bool> sentFcmToken(String fcmToken) async {
    String _deviceId = await deviceIdService.getId();
    http.Response response = await NetworkUtils.post(
        url: FCMToken,
        headers: authHeaders,
        body: json.encode({"token": fcmToken, "deviceID": _deviceId}));
    if (response.statusCode == 200) {
      log(response.body.toString(), name: "sentFcmToken response");
      return true;
    } else {
      log(response.statusCode.toString(), name: "Get sentFcmToken api error");
      return false;
    }
  }

  static Future<List<NotifiactionList>> getNotificationList() async {
    var _responseList = <dynamic>[];
    var _finalList = <NotifiactionList>[];
    http.Response response =
        await NetworkUtils.get(url: Notifiaction, headers: authHeaders);
    if (response.statusCode == 200) {
      log(response.body, name: "getNotifiactionList response");
      _responseList = json.decode(response.body);
      _finalList =
          _responseList.map((e) => NotifiactionList.fromJson(e)).toList();
      return _finalList;
    } else {
      log(response.statusCode.toString(),
          name: "getNotifiactionList api error");
      return _finalList;
    }
  }
}
