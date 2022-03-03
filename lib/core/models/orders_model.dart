class OrdersDto {
  int id;
  String description;
  String userID;
  List<OrderItems> orderItems;
  int fees;
  int tax;
  double deliveryFees;
  String totalPrice;
  int billingAddressID;
  int shippingAddressID;
  String currencyCode;
  String dateTime;
  String couponCode;
  String status;
  String notes;

  OrdersDto(
      {this.id,
      this.description,
      this.userID,
      this.orderItems,
      this.fees,
      this.tax,
      this.deliveryFees,
      this.totalPrice,
      this.billingAddressID,
      this.shippingAddressID,
      this.currencyCode,
      this.dateTime,
      this.couponCode,
      this.status,
      this.notes});

  OrdersDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    userID = json['userID'];
    if (json['orderItems'] != null) {
      orderItems = new List<OrderItems>();
      json['orderItems'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    fees = json['fees'] as int;
    tax = json['tax'] as int;
    deliveryFees = double.parse(json['deliveryFees'].toString());
    totalPrice = json['totalPrice'].toString();
    billingAddressID = json['billingAddressID'];
    shippingAddressID = json['shippingAddressID'];
    currencyCode = json['currencyCode'];
    dateTime = json['dateTime'];
    couponCode = json['couponCode'];
    status = json['status'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['userID'] = this.userID;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    data['fees'] = this.fees;
    data['tax'] = this.tax;
    data['deliveryFees'] = this.deliveryFees;
    data['totalPrice'] = this.totalPrice;
    data['billingAddressID'] = this.billingAddressID;
    data['shippingAddressID'] = this.shippingAddressID;
    data['currencyCode'] = this.currencyCode;
    data['dateTime'] = this.dateTime;
    data['couponCode'] = this.couponCode;
    data['status'] = this.status;
    data['notes'] = this.notes;
    return data;
  }
}

class OrderItems {
  int id;
  String description;
  int productID;
  String price;
  int quantity;
  String notes;
  int orderID;
  int refundID;

  OrderItems(
      {this.id,
      this.description,
      this.productID,
      this.price,
      this.quantity,
      this.notes,
      this.orderID,
      this.refundID});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    productID = json['productID'];
    price = json['price'].toString();
    quantity = json['quantity'];
    notes = json['notes'];
    orderID = json['orderID'];
    refundID = json['refundID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['productID'] = this.productID;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['notes'] = this.notes;
    data['orderID'] = this.orderID;
    data['refundID'] = this.refundID;
    return data;
  }
}
