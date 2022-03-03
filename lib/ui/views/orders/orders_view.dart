import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/genera_widgets.dart';
import 'package:waslcom/ui/shared_widgets/shared_scaffold_widget.dart';
import 'package:waslcom/ui/views/orders/orders_view_controller.dart';
import 'package:waslcom/ui/views/orders/orders_widgets.dart';
import 'package:waslcom/ui/views/payment/payment_view.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/place_holders.dart';
import 'package:waslcom/ui/views/store_views/main_store_view/main_store_view_controller.dart';
import 'package:get/get.dart';

class OrdersView extends StatelessWidget {
  final bool fromPlaceOrder;

  const OrdersView({Key key, this.fromPlaceOrder = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SharedScaffoldWidget.sharedScaffoldWidget(context, size,
          appBar: StoreAppBars.myOrdersViewAppBar(context, size,
              showBack: !fromPlaceOrder),
          navBarEnum: NavBarEnum.OrdersView,
          body: GetBuilder<OrdersViewController>(
              init: OrdersViewController(),
              builder: (controller) => controller.connectionError
                  ? NoConnectionWidget()
                  : controller.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            controller.ordersList.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                    padding: EdgeInsets.only(bottom: 30),
                                    itemCount: controller.ordersList.length,
                                    itemBuilder: (context, index) => OrderCard(
                                      goToPayment: () async {
                                        GeneralWidgets.showModalSheet(context, [
                                          ListTile(
                                            title: Text(
                                              "التسديد نقداً عند الاستلام",
                                              style: TextStyle(
                                                  color: AppColors.blue100Color,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                            onTap: () => controller.cashPayment(
                                                controller.getData(index).id),
                                            leading:
                                                Icon(Icons.monetization_on),
                                          ),
                                          Get.find<MainStoreController>()
                                                      .payment ==
                                                  'true'
                                              ? ListTile(
                                                  title: Text(
                                                    "التسديد عن طريق حساب بنكي",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blue100Color,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  onTap: () async {
                                                    bool result = await Get.to(
                                                        () => PaymentView(
                                                              orderNumber:
                                                                  controller
                                                                      .getData(
                                                                          index)
                                                                      .id,
                                                            ));
                                                    if (result !=
                                                        null) if (result)
                                                      controller.getAllOrders();
                                                  },
                                                  leading: Icon(
                                                      Icons.payment_outlined),
                                                )
                                              : Container()
                                        ]);
                                      },
                                      ordersDto: controller.getData(index),
                                    ),
                                  ))
                                : NoDataWidget(
                                    message:
                                        "لاتوجد طلبيات منفذة من قبلكم حتى الآن",
                                  )
                          ],
                        ))),
    );
  }
}
