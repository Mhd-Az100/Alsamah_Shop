import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:marquee_text/marquee_direction.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:provider/provider.dart';
import 'package:waslcom/ui/shared_widgets/shared_scaffold_widget.dart';
import 'package:waslcom/ui/views/store_views/main_store_view/main_store_view_controller.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/drawer/drawer_widget.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/gallery.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/place_holders.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/store_item.dart';

class MainStoreView extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  MainStoreController ctrl = Get.put(MainStoreController());
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SharedScaffoldWidget.sharedScaffoldWidget(context, size,
        drawer: CustomDrawer(),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child:
              GetBuilder<MainStoreController>(builder: (mainStoreController) {
            if (mainStoreController.isLoading.isTrue) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (mainStoreController.connectionError.isTrue) {
              return Center(
                child: NoConnectionWidget(
                  onTap: () => mainStoreController.onInitial(),
                ),
              );
            } else {
              return ListView(
                  padding: EdgeInsets.zero.copyWith(bottom: 30),
                  children: [
                    if (mainStoreController.galleryImages.isNotEmpty)
                      InheritedProvider.value(
                          value: mainStoreController, child: GalleryImages()),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: mainStoreController.marqueeText.isEmpty
                          ? Container()
                          : MarqueeText(
                              text: '${mainStoreController.marqueeText}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              marqueeDirection: MarqueeDirection.ltr,
                              alwaysScroll: true,
                              speed: 30,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10.0),
                      child: StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        crossAxisCount: 1,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: mainStoreController.storesList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            StoreItem(
                          imageId: mainStoreController
                              .getData(index)
                              .imageID
                              .toString(),
                          name: mainStoreController.getData(index).name,
                          onTap: () => mainStoreController.tapItemAction(index),
                        ),
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(1, 0.7),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      ),
                    ),
                  ]);
            }
          }),
        ));
  }

  Future<dynamic> _refresh() {
    return ctrl.getStores().then((value) {});
  }
}
