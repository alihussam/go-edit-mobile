import 'package:goedit/models/user.dart';

class Job {
  String sId;
  String currency;
  String title;
  String description;
  double budget;
  String userRole;
  String createdAt;
  String updatedAt;
  User user;

  Job(
      {this.sId,
      this.currency,
      this.title,
      this.description,
      this.budget,
      this.userRole,
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
    userRole = json['userRole'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['currency'] = this.currency;
    data['title'] = this.title;
    data['description'] = this.description;
    data['budget'] = this.budget;
    data['userRole'] = this.userRole;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
