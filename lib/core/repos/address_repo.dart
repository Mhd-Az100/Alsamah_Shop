import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:waslcom/core/models/address_models.dart';
import 'package:waslcom/core/models/deliveryfess_model.dart';
import 'package:waslcom/core/network.dart';
import 'package:waslcom/core/services/storage_service.dart';

class AddressRepository {
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
  static const Addresses = "ShippingAddresses";
  static const my_Addresses = "ShippingAddresses/Mine";

  ///---------------------------------------------------------------------------
  ///Calls
  static Future<bool> createAddressRequest(AddressDto addressDto) async {
    final http.Response response = await NetworkUtils.post(
        url: Addresses,
        body: json.encode(addressDto.toJson()),
        headers: authHeaders);
    log(response.body.toString(), name: "createAddressRequest response");
    if (response.statusCode == 201) {
      BotToast.showText(
          text: "تم اضافة العنوان بنجاح",
          duration: Duration(seconds: 4),
          align: Alignment.center);
      return true;
    } else {
      return false;
    }
  }

  static Future<MapEntry<int, bool>> createAddressRequestForSendOrder(
      AddressDto addressDto) async {
    final http.Response response = await NetworkUtils.post(
        url: Addresses,
        body: json.encode(addressDto.toJson()),
        headers: authHeaders);
    log(response.body.toString(),
        name: "createAddressRequestForSendOrder response");
    if (response.statusCode == 201) {
      return MapEntry(AddressDto.fromJson(json.decode(response.body)).id, true);
    } else {
      return MapEntry(0, false);
    }
  }

  ///---------------------------------------------------------------------------
  ///Delete address
  static Future<bool> deleteAddressRequest(int id) async {
    final http.Response response = await NetworkUtils.delete(
        url: Addresses + "/$id", headers: deleteHeaders);
    log(response.body.toString(), name: "deleteAddressRequest response");
    if (response.statusCode == 200) {
      BotToast.showText(
          text: "تم حذف العنوان بنجاح",
          duration: Duration(seconds: 3),
          align: Alignment.center);
      return true;
    } else {
      return false;
    }
  }

  ///---------------------------------------------------------------------------
  ///Get all address
  static Future<List<AddressDto>> getAllAddress() async {
    var _responseList = <dynamic>[];
    var _finalList = <AddressDto>[];
    http.Response response = await NetworkUtils.get(
        url: my_Addresses + "?page=1&count=100", headers: authHeaders);
    if (response.statusCode == 200) {
      log(response.body, name: "getAllAddress response");
      _responseList = json.decode(response.body);
      _finalList = _responseList.map((e) => AddressDto.fromJson(e)).toList();
      return _finalList;
    } else {
      log(response.statusCode.toString(), name: "getAllAddress api error");
      return _finalList;
    }
  }

  //==============================================================================
  static Future<Deliveryfess> getdeliveryfess() async {
    Deliveryfess deliveryfess;

    http.Response res = await http.get(
        'http://localhost:5010/api/orders/DeliveryFees/1?currencyCode=SE',
        headers: authHeaders);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      deliveryfess = Deliveryfess.fromJson(body);
      return deliveryfess;
    } else {
      print('statuscode=${res.statusCode}');
      return null;
    }
  }
}
