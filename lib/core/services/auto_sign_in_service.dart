import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/instance_manager.dart';
import 'package:waslcom/core/repos/auth_repo.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';

class AutoSignInService {
  final StorageService storageService = Get.find<StorageService>();
  final AuthRepository _authRepository = Get.find();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //
  PhoneAuthCredential _phoneAuthCredential;
  String _verificationId;

  Future mtnAutoLogin(Function splashSyncFunctions) async {
    if (storageService.isCompleteLoginAccount) {
      try {
        bool _authenticated = await _authRepository.testAuth();
        if (!_authenticated) {
          _authRepository
              .registerByMtn(
                  phoneNumber: storageService.getTokenInfo().userName.trim(),
                  autoLoginMode: true)
              .then((value) {
            splashSyncFunctions();
          });
        } else {
          splashSyncFunctions();
        }
      } catch (e) {
        e.toString().getLog(loggerName: "mtnAutoLogin function error");
      }
    }
  }
}
