class BillingAddressDto {
  int id;
  String userFullName;
  String userMobile;
  String country;

  String city;

  String geoLocation;

  String description;

  BillingAddressDto({
    this.id,
    this.userFullName,
    this.userMobile,
    this.country,
    this.city,
    this.geoLocation,
    this.description,
  });

  BillingAddressDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userFullName = json['userFullName'];
    userMobile = json['userMobile'];
    country = json['country'];
    city = json['city'];
    geoLocation = json['geoLocation'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userFullName'] = this.userFullName;
    data['userMobile'] = this.userMobile;
    data['country'] = this.country;
    data['city'] = this.city;
    data['geoLocation'] = this.geoLocation;
    data['description'] = this.description;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
