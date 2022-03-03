import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:connection_verify/connection_verify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geocoder/model.dart';
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
import 'package:waslcom/core/repos/orders_repo.dart';
import 'package:waslcom/core/services/location_service.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/core/utils/messages_util.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/text_widgets.dart';
import 'package:waslcom/ui/views/order%20items/order_items_view.dart';
import 'package:waslcom/ui/views/orders/orders_view_controller.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';

class PlaceOrderOnMapViewController extends GetxController {
  ///---------------------------------------------------------------------------

  ///---------------------------------------------------------------------------
  ///Connection error indicator

  bool _connectionError = false;

  bool get connectionError => _connectionError;

  set connectionErrorSet(bool value) {
    _connectionError = value;
    update();
  }

  ///---------------------------------------------------------------------------
  ///Get Address info List
  var addressList = <AddressDto>[];

  Future getAllAddress() async {
    try {
      addressList = await AddressRepository.getAllAddress();
      update();
    } catch (e) {
      log(e.toString(), name: "getAllAddress controller  error");
    }
  }

  ///---------------------------------------------------------------------------
  ///Location Details
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

  set addressDetailsWithoutToastSet(Address value) {
    _addressDetails = value;
    formattedAddressSet(value.addressLine);
    log(formattedAddress.toString(), name: "formattedAddress");
  }

  void getLocationDetails({
    double lat,
    double lon,
  }) async {
    addMarkerOnTab(LatLng(lat, lon));
    try {
      BotToast.showLoading();
      await LocationService.getLocationDetailsByGeoCoder(lat: lat, lon: lon)
          .then((value) {
        if (!GetUtils.isNull(value)) {
          addressDetailsWithoutToastSet = value;

          /// In case off address details is available
          showSendOrderDialog(BuildContext,
              addAddressConditionsEnum:
                  AddAddressConditionsEnum.ClickOnMapAndGeoLocatorIsAvailable,
              latLong: "${lat.toString()},${lon.toString()}");
        } else {
          ///In case no address details and not using the address list
          showSendOrderDialog(BuildContext,
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

  ///---------------------------------------------------------------------------
  ///Add marker on map

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

  ///---------------------------------------------------------------------------
  bool _mapIsLoading = true;

  get mapIsLoading => _mapIsLoading;

  set mapIsLoadingSet(value) {
    _mapIsLoading = value;
    update();
  }

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
  ///onInitial
  void onInitial() async {
    try {
      mapIsLoadingSet = true;
      if (await ConnectionVerify.connectionStatus()) {
        connectionErrorSet = false;
        await getAllAddress();
        await autoSetUserAddress();
        if (Get.find<StorageService>().getBillingInfo().id == null ?? false)
          await getUserBillingAddress();
      } else {
        connectionErrorSet = true;
      }
    } catch (e) {
      log(e.toString(), name: "onInitial controller  error");
    } finally {
      mapIsLoadingSet = false;
    }
  }

  ///---------------------------------------------------------------------------
  final _shoppingCart = Get.find<ShoppingCartController>();

  ///Place Order
  void placeOrderFromAddressList(int index, String timeorder) async {
    print('time : $timeorder');
    timeorder == '' ? timeorder = 'لا يوجد مدة محددة' : timeorder = timeorder;
    print('time : $timeorder');

    try {
      BotToast.showLoading();
      await OrderRepository.createOrderRequest(_shoppingCart
              .prepareOderToSend(addressList[index].id, notes: timeorder))
          .then((value) async {
        if (value != null) {
          _shoppingCart.emptyShoppingCart();
          timeOrder = '';
          await Get.find<OrdersViewController>()
              .getOrderitems(value.toString());
          Get.off(OrderItemDetails());
          // Get.off(() => OrdersView(
          //       fromPlaceOrder: true,
          //     ));
        } else {}
      });
    } catch (e) {
      log(e.toString(), name: "placeOrderFromAddressList func  error");
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void placeOrderDirectOnMap(
      {String addressDescription,
      String userName,
      String userPhone,
      @required String latLong}) async {
    try {
      BotToast.showLoading();

      final MapEntry response = (!GetUtils.isNull(addressDetails))
          ? await AddressRepository.createAddressRequestForSendOrder(AddressDto(
              city: addressDetails.locality,
              country: addressDetails.countryName,
              area: addressDetails.adminArea,
              description: addressDetails.addressLine,
              userFullName: userName,
              userMobile: userPhone,
              geoLocation: latLong,
              id: 0,
            ))
          : await AddressRepository.createAddressRequestForSendOrder(AddressDto(
              country: "Syria",
              city: "Damascus",
              area: "Damascus",
              description: addressDescription ?? "",
              userFullName: userName,
              userMobile: userPhone,
              geoLocation: latLong,
              id: 0,
            ));
      if (response.value) {
        await OrderRepository.createOrderRequest(
                _shoppingCart.prepareOderToSend(response.key))
            .then((value) async {
          if (value != null) {
            timeOrder = '';
            await Get.find<OrdersViewController>()
                .getOrderitems(value.toString());
            Get.off(OrderItemDetails());
            _shoppingCart.emptyShoppingCart();
            // Get.off(
            //   () => OrdersView(
            //     fromPlaceOrder: true,
            //   ),
            // );
          }
        });
      } else {
        BotToast.showText(text: "تم تحديد الموقع على الخريطة");
      }
    } catch (e) {
      log(e.toString(), name: "placeOrderDirectOnMap error");
    } finally {
      BotToast.closeAllLoading();
    }
  }

//check deliverytime
  var checkTimeDelivery;
  void checkDeliveryTime() async {
    var check = await AppPropertiesRepo.checkDeliveryTime();
    checkTimeDelivery = check;
    print('checkTimeDelivery : $checkTimeDelivery');
  }

  ///---------------------------------------------------------------------------
  ///Dialogs
  String timeOrder = '';
  void showSendOrderDialog(context,
      {@required AddAddressConditionsEnum addAddressConditionsEnum,
      String latLong,
      int index = 0}) async {
    await Future.delayed(Duration(milliseconds: 400));
    String recipientAddressDetails;
    String recipientPhoneNumber;
    String recipientFixedLinePhoneNumber;
    String recipientUserName;
    bool recipientAddressDetailsRequired = addAddressConditionsEnum ==
        AddAddressConditionsEnum.ClickOnMapAndGeoLocatorIsNotAvailable;
    Get.dialog(
      AlertDialog(
        title: Text(
          "ارسال الطلب",
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
                  SizedBox(
                    height: 4,
                  ),
                  Text("سوف يتم ارسال الطلب الى العنوان التالي",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey500Color)),
                  SizedBox(
                    height: 10,
                  ),
                  if (addAddressConditionsEnum ==
                      AddAddressConditionsEnum.ClickOnAddressList) ...[
                    ///If clicked on already exited address
                    /// No data will be entered
                    Text("${addressList[index].userFullName}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                            color: AppColors.blue200Color,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                    Text("${addressList[index].userMobile}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                            color: AppColors.blue200Color,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                    Text("${addressList[index].description}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                            color: AppColors.blue200Color,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                  ] else ...[
                    ///New address
                    ///Fixed text fields
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
                      textFormatter: [GeneralUtils.syrianPhoneFormatter],
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
                      onChange: (value) =>
                          recipientFixedLinePhoneNumber = value,
                    ),
                  ],
                  if (addAddressConditionsEnum ==
                      AddAddressConditionsEnum
                          .ClickOnMapAndGeoLocatorIsAvailable) ...[
                    ///Address details is available
                    Text("${addressDetails.addressLine}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                            color: AppColors.blue200Color,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                  ],
                  if (addAddressConditionsEnum ==
                      AddAddressConditionsEnum
                          .ClickOnMapAndGeoLocatorIsNotAvailable) ...[
                    ///Address details is not available
                    SecondCustomTextWidget(
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      labelTextColor: AppColors.blue200Color,
                      labelText: "سجل تفاصيل عنوان المستلم",
                      onChange: (value) => recipientAddressDetails = value,
                    ),
                  ],
                  SizedBox(
                    height: MediaQuery.of(Get.context).viewInsets.bottom + 20,
                  ),
                  checkTimeDelivery == 'enable'
                      ? Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  DatePicker.showTime12hPicker(context,
                                      showTitleActions: true,
                                      onConfirm: (date) {
                                    timeOrder = date.toString();
                                    print(timeOrder);
                                    BotToast.showText(
                                        text: "  تم تحديد الوقت $timeOrder ",
                                        duration: Duration(seconds: 4),
                                        align: Alignment.center);
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.ar);
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.access_time_sharp,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  timeOrder = 'في اقرب وقت ممكن';
                                  print(timeOrder);
                                  BotToast.showText(
                                      text: "تم تحديد الوقت ",
                                      duration: Duration(seconds: 4),
                                      align: Alignment.center);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/pngs/cardelivery.png',
                                        scale: 19,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "في اسرع وقت ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            )),
        actions: <Widget>[
          FlatButton(
            child: Text("إرسال الطلب"),
            onPressed: () {
              if (timeOrder == "" && checkTimeDelivery == "enable") {
                BotToast.showText(
                    text: "الرجاء اختر  الوقت المراد", align: Alignment.center);
                return;
              }

              /// Full address details already exited
              if (addAddressConditionsEnum ==
                  AddAddressConditionsEnum.ClickOnAddressList) {
                Get.back();
                placeOrderFromAddressList(index, timeOrder);
              } else {
                /// Address need more details
                if ((recipientAddressDetailsRequired &&
                        GetUtils.isNull(recipientAddressDetails)) ||
                    GetUtils.isNull(recipientPhoneNumber) ||
                    GetUtils.isNull(recipientUserName)) {
                  BotToast.showText(
                      text: "جميع المعلومات مطلوبة عدا الهاتف الأرضي",
                      align: Alignment.center);
                } else {
                  Get.back();
                  placeOrderDirectOnMap(
                      latLong: latLong,
                      userName: recipientUserName,
                      userPhone: recipientPhoneNumber,
                      addressDescription:
                          !GetUtils.isNullOrBlank(recipientFixedLinePhoneNumber)
                              ? (recipientAddressDetails ??
                                      addressDetails.addressLine) +
                                  " - الهاتف الأرضي : " +
                                  recipientFixedLinePhoneNumber
                              : (recipientAddressDetails ??
                                  addressDetails.addressLine));
                }
              }
            },
          ),
          FlatButton(
            child: Text(
              "تراجع",
              style: TextStyle(color: AppColors.redColor),
            ),
            onPressed: () {
              timeOrder = '';

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
      _autoSetReceiverAddress =
          await AppPropertiesRepo.checkAutoDetermineReceiverAddress();
      if (_autoSetReceiverAddress) {
        Position _position = await getCurrentLocation();
        if (_position != null)
          _defaultLatLang = LatLng(_position.latitude, _position.latitude);
      }
    } catch (e) {
      print(e);
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
    onInitial();
    super.onInit();
  }
}
