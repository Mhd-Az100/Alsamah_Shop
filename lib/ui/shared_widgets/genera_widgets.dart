import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/core/models/currency_model.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';

class GeneralWidgets {
  static showModalSheet(
    BuildContext context,
    List<Widget> listTile, {
    bool hasATextFiled = false,
  }) =>
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                blurRadius: 18,
                spreadRadius: 1,
                color: AppColors.grey.withOpacity(0.2))
          ], color: AppColors.whiteColor),
          child: !hasATextFiled
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...listTile,
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...listTile,
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),
        ),
      );

  static showModalSheetForCurrencies(
          List<CurrencyDto> list, Function(CurrencyDto currencyDto) onTap) =>
      showModalBottomSheet(
          context: Get.context,
          builder: (context) => Container(
                height: 240,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 18,
                      spreadRadius: 1,
                      color: AppColors.grey.withOpacity(0.2))
                ], color: AppColors.whiteColor),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Get.back();
                      onTap(list[index]);
                    },
                    leading: Text(
                      list[index].symbol,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.orangeColor),
                    ),
                    title: Text(
                      list[index].name,
                      style: GoogleFonts.cairo(
                          color: AppColors.grey500Color, fontSize: 18),
                    ),
                  ),
                ),
              ));

  static ignoreWidget(Widget child, {bool ignore = true}) => Opacity(
        opacity: ignore ? 0.5 : 1,
        child: IgnorePointer(
          ignoring: ignore,
          child: child,
        ),
      );
}
