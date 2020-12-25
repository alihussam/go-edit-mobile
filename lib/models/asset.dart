import 'dart:io';

import 'package:goedit/models/user.dart';

class Asset {
  String sId;
  String title;
  String description;
  double price;
  String currency;
  List<String> imageUrls;
  String resourceUrl;
  User user;
  bool isDisabled;
  String createdAt;
  String updatedAt;
  File imageFile;

  Asset(
      {this.sId,
      this.title,
      this.description,
      this.price,
      this.currency,
      this.imageUrls,
      this.resourceUrl,
      this.user,
      this.isDisabled,
      this.createdAt,
      this.updatedAt,
      this.imageFile});

  Asset.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    price =
        json['price'] != null ? double.parse(json['price'].toString()) : null;
    currency = json['currency'];
    imageUrls = json['imageUrls'].cast<String>();
    resourceUrl = json['resourceUrl'];
    if (!(json['user'] is String)) {
      user = json['user'] != null ? new User.fromJson(json['user']) : null;
    }
    isDisabled = json['isDisabled'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sId != null) data['_id'] = this.sId;
    if (this.title != null) data['title'] = this.title;
    if (this.description != null) data['description'] = this.description;
    if (this.price != null) data['price'] = this.price;
    if (this.currency != null) data['currency'] = this.currency;
    if (this.imageUrls != null) data['imageUrls'] = this.imageUrls;
    if (this.resourceUrl != null) data['resourceUrl'] = this.resourceUrl;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.isDisabled != null) data['isDisabled'] = this.isDisabled;
    if (this.createdAt != null) data['createdAt'] = this.createdAt;
    if (this.updatedAt != null) data['updatedAt'] = this.updatedAt;
    return data;
  }
}