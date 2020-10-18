import 'package:goedit/models/user.dart';

class Job {
  String sId;
  String currency;
  String title;
  String description;
  double budget;
  String createdAt;
  String updatedAt;
  User user;

  Job(
      {this.sId,
      this.currency,
      this.title,
      this.description,
      this.budget,
      this.createdAt,
      this.updatedAt,
      this.user});

  Job.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    currency = json['currency'];
    title = json['title'];
    description = json['description'];
    budget =
        json['budget'] != null ? double.parse(json['budget'].toString()) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (!(json['user'] is String)) {
      user = json['user'] != null ? new User.fromJson(json['user']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sId != null) data['_id'] = this.sId;
    if (this.currency != null) data['currency'] = this.currency;
    if (this.title != null) data['title'] = this.title;
    if (this.description != null) data['description'] = this.description;
    if (this.budget != null) data['budget'] = this.budget;
    if (this.createdAt != null) data['createdAt'] = this.createdAt;
    if (this.updatedAt != null) data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
