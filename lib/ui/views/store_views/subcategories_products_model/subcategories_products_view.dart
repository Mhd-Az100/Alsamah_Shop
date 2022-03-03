import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/ui/shared_widgets/shared_scaffold_widget.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/place_holders.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/store_item.dart';
import 'package:waslcom/ui/views/store_views/subcategories_products_model/subcategories_products_view_controller.dart';

class SubCategoriesCategoriesView extends StatelessWidget {
  final String id;
  final String title;

  const SubCategoriesCategoriesView({Key key, this.id, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SharedScaffoldWidget.sharedScaffoldWidget(context, size,
        navBarEnum: NavBarEnum.StoreView,
        appBar:
            StoreAppBars.subCategoriesAndProductsAppBar(context, size, title),
        body: GetX<SubCategoriesProductsViewController>(
            init: SubCategoriesProductsViewController(id),
            global: false,
            builder: (stateController) {
              if (stateController.isLoading.isTrue) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (stateController.connectionError.isTrue) {
                return Center(
                  child: NoConnectionWidget(
                    onTap: () => stateController.onInitial(id),
                  ),
                );
              } else {
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10.0),
                      child: stateController.dataList.isNotEmpty
                          ? StaggeredGridView.countBuilder(
                              shrinkWrap: true,
                              crossAxisCount: 4,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: stateController.dataList.length,
                              itemBuilder: (BuildContext context, int index) =>
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
                                    stateController.clickOnItemFunction(index),
                              ),
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      2, index.isEven ? 3 : 2.8),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: NoDataWidget(
                                onTap: () => Get.back(),
                              ),
                            ),
                    )
                  ],
                );
              }
            }));
  }
}
