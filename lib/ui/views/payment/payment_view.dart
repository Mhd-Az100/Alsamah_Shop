import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';
import 'package:waslcom/ui/shared_widgets/genera_widgets.dart';
import 'package:waslcom/ui/views/payment/payment_view_controller.dart';
import 'package:waslcom/ui/views/payment/payment_widgets.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/place_holders.dart';

class PaymentView extends StatelessWidget {
  final int orderNumber;

  const PaymentView({Key key, this.orderNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: StoreAppBars.paymentAccountInfo(context, size),
        body: GetBuilder<PaymentViewController>(
            init: PaymentViewController(),
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
                                  itemBuilder: (context, index) => PaymentCard(
                                    onTap: () =>
                                        GeneralWidgets.showModalSheet(context, [
                                      ListTile(
                                        onTap: () =>
                                            controller.saveToClipboard(index),
                                        title: Text("نسخ معلومات الدفع الى الذاكرة"),
                                        leading: Icon(Icons.copy),
                                      ),
                                      ListTile(
                                        onTap: () => controller
                                            .sharePaymentAccountInfo(index),
                                        title: Text(
                                            "اذهب الى تطبيق الدفع فوراً"),
                                        leading: Icon(Icons.share),
                                      ),
                                      if (!GetUtils.isNull(orderNumber))
                                        LinearGradientButton(
                                          borderRaduis: 0,
                                          onTap: () => controller
                                              .uploadFile(orderNumber),
                                          title: "اضغط لارسال فاتورة الطلب",
                                          colorsList:
                                              AppColors.greenButtonColor,
                                        ),
                                      // ListTile(
                                      //   onTap: () {},
                                      //   title: Text(
                                      //       "ارسال الفاتورة لاستكمال الطلب"),
                                      //   leading: Icon(Icons.padding),
                                      // ),
                                    ]),
                                    paymentDto: controller.getData(index),
                                  ),
                                ))
                              : NoDataWidget(
                                  message:
                                      "No orders has been made yet, please make an order to see it in orders history",
                                )
                        ],
                      )));
  }
}
