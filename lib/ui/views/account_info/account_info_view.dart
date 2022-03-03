import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:waslcom/core/models/billing_address_dto.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_files/font_styles.dart';
import 'package:waslcom/ui/shared_widgets/buttons_widgets.dart';
import 'package:waslcom/ui/shared_widgets/text_widgets.dart';
import 'package:waslcom/ui/views/store_views/store_widgets/app_bars.dart';

import 'account.info_widget.dart';
import 'account_info_view_controller.dart';

class AccountInfoView extends StatelessWidget {
  final BillingAddressDto billingAddressDto;

  AccountInfoView({
    Key key,
    this.billingAddressDto,
  }) : super(key: key);

  final bool fromLogIn =
      GeneralUtils.getStorageService.isCompleteLoginAccountButNoCurrencies;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: StoreAppBars.completeAccountInfo(context, size,
          editMode: billingAddressDto != null),
      body: GetBuilder<AccountInfoViewController>(
          init: AccountInfoViewController(),
          builder: (controller) {
            controller.billingAddressDtoSet = billingAddressDto;
            return Form(
              key: controller.key,
              autovalidateMode: controller.autoValidateMode,
              child: ListView(
                children: [
                  SelectCurrencyWidget(
                    currencyDto: controller.currencyDto,
                    onTap: () => controller.getAllCurrencies(),
                    showOnlyMode: controller.autoSetCurrencyMode,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  if (!fromLogIn) ...[
                    CustomTextWidget(
                      padding: EdgeInsets.symmetric(horizontal: 14.0)
                          .copyWith(bottom: size.height * 0.02),
                      labelText: "الاسم الكامل",
                      controller: controller.fullNameController,
                      inputTextStyle: headLine_2(),
                      keyBoardType: TextInputType.text,
                      validator: controller.validateField,
                    ),
                    CustomTextWidget(
                      padding: EdgeInsets.symmetric(horizontal: 14.0)
                          .copyWith(bottom: size.height * 0.02),
                      labelText: "البلد",
                      controller: controller.countryController,
                      inputTextStyle: headLine_2(),
                      keyBoardType: TextInputType.text,
                      validator: controller.validateField,
                    ),
                    CustomTextWidget(
                      padding: EdgeInsets.symmetric(horizontal: 14.0)
                          .copyWith(bottom: size.height * 0.02),
                      labelText: "المدينة",
                      controller: controller.cityController,
                      inputTextStyle: headLine_2(),
                      keyBoardType: TextInputType.text,
                      validator: controller.validateField,
                    ),
                    CustomTextWidget(
                      padding: EdgeInsets.symmetric(horizontal: 14.0)
                          .copyWith(bottom: size.height * 0.02),
                      labelText: "  وصف العنوان",
                      textAlign: TextAlign.end,
                      controller: controller.addressDescriptionController,
                      inputTextStyle: headLine_2(),
                      keyBoardType: TextInputType.text,
                      validator: controller.validateField,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                  ],
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: LinearGradientButton(
                      title: "حفظ المعلومات",
                      onTap: () => controller.saveAccountInfo(fromLogIn),
                      colorsList: AppColors.blueButtonColor,
                      titleStyle: btnTextStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () => GeneralUtils.getStorageService.fullLogOut(),
                    child: Text(
                      "هل تريد تسجيل الخروج ؟",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, decoration: TextDecoration.overline),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
