import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/untils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class AddressWidget extends StatelessWidget {
  final String addressDetails;
  final Function onTap;

  const AddressWidget({Key key, this.addressDetails, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.1,
      margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColors.grey500Color.withOpacity(0.8),
                spreadRadius: 2,
                blurRadius: 18)
          ]),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                  child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: "Address".tr,
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: size.longestSide / 40)),
                  TextSpan(
                      text: " : ",
                      style:
                          GoogleFonts.cairo(fontSize: size.longestSide / 50)),
                  TextSpan(
                      text: addressDetails.nullableValue("Address details"),
                      style: GoogleFonts.cairo(
                          color: AppColors.blue150Color,
                          fontWeight: FontWeight.w600,
                          fontSize: size.longestSide / 50))
                ]),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
            ),
            SizedBox(
              width: size.width * 0.08,
            ),
            InkWell(
              onTap: onTap,
              child: SvgPicture.asset(
                "assets/svgs/right-arrow.svg",
                width: size.width / 15,
                color: AppColors.blue150Color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function onTap;
  final bool readOnly;
  final bool autoFocus;
  final Function onChange;
  final Function onSubmit;

  const AddressSearchWidget({
    Key key,
    this.controller,
    this.onTap,
    this.readOnly = false,
    this.autoFocus = false,
    this.onChange,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.06,
      margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColors.blueAccentColor.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 18)
          ]),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/svgs/search.svg",
              width: size.width / 20,
              color: AppColors.blue150Color,
            ),
            SizedBox(
              width: size.width * .05,
            ),
            Container(
              width: size.width * 0.6,
              child: TextField(
                decoration:
                    InputDecoration.collapsed(hintText: "ابحث هنا "),
                readOnly: readOnly,
                autofocus: autoFocus,
                controller: controller,
                onChanged: onChange,
                onSubmitted: onSubmit,
                textInputAction: TextInputAction.search,
              ),
            )
          ],
        ),
      ),
    );
  }
}
