import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/models/subcategories_products_model.dart'
    as productModel;
import 'package:waslcom/core/network.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/untils.dart';
import 'package:waslcom/ui/shared_widgets/cached_image_widget.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';
import 'package:waslcom/core/utils/general_utils.dart';

class StoreItem extends StatelessWidget {
  final String name;
  final String imageId;
  final Function onTap;
  final Function addToCart;
  final bool isProduct;
  final int id;
  final productModel.SubCategoriesAndProductsModel product;

  StoreItem(
      {Key key,
      this.name,
      this.onTap,
      this.imageId,
      this.addToCart,
      this.isProduct = false,
      this.id,
      this.product})
      : super(key: key);

  final ShoppingCartController shoppingCartController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
          onTap: onTap,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5.0,
                        spreadRadius: 1.0)
                  ]),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: SharedCachedNetworkImage
                                  .getCachedNetworkImage(
                                      imageUrl:
                                          NetworkUtils.MEDIA_API + "$imageId"),
                            ),
                          ),
                        ),
                        (isProduct)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Container(
                                          child: Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: "Price".tr,
                                            style: GoogleFonts.cairo(
                                                fontSize:
                                                    size.longestSide / 50)),
                                        TextSpan(
                                            text: " : ",
                                            style: GoogleFonts.cairo(
                                                fontSize:
                                                    size.longestSide / 50)),
                                        TextSpan(
                                            text: GeneralUtils.getStorageService
                                                    .isCompleteLoginAccount
                                                ? product.price
                                                    .toStringAsFixed(1)
                                                    .nullableValue("0")
                                                : '',
                                            style: GoogleFonts.cairo(
                                                color: AppColors.greenColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    size.longestSide / 50)),
                                        TextSpan(
                                            text:
                                                " ${Get.find<StorageService>().getCurrencyInfo().code}",
                                            style: GoogleFonts.cairo(
                                                color: AppColors.blueGrey,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    size.longestSide / 70))
                                      ]))),
                                    ),
                                  ],
                                ))
                            : SizedBox(
                                height: size.height * 0.01,
                              ),
                        if (_showOldPrice())
                          Padding(
                              padding: const EdgeInsets.only(bottom: 1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Container(
                                        child: Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text: GeneralUtils.getStorageService
                                                  .isCompleteLoginAccount
                                              ? product.oldPrice
                                                  .toStringAsFixed(1)
                                                  .nullableValue("0")
                                              : '',
                                          style: GoogleFonts.cairo(
                                              color: AppColors.redColor,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.longestSide / 50)),
                                      TextSpan(
                                          text:
                                              " ${Get.find<StorageService>().getCurrencyInfo().code}",
                                          style: GoogleFonts.cairo(
                                              color: AppColors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.longestSide / 70))
                                    ]))),
                                  ),
                                ],
                              )),
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                                color: AppColors.blueGrey.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: AutoSizeText(
                              name ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                  fontSize: size.shortestSide / 25,
                                  color: AppColors.blue300Color,
                                  fontWeight: FontWeight.w800),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (isProduct)
                    GetBuilder<ShoppingCartController>(
                      init: shoppingCartController,
                      builder: (controller) => Align(
                          alignment: Alignment.topRight,
                          child:
                              shoppingCartController.addToCartButton(product)),
                    ),
                ],
              ))),
    );
  }

  bool _showOldPrice() {
    return isProduct &&
        product?.oldPrice != null &&
        product?.oldPrice?.toInt() != 0;
  }
}
