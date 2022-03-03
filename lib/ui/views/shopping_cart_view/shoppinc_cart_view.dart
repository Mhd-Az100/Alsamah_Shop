import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';
import 'package:waslcom/ui/shared_widgets/genera_widgets.dart';
import 'package:waslcom/ui/shared_widgets/shared_scaffold_widget.dart';
import 'package:waslcom/ui/views/address_view/address_view.dart';
import 'package:waslcom/ui/views/address_view/address_view_controller.dart';
import 'package:waslcom/ui/views/product_details/product_details_view.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_widgets/shopping_cart_item.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/place_holders.dart';

class ShoppingCartView extends StatelessWidget {
  MyAddressController ctrl = Get.find<MyAddressController>();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SharedScaffoldWidget.sharedScaffoldWidget(context, size,
        navBarEnum: NavBarEnum.ShoppingCartView,
        appBar: StoreAppBars.shoppingCartAppBar(context, size),
        body: GetBuilder<ShoppingCartController>(
            init: ShoppingCartController(),
            builder: (controller) => (controller.productsList.isNotEmpty)
                ? Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(25.0),
                                  bottomLeft: Radius.circular(25.0)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 18,
                                    spreadRadius: 1,
                                    color: AppColors.grey.withOpacity(0.2))
                              ],
                              color: AppColors.whiteColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 14.5),
                                  child: Container(
                                      child: Text.rich(TextSpan(children: [
                                    TextSpan(
                                        text: "Total cost".tr,
                                        style: GoogleFonts.cairo(
                                            fontSize: size.longestSide / 40)),
                                    TextSpan(
                                        text: " : ",
                                        style: GoogleFonts.cairo(
                                            fontSize: size.longestSide / 40)),
                                    TextSpan(
                                        text: GeneralUtils.getStorageService
                                                .isCompleteLoginAccount
                                            ? controller
                                                .getTotalCost()
                                                .toStringAsFixed(1)
                                            : '',
                                        style: GoogleFonts.cairo(
                                            color: AppColors.greenColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.longestSide / 40)),
                                    TextSpan(
                                        text:
                                            " ${Get.find<StorageService>().getCurrencyInfo().code}",
                                        style: GoogleFonts.cairo(
                                            color: AppColors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.longestSide / 70))
                                  ]))),
                                ),
                                flex: 3,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                      child: PlaceOrderGradientButton(
                                    title: "إرسال",
                                    onTap: () => GeneralUtils.getStorageService
                                            .isCompleteLoginAccount
                                        ? GeneralWidgets.showModalSheet(
                                            context, [
                                            Get.find<StorageService>()
                                                        .getBillingInfo()
                                                        .id ==
                                                    null
                                                ? Container()
                                                : ListTile(
                                                    leading:
                                                        Icon(Icons.menu_book),
                                                    title: Text(
                                                        "اختيار من عناوين سابقة"
                                                            .tr),
                                                    onTap: () {
                                                      ctrl.checkDeliveryTime();
                                                      Navigator.of(context)
                                                          .pop();
                                                      Get.off(
                                                          () => MyAddressView(
                                                                fromShoppingCart:
                                                                    true,
                                                              ));
                                                    },
                                                  ),
                                            ListTile(
                                              onTap: () {
                                                ctrl.checkDeliveryTime();

                                                Get.off(() => MyAddressView(
                                                      fromShoppingCart: true,
                                                    ));
                                                Navigator.of(context).pop();
                                                // Get.off(() =>
                                                //     PlaceOrderOnMapView());
                                                ctrl.addNewAddress();
                                              },
                                              leading: Icon(Icons.location_on),
                                              title: Text(
                                                  "توصيل الى عنوان جديد".tr),
                                            ),
                                          ])
                                        : DialogsUtils.showGuestLogInDialog(),
                                  )))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          itemBuilder: (context, index) => ShoppingCartItem(
                              product: controller.getData(index),
                              decrement: () =>
                                  controller.decreaseProductQuantity(index),
                              increment: () =>
                                  controller.increaseProductQuantity(index),
                              menuTap: () =>
                                  GeneralWidgets.showModalSheet(context, [
                                    ListTile(
                                      leading: Icon(
                                        Icons.delete,
                                        color: AppColors.redColor,
                                      ),
                                      title: Text('حذف من السلة'.tr),
                                      onTap: () => controller
                                          .deleteItemInShoppingCart(index),
                                    ),
                                  ]),
                              onTap: () {
                                // Get.find<ProductDetailsController>()
                                //     .getproductAttributes(
                                //   controller
                                //       .getData(index)
                                //       .originalProductModel
                                //       .productAttributes,
                                // );
                                Get.to(
                                  () => ProductDetailsView(
                                    product: controller
                                        .getData(index)
                                        .originalProductModel,
                                  ),
                                );
                              }),
                          itemCount: controller.productsList.length,
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: NoDataGeneralWidget(
                      onTap: () => Get.back(),
                      icon: Icons.shopping_cart_outlined,
                      message: "السلة فارغة، لا توجد أي عناصر للعرض",
                    ),
                  )));
  }
}
