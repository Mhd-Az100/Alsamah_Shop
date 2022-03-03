import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:waslcom/core/repos/auth_repo.dart';
import 'package:waslcom/core/services/notification_service.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/views/account_info/account_info_view.dart';
import 'package:waslcom/ui/views/onBoarding/onBoarding_view.dart';
import 'package:waslcom/ui/views/store_views/main_store_view/main_store_view.dart';

class FirebaseAuthController extends GetxController {
  ///---------------------------------------------------------------------------
  final AuthRepository _authRepository = Get.find();
  final StorageService storage = Get.find();

  ///---------------------------------------------------------------------------
  ///View index
  int _viewIndex = 0;

  int get viewIndex => _viewIndex;

  set viewIndexSet(int value) {
    _viewIndex = value;
    update();
  }

  ///---------------------------------------------------------------------------
  ///Validation
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  GlobalKey<FormState> get key => _key;

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  AutovalidateMode get autoValidateMode => _autoValidateMode;

  set autoValidateModeSet(AutovalidateMode value) {
    _autoValidateMode = value;
    update();
  }

  String validateIsEmailAddress(String value) {
    String error;
    if (value.isEmpty) {
      error = "Is required".tr;
    } else if (!GetUtils.isEmail(value)) {
      error = "Not valid email address".tr;
    }
    return error;
  }

  // String validateIsPhoneNumber(String value) {
  //   String error;
  //   if (value.isEmpty) {
  //     error = "هذا الحقل مطوب".tr;
  //   } else if (value.length < 11) {
  //     error = "رقم الهاتف يجب أن يكون مؤلفاً من عشر خانات فأكثر".tr;
  //   } else if (value.startsWith("0")) {
  //     error = "أزل الصفر من البداية".tr;
  //   }
  //   return error;
  // }

  String validateIsPassword(String value) {
    String error;
    if (value.isEmpty) {
      error = "Is required".tr;
    } else if (value.length < 6) {
      error = "Password must be more than 6 digits".tr;
    }
    return error;
  }

  String validateIsVerificationCode(String value) {
    String error;
    if (value.isEmpty) {
      error = "هذا الحقل مطوب".tr;
    } else if (value.length < 6) {
      error = "رمز التفعيل مؤلف من ست خانات".tr;
    }
    return error;
  }

  ///---------------------------------------------------------------------------
  var phoneNumberController = TextEditingController();
  var verificationCodeController = TextEditingController();

  ///---------------------------------------------------------------------------

  ///Formatter
  // final MaskTextInputFormatter phoneFormatter =
  //     MaskTextInputFormatter(mask: "###-###-###");

  ///Country code
  //Show Country code

  String countryCode = "+966";

  Widget showCountryCode() {
    return CountryCodePicker(
      onChanged: (v) {
        countryCode = v.dialCode;
      },
      initialSelection: countryCode,
      favorite: StorageService.favNumbers,
      alignLeft: true,
    );
  }

  ///---------------------------------------------------------------------------
  ///Firebase Authentication
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static const Invalid_Phone_Number = "invalid-phone-number";

  PhoneAuthCredential _phoneAuthCredential;

  String _verificationId;

  int _resendToken;

  void verificationComplete() {
    viewIndexSet = 1;
    BotToast.showText(text: "تمت العملية بنجاح");
  }

  void goToVerificationView() {
    viewIndexSet = 1;
    autoValidateModeSet = AutovalidateMode.disabled;
  }

  void firebaseLogIn({bool resendMode = false}) async {
    if (resendMode ? true : key.currentState.validate()) {
      try {
        BotToast.showLoading();

        ///Switch to verification view
        await SmsAutoFill().listenForCode;
        SmsAutoFill().code.listen((event) {
          if (event.isNotEmpty) {
            verificationCodeController.text = event.trim();
            update();
          }
        });
        await firebaseAuth.verifyPhoneNumber(
            timeout: const Duration(seconds: 60),
            phoneNumber: countryCode + phoneNumberController.text.trim(),
            verificationCompleted: (v) async {
              BotToast.closeAllLoading();
            },
            verificationFailed: (value) async {
              ///
              BotToast.closeAllLoading();

              ///
              BotToast.showText(
                  text: value?.message ??
                      "يبدو أن عملية التسجيل قد فشلت في هذا البلد،\n قم بتشغيل كاسر بروكسي",
                  duration: Duration(seconds: 5));
              log(value?.message?.toString() ?? "Fireabse connection error",
                  name: "Firebase verificationFailed");
            },
            codeSent: (verificationId, resendToken) async {
              log(verificationId, name: "codeSent");
              _verificationId = verificationId;
              _resendToken = resendToken;
              verificationComplete();
              BotToast.closeAllLoading();
            },
            codeAutoRetrievalTimeout: (value) async {
              ///
              BotToast.closeAllLoading();

              ///
              log(value, name: "Time out");
            },

            ///Resend Sms mode
            forceResendingToken: resendMode ? _resendToken : null);
      } catch (e) {
        log(e.toString(), name: "Firebase login function error");
      }
    } else {
      autoValidateModeSet = AutovalidateMode.onUserInteraction;
    }
  }

  void firebaseVerifyNumber() async {
    if (key.currentState.validate()) {
      try {
        BotToast.showLoading();
        _phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: _verificationId,
            smsCode: verificationCodeController.text.trim());
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(_phoneAuthCredential);

        String firebaseAuthToken = await firebaseAuth.currentUser.getIdToken();
        await _authRepository
            .firebaseLogIn(
                phone: countryCode + phoneNumberController.text.trim(),
                uid: userCredential.user.uid,
                firebaseUserAuthToken: firebaseAuthToken)
            .then((value) async {
          if (value is bool && value) {
            await Get.find<NotificationService>().initialise();
            if (userCredential.additionalUserInfo.isNewUser) {
              storage.setIsLoginWithoutInfo();
              Get.offAll(() => OnBoardingView(
                    fromMainMenu: false,
                  ));
            } else {
              storage.setIsLoginWithoutCurrency();
              Get.offAll(() => AccountInfoView());
            }
          }
        });
      } catch (e) {
        BotToast.showText(
            text: showErrors(e.toString()), duration: Duration(seconds: 7));
      } finally {
        BotToast.closeAllLoading();
      }
    } else {
      autoValidateModeSet = AutovalidateMode.onUserInteraction;
    }
  }

  String showErrors(String error) {
    int start = error.indexOf("[");
    int end = error.indexOf("]");
    return error.replaceRange(start, end + 1, "");
  }

  ///---------------------------------------------------------------------------
  void resendVerificationCode() {
    verificationCodeController.clear();
    viewIndexSet = 0;
  }

  ///---------------------------------------------------------------------------
  ///Guest logIn
  void guestLogin() {
    storage.setIsGuest();
    Get.offAll(() => MainStoreView());
  }

  ///---------------------------------------------------------------------------
  ///OnInit
  void onControllerInit() async {}

  ///---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    verificationCodeController.dispose();
    super.dispose();
  }
}
