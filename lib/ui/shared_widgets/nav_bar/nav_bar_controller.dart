import 'package:get/get.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:flutter/material.dart';

class NavBarController extends GetxController {
  ///The nav-bar current value
  var currentNavBarEnum = NavBarEnum.StoreView;

  Color checkTheCurrentNavBar(NavBarEnum navBarEnum) {
    if (navBarEnum == currentNavBarEnum) {
      return AppColors.blue150Color;
    } else {
      return AppColors.blueGrey;
    }
  }
}
