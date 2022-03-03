import 'package:barcode_scan/barcode_scan.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/shared_scaffold_widget.dart';
import 'package:waslcom/ui/views/product_details/product_details_view.dart';
import 'package:waslcom/ui/views/search/search_view_controller.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/place_holders.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/store_item.dart';

class BarcodeSearch extends StatefulWidget {
  BarcodeSearch({Key key}) : super(key: key);

  @override
  _BarcodeSearchState createState() => _BarcodeSearchState();
}

class _BarcodeSearchState extends State<BarcodeSearch> {
  @override
  void initState() {
    super.initState();
    scane();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SharedScaffoldWidget.sharedScaffoldWidget(context, size,
        shoFab: MediaQuery.of(context).viewInsets.bottom == 0.0,
        navBarEnum: NavBarEnum.SearchView,
        body: GetBuilder<SearchViewController>(
            init: SearchViewController(),
            builder: (stateController) {
              if (stateController.connectionError) {
                return Center(
                  child: NoConnectionWidget(
                    onTap: () => stateController.searchByBarcodeRequest(),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: InkWell(
                        onTap: scane,
                        child: SvgPicture.asset(
                          "assets/svgs/barcodsearch.svg",
                          color: AppColors.blackColor,
                          width: size.width / 4,
                        ),
                      ),
                    ),
                    if (stateController.isLoading) ...[
                      SizedBox(
                        height: size.height * 0.25,
                      ),
                      CircularProgressIndicator()
                    ] else
                      Expanded(
                        flex: 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
                          child: stateController.productsListbybarcode != null
                              ? StoreItem(
                                  id: stateController.productsListbybarcode.id,
                                  imageId: stateController
                                      .productsListbybarcode.imageID
                                      .toString(),
                                  name: stateController
                                      .productsListbybarcode.name,
                                  addToCart: () =>
                                      stateController.productsListbybarcode,
                                  isProduct: stateController
                                          .productsListbybarcode
                                          .childrenCategories ==
                                      null,
                                  product:
                                      stateController.productsListbybarcode,
                                  onTap: () => Get.to(() => ProductDetailsView(
                                        product: stateController
                                            .productsListbybarcode,
                                      )),
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: stateController.firstTime
                                      ? StartSearchBarcodeWidget()
                                      : NoDataWidget(
                                          hideOnTap: true,
                                          onTap: () => Get.back(),
                                        ),
                                ),
                        ),
                      )
                  ],
                );
              }
            }));
  }

  Future scane() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();

      Get.find<SearchViewController>().barcode = barcode.rawContent;
      Get.find<SearchViewController>().searchByBarcodeRequest();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        BotToast.showText(
            text: "camera permission not granted",
            duration: Duration(seconds: 4),
            align: Alignment.center);
      } else {
        BotToast.showText(
            text: "unknown error : $e",
            duration: Duration(seconds: 4),
            align: Alignment.center);
      }
    } on PlatformException {
      BotToast.showText(
          text:
              "null user returned using the back button before scanning anything",
          duration: Duration(seconds: 4),
          align: Alignment.center);
    } catch (e) {
      BotToast.showText(
          text: "unknown error : $e",
          duration: Duration(seconds: 4),
          align: Alignment.center);
    }
  }
}
