import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/models/billing_address_dto.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';

class BillingAddressWidgetForProfile extends StatelessWidget {
  final Function addNewAddress;
  final BillingAddressDto billingAddressDto;

  const BillingAddressWidgetForProfile(
      {Key key, this.addNewAddress, this.billingAddressDto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.38,
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
          if (Get.find<StorageService>()?.getCurrencyInfo()?.name != null ??
              false) ...[
            Icon(
              Icons.payment_outlined,
              color: AppColors.blackColor.withOpacity(0.4),
              size: size.longestSide / 10,
            ),
            Flexible(
              child: SizedBox(
                height: size.height * 0.01,
              ),
            ),
            Container(
              width: size.width * 0.7,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                Get.find<StorageService>().getCurrencyInfo().name,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                    fontSize: size.longestSide / 40,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blueAccentColor),
              ),
            ),
          ],
          Flexible(
            flex: 2,
            child: Container(
                width: size.width * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  billingAddressDto?.description ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                      fontSize: size.longestSide / 40,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey500Color),
                )),
          ),
          Flexible(
            child: SizedBox(
              height: size.height * 0.01,
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: LinearGradientButton(
              onTap: addNewAddress,
              title: "تعديل معلومات الحساب",
              titleStyle:
                  GoogleFonts.cairo(fontSize: 22, color: AppColors.whiteColor),
              colorsList: AppColors.addAddressButton,
            ),
          ),
        ],
      ),
    );
  }
}

class AddNewAddressWidget extends StatelessWidget {
  final Function onTap;

  const AddNewAddressWidget({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.5, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 14.5, vertical: 12),
      width: size.width * 0.9,
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
      child: InkWell(
        onTap: onTap,
        child: Icon(
          Icons.add_circle_outline,
          color: AppColors.grey500Color.withOpacity(0.2),
          size: size.longestSide / 8,
        ),
      ),
    );
  }
}
