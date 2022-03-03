import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/models/subcategories_products_model.dart';
import 'package:waslcom/core/network.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/font_styles.dart';
import 'package:waslcom/ui/shared_files/untils.dart';
import 'package:waslcom/ui/shared_widgets/cached_image_widget.dart';
import 'package:waslcom/ui/views/product_details/product_details_controller.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';

class ProductDetailsView extends StatelessWidget {
  final SubCategoriesAndProductsModel product;

  const ProductDetailsView({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: StoreAppBars.productDetailsAppBar(context, size),
      body: SafeArea(
        child: GetBuilder<ProductDetailsController>(
            init: ProductDetailsController(product),
            builder: (controller) => Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: size.height * 0.38,
                              width: size.width,
                              child: SharedCachedNetworkImage
                                  .getCachedNetworkImage(
                                      forProductDetails: true,
                                      imageUrl: NetworkUtils.MEDIA_API +
                                          "${product.imageID}"),
                            ),
                            Container(
                                height: size.height * 0.65,
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.blueAccentColor
                                            .withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 18)
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Flexible(
                                      flex: 6,
                                      child: Container(
                                        width: size.width * 0.85,
                                        child: Text(
                                          product.name
                                              .nullableValue("لا يوجد اسم"),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.cairo(
                                              color: AppColors.blue150Color,
                                              fontWeight: FontWeight.w600,
                                              fontSize: size.longestSide / 30),
                                        ),
                                      ),
                                    ),
                                    if (!GetUtils.isNull(product.description))
                                      Flexible(
                                        flex: 4,
                                        child: InkWell(
                                          onTap: () => DialogsUtils
                                              .showMoreDetailsDialog(
                                                  size: size,
                                                  content: product.description
                                                      .nullableValue(
                                                          "لا يوجد وصف")),
                                          child: Container(
                                            width: size.width * 0.9,
                                            child: Text(
                                              product.description
                                                  .nullableValue("لا يوجد وصف"),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.cairo(
                                                  color: AppColors.blackColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      size.longestSide / 43),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: Divider(
                                        color: AppColors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                    Flexible(
                                        flex: 4,
                                        child: Container(
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "قطعة",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                InkWell(
                                                  onTap: controller
                                                      .decreaseProductQuantity,
                                                  child: SvgPicture.asset(
                                                    "assets/svgs/collapse-01.svg",
                                                    width: size.width * 0.24,
                                                    color: AppColors.grey,
                                                  ),
                                                ),
                                                Flexible(
                                                    child: Container(
                                                  height: size.height * 0.1,
                                                  child: Text(
                                                    (controller.itemQuantity %
                                                            12)
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: storeItemsFont(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            size.longestSide /
                                                                20,
                                                        color: AppColors
                                                            .blackColor),
                                                  ),
                                                )),
                                                InkWell(
                                                  onTap: () => controller
                                                      .increaseProductQuantity(
                                                          maxQuantity: product
                                                                  ?.quantity ??
                                                              100),
                                                  child: SvgPicture.asset(
                                                    "assets/svgs/expand-2.svg",
                                                    width: size.width * 0.24,
                                                    color:
                                                        AppColors.orangeColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            width: size.width * 0.8,
                                          ),
                                        )),
                                    Flexible(
                                        flex: 4,
                                        child: Container(
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "دزينة   ",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                InkWell(
                                                  onTap: controller
                                                      .decreaseDozenProductQuantity,
                                                  child: SvgPicture.asset(
                                                    "assets/svgs/collapse-01.svg",
                                                    width: size.width * 0.24,
                                                    color: AppColors.grey,
                                                  ),
                                                ),
                                                Flexible(
                                                    child: Container(
                                                  height: size.height * 0.1,
                                                  child: Text(
                                                    (controller.itemQuantity /
                                                            12)
                                                        .floor()
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: storeItemsFont(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            size.longestSide /
                                                                20,
                                                        color: AppColors
                                                            .blackColor),
                                                  ),
                                                )),
                                                InkWell(
                                                  onTap: () => controller
                                                      .increaseDozenProductQuantity(
                                                          maxQuantity: product
                                                                  ?.quantity ??
                                                              100),
                                                  child: SvgPicture.asset(
                                                    "assets/svgs/expand-2.svg",
                                                    width: size.width * 0.24,
                                                    color:
                                                        AppColors.orangeColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            width: size.width * 0.8,
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      child: Divider(
                                        color: AppColors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                                child: Text.rich(
                                                    TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "${Get.find<StorageService>().getCurrencyInfo().code} ",
                                                  style: GoogleFonts.cairo(
                                                      color: AppColors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          size.longestSide /
                                                              70)),
                                              TextSpan(
                                                  text: "سعر الوحدة",
                                                  style: GoogleFonts.cairo(
                                                      fontSize:
                                                          size.longestSide /
                                                              55)),
                                              TextSpan(
                                                  text: " : ",
                                                  style: GoogleFonts.cairo(
                                                      fontSize:
                                                          size.longestSide /
                                                              40)),
                                              TextSpan(
                                                  text: GeneralUtils
                                                          .getStorageService
                                                          .isCompleteLoginAccount
                                                      ? product.price
                                                              ?.toStringAsFixed(
                                                                  1) ??
                                                          "0"
                                                      : '',
                                                  style: GoogleFonts.cairo(
                                                      color:
                                                          AppColors.greenColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          size.longestSide /
                                                              40)),
                                            ]))),
                                          ),
                                          Expanded(child: Container()),
                                          Flexible(
                                            flex: 4,
                                            child: Container(
                                                child: Text.rich(
                                              TextSpan(children: [
                                                TextSpan(
                                                    text: "الوحدة",
                                                    style: GoogleFonts.cairo(
                                                        fontSize:
                                                            size.longestSide /
                                                                45)),
                                                TextSpan(
                                                    text: " : ",
                                                    style: GoogleFonts.cairo(
                                                        fontSize:
                                                            size.longestSide /
                                                                40)),
                                                TextSpan(
                                                    text: product.unit
                                                        .nullableValue("قطعة"),
                                                    style: GoogleFonts.cairo(
                                                        color: AppColors
                                                            .greenColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            size.longestSide /
                                                                40))
                                              ]),
                                              maxLines: 1,
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_showOldPrice())
                                      Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text:
                                                "${Get.find<StorageService>().getCurrencyInfo().code} ",
                                            style: GoogleFonts.cairo(
                                                color: AppColors.blueGrey,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    size.longestSide / 70)),
                                        TextSpan(
                                            text: "قبل الحسم".tr,
                                            style: GoogleFonts.cairo(
                                                fontSize:
                                                    size.longestSide / 40)),
                                        TextSpan(
                                            text: " : ",
                                            style: GoogleFonts.cairo(
                                                fontSize:
                                                    size.longestSide / 40)),
                                        TextSpan(
                                            text: GeneralUtils.getStorageService
                                                    .isCompleteLoginAccount
                                                ? (product.oldPrice *
                                                            controller
                                                                .itemQuantity)
                                                        .toStringAsFixed(1) ??
                                                    "0"
                                                : '',
                                            style: GoogleFonts.cairo(
                                                color: AppColors.redColor,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    size.longestSide / 30)),
                                      ])),
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text:
                                              "${Get.find<StorageService>().getCurrencyInfo().code} ",
                                          style: GoogleFonts.cairo(
                                              color: AppColors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.longestSide / 70)),
                                      TextSpan(
                                          text: "السعر الكلي".tr,
                                          style: GoogleFonts.cairo(
                                              fontSize: size.longestSide / 40)),
                                      TextSpan(
                                          text: " : ",
                                          style: GoogleFonts.cairo(
                                              fontSize: size.longestSide / 40)),
                                      TextSpan(
                                          text: GeneralUtils.getStorageService
                                                  .isCompleteLoginAccount
                                              ? controller?.totalItemPrice
                                                      ?.toStringAsFixed(1) ??
                                                  "0"
                                              : '',
                                          style: GoogleFonts.cairo(
                                              color: AppColors.blueAccentColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.longestSide / 30)),
                                    ])),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: controller.addToCartButton(),
                      ),
                    )
                  ],
                )),
      ),
    );
  }

  bool _showOldPrice() {
    return product?.oldPrice != null && product?.oldPrice?.toInt() != 0;
  }
}
