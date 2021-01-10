import 'package:goedit/models/user.dart';

class Message {
  String sId;
  String text;
  String createdAt;
  User reciever;
  User sender;
  // only used while sending
  String recieverId;

  Message({this.sId, this.text, this.createdAt, this.recieverId});

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    text = json['text'] != null ? json['text'] : '';
    createdAt = json['createdAt'];
    if (!(json['reciever'] is String)) {
      reciever =
          json['reciever'] != null ? new User.fromJson(json['reciever']) : null;
    }
    if (!(json['sender'] is String)) {
      sender =
          json['sender'] != null ? new User.fromJson(json['sender']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['_id'] = this.sId;
    data['text'] = this.text;
    data['user'] = this.recieverId;
    // data['createdAt'] = this.createdAt;
    return data;
  }
}
