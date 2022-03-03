import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';

TextStyle headLine_1({num fontSize}) => GoogleFonts.cairo(
    fontWeight: FontWeight.w400,
    fontSize: fontSize ?? 22,
    color: AppColors.blackColor);

TextStyle headLine_2({num fontSize, num laterSpacing}) => GoogleFonts.roboto(
    fontWeight: FontWeight.w300,
    letterSpacing: laterSpacing ?? 1.0,
    fontSize: fontSize ?? 22,
    color: AppColors.grey500Color);

TextStyle headLine_3({num fontSize}) => GoogleFonts.roboto(
    fontWeight: FontWeight.w300,
    fontSize: fontSize ?? 22,
    color: AppColors.blue300Color);

TextStyle headLine_4({num fontSize, FontWeight fontWeight, Color color}) =>
    GoogleFonts.cairo(
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize ?? 22,
        color: color ?? AppColors.blue300Color);

TextStyle storeItemsFont({num fontSize, FontWeight fontWeight, Color color}) =>
    GoogleFonts.cairo(
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize ?? 22,
        color: color ?? AppColors.blueGrey);

TextStyle btnTextStyle() => GoogleFonts.cairo(
    fontSize: 24, color: AppColors.whiteColor);
