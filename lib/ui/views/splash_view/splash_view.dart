import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/utils/get_file_from_assets_util.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/views/splash_view/splash_view_controller.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<SplashViewController>(
        init: SplashViewController(),
        builder: (controller) => true
            ? Scaffold(
                body: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.73,
                      ),
                      SpinKitThreeBounce(
                        color: AppColors.blueColor,
                        size: size.longestSide / 12,
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage(AssetsUtils.appSplashLogo))),
                ),
              )
            : Scaffold(
                body: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.2,
                      ),
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: AppColors.transparentColor,
                        child: Image.asset("assets/pngs/app_icon.png"),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: size.height * 0.05),
                        child: Text(
                          "Waslcom International".tr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.courgette(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 50),
                        ),
                      ),
                      SpinKitThreeBounce(
                        color: AppColors.whiteColor,
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/pngs/background_1.png"))),
                ),
              ));
  }
}
