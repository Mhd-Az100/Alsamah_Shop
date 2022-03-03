import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/repos/orders_repo.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/orders/orders_view.dart';
import 'package:waslcom/ui/views/orders/orders_view_controller.dart';

class OrderItemsWidget extends StatefulWidget {
  OrderItemsWidget({Key key}) : super(key: key);

  @override
  _OrderItemsWidgetState createState() => _OrderItemsWidgetState();
}

class _OrderItemsWidgetState extends State<OrderItemsWidget> {
  OrdersViewController ctrl = Get.find<OrdersViewController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(
      () => ctrl.orderitemdet == null
          ? Container()
          : Container(
              child: Column(
                children: [
                  Container(
                    width: size.width,
                    margin:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 14.5),
                    padding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 18.5),
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.blueAccentColor.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 18),
                        ],
                        borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '${ctrl.orderitemdet.value.id.toString()}  رقم ',
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.w600,
                                    fontSize: size.longestSide / 45),
                              ),
                            ),
                            Text(
                              "الفاتورة",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.cairo(
                                  color: AppColors.blackColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.longestSide / 43),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColors.grey.withOpacity(0.2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${ctrl.orderitemdet.value.fees.toString()}',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.longestSide / 43),
                            ),
                            Text(
                              "الرسوم",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.cairo(
                                  color: AppColors.redColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.longestSide / 43),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${ctrl.orderitemdet.value.tax.toString()}',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.w600,
                                      fontSize: size.longestSide / 43),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "الضريبة",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.cairo(
                                      color: AppColors.redColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: size.longestSide / 43),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${ctrl.orderitemdet.value.deliveryFees.toStringAsFixed(2)}',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.longestSide / 43),
                            ),
                            Text(
                              "تكاليف توصيل",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.cairo(
                                  color: AppColors.redColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.longestSide / 43),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (ctrl.orderitemdet.value.dateTime)
                                  .toString()
                                  .substring(
                                      0,
                                      ctrl.orderitemdet.value.dateTime
                                                  .toString()
                                                  .indexOf("T") >
                                              -1
                                          ? ctrl.orderitemdet.value.dateTime
                                              .toString()
                                              .indexOf("T")
                                          : 10),
                              textAlign: TextAlign.left,
                              style: GoogleFonts.cairo(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.longestSide / 43),
                            ),
                            Text(
                              "تاريخ الطلب",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.cairo(
                                  color: AppColors.blackColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.longestSide / 43),
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       '${ctrl.orderitemdet.value.billingAddressId.toString()}',
                        //       textAlign: TextAlign.left,
                        //       style: GoogleFonts.cairo(
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: size.longestSide / 43),
                        //     ),
                        //     Text(
                        //       "مكان دفع الفاتورة",
                        //       textAlign: TextAlign.right,
                        //       style: GoogleFonts.cairo(
                        //           color:
                        //               AppColors.blackColor.withOpacity(0.5),
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: size.longestSide / 43),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       '${ctrl.orderitemdet.value.shippingAddressId.toString()}',
                        //       textAlign: TextAlign.left,
                        //       style: GoogleFonts.cairo(
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: size.longestSide / 43),
                        //     ),
                        //     Text(
                        //       "مكان توصيل الفاتورة",
                        //       textAlign: TextAlign.right,
                        //       style: GoogleFonts.cairo(
                        //           color:
                        //               AppColors.blackColor.withOpacity(0.5),
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: size.longestSide / 43),
                        //     ),
                        //   ],
                        // ),
                        Divider(
                          color: AppColors.grey.withOpacity(0.1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${ctrl.orderitemdet.value.totalPrice.toStringAsFixed(2)}  ${Get.find<StorageService>().getCurrencyInfo().symbol}',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.longestSide / 43),
                            ),
                            Text(
                              "الإجمالي",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.cairo(
                                  color: AppColors.redColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.longestSide / 43),
                            ),
                          ],
                        ),
                        ctrl.orderitemdet.value.status == 'Draft'
                            ? Column(
                                children: [
                                  Divider(
                                    color: AppColors.grey.withOpacity(0.1),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      RaisedButton(
                                        onPressed: () async {
                                          await OrderRepository.confirmOrder(
                                              ctrl.orderitemdet.value.id
                                                  .toString(),
                                              false);
                                          Get.find<OrdersViewController>()
                                              .getAllOrders();
                                          Get.off(OrdersView());
                                        },
                                        child: Text(
                                          'رفض الطلب  ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.redAccent,
                                      ),
                                      RaisedButton(
                                        onPressed: () async {
                                          await OrderRepository.confirmOrder(
                                              ctrl.orderitemdet.value.id
                                                  .toString(),
                                              true);
                                          Get.find<OrdersViewController>()
                                              .getAllOrders();
                                          Get.off(OrdersView());
                                        },
                                        child: Text(
                                          'قبول الطلب  ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
