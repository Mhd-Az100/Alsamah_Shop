class PaymentDto {
  int id;
  String title;
  String description;
  String country;
  Logo logo;
  int logoID;
  String notes;

  PaymentDto(
      {this.id,
      this.title,
      this.description,
      this.country,
      this.logo,
      this.logoID,
      this.notes});

  PaymentDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    country = json['country'];
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    logoID = json['logoID'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['country'] = this.country;
    if (this.logo != null) {
      data['logo'] = this.logo.toJson();
    }
    data['logoID'] = this.logoID;
    data['notes'] = this.notes;
    return data;
  }
}

class Logo {
  int id;
  String description;
  String type;
  String contentType;
  String title;
  String path;
  String originalFileName;
  int sequence;
  String notes;

  Logo(
      {this.id,
      this.description,
      this.type,
      this.contentType,
      this.title,
      this.path,
      this.originalFileName,
      this.sequence,
      this.notes});

  Logo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    type = json['type'];
    contentType = json['contentType'];
    title = json['title'];
    path = json['path'];
    originalFileName = json['originalFileName'];
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
    data['path'] = this.path;
    data['originalFileName'] = this.originalFileName;
    data['sequence'] = this.sequence;
    data['notes'] = this.notes;
    return data;
  }
}
