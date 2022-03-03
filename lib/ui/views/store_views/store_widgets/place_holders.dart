import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';
import 'package:get/route_manager.dart';

class NoDataWidget extends StatelessWidget {
  final Function onTap;
  final String onTapTitle;
  final String message;
  final hideOnTap;

  const NoDataWidget({
    Key key,
    this.onTap,
    this.message,
    this.hideOnTap = false,
    this.onTapTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid,
              color: AppColors.grey200Color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColors.grey100Color.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 18)
          ]),
      child: Column(
        children: [
          SizedBox(
            height: size.height / 35,
          ),
          SvgPicture.asset(
            "assets/svgs/billing.svg",
            color: AppColors.blackColor.withOpacity(0.4),
            width: size.width / 4,
          ),
          SizedBox(
            height: size.height / 35,
          ),
          Container(
            width: size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              message ?? "لا توجد عناصر حالياً، يرجى المحاولة مرة ثانية",
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                  fontSize: size.longestSide / 40,
                  fontWeight: FontWeight.w300,
                  color: AppColors.grey500Color),
            ),
          ),
          if (!hideOnTap) ...[
            SizedBox(
              height: size.height / 35,
            ),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: LinearGradientButton(
                onTap: onTap ?? () => Get.back(),
                title: onTapTitle ?? "رجوع الى الخلف",
                colorsList: AppColors.editButton,
              ),
            ),
            SizedBox(
              height: size.height / 35,
            ),
          ],
        ],
      ),
    );
  }
}

class StartSearchWidget extends StatelessWidget {
  final Function onTap;
  final String message;
  final hideOnTap;

  const StartSearchWidget(
      {Key key, this.onTap, this.message, this.hideOnTap = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
        child: ListView(
          children: [
            SizedBox(
              height: size.height / 35,
            ),
            SvgPicture.asset(
              "assets/svgs/search.svg",
              color: AppColors.blackColor.withOpacity(0.4),
              width: size.width / 6,
            ),
            SizedBox(
              height: size.height / 35,
            ),
            Container(
              width: size.width * 0.7,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                message ?? "ابدأ البجث باستخدام الحقل أعلاه",
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                    fontSize: size.longestSide / 40,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey500Color),
              ),
            ),
            if (!hideOnTap) ...[
              SizedBox(
                height: size.height / 35,
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: LinearGradientButton(
                  onTap: onTap ?? () => Get.back(),
                  title: "Go back",
                  colorsList: AppColors.editButton,
                ),
              ),
              SizedBox(
                height: size.height / 35,
              ),
            ],
          ],
        ),
        height: hideOnTap ? size.height * 0.3 : size.height * 0.3,
        width: size.width * 0.9,
        margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
        decoration: BoxDecoration(
            border: Border.all(
                style: BorderStyle.solid,
                color: AppColors.grey200Color.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: AppColors.grey100Color.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 18)
            ]));
  }
}

class StartSearchBarcodeWidget extends StatelessWidget {
  final Function onTap;
  final String message;
  final hideOnTap;

  const StartSearchBarcodeWidget(
      {Key key, this.onTap, this.message, this.hideOnTap = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
        child: ListView(
          children: [
            SizedBox(
              height: size.height / 22,
            ),
            SvgPicture.asset(
              "assets/svgs/barcode.svg",
              color: AppColors.blackColor.withOpacity(0.4),
              width: size.width / 4,
            ),
            SizedBox(
              height: size.height / 35,
            ),
            Container(
              width: size.width * 0.7,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                message ?? "ابدأ البجث باستخدام الباركود",
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                    fontSize: size.longestSide / 40,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey500Color),
              ),
            ),
            if (!hideOnTap) ...[
              SizedBox(
                height: size.height / 35,
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: LinearGradientButton(
                  onTap: onTap ?? () => Get.back(),
                  title: "Go back",
                  colorsList: AppColors.editButton,
                ),
              ),
              SizedBox(
                height: size.height / 35,
              ),
            ],
          ],
        ),
        height: hideOnTap ? size.height * 0.3 : size.height * 0.4,
        width: size.width * 0.9,
        margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
        decoration: BoxDecoration(
            border: Border.all(
                style: BorderStyle.solid,
                color: AppColors.grey200Color.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: AppColors.grey100Color.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 18)
            ]));
  }
}

class NoDataGeneralWidget extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String message;

  const NoDataGeneralWidget({
    Key key,
    this.onTap,
    this.icon,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      width: size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid,
              color: AppColors.grey200Color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColors.grey100Color.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 18)
          ]),
      child: Column(
        children: [
          SizedBox(
            height: size.height / 40,
          ),
          Icon(
            icon ?? Icons.wifi_off,
            color: AppColors.blackColor.withOpacity(0.4),
            size: size.longestSide / 8,
          ),
          SizedBox(
            height: size.height / 35,
          ),
          Container(
            width: size.width * 0.7,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              message ?? "No items founded, please try another choice!",
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                  fontSize: size.longestSide / 40,
                  fontWeight: FontWeight.w300,
                  color: AppColors.grey500Color),
            ),
          ),
          SizedBox(
            height: size.height / 35,
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: LinearGradientButton(
              onTap: onTap,
              title: "رجوع للخلف",
              colorsList: AppColors.editButton,
            ),
          ),
          SizedBox(
            height: size.height / 35,
          ),
        ],
      ),
    );
  }
}

class NoConnectionWidget extends StatelessWidget {
  final Function onTap;

  const NoConnectionWidget({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.4,
      width: size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid,
              color: AppColors.grey200Color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColors.grey100Color.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 18)
          ]),
      child: Column(
        children: [
          SizedBox(
            height: size.height / 35,
          ),
          Icon(
            Icons.wifi_off,
            color: AppColors.blackColor.withOpacity(0.4),
            size: size.longestSide / 8,
          ),
          SizedBox(
            height: size.height / 35,
          ),
          Container(
            width: size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "No connection founded, please check that your device if is connected.",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: size.longestSide / 40,
                  fontWeight: FontWeight.w300,
                  color: AppColors.grey500Color),
            ),
          ),
          SizedBox(
            height: size.height / 35,
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: LinearGradientButton(
              onTap: onTap,
              title: "Retry",
              colorsList: AppColors.editButton,
            ),
          ),
          SizedBox(
            height: size.height / 35,
          ),
        ],
      ),
    );
  }
}
