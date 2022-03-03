enum NavBarEnum {
  SearchView,
  StoreView,
  Offers,
  OrdersView,
  ShoppingCartView,
}

enum NotificationStatusEnum {
  WaitingForPayment,
  PaymentRejected,
  Pending,
  Packaging,
  Delivering,
  Done,
  CustomerCanceled,
  Canceled,
}

extension ArabicStatus on NotificationStatusEnum {
  static const values = {
    NotificationStatusEnum.WaitingForPayment: "بانتظار عملية الدفع",
    NotificationStatusEnum.PaymentRejected: "تم رفض عملية الدفع",
    NotificationStatusEnum.Pending: "تم استلام الطلب",
    NotificationStatusEnum.Packaging: "يتم الآن العمل",
    NotificationStatusEnum.Delivering: "قيد التوصيل",
    NotificationStatusEnum.Done: "تم التوصيل",
    NotificationStatusEnum.Canceled: "تم ايقاف الطلب",
    NotificationStatusEnum.CustomerCanceled: "ملغى من قبلي",
  };

  String get typedValue => values[this];
}

enum MessageType {
  SuccessMessage,
  ErrorMessage,
}
