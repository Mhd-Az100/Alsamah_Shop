import 'package:get/get_core/get_core.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waslcom/core/repos/auth_repo.dart';
import 'package:waslcom/core/services/auto_sign_in_service.dart';
import 'package:waslcom/core/services/deviceId_service.dart';
import 'package:waslcom/core/services/notification_service.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/ui/views/orders/orders_view_controller.dart';
import 'package:waslcom/ui/views/shopping_cart_view/shopping_cart_view_controller.dart';

setupLocator() async {
  await GetStorage.init();
  Get.put(ShoppingCartController());
  Get.put(StorageService());
  Get.put(AuthRepository());
  Get.put(DeviceIdService());
  Get.put(NotificationService());
  Get.put(AutoSignInService());
  Get.put(OrdersViewController());
}
