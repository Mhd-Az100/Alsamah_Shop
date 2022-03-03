import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/core/utils/get_file_from_assets_util.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/font_styles.dart';
import 'package:waslcom/ui/views/notificationlist_view/notificationlist_view.dart';
import 'package:waslcom/ui/views/orders/orders_view.dart';
import 'package:waslcom/ui/views/orders/orders_view_controller.dart';
import 'package:waslcom/ui/views/search/barcode_view.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/drawer/drawer_controller.dart';

class StoreAppBars {
  static mainStoreViewAppBar(BuildContext context, Size size) => AppBar(
      centerTitle: true,
      backgroundColor: AppColors.whiteColor,
      elevation: 0.0,
      iconTheme: IconThemeData(color: AppColors.blue200Color),
      automaticallyImplyLeading: true,
      leading: (Get.find<StorageService>().getIsGuestAccount())
          ? IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => DialogsUtils.showGuestLogInDialog(),
            )
          : null,
      actions: [
        IconButton(
            icon: Icon(
              Icons.notifications,
              color: AppColors.actionIconsColor,
            ),
            onPressed: () {
              Get.to(() => NotificationListView());
            }),
        WhatsAppIcon(
          onTap: () =>
              AppDrawerController().lunchWhatsAppLinks(AppLinksEnum.ContactUs),
        )
      ],
      title: Image.asset(
        AssetsUtils.appTypedLogoappbar,
        width: size.width / 3.2,
      ));

  static categoriesAppBar(BuildContext context, Size size, String title) =>
      AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: AppColors.blue200Color),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
          onPressed: Get.back,
        ),
        actions: [
          WhatsAppIcon(
            onTap: () => AppDrawerController()
                .lunchWhatsAppLinks(AppLinksEnum.ContactUs),
          )
        ],
        title: Text(
          title ?? "التصنيفات".tr,
          style: GoogleFonts.cairo(
            color: AppColors.blue150Color,
          ),
        ),
      );
  static subCategoriesAndProductsAppBar(
          BuildContext context, Size size, String title) =>
      AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: AppColors.blue200Color),
        actions: [
          WhatsAppIcon(
            onTap: () => AppDrawerController()
                .lunchWhatsAppLinks(AppLinksEnum.ContactUs),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
          onPressed: Get.back,
        ),
        title: Text(
          title ?? "المنتجات".tr,
          style: GoogleFonts.cairo(
            color: AppColors.blue150Color,
          ),
        ),
      );

  static shoppingCartAppBar(BuildContext context, Size size) => AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "سلة المشتريات".tr,
          style: headLine_4(
              color: AppColors.blackColor, fontSize: size.longestSide / 35),
        ),
      );

  static productDetailsAppBar(BuildContext context, Size size) => AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
          onPressed: Get.back,
        ),
        title: Text(
          "تفاصيل المنتج".tr,
          style: headLine_4(
              color: AppColors.blackColor, fontSize: size.longestSide / 35),
        ),
      );

  static mapViewAppBar(BuildContext context, Size size) => AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
          onPressed: Get.back,
        ),
        title: Text(
          "اضغط لحديد العنوان على الخريطة".tr,
          style: headLine_4(
              color: AppColors.blackColor, fontSize: size.longestSide / 40),
        ),
      );

  static profileViewAppViewAppBar(BuildContext context, Size size) => AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
          onPressed: Get.back,
        ),
        title: Text(
          "معلومات الحساب".tr,
          style: headLine_4(
              color: AppColors.blackColor, fontSize: size.longestSide / 35),
        ),
      );

  static myAddressViewAppBar(BuildContext context, Size size) => AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
          onPressed: Get.back,
        ),
        title: Text(
          "عناوين الاستلام".tr,
          style: headLine_4(
              color: AppColors.blackColor, fontSize: size.longestSide / 35),
        ),
      );

  static myOrdersViewAppBar(BuildContext context, Size size,
          {bool showBack = true}) =>
      AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
          onPressed: Get.back,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
                onTap: () {
                  Get.find<OrdersViewController>().getAllOrders();
                  Get.off(OrdersView());
                },
                child: Icon(Icons.refresh, color: Colors.black)),
          )
        ],
        title: Text(
          "قائمة طلباتي".tr,
          style: headLine_4(
              color: AppColors.blackColor, fontSize: size.longestSide / 35),
        ),
      );

  static searchViewAppBar(BuildContext context, Size size) => PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.whiteColor,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
            onPressed: Get.back,
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "البحث".tr,
              style: headLine_4(
                  color: AppColors.blackColor, fontSize: size.longestSide / 25),
            ),
          ),
          flexibleSpace: Padding(
            padding: EdgeInsets.only(left: 250, top: 40),
            child: InkWell(
              onTap: () {
                Get.to(() => BarcodeSearch());
              },
              child: SvgPicture.asset(
                "assets/svgs/barcodsearch.svg",
                color: AppColors.blackColor,
                width: size.width / 5,
              ),
            ),
          ),
          // actions: [
          //   IconButton(
          //     color: Colors.black,
          //     icon: Icon(
          //       Icons.qr_code_rounded,
          //       size: 70,
          //     ),
          //     onPressed: () {
          //       Get.to(() => BarcodeSearch());
          //     },
          //   ),
          //   SizedBox(
          //     width: 30,
          //   ),
          // ],
        ),
      );

  static completeAccountInfo(BuildContext context, Size size,
          {bool editMode = false}) =>
      AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        leading: editMode
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
                onPressed: Get.back,
              )
            : null,
        title: Text(
          "معلومات الحساب",
          style: headLine_4(
              color: AppColors.blackColor, fontSize: size.longestSide / 35),
        ),
      );

  static paymentAccountInfo(
    BuildContext context,
    Size size,
  ) =>
      AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.actionIconsColor),
          onPressed: Get.back,
        ),
        title: Text(
          "حسابات التسديد",
          style: headLine_4(
              color: AppColors.blackColor, fontSize: size.longestSide / 35),
        ),
      );
}

class WhatsAppIcon extends StatelessWidget {
  final Function onTap;

  const WhatsAppIcon({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child:
          GestureDetector(onTap: onTap, child: Icon(FontAwesomeIcons.whatsapp)),
    );
  }
}
