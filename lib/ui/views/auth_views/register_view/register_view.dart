import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/font_styles.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';
import 'package:waslcom/ui/shared_widgets/text_widgets.dart';
import 'package:waslcom/ui/views/auth_views/login_view/login_view.dart';
import 'package:waslcom/ui/views/auth_views/register_view/register_view_controller.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.grey75Color,
      body: SafeArea(
          child: GetBuilder<RegisterController>(
        init: RegisterController(),
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
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.grey.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 18)
                            ],
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/pngs/3.jpg")),
                            borderRadius: BorderRadius.circular(18)),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: size.height * 0.05),
                    child: Text(
                      "Waslcom International".tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.courgette(
                          color: AppColors.blue150Color,
                          fontWeight: FontWeight.w600,
                          fontSize: size.longestSide / 25),
                    ),
                  ),
                  CustomTextWidget(
                    padding: EdgeInsets.symmetric(horizontal: 14.0)
                        .copyWith(bottom: size.height * 0.02),
                    labelText: "رقم الهاتف".tr,
                    textAlign: TextAlign.start,
                    prefixWidget: controller.showCountryCode(),
                    // textFormatter: [controller.phoneFormatter],
                    controller: controller.emailController,
                    inputTextStyle: headLine_2(),
                    keyBoardType: TextInputType.number,
                    // validator: controller.validateIsPhoneNumber,
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
                  CustomTextWidget(
                    padding: EdgeInsets.symmetric(horizontal: 14.0)
                        .copyWith(bottom: size.height * 0.02),
                    labelText: "إعادة كلمة السر".tr,
                    controller: controller.confPasswordController,
                    inputTextStyle: headLine_2(),
                    keyBoardType: TextInputType.visiblePassword,
                    secureText: true,
                    validator: controller.validateIsPassword,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.4)
                        .copyWith(bottom: 18),
                    child: GestureDetector(
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
                        colorsList: AppColors.greenButtonColor,
                        onTap: controller.register,
                        title: "Sign Up".tr,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.5),
                      child: GestureDetector(
                        onTap: () => Get.off(() => LoginView()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                  child: Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: "لديك حساب سابق ؟".tr,
                                    style: GoogleFonts.cairo(
                                        fontSize: size.longestSide / 50)),
                                TextSpan(
                                    text: "  ",
                                    style: GoogleFonts.cairo(
                                        fontSize: size.longestSide / 50)),
                                TextSpan(
                                    text: "سجل الدخول",
                                    style: GoogleFonts.cairo(
                                        color: AppColors.blueAccentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.longestSide / 50))
                              ]))),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom + 30,
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
