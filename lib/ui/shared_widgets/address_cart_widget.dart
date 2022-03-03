import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/models/address_models.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/untils.dart';

class AddressCartWidget extends StatelessWidget {
  final AddressDto addressDto;
  final Function onTap;

  const AddressCartWidget({Key key, this.addressDto, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.5, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.blueAccentColor.withOpacity(0.2),
                  blurRadius: 18,
                  spreadRadius: 1)
            ],
            borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: SvgPicture.asset(
                "assets/svgs/real-estate.svg",
                width: size.width / 7,
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 4,
                    child: Container(
                        child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: addressDto.userFullName.nullableValue(""),
                            style: GoogleFonts.cairo(
                                color: AppColors.grey500Color,
                                fontWeight: FontWeight.bold,
                                fontSize: size.longestSide / 50)),
                        TextSpan(
                            text: " : ",
                            style: GoogleFonts.cairo(
                                fontSize: size.longestSide / 50)),
                        TextSpan(
                            text: "اسم المستلم",
                            style: GoogleFonts.cairo(
                                fontSize: size.longestSide / 50,
                                fontWeight: FontWeight.bold,
                                color: AppColors.orangeColor)),
                      ]),
                      textAlign: TextAlign.right,
                    )),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                        child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: addressDto.userMobile.nullableValue(""),
                            style: GoogleFonts.cairo(
                                color: AppColors.grey500Color,
                                fontWeight: FontWeight.bold,
                                fontSize: size.longestSide / 50)),
                        TextSpan(
                            text: " : ",
                            style: GoogleFonts.cairo(
                                fontSize: size.longestSide / 50)),
                        TextSpan(
                            text: "رقم الهاتف",
                            style: GoogleFonts.cairo(
                                fontSize: size.longestSide / 50,
                                fontWeight: FontWeight.bold,
                                color: AppColors.orangeColor)),
                      ]),
                      textAlign: TextAlign.right,
                    )),
                  ),
                  Flexible(
                    flex: 5,
                    child: Container(
                        child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text:
                                addressDto.description.nullableValue("Riyadh"),
                            style: GoogleFonts.cairo(
                                color: AppColors.grey500Color,
                                fontWeight: FontWeight.bold,
                                fontSize: size.longestSide / 50)),
                      ]),
                      textAlign: TextAlign.center,
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
