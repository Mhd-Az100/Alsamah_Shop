import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import 'package:waslcom/ui/views/auth_views/firebase_auth/firebase_auth_controller.dart';
import 'package:waslcom/ui/views/auth_views/firebase_auth/logIn/firebase_auth_view.dart';
import 'package:waslcom/ui/views/auth_views/firebase_auth/vefification/firebase_verification_view.dart';

class FirebaseAuth extends StatelessWidget {
  const FirebaseAuth({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirebaseAuthController>(
        init: FirebaseAuthController(),
        builder: (controller) {
          return InheritedProvider<FirebaseAuthController>.value(
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
                    ? FirebaseAuthView()
                    : FirebaseVerificationView(),
              ),
            ),
          );
        });
  }
}
