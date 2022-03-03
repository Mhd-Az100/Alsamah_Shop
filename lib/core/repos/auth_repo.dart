import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:waslcom/core/models/auth_models.dart';
import 'package:waslcom/core/models/billing_address_dto.dart';
import 'package:waslcom/core/models/mtn_login_dto.dart';
import 'package:waslcom/core/network.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';

import 'billing_address_repo.dart';

class AuthRepository {
  static final StorageService storage = Get.find();
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

  ///---------------------------------------------------------------------------
  ///End-points
  static const Login = "Login";
  static const Register = "Register";
  static const LoginByPhoneFirebase = "LoginByPhoneFirebase";
  static const RegisterByPhone = "RegisterByPhone";
  static const LoginByPhone = "LoginByPhone";
  static const Test_Auth = "Test/Auth";
  static const UseUsernameAndPassword = 'UseUsernameAndPassword';

  ///---------------------------------------------------------------------------
  ///Calls

  Future<bool> registerByEmail(
      {@required String email,
      @required String password,
      @required String confPassword}) async {
    final http.Response response = await NetworkUtils.post(
        url: Register,
        headers: headers,
        body: json.encode({
          "email": "$email",
          "password": "$password",
          "confirmPassword": "$confPassword"
        }));
    log(response.body.toString(), name: "The registerByEmail response : ");
    if (response.statusCode == 200) {
      storage.setIsLoginWithoutInfo();
      storage
          .storeTokenInfo(AuthSuccessModel.fromJson(json.decode(response.body))
            ..userName = email
            ..password = password);
      return true;
    } else {
      var wrongAuth = AuthWrongModel.fromJson(json.decode(response.body));
      BotToast.showText(
          text: wrongAuth.message ?? "",
          duration: Duration(seconds: 4),
          align: Alignment.center);
      return false;
    }
  }

  Future<bool> loginByEmail({
    @required String email,
    @required String password,
  }) async {
    final http.Response response = await NetworkUtils.post(
        url: Login,
        headers: headers,
        body: json.encode({
          "email": "$email",
          "password": "$password",
        }));
    log(response.body.toString(), name: "The loginByEmail response : ");
    if (response.statusCode == 200) {
      storage.setIsLoginWithoutCurrency();
      storage
          .storeTokenInfo(AuthSuccessModel.fromJson(json.decode(response.body))
            ..userName = email
            ..password = password);
      return true;
    } else {
      var wrongAuth = AuthWrongModel.fromJson(json.decode(response.body));
      BotToast.showText(
          text: wrongAuth.message ?? "",
          duration: Duration(seconds: 4),
          align: Alignment.center);
      return false;
    }
  }

  //================login by password or mtn============
  Future<String> checkLogin() async {
    final http.Response response = await NetworkUtils.get(
      url: UseUsernameAndPassword,
    );
    log(response.body.toString(), name: "The login by response : ");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('statuscode : ${response.statusCode}');
      return null;
    }
  }

  Future<bool> firebaseLogIn({
    @required String phone,
    @required String uid,
    @required String firebaseUserAuthToken,
  }) async {
    final http.Response response = await NetworkUtils.post(
        url: LoginByPhoneFirebase,
        headers: headers,
        body: json.encode({
          "phoneNumber": "$phone",
          "uid": "$uid",
          "firebaseUserAuthToken": "$firebaseUserAuthToken",
        }));
    log(response.body.toString(), name: "The firebaseLogIn response : ");
    if (response.statusCode == 200) {
      storage.storeTokenInfo(
          AuthSuccessModel.fromJson(json.decode(response.body))
            ..userName = phone);
      return true;
    } else {
      var wrongAuth = AuthWrongModel.fromJson(json.decode(response.body));
      BotToast.showText(
          text: wrongAuth.message ?? "",
          duration: Duration(seconds: 4),
          align: Alignment.center);
      return false;
    }
  }

  Future<bool> testAuth() async {
    final http.Response response = await NetworkUtils.get(
      url: Test_Auth,
      headers: authHeaders,
    );
    log(response.body.toString(), name: "The testAuth response : ");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  ///local phone authentication
  Future<bool> registerByMtn(
      {@required String phoneNumber, bool autoLoginMode = false}) async {
    final http.Response response = await NetworkUtils.post(
        url: RegisterByPhone,
        headers: headers,
        body: json.encode({"phoneNumber": "$phoneNumber"}));
    log(response.body.toString(), name: "The registerByMtn response : ");
    if (response.statusCode == 200) {
      if (autoLoginMode) {
        await loginByMtn(
            autoLoginMode: autoLoginMode,
            phoneNumber: phoneNumber,
            verificationCode:
                MtnLoginDto.fromJson(json.decode(response.body)).code);
      }
      return true;
    } else {
      // var wrongAuth = AuthWrongModel.fromJson(json.decode(response.body));
      // BotToast.showText(
      //     text: wrongAuth.message ?? "",
      //     duration: Duration(seconds: 4),
      //     align: Alignment.center);
      BotToast.showText(
          text: "حساب التاجر غير موجود يرجى التواصل مع خدمة الزبائن",
          duration: Duration(seconds: 4),
          align: Alignment.center);
      return false;
    }
  }

  Future<bool> loginByMtn({
    @required String phoneNumber,
    @required String verificationCode,
    bool autoLoginMode = false,
  }) async {
    final http.Response response = await NetworkUtils.post(
        url: LoginByPhone,
        headers: headers,
        body: json.encode({
          "phoneNumber": "$phoneNumber",
          "verificationCode": "$verificationCode",
        }));
    log(response.body.toString(), name: "The loginByMtn response : ");
    if (response.statusCode == 200) {
      await storage
          .storeTokenInfo(AuthSuccessModel.fromJson(json.decode(response.body))
            ..userName = phoneNumber
            ..password = verificationCode);
      if (!autoLoginMode)
        await checkIfNewAccount().then((value) {
          if (value)
            storage.setIsLoginWithoutInfo();
          else
            storage.setIsLoginWithoutCurrency();
        });

      return true;
    } else {
      // var wrongAuth = AuthWrongModel.fromJson(json.decode(response.body));
      BotToast.showText(
          text:
              //  wrongAuth.message ??
              "خطأ",
          duration: Duration(seconds: 4),
          align: Alignment.center);
      return false;
    }
  }

  /// Check new account
  Future<bool> checkIfNewAccount() async {
    var _addressList = <BillingAddressDto>[];
    bool _newAccount = true;
    try {
      _addressList = await BillingAddressRepo.getAllBillingAddress();
      _newAccount = _addressList.isEmpty;
    } catch (e) {
      e.toString().getLog(loggerName: "checkIfNewAccount api request");
    }
    return _newAccount;
  }
}
