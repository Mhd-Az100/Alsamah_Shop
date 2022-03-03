import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/notificationlist_view/notificationlist_widget.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/drawer/drawer_controller.dart';

class NotificationListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
            "الإشعارات".tr,
            style: GoogleFonts.cairo(
              color: AppColors.blue150Color,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.actionIconsColor,
            labelColor: AppColors.actionIconsColor,
            tabs: <Widget>[
              Tab(
                text: 'عامة',
                icon: Icon(
                  Icons.notifications,
                  color: AppColors.actionIconsColor,
                ),
              ),
              Tab(
                text: 'خاصة',
                icon: Icon(
                  Icons.person,
                  color: AppColors.actionIconsColor,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ListNotifWidget(size: size),
            ListNotifWidget(size: size),
          ],
        ),
      ),
    );
  }
}
