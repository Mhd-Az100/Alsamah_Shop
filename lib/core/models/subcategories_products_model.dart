import 'dart:developer';

import 'package:get/instance_manager.dart';
import 'package:waslcom/core/models/shopping_cart_model.dart';
import 'package:waslcom/core/services/storage_service.dart';
import 'package:waslcom/core/utils/general_utils.dart';

class SubCategoriesAndProductsModel {
  int id;
  String name;
  Image image;
  int imageID;
  int parentCategoryID;
  int storeID;
  int sequence;
  bool disabled;
  bool hidden;
  String description;
  String notes;
  String unit;
  List<SubCategoriesAndProductsModel> childrenCategories;
  int quantity;
  int minQuantity;
  double price;
  num oldPrice;
  bool isProduct;
  List<dynamic> productAttributes;
  SubCategoriesAndProductsModel({
    this.id,
    this.name,
    this.image,
    this.imageID,
    this.parentCategoryID,
    this.storeID,
    this.sequence,
    this.disabled,
    this.hidden,
    this.description,
    this.notes,
    this.unit,
    this.isProduct = false,
    this.childrenCategories,
    this.quantity,
    this.minQuantity,
    this.price,
    // this.productAttributes2,
  });

  SubCategoriesAndProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    imageID = json['imageID'];
    parentCategoryID = json['parentCategoryID'];
    storeID = json['storeID'];
    unit = json['unit'];
    quantity = json['quantity'] ?? 1;
    minQuantity = json['minQuantity'] ?? 1;
    sequence = json['sequence'];
    disabled = json['disabled'];
    hidden = json['hidden'];
    description = json['description'];
    notes = json['notes'];
    oldPrice = json['oldPrice'];
    if ((GeneralUtils.currencyInfo?.price != null) ?? false) {
      price = convertPriceToDouble(json['price'] ?? 0) *
          convertPriceToDouble(
              Get.find<StorageService>().getCurrencyInfo().price);
    } else {
      price = convertPriceToDouble(json['price'] ?? 0);
    }

    if (json['childrenCategories'] != null) {
      childrenCategories = new List<Null>();
      json['childrenCategories'].forEach((v) {
        childrenCategories.add(SubCategoriesAndProductsModel.fromJson(v));
      });
    }
    try {
      productAttributes =
          List<dynamic>.from(json["productAttributes"].map((x) => x));
    } catch (e) {
      log(e.toString(), name: "Get productAttribute fromjson error");
      productAttributes = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['imageID'] = this.imageID;
    data['parentCategoryID'] = this.parentCategoryID;
    data['storeID'] = this.storeID;
    data['sequence'] = this.sequence;
    data['disabled'] = this.disabled;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['minQuantity'] = this.minQuantity;
    data['unit'] = this.unit;
    data['hidden'] = this.hidden;
    data['description'] = this.description;
    data['notes'] = this.notes;
    if (this.childrenCategories != null) {
      data['childrenCategories'] =
          this.childrenCategories.map((v) => v.toJson()).toList();
    }
    data["productAttributes"] =
        List<dynamic>.from(productAttributes.map((x) => x));

    return data;
  }

  ///---------------------------------------------------------------------------
  ///To Shopping cart model
  ShoppingCartModel toShoppingCartModel({int newQty = 1}) {
    return ShoppingCartModel(
      name: name,
      id: this.id,
      description: this.description,
      quantity: newQty,
      imageID: this.imageID,
      notes: this.notes,
      unitPrice: this.price,
      unit: this.unit,
      minQuantity: this.minQuantity,
      maxQuantity: this.quantity,
      originalProductModel: this,
    );
  }

  ///---------------------------------------------------------------------------
  double convertPriceToDouble(dynamic price) {
    double _price = 0.0;
    if (price is int) {
      _price = price.toDouble();
    } else if (price is String) {
      _price = double.tryParse(price);
    } else if (price is double) {
      _price = price;
    } else {
      _price = double.tryParse(price.toString());
    }
    return _price;
  }
}

class Image {
  int id;
  String description;
  String type;
  String contentType;
  String title;
  int sequence;
  String notes;

  Image(
      {this.id,
      this.description,
      this.type,
      this.contentType,
      this.title,
      this.sequence,
      this.notes});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    type = json['type'];
    contentType = json['contentType'];
    title = json['title'];
    sequence = json['sequence'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['type'] = this.type;
    data['contentType'] = this.contentType;
    data['title'] = this.title;
    data['sequence'] = this.sequence;
    data['notes'] = this.notes;
    return data;
  }
}

class GlobalProductAttribute {
  GlobalProductAttribute({
    this.id,
    this.name,
    this.description,
    this.sequence,
  });

  int id;
  String name;
  dynamic description;
  int sequence;

  factory GlobalProductAttribute.fromJson(Map<String, dynamic> json) =>
      GlobalProductAttribute(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        sequence: json["sequence"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "sequence": sequence,
      };
}

class ProductAttribute {
  ProductAttribute({
    this.id,
    this.description,
    this.keyId,
    this.value,
  });

  int id;
  dynamic description;
  int keyId;
  String value;

  factory ProductAttribute.fromJson(Map<String, dynamic> json) =>
      ProductAttribute(
        id: json["id"],
        description: json["description"],
        keyId: json["keyID"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "keyID": keyId,
        "value": value,
      };
}
