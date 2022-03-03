// To parse this JSON data, do
//
//     final deliveryfess = deliveryfessFromJson(jsonString);

import 'dart:convert';

Deliveryfess deliveryfessFromJson(String str) =>
    Deliveryfess.fromJson(json.decode(str));

String deliveryfessToJson(Deliveryfess data) => json.encode(data.toJson());

class Deliveryfess {
  Deliveryfess({
    this.deliveryFees,
    this.currencyCode,
  });

  double deliveryFees;
  String currencyCode;

  factory Deliveryfess.fromJson(Map<String, dynamic> json) => Deliveryfess(
        deliveryFees: json["deliveryFees"].toDouble(),
        currencyCode: json["currencyCode"],
      );

  Map<String, dynamic> toJson() => {
        "deliveryFees": deliveryFees,
        "currencyCode": currencyCode,
      };
}
