import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/orders/orders_view.dart';
import 'package:waslcom/ui/views/profile_view/profile_view.dart';
import 'package:waslcom/ui/views/search/search_view.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shoppinc_cart_view.dart';
import 'package:waslcom/ui/views/store_views/offers/offers_view.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';

import 'nav_bar/nav_bar_widget.dart';

class SharedScaffoldWidget {
  static sharedScaffoldWidget(BuildContext context, Size size,
          {PreferredSizeWidget appBar,
          Widget drawer,
          Widget body,
          bool shoFab = true,
          NavBarEnum navBarEnum = NavBarEnum.StoreView}) =>
      Scaffold(
        drawer: Get.find<StorageService>().getAccountType() ==
                StorageService.Guest_Account
            ? null
            : drawer,
        appBar: appBar ?? StoreAppBars.mainStoreViewAppBar(context, size),
        backgroundColor: AppColors.grey50Color,
        floatingActionButton: shoFab
            ? FloatingActionButton(
                disabledElevation: 0.0,
                elevation: 5,
                onPressed: () => GeneralUtils.popUntilRoot(context),
                backgroundColor: navBarEnum != NavBarEnum.StoreView
                    ? AppColors.grey500Color
                    : AppColors.blue150Color,
                child: Icon(
                  Icons.storefront_outlined,
                  size: 25,
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomBar(
          navBarEnum: navBarEnum,
          shoppingCartOnTap: ({bool fromNavigationBar = true}) {
            if (navBarEnum != NavBarEnum.StoreView) {
              Get.off(() => ShoppingCartView());
            } else {
              Get.to(() => ShoppingCartView());
            }
          },
          ordersOnTap: () {
            if (Get.find<StorageService>().getIsGuestAccount()) {
              DialogsUtils.showGuestLogInDialog();
            } else {
              if (navBarEnum != NavBarEnum.StoreView) {
                Get.off(() => OrdersView());
              } else {
                Get.to(() => OrdersView());
              }
            }
          },
          searchOnTap: () {
            if (navBarEnum != NavBarEnum.StoreView) {
              Get.off(() => SearchView());
            } else {
              Get.to(() => SearchView());
            }
          },
          offersOnTap: () {
            if (Get.find<StorageService>().getIsGuestAccount()) {
              DialogsUtils.showGuestLogInDialog();
            } else {
              if (navBarEnum != NavBarEnum.StoreView) {
                Get.off(() => OffersView());
              } else {
                Get.to(() => OffersView());
              }
            }
          },
        ),
        body: body,
      );
}
