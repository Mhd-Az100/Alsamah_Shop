import 'dart:developer';

import 'package:get/get.dart';
import 'package:waslcom/core/models/fcm_models.dart';
import 'package:waslcom/core/repos/notification_repo.dart';

class NotificationListController extends GetxController {
  var _notificationlist = <NotifiactionList>[];
  List<NotifiactionList> get notificationlist => _notificationlist;
  void getAllAddress() async {
    try {
      var notiflst = await NotificationRepository.getNotificationList();
      _notificationlist = List.from(notiflst.reversed);
    } catch (e) {
      log(e.toString(), name: "getNotifiactionList controller  error");
    }
  }
}
