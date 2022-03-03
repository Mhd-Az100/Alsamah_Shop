import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/nav_bar/nav_bar_controller.dart';
import 'package:waslcom/ui/views/address_view/address_view_controller.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';

class BottomBar extends StatefulWidget {
  final NavBarEnum navBarEnum;
  final Function shoppingCartOnTap;
  final Function offersOnTap;
  final Function ordersOnTap;
  final Function searchOnTap;

  const BottomBar(
      {Key key,
      this.navBarEnum = NavBarEnum.StoreView,
      this.shoppingCartOnTap,
      this.offersOnTap,
      this.ordersOnTap,
      this.searchOnTap})
      : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final navBarController = NavBarController();

  @override
  void initState() {
    navBarController.currentNavBarEnum = widget.navBarEnum;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: AppColors.grey75Color,
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
              color: Colors.white),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width / 2 - 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(Icons.search,
                          color: navBarController
                              .checkTheCurrentNavBar(NavBarEnum.SearchView)),
                      onTap: widget.searchOnTap,
                    ),
                    GestureDetector(
                        onTap: widget.offersOnTap,
                        child: Image.asset(
                          'assets/pngs/navbarOffer.png',
                          scale: 9,
                        )
                        // Icon(Icons.card_giftcard_rounded,
                        //     color: navBarController
                        //         .checkTheCurrentNavBar(NavBarEnum.Offers)
                        // ),
                        )
                  ],
                )),
            Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width / 2 - 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      child: GetBuilder<ShoppingCartController>(
                        builder: (controller) => controller.getTotalCount() == 0
                            ? Icon(Icons.shopping_cart,
                                color: navBarController.checkTheCurrentNavBar(
                                    NavBarEnum.ShoppingCartView))
                            : Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.shopping_cart,
                                        color: navBarController
                                            .checkTheCurrentNavBar(
                                                NavBarEnum.ShoppingCartView)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.03,
                                            ),
                                            CircleAvatar(
                                              radius: 13,
                                              backgroundColor:
                                                  AppColors.redColor,
                                              child: Text(
                                                controller
                                                    .getTotalCount()
                                                    ?.toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        AppColors.whiteColor),
                                              ),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                      ),
                      onTap: () {
                        Get.put(MyAddressController());
                        widget.shoppingCartOnTap();
                      },
                    ),
                    GestureDetector(
                      onTap: widget.ordersOnTap,
                      child: Icon(Icons.local_shipping,
                          color: navBarController
                              .checkTheCurrentNavBar(NavBarEnum.OrdersView)),
                    )
                  ],
                )),
          ])),
    );
  }
}
