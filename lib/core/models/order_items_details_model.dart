// To parse this JSON data, do
//
//     final orderItemDetailsModel = orderItemDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderItemDetailsModel orderItemDetailsModelFromJson(String str) =>
    OrderItemDetailsModel.fromJson(json.decode(str));

String orderItemDetailsModelToJson(OrderItemDetailsModel data) =>
    json.encode(data.toJson());

class OrderItemDetailsModel {
  OrderItemDetailsModel({
    this.id,
    this.description,
    this.userId,
    this.orderItems,
    this.fees,
    this.tax,
    this.deliveryFees,
    this.totalPrice,
    this.billingAddressId,
    this.shippingAddressId,
    this.distributionPointId,
    this.currencyCode,
    this.dateTime,
    this.couponCode,
    this.paymentReceipts,
    this.orderAttributes,
    this.status,
    this.notes,
  });

  int id;
  String description;
  String userId;
  List<OrderItem> orderItems;
  int fees;
  int tax;
  double deliveryFees;
  double totalPrice;
  int billingAddressId;
  int shippingAddressId;
  int distributionPointId;
  String currencyCode;
  DateTime dateTime;
  dynamic couponCode;
  List<dynamic> paymentReceipts;
  List<dynamic> orderAttributes;
  String status;
  String notes;
  factory OrderItemDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderItemDetailsModel(
        id: json["id"],
        description: json["description"],
        userId: json["userID"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
        fees: json["fees"],
        tax: json["tax"],
        deliveryFees: double.parse(json["deliveryFees"].toString()),
        totalPrice: double.parse(json["totalPrice"].toString()),
        billingAddressId: json["billingAddressID"],
        shippingAddressId: json["shippingAddressID"],
        distributionPointId: json["distributionPointID"],
        currencyCode: json["currencyCode"],
        dateTime: DateTime.parse(json["dateTime"]),
        couponCode: json["couponCode"],
        paymentReceipts:
            List<dynamic>.from(json["paymentReceipts"].map((x) => x)),
        orderAttributes:
            List<dynamic>.from(json["orderAttributes"].map((x) => x)),
        status: json["status"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "userID": userId,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "fees": fees,
        "tax": tax,
        "deliveryFees": deliveryFees,
        "totalPrice": totalPrice,
        "billingAddressID": billingAddressId,
        "shippingAddressID": shippingAddressId,
        "distributionPointID": distributionPointId,
        "currencyCode": currencyCode,
        "dateTime": dateTime.toIso8601String(),
        "couponCode": couponCode,
        "paymentReceipts": List<dynamic>.from(paymentReceipts.map((x) => x)),
        "orderAttributes": List<dynamic>.from(orderAttributes.map((x) => x)),
        "status": status,
        "notes": notes,
      };
}

class OrderItem {
  OrderItem({
    this.id,
    this.description,
    this.productId,
    this.product,
    this.price,
    this.quantity,
    this.notes,
    this.orderId,
    this.refundId,
  });

  int id;
  String description;
  int productId;
  Product product;
  double price;
  int quantity;
  dynamic notes;
  int orderId;
  dynamic refundId;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        description: json["description"],
        productId: json["productID"],
        product: Product.fromJson(json["product"]),
        price: double.parse(json["price"].toString()),
        quantity: json["quantity"],
        notes: json["notes"],
        orderId: json["orderID"],
        refundId: json["refundID"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "productID": productId,
        "product": product.toJson(),
        "price": price,
        "quantity": quantity,
        "notes": notes,
        "orderID": orderId,
        "refundID": refundId,
      };
}

class Product {
  Product({this.imageId, this.name, this.unit});

  int imageId;
  String name;
  String unit;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        imageId: json["imageID"],
        name: json["name"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "imageID": imageId,
        "name": name,
        "unit": unit,
      };
}
