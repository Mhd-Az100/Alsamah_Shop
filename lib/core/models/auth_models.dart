class AuthSuccessModel {
  String status;
  String token;
  String validTo;
  String userName;
  String password;

  AuthSuccessModel(
      {this.status, this.token, this.validTo, this.userName, this.password});

  AuthSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    validTo = json['validTo'];
    userName = json['userName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    data['validTo'] = this.validTo;
    data['userName'] = this.userName;
    data['password'] = this.password;
    return data;
  }
}

class AuthWrongModel {
  int statusCode;
  String message;
  String url;
  String method;
  Null model;
  Null innerError;

  AuthWrongModel(
      {this.statusCode,
      this.message,
      this.url,
      this.method,
      this.model,
      this.innerError});

  AuthWrongModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    url = json['url'];
    method = json['method'];
    model = json['model'];
    innerError = json['innerError'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['url'] = this.url;
    data['method'] = this.method;
    data['model'] = this.model;
    data['innerError'] = this.innerError;
    return data;
  }
}
