class OrderParameterModel {
  String description;
  String userID;
  List<OrderItems> orderItems;
  int shippingAddressID;
  String coupon;
  String notes;
  String currencyCode;
  List<OrderAttribute> orderAttributes;
  int billingAddressID;

  OrderParameterModel(
      {this.description,
      this.userID,
      this.orderItems,
      this.billingAddressID,
      this.currencyCode,
      this.shippingAddressID,
      this.orderAttributes,
      this.coupon,
      this.notes});

  OrderParameterModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    userID = json['userID'];
    if (json['orderItems'] != null) {
      orderItems = new List<OrderItems>();
      json['orderItems'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    if (json['orderItems'] != null) {
      orderItems = new List<OrderItems>();
      json['orderItems'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    orderAttributes = new List<OrderAttribute>();
    json['orderAttributes'].forEach((v) {
      orderAttributes.add(new OrderAttribute.fromJson(v));
    });
    shippingAddressID = json['shippingAddressID'];
    currencyCode = json['currencyCode'];
    billingAddressID = json['billingAddressID'];
    coupon = json['coupon'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['userID'] = this.userID;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    data['shippingAddressID'] = this.shippingAddressID;
    data['billingAddressID'] = this.billingAddressID;
    data['currencyCode'] = this.currencyCode;
    data['coupon'] = this.coupon;
    data['notes'] = this.notes;
    data['orderAttributes'] =
        List<dynamic>.from(orderAttributes.map((x) => x.toJson()));
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class OrderItems {
  String description;
  int productID;
  int quantity;
  String notes;

  OrderItems({this.description, this.productID, this.quantity, this.notes});

  OrderItems.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    productID = json['productID'];
    quantity = json['quantity'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['productID'] = this.productID;
    data['quantity'] = this.quantity;
    data['notes'] = this.notes;
    return data;
  }
}

class OrderAttribute {
  OrderAttribute({
    this.key,
    this.value,
    this.description,
    this.notes,
  });

  String key;
  String value;
  String description;
  String notes;

  OrderAttribute.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    key = json['key'];
    value = json['value'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['description'] = this.description;
    data['notes'] = this.notes;
    return data;
  }
}
