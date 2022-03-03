import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/address_cart_widget.dart';
import 'package:waslcom/ui/shared_widgets/genera_widgets.dart';
import 'package:waslcom/ui/views/profile_view/widgets/profile_widgets.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/place_holders.dart';

import 'address_view_controller.dart';

class MyAddressView extends StatelessWidget {
  final bool fromShoppingCart;

  const MyAddressView({Key key, this.fromShoppingCart = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: StoreAppBars.myAddressViewAppBar(context, size),
      body: GetBuilder<MyAddressController>(
        init: MyAddressController(),
        builder: (controller) => controller.connectionError
            ? NoConnectionWidget()
            : controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      if (controller.addressList.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 30),
                            itemCount: controller.addressList.length + 1,
                            itemBuilder: (context, index) => index ==
                                    controller.addressList.length
                                ? AddNewAddressWidget(
                                    onTap: controller.addNewAddress,
                                  )
                                : GestureDetector(
                                    onTap: () =>
                                        GeneralWidgets.showModalSheet(context, [
                                      if (fromShoppingCart)
                                        ListTile(
                                            leading: Icon(
                                              Icons.send_sharp,
                                              color: AppColors.grey500Color,
                                            ),
                                            title: Text(
                                                "ارسال الطلب الى هذا العنوان"),
                                            onTap: () {
                                              controller.showSendOrderDialog(
                                                  context,
                                                  index: index);
                                            }),
                                      ListTile(
                                          leading: Icon(
                                            Icons.delete,
                                            color: AppColors.redColor,
                                          ),
                                          title: Text("حذف هذا العنوان"),
                                          onTap: () {
                                            Get.back();
                                            controller.deleteAddress(controller
                                                .addressList[index].id);
                                          })
                                    ]),
                                    child: AddressCartWidget(
                                      addressDto: controller.addressList[index],
                                    ),
                                  ),
                          ),
                        )
                      else
                        NoDataWidget(
                          message:
                              "لا توجد عناوين استلام بعد، يرجى اضافة عنوان",
                          onTapTitle: "اضافة عنوان",
                          onTap: controller.addNewAddress,
                        )
                    ],
                  ),
      ),
    );
  }
}
