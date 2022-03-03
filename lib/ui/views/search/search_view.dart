import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/ui/shared_widgets/shared_scaffold_widget.dart';
import 'package:waslcom/ui/views/map_view/map_widgets.dart';
import 'package:waslcom/ui/views/product_details/product_details_view.dart';
import 'package:waslcom/ui/views/search/search_view_controller.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/place_holders.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/store_item.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SharedScaffoldWidget.sharedScaffoldWidget(context, size,
        shoFab: MediaQuery.of(context).viewInsets.bottom == 0.0,
        navBarEnum: NavBarEnum.SearchView,
        appBar: StoreAppBars.searchViewAppBar(
          context,
          size,
        ),
        body: GetBuilder<SearchViewController>(
            init: SearchViewController(),
            builder: (stateController) {
              if (stateController.connectionError) {
                return Center(
                  child: NoConnectionWidget(
                    onTap: () => stateController.searchRequest(),
                  ),
                );
              } else {
                return Column(
                  children: [
                    AddressSearchWidget(
                      controller: stateController.searchValue,
                      readOnly: false,
                      autoFocus: true,
                      onChange: (v) => stateController.searchRequest(),
                      onSubmit: (v) => stateController.searchRequest(),
                    ),
                    if (stateController.isLoading) ...[
                      Center(child: CircularProgressIndicator()),
                    ] else
                      Expanded(
                        flex: 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
                          child: stateController.productsList.isNotEmpty
                              ? StaggeredGridView.countBuilder(
                                  shrinkWrap: true,
                                  crossAxisCount: 4,
                                  itemCount:
                                      stateController.productsList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          StoreItem(
                                    id: stateController.getData(index).id,
                                    imageId: stateController
                                        .getData(index)
                                        .imageID
                                        .toString(),
                                    name: stateController.getData(index).name,
                                    addToCart: () =>
                                        stateController.addToCart(index),
                                    isProduct: stateController
                                            .getData(index)
                                            .childrenCategories ==
                                        null,
                                    product: stateController.getData(index),
                                    onTap: () =>
                                        Get.to(() => ProductDetailsView(
                                              product: stateController
                                                  .getData(index),
                                            )),
                                  ),
                                  staggeredTileBuilder: (int index) =>
                                      new StaggeredTile.count(
                                          2, index.isEven ? 3 : 2.8),
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: stateController.firstTime
                                      ? StartSearchWidget()
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
}
