import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/views/about_app/about_app_view.dart';
import 'package:waslcom/ui/views/address_view/address_view.dart';
import 'package:waslcom/ui/views/contact_us/contact_us_view.dart';
import 'package:waslcom/ui/views/onBoarding/onBoarding_view.dart';
import 'package:waslcom/ui/views/payment/payment_view.dart';
import 'package:waslcom/ui/views/profile_view/profile_view.dart';
import 'package:waslcom/ui/views/store_views/offers/offers_view.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/drawer/drawer_controller.dart';
import 'package:waslcom/ui/views/terms_condition/terms_conditions_view.dart';
import 'package:waslcom/ui/views/store_views/main_store_view/main_store_view_controller.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GetBuilder<AppDrawerController>(
      init: AppDrawerController(),
      builder: (_controller) => Drawer(
        child: Container(
          decoration: BoxDecoration(),
          child: ListView(
            children: <Widget>[
              Center(
                child: new UserAccountsDrawerHeader(
                  accountName: Text(
                    "تم التسجيل بـ    ",
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(color: Colors.white),
                  ),
                  accountEmail: Container(
                    width: size.width * 0.28,
                    child: GestureDetector(
                      onTap: () => BotToast.showText(
                          text: Get.find<StorageService>()
                              .getTokenInfo()
                              .userName,
                          align: Alignment.center),
                      child: Text(
                        Get.find<StorageService>().getTokenInfo().userName,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  currentAccountPicture: GestureDetector(
                    child: new CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  decoration: new BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'assets/pngs/drawer-wallpaper-2.png'))),
                ),
              ),
              SizedBox(height: 20.0),
              InkWell(
                onTap: () =>
                    _controller.lunchWhatsAppLinks(AppLinksEnum.Advertisement),
                child: ListTile(
                  title: Text(
                    'أعلن معنا',
                    style: GoogleFonts.cairo(color: Colors.blueGrey[700]),
                  ),
                  leading: Icon(
                    Icons.tap_and_play,
                    color: Colors.blueGrey[700],
                    size: 25.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    _controller.lunchWhatsAppLinks(AppLinksEnum.Compliant),
                child: ListTile(
                  title: Text(
                    'أرسل شكوى',
                    style: GoogleFonts.cairo(color: Colors.blueGrey[700]),
                  ),
                  leading: Icon(
                    Icons.note,
                    color: Colors.blueGrey[700],
                    size: 25.0,
                  ),
                ),
              ),
              Divider(thickness: 0.3, color: Colors.blue[500]),
              InkWell(
                onTap: () => Get.to(() => MyAddressView()),
                child: ListTile(
                  title: Text(
                    'عناوين الاستلام',
                    style: GoogleFonts.cairo(color: Colors.blueGrey[700]),
                  ),
                  leading: Icon(
                    Icons.pin_drop,
                    color: Colors.blueGrey[700],
                    size: 25.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => ProfileView()),
                child: ListTile(
                  title: Text(
                    'المعلومات الشخصية',
                    style: GoogleFonts.cairo(color: Colors.blueGrey[700]),
                  ),
                  leading: Icon(
                    Icons.person,
                    color: Colors.blueGrey[700],
                    size: 25.0,
                  ),
                ),
              ),
              Get.find<MainStoreController>().payment == 'true'
                  ? InkWell(
                      onTap: () => Get.to(() => PaymentView()),
                      child: ListTile(
                        title: Text(
                          'حسابات التسديد',
                          style: GoogleFonts.cairo(color: Colors.blueGrey[700]),
                        ),
                        leading: Icon(
                          Icons.payment_outlined,
                          color: Colors.blueGrey[700],
                          size: 25.0,
                        ),
                      ),
                    )
                  : Container(),
              Divider(thickness: 0.3, color: Colors.blue[500]),
              InkWell(
                onTap: () => Get.to(() => ContactUsView()),
                child: ListTile(
                  title: Text(
                    'تواصل معنا',
                    style: GoogleFonts.cairo(color: Colors.blueGrey[700]),
                  ),
                  leading: Icon(
                    Icons.contact_mail,
                    color: Colors.blueGrey[700],
                    size: 25.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => AboutAppView()),
                child: ListTile(
                  title: Text(
                    'حول التطبيق',
                    style: GoogleFonts.cairo(color: Colors.blueGrey[700]),
                  ),
                  leading: Icon(
                    Icons.perm_device_information,
                    color: Colors.blueGrey[700],
                    size: 25.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => TermsConditionsView()),
                child: ListTile(
                  title: Text(
                    'سياسة الخصوصية',
                    style: GoogleFonts.cairo(color: Colors.blueGrey[700]),
                  ),
                  leading: Icon(
                    Icons.branding_watermark,
                    color: Colors.blueGrey[700],
                    size: 25.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => OnBoardingView(
                      fromMainMenu: true,
                    )),
                child: ListTile(
                  title: Text(
                    'دليل المستخدم',
                    style: GoogleFonts.cairo(color: Colors.blueGrey[700]),
                  ),
                  leading: Icon(
                    Icons.info,
                    color: Colors.blueGrey[700],
                    size: 25.0,
                  ),
                ),
              ),
              InkWell(
                onTap: _controller.shareApp,
                child: ListTile(
                  title: Text(
                    'مشاركة التطبيق',
                    style: GoogleFonts.cairo(color: Colors.blueGrey[700]),
                  ),
                  leading: Icon(
                    Icons.share,
                    color: Colors.blueGrey[700],
                    size: 25.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _controller.showLogoutDialog();
                },
                child: ListTile(
                  title: Text(
                    'تسجيل الخروج',
                    style: GoogleFonts.cairo(color: Colors.red[900]),
                  ),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.red[900],
                    size: 25.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
