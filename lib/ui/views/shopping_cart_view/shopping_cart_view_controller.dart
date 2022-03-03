import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/models/place_orders_models.dart';
import 'package:waslcom/core/models/shopping_cart_model.dart';
import 'package:waslcom/core/models/subcategories_products_model.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/font_styles.dart';
import 'package:waslcom/ui/shared_widgets/nav_bar/nav_bar_controller.dart';

class ShoppingCartController extends GetxController {
  ///---------------------------------------------------------------------------
  var navBarController = NavBarController();

  ///---------------------------------------------------------------------------
  ///products list

  var productsList = <ShoppingCartModel>[];

  ShoppingCartModel getData(index) => productsList[index];

  ///---------------------------------------------------------------------------
  ///Total Cost

  double getTotalCost() {
    double totalCost = 0;
    productsList.forEach((element) {
      totalCost = element.totalProductPrice + totalCost;
    });
    return totalCost;
  }

  ///---------------------------------------------------------------------------
  ///Get total items count
  int getTotalCount() => productsList.length ?? 0;

  ///---------------------------------------------------------------------------
  ///Add to cart button status

  Widget addToCartButton(SubCategoriesAndProductsModel product) {
    Widget button = Container();
    if (productsList.any((element) => element.id == product.id)) {
      button = Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
            color: AppColors.whiteColor.withOpacity(0.8)),
        child: IconButton(
          onPressed: () => deleteItem(product),
          icon: Icon(
            Icons.shopping_cart,
            size: 25,
            color: AppColors.greenColor,
          ),
        ),
      );
    } else {
      button = Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
            color: AppColors.whiteColor.withOpacity(0.8)),
        child: IconButton(
          onPressed: () => addToCart(product),
          icon: product.quantity > 0
              ? Icon(Icons.add_shopping_cart,
                  size: 25, color: AppColors.blue200Color)
              : Icon(Icons.remove_shopping_cart_outlined,
                  size: 25, color: AppColors.redColor),
        ),
      );
    }
    return button;
  }

  ///---------------------------------------------------------------------------
  ///products list actions

  void addToCart(SubCategoriesAndProductsModel product) {
    if (product.quantity > 0) {
      productsList.add(product.toShoppingCartModel());
      BotToast.showText(
        text: "تمت الاضافة الى السلة",
        align: Alignment.center,
        textStyle: storeItemsFont(color: AppColors.whiteColor),
      );
      update();
    } else {
      BotToast.showText(
        text: "غير متوفر حالياً",
        align: Alignment.center,
        textStyle: storeItemsFont(color: AppColors.whiteColor),
      );
    }
  }

  void deleteItem(SubCategoriesAndProductsModel product) {
    int index = productsList.indexWhere((element) => element.id == product.id);
    if (index > -1) productsList.removeAt(index);
    BotToast.showText(
      text: "تم الحذف من السلة",
      align: Alignment.center,
      textStyle: storeItemsFont(color: AppColors.whiteColor),
    );
    update();
  }

  void deleteItemInShoppingCart(int index) {
    if (index > -1) productsList.removeAt(index);
    BotToast.showText(
      text: "تم الحذف من السلة",
      align: Alignment.center,
      textStyle: storeItemsFont(color: AppColors.whiteColor),
    );
    Get.back();
    update();
  }

  void increaseProductQuantity(index, {int maxQuantity = 100}) {
    if (getData(index).quantity < maxQuantity) {
      getData(index).quantity++;
      update();
    }
  }

  void decreaseProductQuantity(index, {int min = 1}) {
    if (getData(index).quantity > min) {
      getData(index).quantity--;
      update();
    }
  }

  void emptyShoppingCart() {
    productsList.clear();
    update();
  }

  ///---------------------------------------------------------------------------
  ///Place Order
  OrderParameterModel prepareOderToSend(int addressId,
          {String notes, String coupon}) =>
      OrderParameterModel(
          orderAttributes: [OrderAttribute(key: "وقت التوصيل", value: notes)],
          coupon: coupon,
          notes: null,
          currencyCode: Get.find<StorageService>().getCurrencyInfo().code,
          shippingAddressID: addressId,
          billingAddressID: Get.find<StorageService>().getBillingInfo().id,
          orderItems: productsList
              .map((e) => OrderItems(productID: e.id, quantity: e.quantity))
              .toList());
}
