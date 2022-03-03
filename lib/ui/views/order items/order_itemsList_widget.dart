import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/network.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/cached_image_widget.dart';
import 'package:waslcom/ui/views/orders/orders_view_controller.dart';

class OrderItemsList extends StatelessWidget {
  OrderItemsList({Key key}) : super(key: key);
  OrdersViewController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(
      () => ctrl.orderitemdet.value.orderItems.isEmpty
          ? Container()
          : GridView.builder(
              itemCount: ctrl.orderitemdet.value.orderItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.8,
                  crossAxisCount: 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.5, horizontal: 14.5),
                    margin: EdgeInsets.symmetric(vertical: 8.5, horizontal: 20),
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.blueAccentColor.withOpacity(0.2),
                              offset: Offset(0, 11),
                              blurRadius: 18)
                        ]),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '${ctrl.orderitemdet.value.orderItems[index].id}',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cairo(
                                    color: AppColors.blueAccentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.longestSide / 55),
                              ),
                            ),
                            Text(
                              "رقم المنتج".tr,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                color: AppColors.blackColor,
                                fontSize: size.longestSide / 50,
                                fontWeight: FontWeight.w600,
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
                                              "${ctrl.orderitemdet.value.orderItems[index].product.imageId}"),
                                )),
                            SizedBox(
                              width: size.width * 0.08,
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        '${ctrl.orderitemdet.value.orderItems[index].product.name}',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.cairo(
                                            color: AppColors.blueAccentColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.longestSide / 55),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " : اسم المنتج".tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.cairo(
                                        color: AppColors.blackColor,
                                        fontSize: size.longestSide / 50,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: "الكمية".tr,
                                  style: GoogleFonts.cairo(
                                      fontSize: size.longestSide / 45)),
                              TextSpan(
                                  text: " : ",
                                  style: GoogleFonts.cairo(
                                      fontSize: size.longestSide / 40)),
                              TextSpan(
                                  text:
                                      '${ctrl.orderitemdet.value.orderItems[index].quantity}',
                                  style: GoogleFonts.cairo(
                                      color: AppColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.longestSide / 40))
                            ]))),
                            Container(
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
                                  text:
                                      '${ctrl.orderitemdet.value.orderItems[index].product.unit}',
                                  style: GoogleFonts.cairo(
                                      color: AppColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.longestSide / 40)),
                            ]))),
                            Container(
                                child: Text.rich(TextSpan(children: [
                              TextSpan(
                                  text:
                                      '${ctrl.orderitemdet.value.orderItems[index].price}',
                                  style: GoogleFonts.cairo(
                                      color: AppColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.longestSide / 40)),
                              TextSpan(
                                  text: " : ",
                                  style: GoogleFonts.cairo(
                                      fontSize: size.longestSide / 40)),
                              TextSpan(
                                  text: "السعر".tr,
                                  style: GoogleFonts.cairo(
                                      fontSize: size.longestSide / 45)),
                            ]))),
                            Text(
                              "",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                  color: AppColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.longestSide / 50),
                            ),
                          ],
                        ),
                      ],
                    ));
              }),
    );
  }
}
