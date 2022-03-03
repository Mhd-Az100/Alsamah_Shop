import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/models/address_models.dart';
import 'package:waslcom/core/models/deliveryfess_model.dart';
import 'package:waslcom/core/repos/address_repo.dart';
import 'package:waslcom/core/repos/app_properties_repo.dart';
import 'package:waslcom/core/repos/orders_repo.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/address_view/address_view.dart';
import 'package:waslcom/ui/views/map_view/map_view.dart';
import 'package:waslcom/ui/views/order%20items/order_items_view.dart';
import 'package:waslcom/ui/views/orders/orders_view_controller.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';

class MyAddressController extends GetxController {
  ///---------------------------------------------------------------------------

  ///Loading indicator

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoadingSet(bool value) {
    _isLoading = value;
    update();
  }

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

  void getAllAddress() async {
    try {
      isLoadingSet = true;
      var addresslst = await AddressRepository.getAllAddress();
      addressList = List.from(addresslst.reversed);
    } catch (e) {
      log(e.toString(), name: "getAllAddress controller  error");
    } finally {
      isLoadingSet = false;
    }
  }

  ///---------------------------------------------------------------------------
  ///Delete address
  void deleteAddress(int id) async {
    try {
      BotToast.showLoading();
      await AddressRepository.deleteAddressRequest(id);
    } catch (e) {
      log(e.toString(), name: "deleteAddressRequest error");
    } finally {
      getAllAddress();
      BotToast.closeAllLoading();
    }
  }

  void emptyAddress() {
    addressList.clear();
    update();
  }

  ///---------------------------------------------------------------------------
  ///Place Order
  void placeOrderFromAddressList(int index, String timeorder) async {
    final _shoppingCart = Get.find<ShoppingCartController>();
    try {
      print('time : $timeorder');
      timeorder.isEmpty
          ? timeorder = 'لا يوجد مدة محددة'
          : timeorder = timeorder;
      print('time : $timeorder');
      print(Get.find<StorageService>().getBillingInfo().id);
      print(Get.find<StorageService>().getCurrencyInfo().code);

      BotToast.showLoading();
      await OrderRepository.createOrderRequest(_shoppingCart
              .prepareOderToSend(addressList[index].id, notes: timeorder))
          .then((value) async {
        if (value != null) {
          timeOrder = '';

          _shoppingCart.emptyShoppingCart();
          await Get.find<OrdersViewController>()
              .getOrderitems(value.toString());
          Get.off(OrderItemDetails());
          // Get.off(() => OrdersView());
        } else {}
      });
    } catch (e) {
      log(e.toString(), name: "placeOrderFromAddressList func  error");
    } finally {
      BotToast.closeAllLoading();
    }
  }

  ///---------------------------------------------------------------------------
  ///Add new address
  void addNewAddress() async {
    final bool response = await Get.to(() => MapView());
    if (response != null && response is bool) {
      if (response) getAllAddress();
      Get.off(() => MyAddressView(
            fromShoppingCart: response,
          ));
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
  String timeOrder = '';
  void showSendOrderDialog(context, {int index = 0}) {
    Get.back();
    Get.dialog(
      AlertDialog(
        title: Text(
          "ارسال الطلب",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.orangeColor),
        ),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "سوف يتم ارسال الطلب الى العنوان التالي",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.blue150Color),
              ),
              Text(
                "${addressList[index].description}",
                textAlign: TextAlign.center,
              ),
              Divider(
                height: 15,
                thickness: 0.5,
                color: AppColors.grey.withOpacity(0.1),
              ),
              checkTimeDelivery == 'enable'
                  ? Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              DatePicker.showTime12hPicker(context,
                                  showTitleActions: true, onConfirm: (date) {
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
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("ارسال الطلب"),
            onPressed: () {
              if (timeOrder == "" && checkTimeDelivery == "enable") {
                BotToast.showText(
                    text: "الرجاء اختر  الوقت المراد", align: Alignment.center);
                return;
              }
              Get.back();
              placeOrderFromAddressList(index, timeOrder);
            },
          ),
          FlatButton(
            child: Text(
              "تراجع",
              style: TextStyle(color: AppColors.redColor),
            ),
            onPressed: () {
              Get.back();
              timeOrder = '';
            },
          )
        ],
      ),
      barrierDismissible: false,
    );
  }
  //===========================================================================

  //===========================================================================
  Rx<Deliveryfess> deliveryfess = Deliveryfess().obs;
  getdeliveryfess() async {
    print('mhd ctrl ${deliveryfess.value}');

    var delivery = await AddressRepository.getdeliveryfess();
    deliveryfess.value = delivery;
  }

  ///---------------------------------------------------------------------------
  ///onInit
  @override
  void onInit() {
    getAllAddress();
    super.onInit();
  }
}
