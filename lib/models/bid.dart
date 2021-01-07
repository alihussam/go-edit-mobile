import 'package:goedit/models/user.dart';

class Bid {
  String job;
  String sId;
  User user;
  String description;
  double budget;
  String currency;
  String status;

  Bid(
      {this.job,
      this.sId,
      this.user,
      this.description,
      this.budget,
      this.currency,
      this.status});

  Bid.fromJson(Map<String, dynamic> json) {
    print('[Bid] fromJson');
    sId = json['_id'];
    user = json['user'] != null && !(json['user'] is String)
        ? new User.fromJson(json['user'])
        : json['user'] is String
            ? User(sId: json['user'])
            : User();
    description = json['description'];
    budget =
        json['budget'] != null ? double.parse(json['budget'].toString()) : 0;
    currency = json['currency'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sId != null) {
      data['_id'] = this.sId;
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description;
    }
    if (this.budget != null) {
      data['budget'] = this.budget;
    }
    if (this.currency != null) {
      data['currency'] = this.currency;
    }
    if (this.status != null) {
      data['status'] = this.status;
    }
    if (this.job != null) {
      data['job'] = this.job;
    }
    return data;
  }
}
