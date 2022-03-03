class FcmNotificationModel {
  String title;
  String body;

  FcmNotificationModel({this.title, this.body});

  FcmNotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

class NotificationDataModel {
  String status;
  String event;
  String orderID;

  NotificationDataModel({this.status, this.event, this.orderID});

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    event = json['Event'];
    orderID = json['OrderID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Event'] = this.event;
    data['OrderID'] = this.orderID;
    return data;
  }
}
// To parse this JSON data, do
//
//     final notifiactionList = notifiactionListFromJson(jsonString);

class NotifiactionList {
  NotifiactionList({
    this.forYou,
    this.topicNotifications,
  });

  List<ForYou> forYou;
  List<ForYou> topicNotifications;

  factory NotifiactionList.fromJson(Map<String, dynamic> json) =>
      NotifiactionList(
        forYou:
            List<ForYou>.from(json["forYou"].map((x) => ForYou.fromJson(x))),
        topicNotifications: List<ForYou>.from(
            json["topicNotifications"].map((x) => ForYou.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "forYou": List<dynamic>.from(forYou.map((x) => x.toJson())),
        "topicNotifications":
            List<dynamic>.from(topicNotifications.map((x) => x.toJson())),
      };
}

class ForYou {
  ForYou({
    this.id,
    this.title,
    this.text,
    this.imageUrl,
    this.topic,
    this.sendDate,
    this.status,
  });

  int id;
  String title;
  String text;
  String imageUrl;
  String topic;
  DateTime sendDate;
  String status;

  factory ForYou.fromJson(Map<String, dynamic> json) => ForYou(
        id: json["id"],
        title: json["title"],
        text: json["text"],
        imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
        topic: json["topic"],
        sendDate: DateTime.parse(json["sendDate"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "text": text,
        "imageUrl": imageUrl == null ? null : imageUrl,
        "topic": topic,
        "sendDate": sendDate.toIso8601String(),
        "status": status,
      };
}
