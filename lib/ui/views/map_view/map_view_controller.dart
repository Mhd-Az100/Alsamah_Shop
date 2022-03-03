import 'dart:developer';
import 'dart:math' as math;

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waslcom/core/data_sets.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/core/models/address_models.dart';
import 'package:waslcom/core/models/general_enums/add_address_conditions_enum.dart';
import 'package:waslcom/core/repos/address_repo.dart';
import 'package:waslcom/core/repos/app_properties_repo.dart';
import 'package:waslcom/core/repos/billing_address_repo.dart';
import 'package:waslcom/core/services/location_service.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/core/utils/messages_util.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';
import 'package:waslcom/ui/shared_widgets/genera_widgets.dart';
import 'package:waslcom/ui/shared_widgets/text_widgets.dart';

class MapViewController extends GetxController {
  ///---------------------------------------------------------------------------
  var _addressRepo = AddressRepository();

  ///---------------------------------------------------------------------------
  bool _isLoading = false;

  get isLoading => _isLoading;

  void isLoadingSet(value) {
    _isLoading = value;
    update();
  }

  ///---------------------------------------------------------------------------
  Position _position;

  Position get position => _position;

  Future<Position> getCurrentLocation() async {
    Position _position;
    try {
      _position = await LocationService.determinePosition();
    } catch (e) {
      if (e.toString() == ErrorsLocal.LocationServiceDisabled)
        MessagesUtil.showCustomMessage(
            message: "يرجى رفع مستوى فعالية تحديد الموقع في إعدادات الهاتف",
            messageType: MessageType.ErrorMessage);
      print(e);
    }
    return _position;
  }

  ///---------------------------------------------------------------------------
  /// Select new location
  String _formattedAddress = "";

  get formattedAddress => _formattedAddress;

  void formattedAddressSet(value) {
    _formattedAddress = value;
    update();
  }

  Address _addressDetails;

  Address get addressDetails => _addressDetails;

  set addressDetailsSet(Address value) {
    _addressDetails = value;
    formattedAddressSet(value.addressLine);
    log(formattedAddress.toString(), name: "formattedAddress");
    BotToast.showText(text: _formattedAddress.tr, align: Alignment.center);
  }

  LatLng _latLng = LatLng(33.5138, 36.2765);

  LatLng get latLng => _latLng;

  set latLngSet(LatLng value) {
    _latLng = value;
  }

  void getLocationDetails({double lat, double lon}) async {
    addMarkerOnTab(LatLng(lat, lon));
    latLngSet = LatLng(lat, lon);
    try {
      BotToast.showLoading();
      await LocationService.getLocationDetailsByGeoCoder(lat: lat, lon: lon)
          .then((value) {
        if (!GetUtils.isNull(value)) {
          addressDetailsSet = value;
          showSendOrderDialog(
              addAddressConditionsEnum:
                  AddAddressConditionsEnum.ClickOnMapAndGeoLocatorIsAvailable);
        } else {
          showSendOrderDialog(
              addAddressConditionsEnum: AddAddressConditionsEnum
                  .ClickOnMapAndGeoLocatorIsNotAvailable);
        }
      });
    } catch (e) {
      log(e.toString(), name: "getLocationDetails error");
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void getLocationDetailsBySearchAutoCompleter(BuildContext context) async {
    try {
      await LocationService.getPredictionForSearchAutoCompleter(context);
    } catch (e) {
      log(e.toString(), name: "getLocationDetailsBySearchAutoCompleter error");
    }
  }

  ///---------------------------------------------------------------------------
  Set<Marker> markers = Set();

  void addMarkerOnTab(LatLng target) async {
    try {
      markers.add(Marker(
        markerId: MarkerId('user_location'),
        position: target,
      ));
      update();
    } catch (e) {
      print('on tab marker failed!');
    }
  }

//-----------------------------for marker-------------------------------------
  CameraPosition markerposition;

  positionMarker(position) {
    markerposition = position;
    print('rrrrrrrrrrrrr  $position');
    update();
  }

  ///---------------------------------------------------------------------------
  ///Send address
  var addressDescriptionController = TextEditingController();

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

  String validateIsHasValue(String value) {
    String error;
    if (value.isEmpty) {
      error = "Is required".tr;
    }
    return error;
  }

  ///---------------------------------------------------------------------------
  /// address submitter
  void showAddressSubmitter(BuildContext context, Size size) =>
      GeneralWidgets.showModalSheet(
          context,
          [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.5, vertical: 4),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.5, vertical: 4),
                child: Text(
                  formattedAddress,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                      color: AppColors.blue150Color,
                      fontWeight: FontWeight.w400,
                      fontSize: size.longestSide / 35),
                ),
              ),
            ),
            LinearGradientButton(
              title: "اضغط لحفظ العنوان",
              borderRaduis: 0,
              onTap: sendAddressRequest,
            ),
          ],
          hasATextFiled: false);

  ///---------------------------------------------------------------------------
  ///Send address
  void sendAddressRequest(
    String recipientAddressDetails,
    String recipientPhoneNumber,
    String recipientUserName,
  ) async {
    Get.back();
    try {
      BotToast.showLoading();
      if (!GetUtils.isNull(addressDetails)) {
        await AddressRepository.createAddressRequest(AddressDto(
          city: addressDetails.locality,
          country: addressDetails.countryName,
          area: addressDetails.adminArea,
          description: addressDetails.addressLine,
          geoLocation:
              "${latLng.latitude.toString()},${latLng.longitude.toString()}",
          id: 0,
          userFullName: recipientUserName,
          userMobile: recipientPhoneNumber,
        )).then((value) => Get.back(result: value));
      } else {
        await AddressRepository.createAddressRequest(AddressDto(
          description: recipientAddressDetails,
          userMobile: recipientPhoneNumber,
          userFullName: recipientUserName,
          geoLocation:
              "${latLng.latitude.toString()},${latLng.longitude.toString()}",
          id: 0,
        )).then((value) => Get.back(result: value));
      }
    } catch (e) {
      log(e.toString(), name: "sendAddressRequest error");
    } finally {
      BotToast.closeAllLoading();
    }
  }

  ///---------------------------------------------------------------------------
  ///Dialog
  void showSendOrderDialog(
      {@required AddAddressConditionsEnum addAddressConditionsEnum,
      String latLong,
      int index = 0}) async {
    String recipientAddressDetails;
    String recipientPhoneNumber;
    String recipientUserName;
    String recipientFixedLinePhoneNumber;
    bool recipientAddressDetailsRequired = addAddressConditionsEnum ==
        AddAddressConditionsEnum.ClickOnMapAndGeoLocatorIsNotAvailable;
    Get.dialog(
      AlertDialog(
        title: Text(
          "حفظ العنوان",
          style: GoogleFonts.cairo(
              color: AppColors.orangeColor,
              fontWeight: FontWeight.bold,
              fontSize: 22),
          textAlign: TextAlign.center,
        ),
        content: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "يرجى ادخال تفاصيل العنوان الاضافية لاستكمال بيانات الاستلام",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                          color: AppColors.grey500Color,
                          fontWeight: FontWeight.w700,
                          fontSize: 17)),
                  SizedBox(
                    height: 14,
                  ),
                  SecondCustomTextWidget(
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    labelText: "الإسم",
                    labelTextColor: AppColors.blue200Color,
                    onChange: (value) => recipientUserName = value,
                  ),
                  SecondCustomTextWidget(
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    keyBoardType: TextInputType.phone,
                    labelTextColor: AppColors.blue200Color,
                    labelText: "رقم الجوال",
                    onChange: (value) => recipientPhoneNumber = value,
                  ),
                  SecondCustomTextWidget(
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    keyBoardType: TextInputType.phone,
                    labelTextColor: AppColors.blue200Color,
                    textFormatter: [GeneralUtils.syrianPhoneFormatter],
                    labelText: "رقم الهاتف الأرضي ( اختياري )",
                    onChange: (value) => recipientFixedLinePhoneNumber = value,
                  ),
                  if (addAddressConditionsEnum ==
                      AddAddressConditionsEnum
                          .ClickOnMapAndGeoLocatorIsAvailable) ...[
                    Text("${addressDetails?.addressLine}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                            color: AppColors.blue200Color,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                  ] else if (addAddressConditionsEnum ==
                      AddAddressConditionsEnum
                          .ClickOnMapAndGeoLocatorIsNotAvailable) ...[
                    SecondCustomTextWidget(
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      labelTextColor: AppColors.blue200Color,
                      labelText: "سجل تفاصيل العنوان",
                      onChange: (value) => recipientAddressDetails = value,
                    ),
                  ],
                  SizedBox(
                    height: MediaQuery.of(Get.context).viewInsets.bottom + 20,
                  )
                ],
              ),
            )),
        actions: <Widget>[
          FlatButton(
            child: Text("حفظ العنوان"),
            onPressed: () {
              /// Full address details already exited

              /// Address need more details
              if ((recipientAddressDetailsRequired &&
                      GetUtils.isNull(recipientAddressDetails)) ||
                  GetUtils.isNull(recipientPhoneNumber) ||
                  GetUtils.isNull(recipientUserName)) {
                BotToast.showText(
                    text: "جميع المعلومات مطلوبة عدا الهاتف الأرضي",
                    align: Alignment.center);
              } else {
                sendAddressRequest(
                    !GetUtils.isNullOrBlank(recipientFixedLinePhoneNumber)
                        ? (recipientAddressDetails ??
                                addressDetails.addressLine) +
                            " - الهاتف الأرضي : " +
                            recipientFixedLinePhoneNumber
                        : (recipientAddressDetails ??
                            addressDetails.addressLine),
                    recipientPhoneNumber,
                    recipientUserName);
              }
            },
          ),
          FlatButton(
            child: Text(
              "تراجع",
              style: TextStyle(color: AppColors.redColor),
            ),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  ///Check auto set receiver address on map
  bool _autoSetReceiverAddress = true;

  bool get autoSetReceiverAddress => _autoSetReceiverAddress;

  LatLng _defaultLatLang = LatLng(33.5138, 36.2765);

  LatLng get defaultLatLang => _defaultLatLang;

  Future autoSetUserAddress() async {
    try {
      isLoadingSet(true);
      _autoSetReceiverAddress =
          await AppPropertiesRepo.checkAutoDetermineReceiverAddress();
      if (_autoSetReceiverAddress) {
        Position _position = await getCurrentLocation();
        if (_position != null)
          _defaultLatLang = LatLng(_position.latitude, _position.latitude);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingSet(false);
    }
  }

  ///---------------------------------------------------------------------------
  ///Get billing address info
  Future getUserBillingAddress() async {
    try {
      final billingAddressList =
          await BillingAddressRepo.getAllBillingAddress();
      if (billingAddressList.isNotEmpty) {
        Get.find<StorageService>().saveBillingInfo(billingAddressList.first);
      }
    } catch (e) {
      log(e.toString(), name: "getAllAddress controller  error");
    }
  }

  ///---------------------------------------------------------------------------
  @override
  void onInit() async {
    autoSetUserAddress();
    if (Get.find<StorageService>().getBillingInfo().id == null ?? false)
      await getUserBillingAddress();
    super.onInit();
  }

  @override
  void dispose() {
    addressDescriptionController?.dispose();
    super.dispose();
  }
}
