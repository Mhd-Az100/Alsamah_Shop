import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:connection_verify/connection_verify.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/enums.dart';
import 'package:waslcom/core/models/fcm_models.dart';
import 'package:waslcom/core/models/order_items_details_model.dart';
import 'package:waslcom/core/models/orders_model.dart';
import 'package:waslcom/core/repos/orders_repo.dart';
import 'package:waslcom/core/repos/payment_account_repo.dart';
import 'package:waslcom/core/services/notification_service.dart';
import 'package:waslcom/core/utils/get_file_from_assets_util.dart';
import 'package:waslcom/core/utils/messages_util.dart';

class OrdersViewController extends GetxController {
  ///---------------------------------------------------------------------------

  ///Loading indicator

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoadingSet(bool value) {
    _isLoading = value;
    update();
  }

  ///---------------------------------------------------------------------------
  ///Connection error indicator

  bool _connectionError = false;

  bool get connectionError => _connectionError;

  set connectionErrorSet(bool value) {
    _connectionError = value;
    update();
  }

  ///---------------------------------------------------------------------------
  ///Get Address info List
  var ordersList = <OrdersDto>[];

  void getAllOrders() async {
    try {
      isLoadingSet = true;
      ordersList = await OrderRepository.getAllOrders();
    } catch (e) {
      log(e.toString(), name: "getAllOrders controller error");
    } finally {
      isLoadingSet = false;
    }
  }

  OrdersDto getData(index) => ordersList[index];

  ///---------------------------------------------------------------------------
  NotificationService _notificationService = Get.find<NotificationService>();
  StreamSubscription<NotificationDataModel> notificationStreamSubscription;

  void listenToNewNotification() {
    notificationStreamSubscription = _notificationService
        .newNotificationsStream.stream
        .listen((notification) {
      getAllOrders();
    });
  }

  ///---------------------------------------------------------------------------
  ///Cash payment
  Future cashPayment(int orderNumber) async {
    Get.back();

    ///
    try {
      BotToast.showLoading();
      var _cashImgFile = await AssetsUtils.getCashImagePath();
      bool _successUpload = await PaymentAccountRepository.uploadPaymentReceipt(
          _cashImgFile.absolute.path, orderNumber);
      if (_successUpload) {
        getAllOrders();
        MessagesUtil.showCustomMessage(
            messageType: MessageType.SuccessMessage,
            duration: 3,
            message: "تم استلام الطلب بنجاح");
      } else
        BotToast.showText(
            text: "حدثت مشكلة في عملية إكمال الطلب يرجى المحاولة في وقت لاحق");
    } catch (e) {
      print(e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  ///---------------------------------------------------------------------------
  // get order details
  Rx<OrderItemDetailsModel> orderitemdet = OrderItemDetailsModel().obs;
  getOrderitems(String id) async {
    var orderitems = await OrderRepository.getorderitems(id);
    orderitemdet.value = orderitems;
  }

  ///---------------------------------------------------------------------------
  ///onInit
  @override
  void onInit() async {
    listenToNewNotification();
    connectionErrorSet = false;
    if (await ConnectionVerify.connectionStatus()) {
      getAllOrders();
    } else {
      connectionErrorSet = true;
    }

    super.onInit();
  }

  @override
  void dispose() {
    notificationStreamSubscription?.cancel();
    super.dispose();
  }
}
