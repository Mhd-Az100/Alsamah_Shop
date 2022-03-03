import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/notificationlist_view/notification_info.dart';

class ListNotifWidget extends StatelessWidget {
  const ListNotifWidget({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1,
                    color: AppColors.blueGrey.withOpacity(0.5),
                    spreadRadius: 0.5),
              ],
            ),
            child: InkWell(
              onTap: () {
                Get.to(() => NotificationInfo());
              },
              child: ListTile(
                leading: Image.asset('assets/pngs/alsamah_icon_luncher.png'),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "اشعار عاماشعار عام مثال اشعار عام مثال اشعار عام مثال اشعار عام مثال اشعار عام مثال اشعار عام مثال اشعار عام مثال اشعار عام مثال ",
                      style: GoogleFonts.cairo(
                          fontSize: size.shortestSide / 25,
                          color: AppColors.blue300Color,
                          fontWeight: FontWeight.w800),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          );
        });
  }
}

class PhotoViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        imageProvider: AssetImage('assets/pngs/alsamah_icon_luncher.png'),
      ),
    );
  }
}
