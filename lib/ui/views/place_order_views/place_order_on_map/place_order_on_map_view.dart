import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/models/general_enums/add_address_conditions_enum.dart';
import 'package:waslcom/ui/shared_widgets/address_cart_widget.dart';
import 'package:waslcom/ui/shared_widgets/map_widget.dart';
import 'package:waslcom/ui/views/place_order_views/place_order_on_map/place_order_on_map_view_controller.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';

class PlaceOrderOnMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: StoreAppBars.mapViewAppBar(context, size),
      body: GetBuilder<PlaceOrderOnMapViewController>(
        init: PlaceOrderOnMapViewController(),
        builder: (controller) => Stack(
          children: [
            controller.mapIsLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : MapWidget(
                    defaultCameraTarget: controller.defaultLatLang,
                    onTabCallback: (latLan) => controller.getLocationDetails(
                        lat: latLan.latitude, lon: latLan.longitude),
                    markers: controller.markers,
                    mapController: (controller) {},
                  ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: AddressSearchWidget(
            //     onTap: () => controller
            //         .getLocationDetailsBySearchAutoCompleter(context),
            //   ),
            // ),
            if (controller.addressList.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: EdgeInsets.only(bottom: 50),
                    height: size.height * 0.3,
                    child: Column(
                      children: [
                        Expanded(
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              viewportFraction: 0.8,
                              aspectRatio: 2.2,
                            ),
                            itemCount: controller.addressList.length,
                            itemBuilder: (context, index, realIndex) =>
                                GestureDetector(
                              onTap: () => controller.showSendOrderDialog(
                                  context,
                                  addAddressConditionsEnum:
                                      AddAddressConditionsEnum
                                          .ClickOnAddressList,
                                  index: index),
                              child: AddressCartWidget(
                                addressDto: controller.addressList[index],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              )
          ],
        ),
      ),
    );
  }
}
