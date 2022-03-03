import 'package:bot_toast/bot_toast.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/repos/auth_repo.dart';
import 'package:waslcom/core/services/notification_service.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/views/account_info/account_info_view.dart';

class LoginViewController extends GetxController {
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
      error = "Is required".tr;
    } else if (value.length < 6) {
      error = "Password must be more than 6 digits".tr;
    }
    return error;
  }

  ///---------------------------------------------------------------------------
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneNumberController = TextEditingController();

  ///---------------------------------------------------------------------------
  void login() {
    if (key.currentState.validate()) {
      logInRequest();
    } else {
      autoValidateModeSet = AutovalidateMode.onUserInteraction;
    }
  }

  var statusLogin;

  void checkLoginBy() async {
    var status = await _authRepository.checkLogin();
    statusLogin = status;
  }

  void logInRequest() async {
    try {
      BotToast.showLoading();
      await _authRepository
          .loginByEmail(
        email: countryCode + phoneNumberController.text.trim() + "@waslcom.com",
        password: passwordController.text.trim(),
      )
          .then((value) async {
        if (value) {
          await Get.find<NotificationService>().initialise();
          Get.offAll(() => AccountInfoView());
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
    super.dispose();
  }
}
