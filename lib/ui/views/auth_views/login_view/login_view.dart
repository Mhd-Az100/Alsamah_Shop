import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/utils.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/font_styles.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';
import 'package:waslcom/ui/shared_widgets/text_widgets.dart';
import 'package:waslcom/ui/views/auth_views/login_view/login_view_controller.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/drawer/drawer_controller.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.grey75Color,
      body: SafeArea(
          child: GetBuilder<LoginViewController>(
        init: LoginViewController(),
        builder: (controller) => Stack(
          children: [
            Form(
              key: controller.key,
              autovalidateMode: controller.autoValidateMode,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(top: size.height * 0.02, bottom: 25),
                    child: Align(
                      alignment: AlignmentDirectional.center,
                      child: Container(
                        width: size.width * 0.9,
                        height: size.height * 0.4,
                        decoration: BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: AppColors.grey.withOpacity(0.4),
                            //       spreadRadius: 1,
                            //       blurRadius: 18)
                            // ],
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage("assets/pngs/alsamah_logo.png")),
                            borderRadius: BorderRadius.circular(18)),
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.only(bottom: size.height * 0.05),
                  //   child: Text(
                  //     "Waslcom International".tr,
                  //     textAlign: TextAlign.center,
                  //     style: GoogleFonts.courgette(
                  //         color: AppColors.blue150Color,
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: size.longestSide / 25),
                  //   ),
                  // ),
                  CustomTextWidget(
                    padding: EdgeInsets.symmetric(horizontal: 14.0)
                        .copyWith(bottom: size.height * 0.02),
                    labelText: "الإيميل".tr,
                    textAlign: TextAlign.start,
                    controller: controller.emailController,
                    // controller: controller.phoneNumberController,
                    // textFormatter: [controller.phoneFormatter],
                    inputTextStyle: headLine_2(),
                    keyBoardType: TextInputType.emailAddress,
                    // validator: controller.validateIsPhoneNumber,
                    // prefixWidget: controller.showCountryCode(),
                  ),
                  CustomTextWidget(
                    padding: EdgeInsets.symmetric(horizontal: 14.0)
                        .copyWith(bottom: size.height * 0.02),
                    labelText: "كلمة السر".tr,
                    controller: controller.passwordController,
                    inputTextStyle: headLine_2(),
                    keyBoardType: TextInputType.visiblePassword,
                    secureText: true,
                    validator: controller.validateIsPassword,
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
                        onTap: controller.login,
                        title: "Sign In".tr,
                      )),
                  // Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 14.5),
                  //     child: GestureDetector(
                  //       onTap: () => Get.off(() => RegisterView()),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Flexible(
                  //             child: Container(
                  //                 child: Text.rich(TextSpan(children: [
                  //               TextSpan(
                  //                   text: "ليس لديك حساب سابق ؟ ".tr,
                  //                   style: GoogleFonts.cairo(
                  //                       fontSize: size.longestSide / 50)),
                  //               TextSpan(
                  //                   text: "  ",
                  //                   style: GoogleFonts.cairo(
                  //                       fontSize: size.longestSide / 50)),
                  //               TextSpan(
                  //                   text: "أنشئ حساب",
                  //                   style: GoogleFonts.cairo(
                  //                       color: AppColors.greenColor,
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: size.longestSide / 50))
                  //             ]))),
                  //           ),
                  //         ],
                  //       ),
                  //     )),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom + 30,
                  ),

                  GestureDetector(
                    onTap: () => AppDrawerController()
                        .lunchWhatsAppLinks(AppLinksEnum.ContactUs),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WhatsAppIcon(),
                        Text('تواصل معنا لإنشاء حساب خاص بك',
                            style: TextStyle(
                                color: AppColors.blueAccentColor,
                                fontSize: 16)),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
