import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';
import 'package:waslcom/ui/shared_widgets/text_widgets.dart';
import 'package:waslcom/ui/views/auth_views/firebase_auth/firebase_auth_controller.dart';

class FirebaseVerificationView extends StatelessWidget {
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
                  height: size.height * 0.05,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: size.width * 0.8,
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                    text: "يرجى انتظار رمز التفعيل المرسل الى  "
                                        .tr,
                                    style: GoogleFonts.cairo(
                                        fontSize: size.longestSide / 44)),
                                TextSpan(
                                    text: "  ",
                                    style: GoogleFonts.cairo(
                                        fontSize: size.longestSide / 48)),
                                TextSpan(
                                    text:
                                        "${controller.phoneNumberController.text}+" ??
                                            "",
                                    style: GoogleFonts.cairo(
                                        color: AppColors.greenColor,
                                        letterSpacing: 1.8,
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.longestSide / 28)),
                              ]),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            )),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.5, vertical: 18.5),
                  child: SvgPicture.asset(
                    "assets/svgs/undraw_two_factor_authentication_namy.svg",
                    width: size.width / 4,
                    height: size.height / 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0)
                      .copyWith(bottom: 30),
                  child: SecondCustomTextWidget(
                    textAlign: TextAlign.center,
                    controller: controller.verificationCodeController,
                    labelText: "رمز التفعيل",
                    inputTextStyle: TextStyle(fontSize: 32),
                    validator: controller.validateIsVerificationCode,
                    keyBoardType: TextInputType.number,
                    textFormatter: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                FractionallySizedBox(
                    widthFactor: 0.93,
                    child: LinearGradientButton(
                      colorsList: AppColors.greenButtonColor,
                      onTap: controller.firebaseVerifyNumber,
                      title: "تأكيد رقم الهاتف".tr,
                    )),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.5),
                    child: GestureDetector(
                      onTap: () => controller.firebaseLogIn(resendMode: true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                                child: Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: "هل الرمز لم يصل بعد ؟ ".tr,
                                  style: GoogleFonts.cairo(
                                      fontSize: size.longestSide / 48)),
                              TextSpan(
                                  text: "  ",
                                  style: GoogleFonts.cairo(
                                      fontSize: size.longestSide / 48)),
                              TextSpan(
                                  text: "إعادة ارسال الرقم",
                                  style: GoogleFonts.cairo(
                                      color: AppColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.longestSide / 48))
                            ]))),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom + 50,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
