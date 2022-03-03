class OrderStatus {
  static const Pending = "Pending";
  static const Packaging = "Packaging";
  static const Delivering = "Delivering";
  static const Done = "Done";
  static const Canceled = "Canceled";
  static const WaitingForPayment = "WaitingForPayment";
  static const PaymentRejected = "PaymentRejected";
  static const CustomerCanceled = "CustomerCanceled";

  static const PendingId = 1;
  static const PackagingId = 2;
  static const DeliveringId = 3;
  static const DoneId = 4;
}

class ErrorsLocal {
  static const LocationServiceDisabled =
      "The location service on the device is disabled.";
}
