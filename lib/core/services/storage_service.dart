import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waslcom/core/models/auth_models.dart';
import 'package:waslcom/core/models/billing_address_dto.dart';
import 'package:waslcom/core/models/currency_model.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';
import 'package:waslcom/ui/views/splash_view/splash_view.dart';

class StorageService {
  GetStorage storage = GetStorage();

  ///---------------------------------------------------------------------------
  ///Keys
  static const User_Basic_info = "UserBasicInfo";
  static const IsLogin = "IsLogin";
  static const Account_Type = "Account_Type";
  static const Currency_Info = "Currency_Info";
  static const Billing_Info = "Billing_Info";

  ///---------------------------------------------------------------------------
  ///Values
  static const Guest_Account = "Guest_Account";
  static const Complete_Login_Account = "Complete_Login_Account";
  static const Not_Complete_Login_Account = "Not_Complete_Login_Account";
  static const Complete_Login_Account_But_No_Currencies =
      "Complete_Login_Account_But_No_Currencies";
  static const NA_Account = "NA_Account";

  ///---------------------------------------------------------------------------
  ///Fav codes
  static const List<String> favNumbers = <String>[
    "+966",
    "+49",
    "+90",
    "+31",
    "+971",
    "+963"
  ];

  ///---------------------------------------------------------------------------
  void setIsGuest() => storage.write(Account_Type, Guest_Account);

  bool getIsGuestAccount() => getAccountType() == Guest_Account;

  void setIsLoginWithoutInfo() =>
      storage.write(Account_Type, Not_Complete_Login_Account);

  void setIsLoginWithoutCurrency() =>
      storage.write(Account_Type, Complete_Login_Account_But_No_Currencies);

  void setIsCompleteLogin() =>
      storage.write(Account_Type, Complete_Login_Account);

  void logOut() => storage.erase();

  void fullLogOut() {
    logOut();
    Get.find<ShoppingCartController>().emptyShoppingCart();
    Get.offAll(() => SplashView());
  }

  String getAccountType() {
    if (GetUtils.isNull(storage.read(Account_Type))) {
      return NA_Account;
    } else {
      return storage.read(Account_Type);
    }
  }

  bool get isCompleteLoginAccount => getAccountType() == Complete_Login_Account;

  bool get isCompleteLoginAccountButNoCurrencies =>
      getAccountType() == Complete_Login_Account_But_No_Currencies;

  bool get isNotCompleteLoginAccount =>
      getAccountType() == Not_Complete_Login_Account;

  bool get isGuestAccount => getAccountType() == Guest_Account;

  ///---------------------------------------------------------------------------
  Future storeTokenInfo(AuthSuccessModel authSuccessModel) async {
    await storage.write(
        User_Basic_info, json.encode(authSuccessModel.toJson()));
  }

  AuthSuccessModel getTokenInfo() {
    return AuthSuccessModel.fromJson(
        json.decode(storage.read(User_Basic_info)));
  }

  ///---------------------------------------------------------------------------
  void saveCurrencyInfo(CurrencyDto currencyDto) =>
      storage.write(Currency_Info, json.encode(currencyDto.toJson()));

  CurrencyDto getCurrencyInfo() => storage.hasData(Currency_Info)
      ? CurrencyDto.fromJson(json.decode(storage.read(Currency_Info)))
      : CurrencyDto();

  ///---------------------------------------------------------------------------

  void saveBillingInfo(BillingAddressDto billingAddressDto) =>
      storage.write(Billing_Info, json.encode(billingAddressDto.toJson()));

  BillingAddressDto getBillingInfo() {
    if (storage.hasData(Billing_Info))
      return BillingAddressDto.fromJson(
          json.decode(storage.read(Billing_Info)));
    else
      return BillingAddressDto();
  }
}
