import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import 'package:waslcom/ui/views/auth_views/mtn_auth/login/mtn_login_view.dart';
import 'package:waslcom/ui/views/auth_views/mtn_auth/mtn_auth_view_controller.dart';
import 'package:waslcom/ui/views/auth_views/mtn_auth/verification/mtn_verification_view.dart';

class MtnAuthView extends StatelessWidget {
  const MtnAuthView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MtnAuthViewController>(
        init: MtnAuthViewController(),
        builder: (controller) {
          return InheritedProvider<MtnAuthViewController>.value(
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
                    ? MtnLoginView()
                    : MtnVerificationVerificationView(),
              ),
            ),
          );
        });
  }
}
