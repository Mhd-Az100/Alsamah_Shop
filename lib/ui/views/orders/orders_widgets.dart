import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/data_sets.dart';
import 'package:waslcom/core/models/orders_model.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/order%20items/order_items_view.dart';
import 'package:waslcom/ui/views/orders/orders_view_controller.dart';

class OrderCard extends StatelessWidget {
  final OrdersDto ordersDto;
  final Function goToPayment;

  OrderCard({Key key, this.ordersDto, this.goToPayment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      margin: EdgeInsets.symmetric(vertical: 14, horizontal: 14.5),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 18.5),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [getShadow(ordersDto)],
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  ordersDto.status.getArabicStatus(),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.cairo(
                      color: getColor(ordersDto),
                      fontWeight: FontWeight.w600,
                      fontSize: size.longestSide / 45),
                ),
              ),
              Text(
                "حالة الطلب",
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
                ordersDto.id.getFakeOrderNumber(),
                textAlign: TextAlign.left,
                style: GoogleFonts.cairo(
                    color: getColor(ordersDto),
                    fontWeight: FontWeight.w600,
                    fontSize: size.longestSide / 43),
              ),
              Text(
                ".رقم الطلب",
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(
                    color: AppColors.blackColor.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: size.longestSide / 43),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (ordersDto.dateTime).substring(
                    0,
                    ordersDto.dateTime.indexOf("T") > -1
                        ? ordersDto.dateTime.indexOf("T")
                        : 10),
                textAlign: TextAlign.left,
                style: GoogleFonts.cairo(
                    color: getColor(ordersDto),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (ordersDto.deliveryFees)?.toStringAsFixed(2) ?? "0.0",
                textAlign: TextAlign.left,
                style: GoogleFonts.cairo(
                    color: getColor(ordersDto),
                    fontWeight: FontWeight.w600,
                    fontSize: size.longestSide / 43),
              ),
              Text(
                "تكاليف توصيل",
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(
                    color: AppColors.blackColor.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: size.longestSide / 43),
              ),
            ],
          ),
          Divider(
            color: AppColors.grey.withOpacity(0.1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ("${double.parse(ordersDto.totalPrice).toStringAsFixed(2) ?? "0.0"}") +
                    " ${Get.find<StorageService>().getCurrencyInfo().symbol}",
                textAlign: TextAlign.left,
                style: GoogleFonts.cairo(
                    color: getColor(ordersDto),
                    fontWeight: FontWeight.w600,
                    fontSize: size.longestSide / 43),
              ),
              Text(
                "الإجمالي",
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(
                    color: AppColors.blackColor.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: size.longestSide / 43),
              ),
              GestureDetector(
                onTap: () async {
                  Get.dialog(
                    AlertDialog(
                      actionsPadding: EdgeInsets.symmetric(horizontal: 120),
                      title: Text("الرجاء الانتظار..",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.blueAccentColor, fontSize: 22)),
                      actions: [
                        CircularProgressIndicator(),
                      ],
                    ),
                    // barrierDismissible: false,
                  );
                  await Get.find<OrdersViewController>().getOrderitems(
                      ordersDto.id.getFakeOrderNumber().toString());
                  Get.off(OrderItemDetails());
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 1)],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.receipt),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "عرض الفاتورة",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(
                            color: AppColors.blue100Color.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (ordersDto.status == OrderStatus.WaitingForPayment) ...[
            Divider(
              color: AppColors.grey.withOpacity(0.1),
            ),
            FlatButton.icon(
                onPressed: goToPayment,
                icon: Icon(Icons.payment_outlined),
                label: Text(
                  "إضغط لإجراء عملية الدفع",
                  style: TextStyle(
                      color: AppColors.orangeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ],
      ),
    );
  }

  BoxShadow getShadow(OrdersDto ordersDto) {
    switch (ordersDto.status) {
      case OrderStatus.Pending:
        {
          return BoxShadow(
              color: AppColors.orangeColor.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 18);
        }
        break;
      case OrderStatus.Packaging:
        {
          return BoxShadow(
              color: AppColors.blueAccentColor.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 18);
        }
        break;
      case OrderStatus.Delivering:
        {
          return BoxShadow(
              color: AppColors.darkGreenColor.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 18);
        }
        break;
      case OrderStatus.Done:
        {
          return BoxShadow(
              color: AppColors.greenColor.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 18);
        }
        break;
      case OrderStatus.Canceled:
        {
          return BoxShadow(
              color: AppColors.redColor.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 18);
        }
        break;
      default:
        return BoxShadow(
            color: AppColors.blueGrey.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 18);
    }
  }

  Color getColor(OrdersDto ordersDto) {
    switch (ordersDto.status) {
      case OrderStatus.Pending:
        {
          return AppColors.orangeColor;
        }
        break;
      case OrderStatus.Packaging:
        {
          return AppColors.blueAccentColor;
        }
        break;
      case OrderStatus.Delivering:
        {
          return AppColors.darkGreenColor;
        }
        break;
      case OrderStatus.Done:
        {
          return AppColors.greenColor;
        }
        break;
      case OrderStatus.Canceled:
        {
          return AppColors.redColor;
        }
        break;
      default:
        return AppColors.blueGrey;
    }
  }
}
