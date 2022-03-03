import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import 'package:waslcom/ui/views/auth_views/mtn_auth%20merchant/login/mtn_login_view.dart';
import 'package:waslcom/ui/views/auth_views/mtn_auth%20merchant/mtn_auth_view_controller.dart';
import 'package:waslcom/ui/views/auth_views/mtn_auth%20merchant/verification/mtn_verification_view.dart';

class MtnAuthViewMerchant extends StatelessWidget {
  const MtnAuthViewMerchant({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MtnAuthViewMerchantController>(
        init: MtnAuthViewMerchantController(),
        builder: (controller) {
          return InheritedProvider<MtnAuthViewMerchantController>.value(
            value: controller,
            child: Form(
              key: controller.key,
              autovalidateMode: controller.autoValidateMode,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                reverseDuration: Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.vertical,
                  axisAlignment: -1,
                  child: child,
                ),
                child: controller.viewIndex == 0
                    ? MtnLoginViewMarchent()
                    : MtnVerificationMerchantView(),
              ),
            ),
          );
        });
  }
}
