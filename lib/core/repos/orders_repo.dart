import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:waslcom/core/models/order_items_details_model.dart';
import 'package:waslcom/core/models/orders_model.dart';
import 'package:waslcom/core/models/place_orders_models.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import '../network.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class OrderRepository {
  ///---------------------------------------------------------------------------
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
  static const createOrder = "Orders";
  static const getOrders = "Orders/Mine";
  static const getOrdersdetails = "orders/";
  static const orderStatus = "orders/UpdateStatus/";
  static const orderAccepted = "?orderAccepted=";

  ///---------------------------------------------------------------------------
  ///Calls
  static Future<int> createOrderRequest(OrderParameterModel orderModel) async {
    final http.Response response = await NetworkUtils.post(
        url: createOrder,
        body: json.encode(orderModel.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${storage.getTokenInfo().token}'
        });
    log(authHeaders.toString(), name: "createOrderRequest authHeaders");

    log(response.body.toString(), name: "createOrderRequest response");
    log(json.encode(orderModel.toJson()).toString(),
        name: "createOrderRequest body data");

    if (response.statusCode == 201) {
      var body = jsonDecode(response.body);
      int id = body['id'];
      print('id order : $id');
      BotToast.showText(
          text: "تم ارسال الطلب بنجاح",
          duration: Duration(seconds: 4),
          align: Alignment.center);
      return id;
    } else {
      print('statuscode=${response.statusCode}');

      return null;
    }
  }

  static Future<List<OrdersDto>> getAllOrders(
      {int pageIndex = 1, int pageSize = 1000}) async {
    var _responseList = <dynamic>[];
    var _finalList = <OrdersDto>[];
    http.Response response = await NetworkUtils.get(
        url: getOrders + "?Page=$pageIndex&Count=$pageSize",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${storage.getTokenInfo().token}'
        });
    if (response.statusCode == 200) {
      log(response.body.toString(), name: "getAllOrders response");
      _responseList = json.decode(response.body);
      _finalList = _responseList.map((e) => OrdersDto.fromJson(e)).toList();
      return _finalList.reversed.toList();
    } else {
      log(response.statusCode.toString(), name: "Get getAllOrders api error");
      return _finalList;
    }
  }

//==================================================================
  // get order details

  static Future<OrderItemDetailsModel> getorderitems(String id) async {
    OrderItemDetailsModel orderitems;
    print("aaaa=$authHeaders");
    http.Response res = await NetworkUtils.get(
        url: getOrdersdetails + id, headers: authHeaders);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      orderitems = OrderItemDetailsModel.fromJson(body);
      return orderitems;
    } else {
      print('statuscode=${res.statusCode}');
      return null;
    }
  }
  //==================================================================
  // set order statuse

  static Future<bool> confirmOrder(String id, bool status) async {
    final http.Response response = await NetworkUtils.post(
        url: orderStatus + id + orderAccepted + status.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${storage.getTokenInfo().token}'
        });
    if (response.statusCode == 200) {
      BotToast.showText(
          text: "تم ارسال الطلب بنجاح",
          duration: Duration(seconds: 4),
          align: Alignment.center);
      return true;
    } else {
      print('statuscode : ${response.statusCode}');
      return false;
    }
  }
}
