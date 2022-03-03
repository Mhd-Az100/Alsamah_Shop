import 'dart:convert';
import 'dart:developer';

import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:waslcom/core/models/payment_models.dart';
import 'package:waslcom/core/services/storage_service.dart';

import '../network.dart';

class PaymentAccountRepository {
  static final StorageService storage = Get.find();

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

  static const PaymentsInfo = "PaymentsInfo";
  static const PaymentReceipts_Upload = "PaymentReceipts/Upload";

  ///---------------------------------------------------------------------------
  ///Calls
  static Future<List<PaymentDto>> getAllPaymentInfo(
      {int pageIndex = 1, int pageSize = 1000}) async {
    var _responseList = <dynamic>[];
    var _finalList = <PaymentDto>[];
    http.Response response = await NetworkUtils.get(
        url: PaymentsInfo + "?Page=$pageIndex&Count=$pageSize",
        headers: authHeaders);
    if (response.statusCode == 200) {
      log(response.body.toString(), name: "getAllPaymentInfo response");
      _responseList = json.decode(response.body);
      _finalList = _responseList.map((e) => PaymentDto.fromJson(e)).toList();
      return _finalList.reversed.toList();
    } else {
      log(response.statusCode.toString(),
          name: "Get getAllPaymentInfo api error");
      return _finalList;
    }
  }

  ///Upload payment receipt

  static Future<bool> uploadPaymentReceipt(String file, int orderId) async {
    bool successUpload = false;
    Map<String, String> fields = {"orderID": "$orderId"};
    Map<String, String> files = {"file": file};
    var response = await NetworkUtils.postMultipart(
        url: PaymentReceipts_Upload,
        headers: authHeaders,
        fields: fields,
        files: files);

    if (response.statusCode == 201) successUpload = true;
    return successUpload;
  }
}
