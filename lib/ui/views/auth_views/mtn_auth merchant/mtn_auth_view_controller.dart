import 'package:bot_toast/bot_toast.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:waslcom/core/repos/auth_repo.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/ui/views/onBoarding/onBoarding_view.dart';
import 'package:waslcom/ui/views/store_views/main_store_view/main_store_view.dart';

class MtnAuthViewMerchantController extends GetxController {
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

  String validateIsPhoneNumber(String value) {
    String error;
    if (value.isEmpty) {
      error = "هذا الحقل مطوب".tr;
    } else if (value.length < 11) {
      error = "رقم الهاتف يجب أن يكون مؤلفاً من عشر خانات فأكثر".tr;
    } else if (value.startsWith("0")) {
      error = "أزل الصفر من البداية".tr;
    }
    return error;
  }

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
  final MaskTextInputFormatter phoneFormatter =
      MaskTextInputFormatter(mask: "###-###-###");

  ///Country code
  //Show Country code

  String _initialCountryCode = "+966";
  String countryCode = "966";

  Widget showCountryCode() {
    return CountryCodePicker(
      onChanged: (v) {
        countryCode = v.dialCode.replaceAll("+", "");
        print(countryCode);
      },
      initialSelection: _initialCountryCode,
      favorite: StorageService.favNumbers,
      alignLeft: true,
    );
  }

  ///---------------------------------------------------------------------------
  ///Mtn Authentication

  void verificationComplete() {
    viewIndexSet = 1;
    BotToast.showText(text: "تمت العملية بنجاح");
  }

  void goToVerificationView() {
    viewIndexSet = 1;
    autoValidateModeSet = AutovalidateMode.disabled;
  }

  void mtnLoginRequest({bool resendCodeMode = false}) async {
    if ((resendCodeMode) ? true : key.currentState.validate()) {
      try {
        BotToast.showLoading();
        await _authRepository
            .registerByMtn(
                phoneNumber:
                    countryCode + phoneFormatter.getUnmaskedText().trim())
            .then((value) {
          if (value) goToVerificationView();
        });
      } catch (e) {
        e.toString().getLog(loggerName: "mtnLoginRequest api request");
      } finally {
        BotToast.closeAllLoading();
      }
    } else {
      autoValidateModeSet = AutovalidateMode.onUserInteraction;
    }
  }

  void mtnVerifyNumber() async {
    if (key.currentState.validate()) {
      try {
        BotToast.showLoading();
        await _authRepository
            .loginByMtn(
                phoneNumber:
                    countryCode + phoneFormatter.getUnmaskedText().trim(),
                verificationCode: verificationCodeController.text)
            .then((value) {
          if (value)
            Get.offAll(() => OnBoardingView(
                  fromMainMenu: false,
                ));
        });
      } catch (e) {
        e.toString().getLog(loggerName: "mtnVerifyNumber api request");
      } finally {
        BotToast.closeAllLoading();
      }
    } else {
      autoValidateModeSet = AutovalidateMode.onUserInteraction;
    }
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
