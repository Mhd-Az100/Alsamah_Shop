import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/order items/order_items_widget.dart';
import 'package:waslcom/ui/views/orders/orders_view_controller.dart';

import 'order_itemsList_widget.dart';

class OrderItemDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
          onPressed: Get.back,
        ),
        title: Center(
          child: Text(
            Get.find<OrdersViewController>().orderitemdet.value.status ==
                    "Draft"
                ? 'مسودة الفاتورة'
                : 'تفاصيل الفاتورة',
            style: TextStyle(color: AppColors.blackColor, fontSize: 22),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Container(child: OrderItemsWidget())),
          Expanded(child: OrderItemsList())
        ],
      ),
    );
  }
}
