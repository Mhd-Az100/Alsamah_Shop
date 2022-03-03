import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/notificationlist_view/notificationlist_widget.dart';

class NotificationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: AppColors.whiteBackgroundColor,
        height: size.height,
        width: size.width,
        child: Container(
          padding: EdgeInsets.all(25),
          child: ListView(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Get.to(() => PhotoViewWidget());
                      },
                      child:
                          Image.asset('assets/pngs/alsamah_icon_luncher.png'))),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: Text(
                    "اشعار عاماشعار عام مثال اشعار عام مثال اشعار عام مثال اشعار عام مثال اشعار عام مثال اشعار عام مثال اشعار عام مثال اشعار عام مثال ",
                    style: GoogleFonts.cairo(
                        fontSize: size.shortestSide / 25,
                        color: AppColors.blue300Color,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }
}
