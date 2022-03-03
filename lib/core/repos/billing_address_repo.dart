import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:waslcom/core/models/billing_address_dto.dart';
import 'package:waslcom/core/services/storage_service.dart';

import '../network.dart';

class BillingAddressRepo {
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
  static const Addresses = "BillingAddress";
  static const Profile = "Profile";

  static const my_Addresses = "BillingAddress/Mine";

  ///---------------------------------------------------------------------------
  ///Create billing address
  static Future<bool> createBillingAddressRequest(
      BillingAddressDto billingAddressDto) async {
    final http.Response response = await NetworkUtils.post(
        url: Addresses,
        body: json.encode(billingAddressDto.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${storage.getTokenInfo().token}'
        });
    log(response.body.toString(), name: "createBillingAddressRequest response");
    if (response.statusCode == 201) {
      BotToast.showText(
          text: "تم اضافة عنوان الدفع بنجاح",
          duration: Duration(seconds: 4),
          align: Alignment.center);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateBillingAddressRequest(
      {@required BillingAddressDto billingAddressDto, @required int id}) async {
    final http.Response response = await NetworkUtils.put(
        url: Addresses + "/$id",
        body: json.encode(billingAddressDto.toJson()),
        headers: authHeaders);
    log(response.body.toString(), name: "updateBillingAddressRequest response");
    if (response.statusCode > 199 || response.statusCode < 300) {
      BotToast.showText(
          text: "تم تحديث عنوان الدفع بنجاح",
          duration: Duration(seconds: 3),
          align: Alignment.center);
      return true;
    } else {
      return false;
    }
  }

  static Future<List<BillingAddressDto>> getAllBillingAddress() async {
    var _responseList = <dynamic>[];
    var _finalList = <BillingAddressDto>[];
    http.Response response = await NetworkUtils.get(
        url: my_Addresses + "?page=1&count=100", headers: authHeaders);
    if (response.statusCode == 200) {
      log(response.body.toString(), name: "getAllBillingAddress response");
      _responseList = json.decode(response.body);
      _finalList =
          _responseList.map((e) => BillingAddressDto.fromJson(e)).toList();
      return _finalList;
    } else {
      log(response.statusCode.toString(),
          name: "getAllBillingAddress api error");
      return _finalList;
    }
  }

  ///---------------------------------------------------------------------------
  static Future<bool> profileInfo(String name) async {
    final http.Response response = await NetworkUtils.put(
        url: Profile,
        body: jsonEncode(<String, String>{
          'firstName': name,
        }),
        headers: authHeaders);
    log(response.body.toString(), name: "profile info response");
    if (response.statusCode > 199 || response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }
}
