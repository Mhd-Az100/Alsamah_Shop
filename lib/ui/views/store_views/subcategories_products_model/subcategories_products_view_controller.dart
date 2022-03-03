import 'dart:developer';

import 'package:connection_verify/connection_verify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/models/subcategories_products_model.dart';
import 'package:waslcom/core/repos/store_repo.dart';
import 'package:waslcom/ui/views/product_details/product_details_view.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';
import 'package:waslcom/ui/views/store_views/subcategories_products_model/subcategories_products_view.dart';

class SubCategoriesProductsViewController extends GetxController {
  final String id;

  SubCategoriesProductsViewController(this.id);

  ///---------------------------------------------------------------------------
  ///Loading indicator

  RxBool isLoading = false.obs;

  ///---------------------------------------------------------------------------
  ///Connection error indicator

  RxBool connectionError = false.obs;

  ///---------------------------------------------------------------------------
  ///Get Stores List

  var dataList = <SubCategoriesAndProductsModel>[];

  void getSubCategoriesAndProducts(String id) async {
    try {
      isLoading(true);
      dataList = await StoreRepository.getProducts(id);
      dataList.addAll(await StoreRepository.getSubCategories(id));
    } catch (e) {
      log(e.toString(), name: "Get getSubCategoriesAndProducts func error");
    } finally {
      isLoading(false);
    }
    update();
  }

  SubCategoriesAndProductsModel getData(int index) => dataList[index];

  ///---------------------------------------------------------------------------
  ///Pagination
  ScrollController _scrollController = ScrollController();
  int _pageSize = 10;
  int _pageIndex = 0;
  bool _isLastPage = false;

  void activePagination(String id) {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!_isLastPage) {
          _pageIndex++;
          StoreRepository.getProducts(id,
              pageIndex: _pageIndex, pageSize: _pageSize);
        }
      }
    });
  }

  ///Click on items action
  void clickOnItemFunction(int index) {
    if (!getData(index).isProduct) {
      Get.to(
          () => SubCategoriesCategoriesView(
                id: getData(index)?.id?.toString(),
                title: getData(index)?.name,
              ),
          preventDuplicates: false);
    } else if (getData(index).isProduct) {
      Get.to(() => ProductDetailsView(
            product: getData(index),
          ));
    }
  }

  ///---------------------------------------------------------------------------
  ///General functions ( add to cart )

  void addToCart(int index) {
    ShoppingCartController shoppingCartController = Get.find();
    shoppingCartController.addToCart(getData(index));
  }

  ///---------------------------------------------------------------------------
  ///onInitial
  void onInitial(String id) async {
    try {
      if (await ConnectionVerify.connectionStatus()) {
        connectionError(false);
        getSubCategoriesAndProducts(id);
      } else {
        connectionError(true);
      }
    } catch (e) {
      print(e);
    }
  }

  ///---------------------------------------------------------------------------
  @override
  void onInit() {
    onInitial(id);
    super.onInit();
  }
}
