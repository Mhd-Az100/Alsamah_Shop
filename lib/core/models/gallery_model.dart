class GalleryModel {
  int id;
  String title;
  String description;
  int sequence;
  Media media;
  int mediaID;
  String type;
  String target;
  bool disabled;
  String notes;

  GalleryModel(
      {this.id,
      this.title,
      this.description,
      this.sequence,
      this.media,
      this.mediaID,
      this.type,
      this.target,
      this.disabled,
      this.notes});

  GalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    sequence = json['sequence'];
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    mediaID = json['mediaID'];
    type = json['type'];
    target = json['target'];
    disabled = json['disabled'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['sequence'] = this.sequence;
    if (this.media != null) {
      data['media'] = this.media.toJson();
    }
    data['mediaID'] = this.mediaID;
    data['type'] = this.type;
    data['target'] = this.target;
    data['disabled'] = this.disabled;
    data['notes'] = this.notes;
    return data;
  }
}

class Media {
  int id;
  String description;
  String type;
  String contentType;
  String title;
  int sequence;
  String notes;

  Media(
      {this.id,
      this.description,
      this.type,
      this.contentType,
      this.title,
      this.sequence,
      this.notes});

  Media.fromJson(Map<String, dynamic> json) {
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
