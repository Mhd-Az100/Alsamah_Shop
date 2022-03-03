class AddressDto {
  int id;
  String country;
  String state;
  String city;
  String area;
  String description;
  String userFullName;
  String userMobile;

  String geoLocation;

  AddressDto(
      {this.id,
      this.country,
      this.state,
      this.userFullName,
      this.userMobile,
      this.city,
      this.area,
      this.geoLocation,
      this.description});

  AddressDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    userMobile = json['userMobile'];
    state = json['state'];
    userFullName = json['userFullName'];
    geoLocation = json['geoLocation'];
    city = json['city'];
    area = json['area'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country'] = this.country;
    data['state'] = this.state;
    data['userMobile'] = this.userMobile;
    data['userFullName'] = this.userFullName;
    data['geoLocation'] = this.geoLocation;
    data['city'] = this.city;
    data['area'] = this.area;

    data['description'] = this.description;

    return data;
  }
}
