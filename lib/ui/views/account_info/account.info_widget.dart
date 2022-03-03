import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/models/currency_model.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';

class BillingAddressWidget extends StatelessWidget {
  final Function addNewBillingAddress;

  const BillingAddressWidget({
    Key key,
    this.addNewBillingAddress,
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
            Icons.error_outline_sharp,
            color: AppColors.blackColor.withOpacity(0.4),
            size: size.longestSide / 10,
          ),
          Flexible(
            child: SizedBox(
              height: size.height / 35,
            ),
          ),
          Container(
            width: size.width * 0.7,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "من فضلك قم باضافة عنوان واحد على الاقل للتواصل",
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
              onTap: addNewBillingAddress,
              title: "اضافة عنوان",
              colorsList: AppColors.addAddressButton,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectCurrencyWidget extends StatelessWidget {
  final Function onTap;
  final CurrencyDto currencyDto;
  final bool showOnlyMode;

  const SelectCurrencyWidget({
    Key key,
    this.onTap,
    this.currencyDto,
    this.showOnlyMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: showOnlyMode ? size.height * 0.3: size.height * 0.4,
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
            Icons.payment,
            color: AppColors.blackColor.withOpacity(0.4),
            size: size.longestSide / 10,
          ),
          Flexible(
            child: SizedBox(
              height: size.height / 35,
            ),
          ),
          Container(
              width: size.width * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: getContent(size)),
          SizedBox(
            height: size.height / 35,
          ),
          if (!showOnlyMode)
            FractionallySizedBox(
              widthFactor: 0.9,
              child: LinearGradientButton(
                onTap: onTap,
                titleStyle: GoogleFonts.cairo(
                    color: AppColors.blue200Color,
                    fontSize: size.longestSide / 35),
                title: currencyDto != null
                    ? "تعديل عملة الدفع"
                    : "تحديد عملة الدفع",
                colorsList: currencyDto != null
                    ? AppColors.editButton
                    : AppColors.addAddressButton,
              ),
            ),
        ],
      ),
    );
  }

  Widget getContent(Size size) {
    Widget widget = Text(
      "قم باختيار عملة لاجراء عمليات الدفع بها",
      textAlign: TextAlign.center,
      style: GoogleFonts.cairo(
          fontSize: size.longestSide / 40,
          fontWeight: FontWeight.w300,
          color: AppColors.grey500Color),
    );
    if (currencyDto != null) {
      widget = Column(
        children: [
          Text(
            "العملة التي تم اختيارها للدفع",
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
                fontSize: size.longestSide / 40,
                fontWeight: FontWeight.w400,
                color: AppColors.grey500Color),
          ),
          Text(
            currencyDto.symbol + " " + currencyDto.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
                fontSize: size.longestSide / 40,
                fontWeight: FontWeight.w600,
                color: AppColors.blueAccentColor),
          ),
        ],
      );
    }
    return widget;
  }
}
