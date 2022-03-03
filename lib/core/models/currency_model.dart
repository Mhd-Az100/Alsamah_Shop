class CurrencyDto {
  int id;
  String name;
  String country;
  String code;
  String symbol;
  num price;
  bool primary;
  bool disabled;
  String description;
  String notes;

  CurrencyDto(
      {this.id,
      this.name = "",
      this.country = "",
      this.code = "",
      this.symbol = "",
      this.price = 1,
      this.primary,
      this.disabled,
      this.description,
      this.notes});

  CurrencyDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    code = json['code'];
    symbol = json['symbol'];
    price = json['price'];
    primary = json['primary'];
    disabled = json['disabled'];
    description = json['description'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country'] = this.country;
    data['code'] = this.code;
    data['symbol'] = this.symbol;
    data['price'] = this.price;
    data['primary'] = this.primary;
    data['disabled'] = this.disabled;
    data['description'] = this.description;
    data['notes'] = this.notes;
    return data;
  }
}
