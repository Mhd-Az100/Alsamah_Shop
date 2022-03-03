import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/font_styles.dart';
import 'package:waslcom/ui/shared_widgets/map_widget.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';

import 'map_view_controller.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: StoreAppBars.mapViewAppBar(context, size),
      body: GetBuilder<MapViewController>(
        init: MapViewController(),
        builder: (controller) => controller.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  MapWidget(
                    defaultCameraTarget: controller.defaultLatLang,
                    // onTabCallback:
                    //  (latLan) => controller.getLocationDetails(

                    // lat: latLan.latitude, lon: latLan.longitude),
                    // markers: controller.marker,
                    onCameramove: (position) {
                      controller.positionMarker(position);
                    },
                    onCameraidle: () {},
                    mapController: (controller) {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Center(
                      child: Image.asset(
                        'assets/pngs/marker.png',
                        width: 70,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: Container(
                      width: 100,
                      height: 40,
                      child: ElevatedButton(
                        child: Text("إرسال",
                            style: GoogleFonts.cairo(
                                fontSize: size.shortestSide / 25,
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center),
                        onPressed: () {
                          if (controller.markerposition == null) {
                            BotToast.showText(
                              text: "حرك الدبوس للتحديد",
                              align: Alignment.center,
                              textStyle:
                                  storeItemsFont(color: AppColors.whiteColor),
                            );
                          } else {
                            controller.getLocationDetails(
                                lat: controller.markerposition.target.latitude,
                                lon:
                                    controller.markerposition.target.longitude);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
