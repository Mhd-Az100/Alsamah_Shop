import 'dart:convert';
import 'dart:developer';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:waslcom/core/models/currency_model.dart';
import 'package:waslcom/core/services/storage_service.dart';

import '../network.dart';

class CurrenciesRpo {
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
  static const Currencies = "Currencies";

  ///Requests
  static Future<List<CurrencyDto>> getAllCurrencies() async {
    var _responseList = <dynamic>[];
    var _finalList = <CurrencyDto>[];
    http.Response response =
        await NetworkUtils.get(url: Currencies, headers: authHeaders);
    if (response.statusCode == 200) {
      log(response.body.toString(), name: "getAllCurrencies response");
      _responseList = json.decode(response.body);
      _finalList = _responseList.map((e) => CurrencyDto.fromJson(e)).toList();
      return _finalList;
    } else {
      log(response.statusCode.toString(), name: "getAllCurrencies api error");
      return _finalList;
    }
  }
}
