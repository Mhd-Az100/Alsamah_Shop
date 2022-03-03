import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/models/subcategories_products_model.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/font_styles.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';

class ProductDetailsController extends GetxController {
  final SubCategoriesAndProductsModel item;

  ProductDetailsController(this.item);

  ///---------------------------------------------------------------------------
  ShoppingCartController shoppingCartController = Get.find();

  ///---------------------------------------------------------------------------

  ///---------------------------------------------------------------------------

  double get totalItemPrice => _quantity * item.price;

  int _quantity = 0;

  int get itemQuantity => _quantity;

  void itemQuantitySet(int value) {
    _quantity = value;
    update();
  }

  ///---------------------------------------------------------------------------
  void increaseProductQuantity({int maxQuantity = 100}) {
    if (itemQuantity < maxQuantity) {
      _quantity++;
      update();
    } else
      BotToast.showText(
          text: "لقد وصلت للحد الأعلى للطلب بالنسبة لهذا العنصر",
          align: Alignment.center);
  }

  void decreaseProductQuantity({int min = 1}) {
    if (itemQuantity > min) {
      _quantity--;
      update();
    }
  }

  void increaseDozenProductQuantity({int maxQuantity = 100}) {
    if (_quantity < maxQuantity) {
      _quantity += 12;
      update();
    } else
      BotToast.showText(
          text: "لقد وصلت للحد الأعلى للطلب بالنسبة لهذا العنصر",
          align: Alignment.center);
  }

  void decreaseDozenProductQuantity({int min = 1}) {
    if (_quantity > min && (itemQuantity - 12 > 0)) {
      _quantity -= 12;
      update();
    }
  }

  void addToCart() {
    if (_quantity == 0) {
      BotToast.showText(
          text: "الرجاء تحديد الكمية",
          align: Alignment.center,
          textStyle: storeItemsFont(color: AppColors.whiteColor));
    } else {
      int index = shoppingCartController.productsList
          .indexWhere((element) => element.id == item.id);
      if (index > -1) {
        shoppingCartController.productsList[index] =
            item.toShoppingCartModel(newQty: _quantity);
        BotToast.showText(
          text: "تم تعديل العنصر في السلة",
          align: Alignment.center,
          textStyle: storeItemsFont(color: AppColors.whiteColor),
        );
      } else {
        shoppingCartController.productsList
            .add(item.toShoppingCartModel(newQty: _quantity));
        BotToast.showText(
          text: "تمت الاضافة الى السلة",
          align: Alignment.center,
          textStyle: storeItemsFont(color: AppColors.whiteColor),
        );
      }

      shoppingCartController.update();
      Get.back();
    }
  }

  ///---------------------------------------------------------------------------
  ///Set the add to cart button
  Widget addToCartButton() {
    Widget widget;
    if (item.quantity > 0) {
      if (shoppingCartController.productsList
          .any((element) => element.id == item.id)) {
        widget = FractionallySizedBox(
          widthFactor: 0.9,
          child: LinearGradientButton(
            onTap: addToCart,
            title: "تعديل العنصر".tr,
            colorsList: AppColors.editButton,
          ),
        );
      } else {
        widget = FractionallySizedBox(
          widthFactor: 0.9,
          child: LinearGradientButton(
            onTap: addToCart,
            title: "اضافة الى السلة".tr,
            colorsList: AppColors.blueButtonColor,
          ),
        );
      }
    } else {
      widget = FractionallySizedBox(
        widthFactor: 0.9,
        child: LinearGradientButton(
          onTap: () => Get.back(),
          title: "غير متوفر حالياً".tr,
          colorsList: AppColors.productDetailsColors,
        ),
      );
    }

    return widget;
  }

  ///---------------------------------------------------------------------------
  ///Set the item quantity
  void setTheItemQuantity() {
    if (shoppingCartController.productsList.isNotEmpty) {
      int index = shoppingCartController.productsList
          .indexWhere((element) => element.id == item.id);
      if (index > -1) {
        _quantity = shoppingCartController.productsList[index].quantity;
      }
    }
  }

  ///---------------------------------------------------------------------------
  ///Set count keys
  @override
  void onInit() {
    setTheItemQuantity();
    super.onInit();
  }

  //================================================================================
  // get product attribute
  // Map<int, String> productAttributes;
  // void getproductAttributes(
  //     List<ProductAttribute> productAttributesKeys) async {
  //   var productAttributesList = await StoreRepository.getProductAttribbute();

  //   for (GlobalProductAttribute item in productAttributesList) {
  //     if (productAttributesKeys.contains(item.id)) {
  //       productAttributes[item.id] = item.name;
  //     }
  //   }
  // }
}
