import 'package:get/get.dart';
import 'package:waslcom/core/repos/app_properties_repo.dart';
import 'package:waslcom/core/services/auto_sign_in_service.dart';
import 'package:waslcom/core/services/notification_service.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/views/account_info/account_info_view.dart';
import 'package:waslcom/ui/views/auth_views/mtn_auth/mtn_auth_view.dart';
import 'package:waslcom/ui/views/store_views/main_store_view/main_store_view.dart';

class SplashViewController extends GetxController {
  StorageService storageService = Get.find();
  void navigateToProperRoute() async {
    ///For sync functions like navigation, assignments ... ect
    await Future.delayed(Duration(seconds: 2));

    if (storageService.getAccountType() ==
        StorageService.Complete_Login_Account) {
      await Get.find<NotificationService>().initialise();
      await Get.find<AutoSignInService>().mtnAutoLogin(() {
        Get.off(() => MainStoreView());
      });
    } else if (storageService.getAccountType() ==
        StorageService.Guest_Account) {
      Get.off(() => MainStoreView());
    } else if (storageService.getAccountType() ==
            StorageService.Not_Complete_Login_Account ||
        storageService.getAccountType() ==
            StorageService.Complete_Login_Account_But_No_Currencies) {
      Get.off(() => AccountInfoView());
    } else {
      // Get.find<LoginViewController>().statusLogin != 'true'
      // ?
      Get.off(() => MtnAuthView());
      //   :
      // Get.off(() => LoginView());
    }
  }

//check deliverytime
  var checkloginuser;
  void checkLoginUser() async {
    var check = await AppPropertiesRepo.onlyRigistryUser();
    checkloginuser = check;
    print('checkloginuser : $checkloginuser');
  }

  @override
  void onReady() {
    navigateToProperRoute();
    super.onReady();
  }

  @override
  void onInit() {
    checkLoginUser();
    super.onInit();
  }
}
