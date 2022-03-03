import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/instance_manager.dart';
import 'package:waslcom/core/models/fcm_models.dart';
import 'package:waslcom/core/repos/notification_repo.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/core/utils/messages_util.dart';

class NotificationService {
  final StorageService storage = Get.find();

  StreamController<NotificationDataModel> newNotificationsStream =
      StreamController.broadcast();

  static Map<String, String> headers = {
    "accept": "application/json",
    "Content-Type": "application/json"
  };

  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      await _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    if (storage.isCompleteLoginAccount) {
      /// handle [Refreshed] token
      _fcm.onTokenRefresh.listen(NotificationRepository.sentFcmToken);

      /// send token to the [Api]
      String fcmToken = await _fcm.getToken();
      await NotificationRepository.sentFcmToken(fcmToken)
          .then((commonResponse) {});
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        _handleNewnotificationMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _handleNewnotificationMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _handleNewnotificationMessage(message);
      },
    );
  }

  void _handleNewnotificationMessage(Map<String, dynamic> message) {
    log(message.toString(), name: "Notification message");
    try {
      /// convert message from [Map<dynamic, dynamic>] to [Map<String, dynamic>]
      var _data = Map<String, dynamic>.from(message["data"]) ?? {};
      var _notification =
          Map<String, dynamic>.from(message["notification"]) ?? {};

      ///
      ///
      ///
      ///
      ///
      /// just [logging]
      if (_data.isNotEmpty)
        log(
          _data.toString(),
          name: 'data debug:',
          level: 3,
        );
      if (_notification.isNotEmpty)
        log(
          _notification.toString(),
          name: 'notification debug:',
          level: 3,
        );

      ///
      ///
      ///
      ///
      ///
      ///
      /// converting recieved json to [NotificationDataModel]
      NotificationDataModel _notificationObject;
      if (_data?.isNotEmpty ?? false) {
        _notificationObject = NotificationDataModel.fromJson(_data);
      }
      FcmNotificationModel _fcmNotificationObject;
      if (_notification?.isNotEmpty ?? false) {
        _fcmNotificationObject = FcmNotificationModel.fromJson(_notification);
      }

      ///
      ///
      ///
      ///
      ///
      /// show notification [Toast] in the top of screen
      if (_notificationObject?.status?.isNotEmpty ?? false)
        MessagesUtil.showNotification(
            model: _notificationObject, duration: 240);
      if ((_fcmNotificationObject?.title?.isNotEmpty ?? false) &&
          (_notificationObject?.status?.isEmpty ?? false))
        MessagesUtil.showFcmNotification(
            model: _fcmNotificationObject, duration: 240);

      ///
      ///
      ///
      ///
      ///
      ///
      ///
      /// [Notify] all [listeners] that there is a new [notification]
      newNotificationsStream.add(_notificationObject);
    } catch (e) {
      e.toString().getLog(loggerName: "Notification initializer error");
    }
  }
}
