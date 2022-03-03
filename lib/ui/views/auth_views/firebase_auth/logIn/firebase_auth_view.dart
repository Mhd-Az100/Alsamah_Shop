import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/font_styles.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';
import 'package:waslcom/ui/shared_widgets/text_widgets.dart';
import 'package:waslcom/ui/views/auth_views/firebase_auth/firebase_auth_controller.dart';

class FirebaseAuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = context.watch<FirebaseAuthController>();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.grey75Color,
      body: SafeArea(
          child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: size.height * 0.032,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  "تسجيل الدخول في\n تطبيق واصلكم انترناشيونال",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                      color: AppColors.grey500Color,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.5, vertical: 14.5),
                child: SvgPicture.asset(
                  "assets/svgs/logIn.svg",
                  width: size.width / 3,
                  height: size.height / 2.4,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              CustomTextWidget(
                padding: EdgeInsets.symmetric(horizontal: 14.0)
                    .copyWith(bottom: size.height * 0.02),
                labelText: "رقم الهاتف".tr,
                textAlign: TextAlign.start,
                controller: controller.phoneNumberController,
                // textFormatter: [controller.phoneFormatter],
                inputTextStyle: headLine_2(),
                keyBoardType: TextInputType.number,
                // validator: controller.validateIsPhoneNumber,
                prefixWidget: controller.showCountryCode(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.4)
                    .copyWith(bottom: 18),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Forgot password ?".tr,
                    textAlign: TextAlign.end,
                    style: headLine_2(fontSize: size.longestSide / 50),
                  ),
                ),
              ),
              FractionallySizedBox(
                  widthFactor: 0.93,
                  child: LinearGradientButton(
                    colorsList: AppColors.blueButtonColor,
                    onTap: controller.firebaseLogIn,
                    title: "دخول".tr,
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.5),
                  child: GestureDetector(
                    onTap: () => controller.viewIndexSet = 1,
                    child: GestureDetector(
                      onTap: controller.guestLogin,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                                child: Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: "هل تريد تجربة التطبيق ؟ ".tr,
                                  style: GoogleFonts.cairo(
                                      fontSize: size.longestSide / 50)),
                              TextSpan(
                                  text: "  ",
                                  style: GoogleFonts.cairo(
                                      fontSize: size.longestSide / 50)),
                              TextSpan(
                                  text: "ادخل الآن",
                                  style: GoogleFonts.cairo(
                                      color: AppColors.blueAccentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.longestSide / 50))
                            ]))),
                          ),
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom + 30,
              )
            ],
          )
        ],
      )),
    );
  }
}
