class CategoriesModel {
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

  CategoriesModel({
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
  });

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    imageID = json['imageID'];
    parentCategoryID = json['parentCategoryID'];
    storeID = json['storeID'];
    sequence = json['sequence'];
    disabled = json['disabled'];
    hidden = json['hidden'];
    description = json['description'];
    notes = json['notes'];
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
    data['hidden'] = this.hidden;
    data['description'] = this.description;
    data['notes'] = this.notes;

    return data;
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
