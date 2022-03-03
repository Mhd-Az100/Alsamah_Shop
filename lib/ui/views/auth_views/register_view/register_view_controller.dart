import 'package:bot_toast/bot_toast.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/repos/auth_repo.dart';
import 'package:waslcom/core/services/notification_service.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/views/onBoarding/onBoarding_view.dart';

class RegisterController extends GetxController {
  ///---------------------------------------------------------------------------
  AuthRepository _authRepository = Get.find();

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
  //   } else if (value.length < 9) {
  //     error = "رقم الهاتف غير صحيح".tr;
  //   } else if (value.startsWith("0")) {
  //     error = "أزل الصفر من البداية".tr;
  //   }
  //   return error;
  // }

  String validateIsPassword(String value) {
    String error;
    if (value.isEmpty) {
      error = "هذا الحقل مطوب".tr;
    } else if (value.length < 6) {
      error = "كلمة السر يجب أن تكون أكثر من 6 خانات".tr;
    } else if (confPasswordController.text.trim() !=
        passwordController.text.trim()) {
      error = "يجب أن تتطابق كلمتا السر".tr;
    }
    return error;
  }

  ///---------------------------------------------------------------------------
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confPasswordController = TextEditingController();

  ///---------------------------------------------------------------------------
  void register() {
    if (key.currentState.validate()) {
      registerRequest();
    } else {
      autoValidateModeSet = AutovalidateMode.onUserInteraction;
    }
  }

  void registerRequest() async {
    try {
      BotToast.showLoading();
      await _authRepository
          .registerByEmail(
              email: countryCode + phoneNumber.trim() + "@int.c.waslcom.com",
              password: passwordController.text.trim(),
              confPassword: confPasswordController.text.trim())
          .then((value) async {
        if (value) {
          await Get.find<NotificationService>().initialise();
          Get.offAll(() => OnBoardingView());
        }
      });
    } catch (e) {
      print(e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  ///Formatter
  // final MaskTextInputFormatter phoneFormatter =
  //     MaskTextInputFormatter(mask: "###-###-###");
  String phoneNumber = "";

  ///Country code
  //Show Country code

  String countryCode = "963";

  Widget showCountryCode() {
    return CountryCodePicker(
      onChanged: (v) {
        countryCode = v.dialCode.replaceAll("+", "");
      },
      initialSelection: "+966",
      favorite: StorageService.favNumbers,
      alignLeft: true,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confPasswordController.dispose();
    super.dispose();
  }
}
