import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/models/billing_address_dto.dart';
import 'package:waslcom/core/models/currency_model.dart';
import 'package:waslcom/core/repos/app_properties_repo.dart';
import 'package:waslcom/core/repos/billing_address_repo.dart';
import 'package:waslcom/core/repos/currencies_repo.dart';
import 'package:waslcom/core/services/location_service.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/genera_widgets.dart';
import 'package:waslcom/ui/views/store_views/main_store_view/main_store_view.dart';

class AccountInfoViewController extends GetxController {
  //Edit mode
  BillingAddressDto _billingAddressDto;

  set billingAddressDtoSet(BillingAddressDto value) {
    _billingAddressDto = value;
    update();
  }

  bool get editModel => _billingAddressDto != null;

  //Services

  StorageService storage = Get.find();

  //Controllers
  var countryController = TextEditingController();
  var fullNameController = TextEditingController();
  var cityController = TextEditingController();
  var addressDescriptionController = TextEditingController();

  void setControllers() {
    countryController =
        TextEditingController(text: _addressDetails.countryName);
    cityController = TextEditingController(text: _addressDetails.locality);
    addressDescriptionController =
        TextEditingController(text: _addressDetails.addressLine);
    update();
  }

  //Validators
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  GlobalKey<FormState> get key => _key;

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  AutovalidateMode get autoValidateMode => _autoValidateMode;

  set autoValidateModeSet(AutovalidateMode value) {
    _autoValidateMode = value;
    update();
  }

  String validateField(String value) {
    String error;
    if (value.isEmpty) {
      error = "هذا الحقل مطلوب".tr;
    }
    return error;
  }

  @override
  void dispose() {
    addressDescriptionController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

//Location service

  Position _position;

  Position get position => _position;

  Future getCurrentLocation() async {
    try {
      BotToast.showLoading();
      _position = await LocationService.determinePosition();
      await getLocationDetails(
          lat: _position.latitude, lon: _position.longitude);
    } catch (e) {
      print(e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  Future getLocationDetails({double lat, double lon}) async {
    try {
      await LocationService.getLocationDetailsByGeoCoder(lat: lat, lon: lon)
          .then((value) {
        if (!GetUtils.isNull(value)) {
          _addressDetails = value;
          setControllers();
        }
      });
    } catch (e) {
      log(e.toString(), name: "getLocationDetails error");
    } finally {}
  }

  Address _addressDetails;

  Address get addressDetails => _addressDetails;

  //Send address

  void sendAddressRequest() async {
    try {
      BotToast.showLoading();
      await BillingAddressRepo.profileInfo(fullNameController.text.trim());

      final response = await BillingAddressRepo.createBillingAddressRequest(
          BillingAddressDto(
              id: 0,
              country: countryController.text.trim(),
              city: cityController.text.trim(),
              userFullName: fullNameController.text.trim(),
              userMobile: storage
                  .getTokenInfo()
                  .userName
                  .replaceAll("@int.c.waslcom.com", ""),
              description: addressDescriptionController.text.trim(),
              geoLocation: position != null
                  ? "${position?.latitude},${position?.longitude}"
                  : null));
      if (response != null && response is bool) {
        if (response) {
          storage.setIsCompleteLogin();
          storage.saveCurrencyInfo(currencyDto);
          Get.offAll(() => MainStoreView());
        }
      }
    } catch (e) {
      log(e.toString(), name: "sendAddressRequest error");
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void editAddressRequest() async {
    try {
      BotToast.showLoading();
      await BillingAddressRepo.profileInfo(fullNameController.text.trim());
      final response = await BillingAddressRepo.updateBillingAddressRequest(
          id: _billingAddressDto.id,
          billingAddressDto: BillingAddressDto(
              id: _billingAddressDto.id,
              country: countryController.text.trim(),
              city: cityController.text.trim(),
              userFullName: fullNameController.text.trim(),
              userMobile: storage
                  .getTokenInfo()
                  .userName
                  .replaceAll("@int.c.waslcom.com", ""),
              description: addressDescriptionController.text.trim(),
              geoLocation: position != null
                  ? "${position.latitude},${position.longitude}"
                  : null));
      if (response != null && response is bool) {
        if (response) {
          storage.saveCurrencyInfo(currencyDto);
          Get.back(result: response);
        } else {
          BotToast.showText(
              text: "حدثت مشكلة أثناء عملية التعديل",
              backgroundColor: AppColors.redColor.withOpacity(0.7),
              align: Alignment.center);
        }
      }
    } catch (e) {
      log(e.toString(), name: "sendAddressRequest error");
    } finally {
      BotToast.closeAllLoading();
    }
  }

  ///Get currencies
  CurrencyDto _currencyDto;

  CurrencyDto get currencyDto => _currencyDto;

  set currencyDtoSet(CurrencyDto value) {
    _currencyDto = value;
    update();
  }

  var currenciesList = <CurrencyDto>[];

  void getAllCurrencies() async {
    try {
      BotToast.showLoading();
      currenciesList = await CurrenciesRpo.getAllCurrencies();
      GeneralWidgets.showModalSheetForCurrencies(
          currenciesList, (currencyDto) => {currencyDtoSet = currencyDto});
    } catch (e) {
      log(e.toString(), name: "getAllCurrencies controller  error");
    } finally {
      BotToast.closeAllLoading();
    }
  }

//Submit request
  void saveAccountInfo(bool fromLogin) {
    if (fromLogin) {
      storage.saveCurrencyInfo(currencyDto);
      storage.setIsCompleteLogin();
      Get.offAll(() => MainStoreView());
    } else {
      if (key.currentState.validate() && currencyDto != null) {
        editModel ? editAddressRequest() : sendAddressRequest();
      } else {
        BotToast.showText(
            text: "الرجاء التأكد من كافة المعلومات",
            align: Alignment.center,
            textStyle:
                GoogleFonts.cairo(color: AppColors.whiteColor, fontSize: 22));
        autoValidateModeSet = AutovalidateMode.onUserInteraction;
      }
    }
  }

  ///Check auto set currency
  bool _autoSetCurrencyMode = true;

  bool get autoSetCurrencyMode => _autoSetCurrencyMode;

  Future autoSetCurrency() async {
    try {
      BotToast.showLoading();
      _autoSetCurrencyMode = await AppPropertiesRepo.checkAutoSetCurrency();
      if (_autoSetCurrencyMode) {
        currenciesList = await CurrenciesRpo.getAllCurrencies();
        if (currenciesList.isNotEmpty)
          currencyDtoSet = currenciesList.first;
        else
          currencyDtoSet = CurrencyDto();
      }
    } catch (e) {
      print(e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  @override
  void onInit() async {
    await autoSetCurrency();
    await getCurrentLocation();
    if (_billingAddressDto != null) {
      fullNameController =
          TextEditingController(text: _billingAddressDto.userFullName);
      countryController =
          TextEditingController(text: _billingAddressDto.country);
      cityController = TextEditingController(text: _billingAddressDto.city);
      addressDescriptionController =
          TextEditingController(text: _billingAddressDto.description);
      currencyDtoSet = storage.getCurrencyInfo();
    }
    super.onInit();
  }
}
