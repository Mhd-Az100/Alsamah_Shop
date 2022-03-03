import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:connection_verify/connection_verify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/models/billing_address_dto.dart';
import 'package:waslcom/core/repos/address_repo.dart';
import 'package:waslcom/core/repos/billing_address_repo.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/genera_widgets.dart';
import 'package:waslcom/ui/views/account_info/account_info_view.dart';
import 'package:waslcom/ui/views/map_view/map_view.dart';

class ProfileViewController extends GetxController {
  ///---------------------------------------------------------------------------

  ///Loading indicator

  bool _isLoading = true;

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
  var addressList = <BillingAddressDto>[];

  BillingAddressDto _billingAddressDto;

  BillingAddressDto get billingAddressDto => _billingAddressDto;

  set billingAddressDtoSet(BillingAddressDto value) {
    _billingAddressDto = value;
    update();
  }

  Future getAllAddress() async {
    try {
      isLoadingSet = true;
      addressList = await BillingAddressRepo.getAllBillingAddress();
      if (addressList.isNotEmpty) billingAddressDtoSet = addressList.first;
    } catch (e) {
      log(e.toString(), name: "getAllAddress controller  error");
    } finally {
      isLoadingSet = false;
    }
  }

  ///---------------------------------------------------------------------------
  ///Navigate to account info
  void navigateToAccountInfo() async {
    final response = await Get.to(() => AccountInfoView(
          billingAddressDto: billingAddressDto,
        ));
    if (response != null && response is bool) {
      if (response) {
        GeneralUtils.popUntilRoot(Get.context);
      }
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

  ///---------------------------------------------------------------------------
  ///onInitial
  void onInitial() async {
    try {
      if (await ConnectionVerify.connectionStatus()) {
        connectionErrorSet = false;
        getAllAddress();
      } else {
        connectionErrorSet = true;
      }
    } catch (e) {
      log(e.toString(), name: "onInitial controller  error");
    }
  }

  ///---------------------------------------------------------------------------
  ///Add new address
  void addNewAddress(BuildContext context) =>
      GeneralWidgets.showModalSheet(context, [
        ListTile(
          leading: Icon(Icons.map_outlined),
          onTap: () async {
            Navigator.of(context).pop();
            Get.to(() => MapView()).then((value) {
              if (value != null && value is bool) {
                if (value) {
                  getAllAddress();
                }
              }
            });
          },
          title: Text("Add address using map"),
        ),
        Divider(
          color: AppColors.grey500Color.withOpacity(0.2),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop();
          },
          leading: Icon(Icons.edit_location_outlined),
          title: Text("Add address manually"),
        )
      ]);

  ///---------------------------------------------------------------------------
  @override
  void onInit() {
    onInitial();
    super.onInit();
  }
}
