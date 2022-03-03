import 'dart:developer';

import 'package:connection_verify/connection_verify.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/models/categories_view_model.dart';
import 'package:waslcom/core/repos/store_repo.dart';

class CategoriesViewController extends GetxController {
  final String id;

  CategoriesViewController(this.id);

  ///---------------------------------------------------------------------------
  ///Loading indicator

  RxBool isLoading = false.obs;

  ///---------------------------------------------------------------------------
  ///Connection error indicator

  RxBool connectionError = false.obs;

  ///---------------------------------------------------------------------------
  ///Get Stores List

  var dataList = <CategoriesModel>[];

  Future getCategories(String id) async {
    try {
      isLoading(true);
      dataList = await StoreRepository.getCategories(id);
    } catch (e) {
      log(e.toString(), name: "Get getCategories func error");
    } finally {
      isLoading(false);
    }
    update();
  }

  CategoriesModel getData(int index) {
    return dataList[index];
  }

  ///---------------------------------------------------------------------------
  ///onInitial
  void onInitial(String id) async {
    try {
      if (await ConnectionVerify.connectionStatus()) {
        connectionError(false);
        getCategories(id);
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
