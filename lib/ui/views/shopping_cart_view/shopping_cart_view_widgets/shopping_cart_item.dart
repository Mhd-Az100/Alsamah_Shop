import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/models/shopping_cart_model.dart';
import 'package:waslcom/core/network.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/font_styles.dart';
import 'package:waslcom/ui/shared_files/untils.dart';
import 'package:waslcom/ui/shared_widgets/cached_image_widget.dart';

class ShoppingCartItem extends StatelessWidget {
  final ShoppingCartModel product;
  final Function increment;
  final Function decrement;
  final Function onTap;
  final Function menuTap;

  const ShoppingCartItem(
      {Key key,
      this.product,
      this.increment,
      this.decrement,
      this.onTap,
      this.menuTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.5),
        decoration: BoxDecoration(
            color: Color(0xFFF5F4F4),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: AppColors.blueAccentColor.withOpacity(0.2),
                  offset: Offset(0, 11),
                  blurRadius: 18)
            ]),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 14.5, horizontal: 14.5),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.blackColor.withOpacity(0.2),
                          offset: Offset(0, 1),
                          blurRadius: 10)
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            "اسم المنتج".tr,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(
                              color: AppColors.blackColor,
                              fontSize: size.longestSide / 50,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              product?.name ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                  color: AppColors.blueAccentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.longestSide / 55),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: menuTap,
                          child: SvgPicture.asset(
                            "assets/svgs/menu.svg",
                            width: size.width * 0.08,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: size.height * 0.02,
                      thickness: 0.5,
                      color: AppColors.grey.withOpacity(0.1),
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              height: size.height * 0.1,
                              child: SharedCachedNetworkImage
                                  .getCachedNetworkImage(
                                      imageUrl: NetworkUtils.MEDIA_API +
                                          "${product.imageID}"),
                            )),
                        SizedBox(
                          width: size.width * 0.08,
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: onTap,
                                        child: SvgPicture.asset(
                                          "assets/svgs/collapse-01.svg",
                                          width: size.width * 0.2,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                      Flexible(
                                          child: Text(
                                        product.quantity.toString(),
                                        style: storeItemsFont(
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.longestSide / 30,
                                            color: AppColors.blueAccentColor),
                                      )),
                                      InkWell(
                                        onTap: onTap,
                                        child: SvgPicture.asset(
                                          "assets/svgs/expand-2.svg",
                                          width: size.width * 0.2,
                                          color: AppColors.orangeColor,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                    // Divider(
                    //   height: size.height * 0.02,
                    //   thickness: 0.5,
                    //   color: AppColors.grey.withOpacity(0.1),
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                            child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "الوحدة".tr,
                              style: GoogleFonts.cairo(
                                  fontSize: size.longestSide / 45)),
                          TextSpan(
                              text: " : ",
                              style: GoogleFonts.cairo(
                                  fontSize: size.longestSide / 40)),
                          TextSpan(
                              text: product.unit.nullableValue("قطعة"),
                              style: GoogleFonts.cairo(
                                  color: AppColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.longestSide / 40)),
                        ]))),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          product.totalProductPrice
                                  .toStringAsFixed(1)
                                  .nullableValue("0") +
                              " ${Get.find<StorageService>().getCurrencyInfo().code}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                              color: AppColors.blueColor,
                              fontWeight: FontWeight.bold,
                              fontSize: size.longestSide / 50),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                            child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "كمية اجمالية",
                              style: GoogleFonts.cairo(
                                  fontSize: size.longestSide / 45)),
                          TextSpan(
                              text: " : ",
                              style: GoogleFonts.cairo(
                                  fontSize: size.longestSide / 40)),
                          TextSpan(
                              text: product.quantity.toString(),
                              style: GoogleFonts.cairo(
                                  color: AppColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.longestSide / 40))
                        ]))),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                            child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "قطعة",
                              style: GoogleFonts.cairo(
                                  fontSize: size.longestSide / 45)),
                          TextSpan(
                              text: " : ",
                              style: GoogleFonts.cairo(
                                  fontSize: size.longestSide / 40)),
                          TextSpan(
                              text: '${(product.quantity) % 12}',
                              style: GoogleFonts.cairo(
                                  color: AppColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.longestSide / 40))
                        ]))),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                            child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "دزينة",
                              style: GoogleFonts.cairo(
                                  fontSize: size.longestSide / 45)),
                          TextSpan(
                              text: " : ",
                              style: GoogleFonts.cairo(
                                  fontSize: size.longestSide / 40)),
                          TextSpan(
                              text: '${((product.quantity) / 12).floor()}',
                              style: GoogleFonts.cairo(
                                  color: AppColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.longestSide / 40))
                        ]))),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
