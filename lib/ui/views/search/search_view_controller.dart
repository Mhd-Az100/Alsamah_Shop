import 'dart:developer';

import 'package:connection_verify/connection_verify.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/models/subcategories_products_model.dart';
import 'package:waslcom/core/repos/store_repo.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';

class SearchViewController extends GetxController {
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

  ///---------------------------------------------------------------------------
  bool _firstTime = true;

  bool get firstTime => _firstTime;

  set firstTimeSet(bool value) {
    _firstTime = value;
    update();
  }

  ///---------------------------------------------------------------------------
  ///Get products info
  var searchValue = TextEditingController();

  var productsList = <SubCategoriesAndProductsModel>[];

  void searchRequest() async {
    if (searchValue.text.isNotEmpty) {
      firstTimeSet = false;
      try {
        isLoadingSet = true;
        productsList = await StoreRepository.searchRequest(searchValue.text);
      } catch (e) {
        log(e.toString(), name: "searchRequest controller  error");
      } finally {
        isLoadingSet = false;
      }
    } else {
      productsList.clear();
      update();
    }
  }

  ///---------------------------------------------------------------------------
  ///Get products info
  var barcode = '';

  SubCategoriesAndProductsModel productsListbybarcode;

  void searchByBarcodeRequest() async {
    if (barcode.isNotEmpty) {
      firstTimeSet = false;
      try {
        isLoadingSet = true;
        productsListbybarcode = await StoreRepository.searchByBarcode(barcode);
      } catch (e) {
        log(e.toString(), name: "searchRequest controller  error");
      } finally {
        isLoadingSet = false;
      }
    } else {
      productsListbybarcode = null;
      update();
    }
  }

  SubCategoriesAndProductsModel getData(index) => productsList[index];

  ///---------------------------------------------------------------------------
  void addToCart(int index) {
    ShoppingCartController shoppingCartController = Get.find();
    shoppingCartController.addToCart(getData(index));
  }

  ///---------------------------------------------------------------------------
  @override
  void onInit() async {
    if (await ConnectionVerify.connectionStatus()) {
      connectionErrorSet = false;
    } else {
      connectionErrorSet = true;
    }
    super.onInit();
  }
}
