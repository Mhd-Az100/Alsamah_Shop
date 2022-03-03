import 'package:waslcom/core/models/subcategories_products_model.dart';

class ShoppingCartModel {
  int id;
  String name;
  int imageID;
  int quantity;
  int maxQuantity;
  int minQuantity;
  String description;
  String notes;
  String unit;
  double unitPrice;
  SubCategoriesAndProductsModel originalProductModel;

  ShoppingCartModel({
    this.id,
    this.name,
    this.originalProductModel,
    this.quantity,
    this.maxQuantity,
    this.minQuantity,
    this.imageID,
    this.description,
    this.unitPrice,
    this.notes,
    this.unit,
  });

  ShoppingCartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitPrice = json['unitPrice'];
    unit = json['unit'];
    maxQuantity = json['maxQuantity'];
    minQuantity = json['minQuantity'];
    quantity = json['quantity'];
    name = json['name'];
    imageID = json['imageID'];
    description = json['description'];
    notes = json['notes'];
    originalProductModel = json['originalProductModel'] != null
        ? new SubCategoriesAndProductsModel.fromJson(json['originalProductModel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['maxQuantity'] = this.maxQuantity;
    data['minQuantity'] = this.minQuantity;
    data['unit'] = this.unit;
    data['name'] = this.name;
    data['imageID'] = this.imageID;
    data['description'] = this.description;
    data['notes'] = this.notes;
    data['originalProductModel'] = this.originalProductModel.toJson();

    return data;
  }

  double get totalProductPrice => quantity * unitPrice;
}
