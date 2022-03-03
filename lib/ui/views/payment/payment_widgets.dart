import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/models/payment_models.dart';
import 'package:waslcom/core/network.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/cached_image_widget.dart';

class PaymentCard extends StatelessWidget {
  final PaymentDto paymentDto;
  final Function onTap;

  const PaymentCard({Key key, this.paymentDto, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      margin: EdgeInsets.symmetric(vertical: 14, horizontal: 14.5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18.5),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
                color: paymentDto.id.isEven
                    ? AppColors.orangeColor.withOpacity(0.2)
                    : AppColors.blueAccentColor.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 18)
          ],
          borderRadius: BorderRadius.circular(14)),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    paymentDto.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                        color: paymentDto.id.isEven
                            ? AppColors.orangeColor
                            : AppColors.blueAccentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: size.longestSide / 43),
                  ),
                ),
                Text(
                  "اسم البنك",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.cairo(
                      color: AppColors.blackColor.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: size.longestSide / 43),
                ),
              ],
            ),
            Divider(
              color: AppColors.grey.withOpacity(0.2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.8,
                  height: size.height * 0.2,
                  child: SharedCachedNetworkImage.getCachedNetworkImage(
                      showPlaceHolder: false,
                      imageUrl:
                          NetworkUtils.MEDIA_API + "${paymentDto.logoID}"),
                ),
              ],
            ),
            Divider(
              color: AppColors.grey.withOpacity(0.1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    paymentDto.description,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                        color: AppColors.blackColor.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: size.longestSide / 43),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
