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
  File resourceFile;
  double avgRating;
  bool isCurrentUsersAsset = false;
  List<String> usersBought;

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
      this.imageFile,
      this.isCurrentUsersAsset});

  Asset.fromJson(Map<String, dynamic> json) {
    print('Deforming asset with bought users');
    print(json['usersBought']);
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    price =
        json['price'] != null ? double.parse(json['price'].toString()) : null;
    currency = json['currency'];
    imageUrls = json['imageUrls'].length > 0
        ? json['imageUrls'].cast<String>()
        : [
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZP-L20C3N8Pfs71J4Fc52e7e7p2PeA7wimg&usqp=CAU'
          ];
    resourceUrl = json['resourceUrl'];
    if (!(json['user'] is String)) {
      user = json['user'] != null ? new User.fromJson(json['user']) : null;
    }
    isDisabled = json['isDisabled'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    avgRating = json['avgRating'] != null ? json['avgRating'] : 0;
    usersBought =
        json['usersBought'] != null ? json['usersBought'].cast<String>() : [];
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
    if (this.avgRating != null) data['avgRating'] = this.avgRating;
    return data;
  }
}
