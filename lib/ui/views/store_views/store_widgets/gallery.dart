import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:waslcom/ui/views/store_views/main_store_view/main_store_view_controller.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class GalleryImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainStoreController _pageRouteController =
        context.watch<MainStoreController>();
    final Size size = MediaQuery.of(context).size;
    return Container(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width,
        child: Carousel(
          onImageTap: (int index) {
            Get.find<MainStoreController>().lunchUrl(index);
          },
          boxFit: BoxFit.cover,
          images: _pageRouteController.galleryImages,
          autoplay: true,
          autoplayDuration: Duration(seconds: 10),
          dotBgColor: Colors.white30,
          dotSize: 6.0,
          dotColor: Colors.blue[700],
          indicatorBgPadding: 2.0,
        ));
  }
}
