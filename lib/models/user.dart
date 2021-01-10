import 'dart:io';

import 'package:goedit/models/employerProfile.dart';
import 'package:goedit/models/freelancerProfile.dart';
import 'package:goedit/models/name.dart';
import 'package:goedit/models/rating.dart';

class User {
  String sId;
  Name name;
  String email;
  String password;
  bool isEmailVerified;
  String role;
  String imageUrl;
  bool isDisabled;
  FreelancerProfile freelancerProfile;
  EmployerProfile employerProfile;
  String createdAt;
  String updatedAt;
  List<String> portfolioUrls = [];
  File profileImage;
  List<File> portfolioImages = [];
  List<Rating> ratings = [];

  User(
      {this.sId,
      this.name,
      this.email,
      this.password,
      this.isEmailVerified,
      this.role,
      this.imageUrl =
          'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png',
      this.isDisabled,
      this.freelancerProfile,
      this.employerProfile,
      this.createdAt,
      this.updatedAt,
      this.portfolioUrls,
      this.ratings});

  String get unifiedName {
    String name = '';
    if (this.name.firstName != null) name += this.name.firstName + ' ';
    if (this.name.middleName != null) name += this.name.middleName + ' ';
    if (this.name.lastName != null) name += this.name.lastName + ' ';
    return name;
  }

  String get shortName {
    String name = '';
    if (this.name.firstName != null) name += this.name.firstName + ' ';
    if (this.name.lastName != null)
      name += this.name.lastName.toUpperCase().substring(0, 1);
    return name;
  }

  User.fromJson(Map<String, dynamic> json) {
    print('[UserModel] fromJson');
    sId = json['_id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    email = json['email'];
    password = json['password'];
    isEmailVerified = json['isEmailVerified'];
    role = json['role'] != null ? json['role'] : '';
    imageUrl = json['imageUrl'] != null
        ? json['imageUrl']
        : 'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png';
    isDisabled = json['isDisabled'];
    freelancerProfile = json['freenlancerProfile'] != null
        ? new FreelancerProfile.fromJson(json['freenlancerProfile'])
        : null;
    employerProfile = json['employerProfile'] != null
        ? new EmployerProfile.fromJson(json['employerProfile'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    portfolioUrls = json['portfolioUrls'] != null
        ? json['portfolioUrls'].cast<String>()
        : [];
    if (json['ratings'] != null) {
      List<Rating> ratingsList = [];
      for (var entry in json['ratings']) {
        ratings.add(Rating.fromJson(entry));
      }
      ratings = ratingsList;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sId != null) data['_id'] = this.sId;
    if (this.name != null) data['name'] = this.name.toJson();
    if (this.email != null) data['email'] = this.email;
    if (this.password != null) data['password'] = this.password;
    if (this.isEmailVerified != null)
      data['isEmailVerified'] = this.isEmailVerified;
    if (this.role != null) data['role'] = this.role;
    if (this.imageUrl != null) data['imageUrl'] = this.imageUrl;
    if (this.isDisabled != null) data['isDisabled'] = this.isDisabled;
    if (this.freelancerProfile != null)
      data['freenlancerProfile'] = this.freelancerProfile.toJson();
    if (this.employerProfile != null)
      data['employerProfile'] = this.employerProfile.toJson();
    if (this.createdAt != null) data['createdAt'] = this.createdAt;
    if (this.updatedAt != null) data['updatedAt'] = this.updatedAt;
    return data;
  }
}
